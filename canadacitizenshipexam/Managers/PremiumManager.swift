//
//  PremiumManager.swift
//  canadacitizenshipexam
//

import Foundation
import StoreKit

// Why a purchase can't be completed, or why we can't tell whether the user
// already owns it. `.message` mirrors CCEFailure's role for network
// errors — a ready-to-display string — but this needs an associated value
// on `.unknown` to wrap whatever StoreKit itself throws, which a plain
// String-backed enum (like CCEFailure) can't carry.
enum PremiumPurchaseError: Error {

  case productNotFound
  case verificationFailed
  case userCancelled
  case pending
  case unknown(Error)

  var message: String {
    switch self {
      case .productNotFound:
        return "The premium unlock couldn't be found right now. Please try again later."
      case .verificationFailed:
        return "We couldn't verify your purchase. Please try again or contact support."
      case .userCancelled:
        return "Purchase cancelled."
      case .pending:
        return "Your purchase needs approval (e.g. Ask to Buy) and will unlock automatically once approved."
      case .unknown(let error):
        return error.localizedDescription
    }
  }

  // .userCancelled isn't really a failure worth alerting the user about —
  // they're the one who just did it.
  var isUserFacing: Bool {
    if case .userCancelled = self { return false }
    return true
  }

}

// Owns the single non-consumable "unlock everything" purchase — see
// PremiumBannerView's "Unlock All Premium Features" copy, already shown
// (identically) across Home/Progress/Tests/Book/Settings before this
// class existed to back it with anything real.
//
// Exposes a completion-handler API, matching this codebase's other
// managers (NotificationManager, NetworkManager) rather than surfacing
// async/await directly to UIKit call sites — internally this wraps
// StoreKit 2's async APIs with Task { }.
class PremiumManager {

  // Singleton pattern.
  static let shared = PremiumManager()

  // Must match a product configured in App Store Connect once this app is
  // published — until then, Configuration.storekit (see that file, and
  // TODO.md) defines a matching product for local Simulator testing.
  static let premiumUnlockProductID = "com.haiphcnguyen.canadacitizenshipexam.premium_unlock"

  static let premiumUnlockedDefaultsKey = "premiumUnlocked"

  // Synchronous, for UI code (e.g. viewWillAppear) that can't await —
  // StoreKit's own entitlement check is async, so this is a cache of its
  // last known answer, kept current by refreshEntitlements() (called at
  // init, below) and the Transaction.updates listener (new purchases,
  // restores, and refunds/revocations, including ones synced in from
  // another device, for as long as the app process lives).
  //
  // Backed by UserDefaults purely so the very first viewWillAppear of a
  // cold launch — before refreshEntitlements() has had a chance to
  // round-trip — still reflects an already-purchased state instead of
  // defaulting every screen to "locked" for a moment. UserDefaults is
  // never the source of truth here; entitlement checks always win as soon
  // as they land.
  private(set) var isPremiumUnlocked: Bool {
    get { UserDefaults.standard.bool(forKey: PremiumManager.premiumUnlockedDefaultsKey) }
    set { UserDefaults.standard.set(newValue, forKey: PremiumManager.premiumUnlockedDefaultsKey) }
  }

  private var updatesTask: Task<Void, Never>?

  private init() {
    updatesTask = Task { [weak self] in
      await self?.refreshEntitlements()
      guard let self = self else { return }
      for await update in Transaction.updates {
        await self.handle(transactionResult: update)
      }
    }
  }

  deinit {
    updatesTask?.cancel()
  }

  // MARK: - Public API

  func fetchProduct(completion: @escaping (Result<Product, PremiumPurchaseError>) -> Void) {
    Task {
      do {
        let products = try await Product.products(for: [PremiumManager.premiumUnlockProductID])
        guard let product = products.first else {
          await MainActor.run { completion(.failure(.productNotFound)) }
          return
        }
        await MainActor.run { completion(.success(product)) }
      } catch {
        await MainActor.run { completion(.failure(.unknown(error))) }
      }
    }
  }

  func purchase(_ product: Product, completion: @escaping (Result<Void, PremiumPurchaseError>) -> Void) {
    Task {
      do {
        let result = try await product.purchase()
        switch result {
          case .success(let verification):
            switch verification {
              case .verified(let transaction):
                await unlock(using: transaction)
                await MainActor.run { completion(.success(())) }
              case .unverified:
                await MainActor.run { completion(.failure(.verificationFailed)) }
            }
          case .userCancelled:
            await MainActor.run { completion(.failure(.userCancelled)) }
          case .pending:
            await MainActor.run { completion(.failure(.pending)) }
          @unknown default:
            await MainActor.run {
              completion(.failure(.unknown(NSError(
                domain: "PremiumManager", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Unrecognized purchase result."]))))
            }
        }
      } catch {
        await MainActor.run { completion(.failure(.unknown(error))) }
      }
    }
  }

  // AppStore.sync() re-syncs this device's transaction history from Apple
  // (e.g. after a reinstall, or a fresh device) — the Transaction.updates
  // listener above then picks up whatever it finds, the same way it would
  // for a live purchase. Callers should check isPremiumUnlocked afterward
  // to tell "restored" from "nothing to restore" — both are `.success`
  // here, since neither is actually an error.
  func restorePurchases(completion: @escaping (Result<Void, PremiumPurchaseError>) -> Void) {
    Task {
      do {
        try await AppStore.sync()
        await refreshEntitlements()
        await MainActor.run { completion(.success(())) }
      } catch {
        await MainActor.run { completion(.failure(.unknown(error))) }
      }
    }
  }

  // MARK: - Entitlement bookkeeping

  private func refreshEntitlements() async {
    for await entitlement in Transaction.currentEntitlements {
      await handle(transactionResult: entitlement)
    }
  }

  private func handle(transactionResult: VerificationResult<Transaction>) async {
    guard case .verified(let transaction) = transactionResult else {
      // An unverified entitlement is treated as absent rather than
      // granting premium off unverifiable data.
      return
    }
    guard transaction.productID == PremiumManager.premiumUnlockProductID else { return }

    if transaction.revocationDate == nil {
      await unlock(using: transaction)
    } else {
      await MainActor.run { self.isPremiumUnlocked = false }
    }
  }

  private func unlock(using transaction: Transaction) async {
    await MainActor.run { self.isPremiumUnlocked = true }
    await transaction.finish()
  }

}
