//
//  TestsVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

protocol TestsVCDelegate {
  
}

class TestsVC_: UIViewController, TestsVCDelegate {

  var unlockPremiumFeaturesView: UIView?

  var completionPercentageView: UIView? = nil

  var completionCircularProgressView: CircularProgressView? = nil

  var completionPercentageLabel: UILabel? = nil

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Build the Unlock view first since other views depend on it.
    unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()

    setupScrollView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
  }



}
