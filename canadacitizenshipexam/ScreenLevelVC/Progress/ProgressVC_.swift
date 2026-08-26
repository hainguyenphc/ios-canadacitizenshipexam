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

  // Kept so notificationsRowTapped can update this row's text/icon whenever
  // notifications are turned on or off.
  var notificationsActionableItem: CardActionableItem?

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // TestVC hides the tab bar for the duration of a test (see its
    // configureUI) and only ever un-hides it if the user lands back on
    // Home — TestResultVC's "How am I doing?" pushes this screen directly
    // instead, so it needs to restore the tab bar itself too, same as
    // HomeVC_ already does on its own appearance.
    tabBarController?.tabBar.isHidden = false

    // The row is only built once (guarded by isFirstTimeLoaded below), but
    // Home's and Settings' own reminders rows can also flip this same
    // NotificationManager state — re-sync every time this screen appears so
    // they never drift.
    refreshNotificationsRow()

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
    self.view.backgroundColor = .systemGroupedBackground
  }

}

// MARK: - Actions

extension ProgressVC_ {

  // Tab order set up in SceneDelegate.createPrimaryTabBarController: Home,
  // Tests, Book, Progress, Settings.
  func navigateToTests() {
    tabBarController?.selectedIndex = 1
  }

  func navigateToBooks() {
    tabBarController?.selectedIndex = 2
  }

  func notificationsRowTapped() {
    // Toggle off if already on, on otherwise — same as Home's own
    // notifications row.
    let turningOn = !NotificationManager.shared.isDailyReminderEnabled
    NotificationManager.shared.setDailyReminderEnabled(turningOn) { [weak self] granted in
      guard let self = self else { return }
      // Turning off always succeeds (see NotificationManager); granted only
      // comes back false here when turning on was denied permission.
      if turningOn && !granted {
        self.presentNotificationsPermissionDeniedAlert()
      }
      self.refreshNotificationsRow()
    }
  }

  // Matches this row's text/icon to NotificationManager's current state,
  // whichever screen last changed it.
  func refreshNotificationsRow() {
    let isOn = NotificationManager.shared.isDailyReminderEnabled
    notificationsActionableItem?.update(
      text: isOn
        ? "Daily practice reminders are on."
        : "Turn on notifications in Settings to get daily practice reminders.",
      imageName: isOn ? "checkmark.circle.fill" : "alarm"
    )
  }

}
