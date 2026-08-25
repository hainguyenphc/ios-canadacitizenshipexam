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

protocol UnlockPremiumFeatureProtocol {

  /*
   */
  func buildTheUnlockPremiumFeatureView() -> UIView?

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
