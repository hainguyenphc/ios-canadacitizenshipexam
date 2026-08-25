//
//  SettingsVC_.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit
import FirebaseAuth

protocol SettingsVCDelegate {

}

// MARK: View/ViewController

class SettingsVC_: UIViewController, SettingsVCDelegate {

  // MARK: - View Model & Logic variables

  // Whether the heading view should be sticky.
  let isTheHeadingViewSticky: Bool = false

  var distanceToTop: CGFloat = 0

  var isFirstTimeLoaded: Bool = true

  static let darkModeDefaultsKey = "darkModeEnabled"

  var isDarkModeOn: Bool {
    get { UserDefaults.standard.bool(forKey: SettingsVC_.darkModeDefaultsKey) }
    set { UserDefaults.standard.set(newValue, forKey: SettingsVC_.darkModeDefaultsKey) }
  }

  // MARK: - Sub-views

  var unlockPremiumFeaturesView: UIView?

  // Kept so dailyReminderSwitchToggled can reset it back to Off if the user
  // ends up denying the notifications permission.
  var dailyReminderSwitch: UISwitch?

  // Kept so practiceTimeRowTapped can update this row's trailing value once
  // a new time is picked, and so it can be re-synced with Home's own
  // Practice Time row on every appearance.
  var practiceTimeValueLabel: UILabel?

  // Same idea as practiceTimeValueLabel above, but for the Exam Date row —
  // kept in sync with Home's own "Schedule your Exam" row.
  var examDateValueLabel: UILabel?

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if isFirstTimeLoaded {
      // Build the Unlock view first since other views depend on it.
      unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()

      // The Settings view has its heading area attached to the scroll view.
      // I.e., the heading area is not sticky.
      // Hence, we set up the scroll view first.
      setupScrollView()
      // Then we build the heading.
      buildTheHeadingView()
      // Next, we construct the cards below the heading.
      buildTheCards()
      // Finally, establish the scroll view height.
      specifyScrollViewHeight()

      isFirstTimeLoaded = !isFirstTimeLoaded
    }

    reconcileDailyReminderSwitch()
    // Same reasoning as reconcileDailyReminderSwitch above — Home's own
    // Practice Time / Schedule your Exam rows can also change these values.
    practiceTimeValueLabel?.text = NotificationManager.shared.practiceTimeDisplayText
    examDateValueLabel?.text = ExamScheduleManager.shared.examDateValueText
  }

  // The switch is only built once (guarded by isFirstTimeLoaded above), but
  // the Home screen's actionable item can also flip this same
  // NotificationManager state — re-sync every time this screen appears so
  // the two never drift. The user can also revoke notification permission
  // from the iOS Settings app directly, without ever touching this switch,
  // so that's checked here too, rather than keeping "On" showing for a
  // reminder the OS silently stopped delivering.
  private func reconcileDailyReminderSwitch() {
    let isOn = NotificationManager.shared.isDailyReminderEnabled
    dailyReminderSwitch?.setOn(isOn, animated: false)

    guard isOn else { return }

    NotificationManager.shared.getAuthorizationStatus { [weak self] status in
      guard let self = self, status == .denied else { return }
      NotificationManager.shared.setDailyReminderEnabled(false)
      self.dailyReminderSwitch?.setOn(false, animated: true)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemGroupedBackground
  }

  // MARK: - Actions

  @objc func logOutButtonPressed() {
    do {
      if let _ = Auth.auth().currentUser?.uid {
        // User would like to sign out.
        try Auth.auth().signOut()
        // Upon landing on the Home VC, as there is no active session any more,
        // he will be redirected to Register VC.
        self.tabBarController?.selectedIndex = 0
      }
    } catch {
      // @TODO: handle error
      print("Error signing user out.")
    }
  }

  @objc func dailyReminderSwitchToggled(_ sender: UISwitch) {
    let wantsEnabled = sender.isOn
    NotificationManager.shared.setDailyReminderEnabled(wantsEnabled) { [weak self] granted in
      guard let self = self, wantsEnabled, !granted else { return }
      // Permission was denied (or just declined), so the switch shouldn't
      // sit on "On" for a reminder that isn't actually going to fire.
      sender.setOn(false, animated: true)
      self.presentNotificationsPermissionDeniedAlert()
    }
  }

  @objc func darkModeSwitchToggled(_ sender: UISwitch) {
    isDarkModeOn = sender.isOn
    view.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
  }

  @objc func practiceTimeRowTapped() {
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
      self?.practiceTimeValueLabel?.text = NotificationManager.shared.practiceTimeDisplayText
    }
    present(picker, animated: true)
  }

  @objc func examDateRowTapped() {
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
      self?.examDateValueLabel?.text = ExamScheduleManager.shared.examDateValueText
    }
    present(picker, animated: true)
  }

}
