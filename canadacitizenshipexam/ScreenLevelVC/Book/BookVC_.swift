  //
  //  ChapterVC_.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-02-04.
  //

import UIKit

protocol BookVCDelegate {

}

class BookVC_: UIViewController, BookVCDelegate {

  // MARK: - View Model & Logic variables

  // Whether the heading view should be sticky.
  let isTheHeadingViewSticky: Bool = false

  var distanceToTop: CGFloat = 0

  var isFirstTimeLoaded: Bool = true

  // MARK: - Sub-views

  var unlockPremiumFeaturesView: UIView?

  var completionPercentageView: UIView? = nil

  var completionCircularProgressView: CircularProgressView? = nil

  var completionPercentageLabel: UILabel? = nil

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if isFirstTimeLoaded {
      // Build the Unlock view first since other views depend on it.
      unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()

      // The Tests view has its heading area attached to the scroll view.
      // I.e., the heading area is not sticky.
      // Hence, we set up the scroll view first.
      setupScrollView()
      // Then we build the heading
      buildTheHeadingView()
      // Next, we construct the cards which are the tests.
      buildTheCards()
      // Finally, establish the scroll view height.
      specifyScrollViewHeight()

      isFirstTimeLoaded = !isFirstTimeLoaded
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
  }

}
