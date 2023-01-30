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
  
  var textColor: CGColor

}

protocol StickyHeadingProtocol {

  /*
   */
  func buildTheBackgroundView() -> UIView?

  /*
   */
  func buildTheUnlockPremiumFeatureView() -> UIView?

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
