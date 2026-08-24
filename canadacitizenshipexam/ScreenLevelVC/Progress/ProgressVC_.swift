//
//  ProgressVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-05.
//

import UIKit

protocol ProgressVCDelegate {

}

class ProgressVC_: UIViewController, ProgressVCDelegate {

  // MARK: - View Model & Logic variables

  // Whether the heading view should be sticky.
  let isTheHeadingViewSticky: Bool = false

  var distanceToTop: CGFloat = 0

  var isFirstTimeLoaded: Bool = true

  // MARK: - Sub-views

  var unlockPremiumFeaturesView: UIView?

  // The circular progress + details pair for the Practice Progress row.
  var practiceCompletionPercentageView: UIView? = nil

  var practiceCompletionCircularProgressView: CircularProgressView? = nil

  // The circular progress + details pair for the Reading Progress row.
  var readingCompletionPercentageView: UIView? = nil

  var readingCompletionCircularProgressView: CircularProgressView? = nil

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if isFirstTimeLoaded {
      // Build the Unlock view first since other views depend on it.
      unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()

      // The Progress view has its heading area attached to the scroll view.
      // I.e., the heading area is not sticky.
      // Hence, we set up the scroll view first.
      setupScrollView()
      // Then we build the heading, which contains both progress summaries.
      buildTheHeadingView()
      // Next, we construct the cards below the heading.
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
