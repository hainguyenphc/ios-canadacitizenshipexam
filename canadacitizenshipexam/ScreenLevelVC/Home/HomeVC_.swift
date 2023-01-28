//
//  HomeVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit

class HomeVC_: UIViewController {
  
  var unlockPremiumFeaturesView: UIView?

  // This is initialized in `assembleTheViews()` later.
  var completionCircularProgressView: CircularProgressView? = nil

  // This is initialized in `assembleTheViews()` later.
  var completionPercentageLabel: UILabel? = nil

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Build the Unlock view first since other views depend on it.
    unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()
    assembleTheViews()
  }

}

// Example: how to update the progress.
// DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//   self.completionCircularProgressView?.progress = 0.5
//   self.completionPercentageLabel?.text = "50%"
// }
