  //
  //  HomeVC.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2022-04-30.
  //

import UIKit
import FirebaseAuth

class HomeVC: CCEBaseUIViewController {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var dateTimeTextField: UITextField = UITextField()

  var appointment: Date! = Date()

  override var sections: [CCECompoundSection] {
    get {
      return [
        CCECompoundSection(
          titles: ["Create a Study Schedule"],
          bodyTexts: ["Make a schedule to meet your goals. Turn on notifications for reminders."],
          iconNames: [SFSymbols.notifications]),
        CCECompoundSection(
          titles: ["Start Practicing"],
          bodyTexts: ["Practice makes perfect. Test your knowledge now."],
          iconNames: [SFSymbols.tests]),
        CCECompoundSection(
          titles: ["Test Exemptions"],
          bodyTexts: ["You do not need to take the test if you are under the age of 18 or 55 and over."],
          iconNames: [SFSymbols.info]),
        CCECompoundSection(
          titles: ["Read the Study Book"],
          bodyTexts: ["Detailed excerpts from the official Discover Canada study guide."],
          iconNames: [SFSymbols.book])
      ]
    }
    set {
      // Leaves empty
    }
  }

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================


  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .secondarySystemBackground
    // If there is no active user session, redirects user to the Register VC.
    guard let currentUser = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    // This is a good chance to cache the logged in user data.
    NetworkManager.shared.generateUsersDataOnServerIfNil(userID: currentUser.uid)
    self.loadProgress()
  }

  override func viewWillAppear(_ animated: Bool) {
    guard let _ = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    // When user is back to Home tab, this deselects the currently selected row.
    if let indexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: indexPath, animated: false)
    }
    self.tabBarController?.tabBar.isHidden = false
    self.navigationItem.setHidesBackButton(true, animated: false)
    self.loadProgress()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func loadProgress() -> Void {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }
    NetworkManager.shared.getUserReadingProgress(userID: userID, viewController: self)
  }

  /* Users picked a date time to start practicing. */
  func registerAppointment() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [
      .alert,
      .badge,
      .sound
    ]) { granted, error in
      // code
    }
    let content = UNMutableNotificationContent()
    content.title = "Practice Reminder"
    content.body = "You booked a pratice session."
    let dateComponents = Calendar.current.dateComponents([
      .year,
      .month,
      .day,
      .hour,
      .minute,
      .second
    ], from: self.appointment) // let date = Date().addingTimeInterval(15)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    center.add(request) { error in
      // @TODO: handle errors
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  override func configureTableView() {
    self.tableView.delegate   = self
    self.tableView.dataSource = self
    super.configureTableView()
  }

}
