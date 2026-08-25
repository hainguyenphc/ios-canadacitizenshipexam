//
//  NotificationManager.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit
import UserNotifications

class NotificationManager {

  // Singleton pattern.
  static let shared = NotificationManager()

  static let dailyReminderIdentifier = "dailyPracticeReminder"

  static let dailyReminderDefaultsKey = "dailyRemindersEnabled"

  static let practiceHourDefaultsKey = "practiceReminderHour"
  static let practiceMinuteDefaultsKey = "practiceReminderMinute"

  // Matches the "Practice Time: 10:00 AM" copy already on the Home screen.
  static let defaultReminderHour = 10
  static let defaultReminderMinute = 0

  private init() {
    // Leaves empty.
  }

  // The user's own preference, independent of whatever the OS actually
  // grants. Settings and Home both read/write through here so the two
  // screens never disagree about whether reminders are "on".
  var isDailyReminderEnabled: Bool {
    get { UserDefaults.standard.bool(forKey: NotificationManager.dailyReminderDefaultsKey) }
    set { UserDefaults.standard.set(newValue, forKey: NotificationManager.dailyReminderDefaultsKey) }
  }

  // The user's chosen practice time, defaulting to the "Practice Time:
  // 10:00 AM" copy until they pick their own. `.object(forKey:) as? Int`
  // rather than `.integer(forKey:)`, since the latter returns 0 for a
  // missing key — indistinguishable from an actual midnight (hour 0)
  // choice — which would silently default everyone to 12:00 AM.
  var practiceReminderHour: Int {
    get { (UserDefaults.standard.object(forKey: NotificationManager.practiceHourDefaultsKey) as? Int) ?? NotificationManager.defaultReminderHour }
    set { UserDefaults.standard.set(newValue, forKey: NotificationManager.practiceHourDefaultsKey) }
  }

  var practiceReminderMinute: Int {
    get { (UserDefaults.standard.object(forKey: NotificationManager.practiceMinuteDefaultsKey) as? Int) ?? NotificationManager.defaultReminderMinute }
    set { UserDefaults.standard.set(newValue, forKey: NotificationManager.practiceMinuteDefaultsKey) }
  }

  // "10:00 AM"-style text for the current practice time, for display on the
  // Home screen's "Practice Time" row.
  var practiceTimeDisplayText: String {
    var components = DateComponents()
    components.hour = practiceReminderHour
    components.minute = practiceReminderMinute
    let date = Calendar.current.date(from: components) ?? Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
  }

  // Updates the practice time. If the daily reminder is currently on, the
  // scheduled notification is rescheduled to the new time right away;
  // otherwise this is just persisted for whenever it's turned on.
  func setPracticeTime(hour: Int, minute: Int) {
    practiceReminderHour = hour
    practiceReminderMinute = minute
    if isDailyReminderEnabled {
      scheduleDailyReminder()
    }
  }

  func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        completion(settings.authorizationStatus)
      }
    }
  }

  // Turns the daily reminder on (requesting permission first if needed) or
  // off. `completion` reports whether the requested state actually took
  // effect — turning on can fail if the user has denied (or declines right
  // now) the notification permission, in which case the caller should
  // reflect that back in its own UI (reset a switch, offer to open Settings).
  func setDailyReminderEnabled(_ enabled: Bool, completion: ((Bool) -> Void)? = nil) {
    guard enabled else {
      isDailyReminderEnabled = false
      cancelDailyReminder()
      completion?(true)
      return
    }

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
      DispatchQueue.main.async {
        if let error = error {
          print("NotificationManager: error requesting authorization: \(error)")
        }

        guard granted else {
          self?.isDailyReminderEnabled = false
          completion?(false)
          return
        }

        self?.isDailyReminderEnabled = true
        self?.scheduleDailyReminder()
        completion?(true)
      }
    }
  }

  private func scheduleDailyReminder() {
    let content = UNMutableNotificationContent()
    content.title = "Practice Reminder"
    content.body = "Take a few minutes to practice for your Canadian citizenship test."
    content.sound = .default

    var dateComponents = DateComponents()
    dateComponents.hour = practiceReminderHour
    dateComponents.minute = practiceReminderMinute

    // Matching just hour/minute (no day) with repeats: true fires this
    // every day at that time, rather than once.
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(
      identifier: NotificationManager.dailyReminderIdentifier,
      content: content,
      trigger: trigger
    )

    // Adding a request under the same identifier replaces any pending one,
    // so re-enabling stays idempotent instead of stacking duplicates.
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("NotificationManager: error scheduling daily reminder: \(error)")
      }
    }
  }

  private func cancelDailyReminder() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationManager.dailyReminderIdentifier])
  }

}

extension UIViewController {

  // A simple "notifications are off" alert with a shortcut into this app's
  // Settings page, for when the user has denied (or just declined) the
  // system permission prompt — requesting authorization again wouldn't show
  // the prompt a second time, so this is the only way back in.
  func presentNotificationsPermissionDeniedAlert() {
    let alert = UIAlertController(
      title: "Notifications Are Off",
      message: "To get daily practice reminders, allow notifications for this app in Settings.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url)
    })
    present(alert, animated: true)
  }

}
