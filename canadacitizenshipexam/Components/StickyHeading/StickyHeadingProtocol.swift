//
//  StickyHeading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-28.
//

import UIKit

enum HorizontalRelativePosition: String {

  case left = "left"
  
  case right = "right"

}

struct CompletionPercentageOptions {

  var position: HorizontalRelativePosition

  // Kept as a genuine (dynamic) UIColor rather than a CGColor: a CGColor is a
  // frozen snapshot resolved against the thread's "current" trait collection
  // at the moment it's taken, which doesn't necessarily match this app's own
  // light/dark setting — that's how the percentage label ended up stuck white.
  var textColor: UIColor

}

// : UIViewController so the default implementations below can call
// view/present(_:animated:) — every conformer already is one.
protocol UnlockPremiumFeatureProtocol: UIViewController {

  var unlockPremiumFeaturesView: PremiumBannerView? { get set }

  func buildTheUnlockPremiumFeatureView() -> PremiumBannerView?

  func presentPremiumPaywall()

  func refreshPremiumBannerIfNeeded()

}

extension UnlockPremiumFeatureProtocol {

  // Shared across Home, Progress, Tests, Book, and Settings — see
  // PremiumBannerView. Returns nil (nothing to build) once premium is
  // already unlocked, which is also what lets a freshly (re)launched
  // screen skip the banner entirely rather than needing to hide it after
  // the fact.
  func buildTheUnlockPremiumFeatureView() -> PremiumBannerView? {
    guard !PremiumManager.shared.isPremiumUnlocked else { return nil }

    let banner = PremiumBannerView(hostView: view)
    banner.onDetailsTapped = { [weak self] in
      self?.presentPremiumPaywall()
    }
    return banner
  }

  func presentPremiumPaywall() {
    present(PremiumPaywallVC(), animated: true)
  }

  // Called from each conforming screen's viewWillAppear, alongside its
  // other "re-sync every time this screen appears" refreshes (see e.g.
  // HomeVC_.refreshNotificationsRow) — covers both this screen's own
  // banner right after a purchase made from it, and any other screen's
  // banner that was already built (and is now stale) before the purchase
  // happened elsewhere.
  func refreshPremiumBannerIfNeeded() {
    guard PremiumManager.shared.isPremiumUnlocked else { return }
    unlockPremiumFeaturesView?.markUnlocked()
  }

}

protocol StickyHeadingProtocol: UnlockPremiumFeatureProtocol {

  /*
   */
  func buildTheBackgroundView() -> UIView?

  /*
   */
  func buildTheTitleLabel(title: String) -> UILabel

  /*
   */
  func buildTheImageNextToTitleLabel(systemName: String) -> UIImageView?

  /*
   */
  func buildTheTaglineLabel(tagline: String) -> UILabel?

  /*
   */
  func buildTheCompletionPercentageView(percent: Float, options: CompletionPercentageOptions) -> UIView?

  /*
   */
  func buildTheCompletionDetailsView() -> UIView?

  /*
   */
  func assembleTheViews() -> Void

}
