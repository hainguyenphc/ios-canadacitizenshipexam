//
//  HomeVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit
import FirebaseAuth

// MARK: - Delegate

protocol HomeVCDelegate {

  func handleSuccessLoadingUsersDataFromNetworkCall(usersData: CCEUsersData)

  func handleErrorLoadingUsersDataFromNetworkCall(error: CCEFailure)

}

// MARK: - View/View Controller

class HomeVC_: UIViewController, HomeVCDelegate {

  // MARK: - View Model

  /*
   Logic attributes.
   */

  // The Home view model.
  let homeVM: HomeVM_ = HomeVM_()

  var count = 0

  // MARK: - Sub-views

  // @todo: payment
  var unlockPremiumFeaturesView: UIView?

  // This is the container housing both `completionCircularProgressView`
  // and `completionPercentageLabel` views.
  // It is used as an anchor to position the scroll view.
  var completionPercentageView: UIView? = nil

  // This is initialized in `assembleTheViews()` later.
  var completionCircularProgressView: CircularProgressView? = nil

  // This is initialized in `assembleTheViews()` later.
  var completionPercentageLabel: UILabel? = nil

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  var blockView: UIView!
  var blockView2: UIView!

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    homeVM.delegate = self
    homeVM.checkAuthorization()

    super.viewWillAppear(animated)

    // Build the Unlock view first since other views depend on it.
    unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()
    assembleTheViews()
    setupScrollView()

    tabBarController?.tabBar.isHidden = false
    navigationItem.setHidesBackButton(true, animated: false)

    // @todo Load progress
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    homeVM.checkAuthorization()
    self.view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
  }

}

// MARK: - Delegate Implementations

extension HomeVC_ {

  func handleSuccessLoadingUsersDataFromNetworkCall(usersData: CCEUsersData) {
      // @todo
  }

  func handleErrorLoadingUsersDataFromNetworkCall(error: CCEFailure) {
      // @todo
  }

}

// MARK: - Code snippets

// Example: how to update the progress.
// DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//   self.completionCircularProgressView?.progress = 0.5
//   self.completionPercentageLabel?.text = "50%"
// }
