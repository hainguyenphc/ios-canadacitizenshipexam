//
//  PremiumManager.swift
//  canadacitizenshipexam
//

import UIKit
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
        return "Premium plans couldn't be found right now. Please try again later."
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

// The 3 billing durations of the single "Premium" subscription group —
// same entitlement/features regardless of which one is active, differing
// only in period and price. All 3 must belong to the same subscription
// group in App Store Connect (and, for local testing,
// Configuration.storekit) — StoreKit only allows one active subscription
// per group per user, and handles switching between these 3 as a
// crossgrade automatically.
enum SubscriptionTier: String, CaseIterable {

  case weekly
  case monthly
  case yearly

  // Must match the product IDs configured in App Store Connect (and,
  // until that exists, Configuration.storekit).
  var productID: String {
    switch self {
      case .weekly: return "com.haiphcnguyen.canadacitizenshipexam.premium.weekly"
      case .monthly: return "com.haiphcnguyen.canadacitizenshipexam.premium.monthly"
      case .yearly: return "com.haiphcnguyen.canadacitizenshipexam.premium.yearly"
    }
  }

  var displayTitle: String {
    switch self {
      case .weekly: return "Weekly"
      case .monthly: return "Monthly"
      case .yearly: return "Yearly"
    }
  }

  static var allProductIDs: [String] { SubscriptionTier.allCases.map { $0.productID } }

  init?(productID: String) {
    guard let match = SubscriptionTier.allCases.first(where: { $0.productID == productID }) else {
      return nil
    }
    self = match
  }

}

// Owns the 3-tier "Premium" subscription — see PremiumBannerView's
// "Unlock All Premium Features" copy, already shown (identically) across
// Home/Progress/Tests/Book/Settings before this class existed to back it
// with anything real.
//
// Exposes a completion-handler API, matching this codebase's other
// managers (NotificationManager, NetworkManager) rather than surfacing
// async/await directly to UIKit call sites — internally this wraps
// StoreKit 2's async APIs with Task { }.
class PremiumManager {

  // Singleton pattern.
  static let shared = PremiumManager()

  static let premiumUnlockedDefaultsKey = "premiumUnlocked"
  static let activeSubscriptionTierDefaultsKey = "activeSubscriptionTier"

  // Synchronous, for UI code (e.g. viewWillAppear) that can't await —
  // StoreKit's own entitlement check is async, so this is a cache of its
  // last known answer, kept current by refreshEntitlements() (called at
  // init, below) and the Transaction.updates listener (new purchases,
  // restores, renewals, and expirations/refunds/revocations — including
  // ones synced in from another device — for as long as the app process
  // lives).
  //
  // Backed by UserDefaults purely so the very first viewWillAppear of a
  // cold launch — before refreshEntitlements() has had a chance to
  // round-trip — still reflects an already-subscribed state instead of
  // defaulting every screen to "locked" for a moment. UserDefaults is
  // never the source of truth here; entitlement checks always win as soon
  // as they land.
  private(set) var isPremiumUnlocked: Bool {
    get { UserDefaults.standard.bool(forKey: PremiumManager.premiumUnlockedDefaultsKey) }
    set { UserDefaults.standard.set(newValue, forKey: PremiumManager.premiumUnlockedDefaultsKey) }
  }

  // Which of the 3 tiers is currently active, if any. Only meaningful
  // alongside isPremiumUnlocked — UI code should check that first; this
  // is for display purposes (e.g. the paywall's "You're subscribed
  // (Monthly)" state), not itself a signal of whether premium is unlocked.
  private(set) var activeTier: SubscriptionTier? {
    get {
      guard let rawValue = UserDefaults.standard.string(forKey: PremiumManager.activeSubscriptionTierDefaultsKey) else {
        return nil
      }
      return SubscriptionTier(rawValue: rawValue)
    }
    set { UserDefaults.standard.set(newValue?.rawValue, forKey: PremiumManager.activeSubscriptionTierDefaultsKey) }
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

  // All 3 tiers, ordered weekly/monthly/yearly (SubscriptionTier's own
  // declared order) regardless of what order StoreKit itself returns them
  // in.
  func fetchProducts(completion: @escaping (Result<[Product], PremiumPurchaseError>) -> Void) {
    Task {
      do {
        let products = try await Product.products(for: SubscriptionTier.allProductIDs)
        guard !products.isEmpty else {
          await MainActor.run { completion(.failure(.productNotFound)) }
          return
        }
        let ordered = SubscriptionTier.allCases.compactMap { tier in
          products.first { $0.id == tier.productID }
        }
        await MainActor.run { completion(.success(ordered)) }
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
              case .verified:
                // Reuses the same entitlement-granting logic
                // Transaction.updates/currentEntitlements drive (tier
                // matching, expiration check, finish()) rather than
                // duplicating it here.
                await handle(transactionResult: verification)
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

  // Presents Apple's own sheet for changing/cancelling the active
  // subscription — an app can't cancel a subscription on the user's
  // behalf directly, only this system UI can.
  func presentManageSubscriptions(in scene: UIWindowScene) {
    Task {
      try? await AppStore.showManageSubscriptions(in: scene)
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
    guard let tier = SubscriptionTier(productID: transaction.productID) else { return }

    // Transaction.currentEntitlements / .updates already only surface
    // transactions StoreKit considers currently entitling, but this
    // double-checks expiration/revocation explicitly rather than trusting
    // that implicitly — cheap insurance against ever granting access off
    // a stale transaction.
    //
    // Note: this treats "in billing retry" / "in grace period" as simply
    // active-until-expirationDate, same as a normal renewal — it doesn't
    // distinguish those states from a fully healthy subscription. A more
    // complete implementation would check
    // Product.SubscriptionInfo.Status for that nuance; not done here (see
    // TODO.md).
    let isActive = transaction.revocationDate == nil
      && (transaction.expirationDate.map { $0 > Date() } ?? false)

    if isActive {
      await MainActor.run {
        self.isPremiumUnlocked = true
        self.activeTier = tier
      }
    } else if activeTier == tier {
      // Only clear if THIS is the tier we thought was active — a
      // stale/expired update for a tier that isn't the current one (e.g.
      // an old transaction from before switching plans) shouldn't
      // clobber a still-active different tier.
      await MainActor.run {
        self.isPremiumUnlocked = false
        self.activeTier = nil
      }
    }

    // Finished unconditionally, not just when granting access — an
    // expired/revoked transaction the app never finishes would keep
    // resurfacing via Transaction.updates on every future launch.
    await transaction.finish()
  }

}
