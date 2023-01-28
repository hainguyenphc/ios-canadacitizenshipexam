//
//  HomeVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit
import FirebaseAuth

class HomeVC_: UIViewController {
  
  var unlockPremiumFeaturesView: UIView?

  // This is initialized in `assembleTheViews()` later.
  var completionCircularProgressView: CircularProgressView? = nil

  // This is initialized in `assembleTheViews()` later.
  var completionPercentageLabel: UILabel? = nil

  override func viewDidLoad() {

  }

  override func viewWillAppear(_ animated: Bool) {
    // Redirects user to Register screen if he is not logged in.
    guard let _ = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }

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
