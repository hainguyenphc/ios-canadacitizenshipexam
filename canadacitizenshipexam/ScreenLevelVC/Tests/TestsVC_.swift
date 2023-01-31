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
  }



}
