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

  // MARK: - View Model & Logic variables

  /*
   Logic attributes.
   */

  var isFirstTimeLoaded: Bool = true

  // The Home view model.
  let homeVM: HomeVM_ = HomeVM_()

  var count = 0

  var distanceToTop: CGFloat = 0

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

  // Kept so notificationsRowTapped can update this row's text/icon whenever
  // notifications are turned on or off.
  var notificationsActionableItem: CardActionableItem?

  // Kept so practiceTimeRowTapped can update this row's text once a new
  // time is picked.
  var practiceTimeActionableItem: CardActionableItem?

  // Kept so examDateRowTapped can update this row's text once a new exam
  // date is picked.
  var examDateActionableItem: CardActionableItem?

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    homeVM.delegate = self
    homeVM.checkAuthorization()

    super.viewWillAppear(animated)

    if self.isFirstTimeLoaded {
      // Build the Unlock view first since other views depend on it.
      unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()
      // For the Home view, the heading view is sticky, so we build it first.
      buildTheHeadingView()
      // Next, we set up the scroll view.
      setupScrollView()
      // Next, we construct the cards.
      buildTheCards()
      // Finally, establish the scroll view height.
      specifyScrollViewHeight()
      isFirstTimeLoaded = !isFirstTimeLoaded
    }

    // The row is only built once (guarded by isFirstTimeLoaded above), but
    // the Settings screen can also flip this same NotificationManager state
    // — re-sync every time this screen appears so the two never drift.
    refreshNotificationsRow()
    refreshPracticeTimeRow()
    refreshExamDateRow()

    tabBarController?.tabBar.isHidden = false
    navigationItem.setHidesBackButton(true, animated: false)

    // @todo Load progress
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    homeVM.checkAuthorization()
    self.view.backgroundColor = .systemGroupedBackground
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

// MARK: - Actions

extension HomeVC_ {

  // Tab order set up in SceneDelegate.createPrimaryTabBarController: Home,
  // Tests, Book, Progress, Settings — same pattern SettingsVC_'s Log Out
  // already uses to land back on Home (index 0).
  func navigateToTests() {
    tabBarController?.selectedIndex = 1
  }

  func navigateToBooks() {
    tabBarController?.selectedIndex = 2
  }
  
  func navigateToProgress() {
    tabBarController?.selectedIndex = 3
  }

  func notificationsRowTapped() {
    // Toggle off if already on, on otherwise — setDailyReminderEnabled(true)
    // was being called unconditionally here before, so a second tap just
    // re-requested already-granted permission and rescheduled the same
    // reminder instead of turning it off.
    let turningOn = !NotificationManager.shared.isDailyReminderEnabled
    NotificationManager.shared.setDailyReminderEnabled(turningOn) { [weak self] granted in
      guard let self = self else { return }
      // Turning off always succeeds (see NotificationManager); granted only
      // comes back false here when turning on was denied permission — in
      // which case the preference (and this row) should stay "off".
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
      text: isOn ? "Daily Reminders On" : "Turn on Notifications",
      imageName: isOn ? "checkmark.circle.fill" : "bell"
    )
  }

  func practiceTimeRowTapped() {
    var components = DateComponents()
    components.hour = NotificationManager.shared.practiceReminderHour
    components.minute = NotificationManager.shared.practiceReminderMinute
    let initialDate = Calendar.current.date(from: components) ?? Date()

    let picker = DateTimePickerVC(heading: "Practice Time", mode: .time, initialDate: initialDate) { [weak self] date in
      let picked = Calendar.current.dateComponents([.hour, .minute], from: date)
      // Reschedules the reminder at the new time automatically if it's
      // currently on (see NotificationManager.setPracticeTime).
      NotificationManager.shared.setPracticeTime(
        hour: picked.hour ?? NotificationManager.defaultReminderHour,
        minute: picked.minute ?? NotificationManager.defaultReminderMinute
      )
      self?.refreshPracticeTimeRow()
    }
    present(picker, animated: true)
  }

  func refreshPracticeTimeRow() {
    practiceTimeActionableItem?.update(
      text: "Practice Time: \(NotificationManager.shared.practiceTimeDisplayText)",
      imageName: "clock"
    )
  }

  func examDateRowTapped() {
    let now = Date()
    // If a past date was already saved (the app was never reopened around
    // exam day, say), start the picker at "now" instead of a date it won't
    // even let the user land back on.
    let storedExamDate = ExamScheduleManager.shared.examDate
    let initialDate = (storedExamDate.map { $0 >= now }) == true ? storedExamDate! : now

    let picker = DateTimePickerVC(
      heading: "Exam Date",
      mode: .dateAndTime,
      initialDate: initialDate,
      minimumDate: now
    ) { [weak self] date in
      ExamScheduleManager.shared.examDate = date
      self?.refreshExamDateRow()
    }
    present(picker, animated: true)
  }

  func refreshExamDateRow() {
    examDateActionableItem?.update(text: ExamScheduleManager.shared.examDateDisplayText, imageName: "calendar")
  }

}

// MARK: - Code snippets

// Example: how to update the progress.
// DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//   self.completionCircularProgressView?.progress = 0.5
//   self.completionPercentageLabel?.text = "50%"
// }
