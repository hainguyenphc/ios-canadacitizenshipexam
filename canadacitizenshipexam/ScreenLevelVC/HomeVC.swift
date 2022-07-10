  //
  //  HomeVC.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2022-04-30.
  //

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var headingView: CCEHeadingView!

  var tableView: UITableView = UITableView()

  var dateTimeTextField: UITextField = UITextField()

  var appointment: Date! = Date()

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var sections: [CCESection_Complex] = [
    CCESection_Complex(
      primaryTitleTexts: ["Create a Study Schedule"],
      bodyTexts: ["Make a schedule to meet your goals. Turn on notifications for reminders."],
      iconNames: [SFSymbols.notifications]),
    CCESection_Complex(
      primaryTitleTexts: ["Start Practicing"],
      bodyTexts: ["Practice makes perfect. Test your knowledge now."],
      iconNames: [SFSymbols.tests]),
    CCESection_Complex(
      primaryTitleTexts: ["Test Exemptions"],
      bodyTexts: ["You do not need to take the test if you are under the age of 18 or 55 and over."],
      iconNames: [SFSymbols.info]),
    CCESection_Complex(
      primaryTitleTexts: ["Read the Study Book"],
      bodyTexts: ["Detailed excerpts from the official Discover Canada study guide."],
      iconNames: [SFSymbols.book])
    // CCESection_Complex(
    //   primaryTitleTexts: ["Unlock Premium Features"],
    //   bodyTexts: ["The features are under way. Please "],
    //   iconNames: [SFSymbols.premium]),
    ]

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
    NetworkManager.shared.cacheUsersData(userID: currentUser.uid)
  }

  override func viewWillAppear(_ animated: Bool) {
    // When user is back to Home tab, this deselects the currently selected row.
    if let indexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: indexPath, animated: false)
    }
    self.tabBarController?.tabBar.isHidden = false
    self.navigationItem.setHidesBackButton(true, animated: false)
    // Allows one second for the network request completes.
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.loadProgress()
    }
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func loadProgress() -> Void {
    guard let currentUser = Auth.auth().currentUser else {
      return
    }
    guard let usersData = NetworkManager.shared.getUsersData(userID: currentUser.uid) else {
      return
    }
    let totalChaptersRead = usersData.readChapters.count
    let totalChapters = Chapters.storage.count
    let progress = Float(totalChaptersRead * 100 / totalChapters)
    DispatchQueue.main.async {
      self.headingView = CCEHeadingView(
        progress: progress,
        title: "Practice Progress",
        bodyOne: "\(totalChaptersRead) out of \(totalChapters) chapters read",
        bodyTwo: "Progress: \(progress)%"
      )
      self.configureTableView()
      self.configureHeadingView()
    }
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
      // code
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureHeadingView() -> Void {
    self.headingView.progress = 100
    self.view.addSubview(self.headingView)
    self.headingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.headingView.topAnchor.constraint(
        equalTo: self.view.topAnchor, constant: 10),
      self.headingView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor, constant: 10),
      self.headingView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor, constant: -10)
    ])
  }

  func configureTableView() -> Void {
    self.tableView.separatorStyle = .none
    self.view.addSubview(self.tableView)
    self.tableView.delegate   = self
    self.tableView.dataSource = self
    self.tableView.register(
      CCESectionCell_Complex.self,
      forCellReuseIdentifier: K.sectionCellIdentifier)
    self.tableView.pin(to: self.view)
    self.tableView.backgroundColor = .secondarySystemBackground
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    // Moves table content down 80 units down -> the Heading Label is visible.
    self.tableView.contentInset = UIEdgeInsets(
      top: 80, left: 0, bottom: 0, right: 0)
  }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(withIdentifier: K.sectionCellIdentifier, for: indexPath) as! CCESectionCell_Complex
    rcell.set_(section: sections[indexPath.row], at: 0)
    return rcell
  }

  /* Dynamically determines the table row height. */
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath.row == 2) {
      return 120
    }
    let section             = sections[indexPath.row]
    let count               = section.primaryTitleTexts.count
    let characterCount      = self.sections[indexPath.row].bodyTexts[0].count
    let numberOfRowsNeeded  = (Double) (characterCount / K.standardCharacterCountForTableCell).rounded(.up)
    if count == 1 {
      if numberOfRowsNeeded <= 2 {
        return (count == 1) ? (CGFloat) (100) : (CGFloat) (100 * count - 30)
      } else {
        return 190
      }
    }
    else {
      return (CGFloat) (100 * count - 30)
    }
  }

  /* Scrolling down hides its heading view. Scrolling up to the top shows it. */
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    if offsetY > -170 {
      self.headingView.isHidden = true
    }
    else {
      self.headingView.isHidden = false
    }
  }

  /* Configures the tab bar controller. Clicking on "Start Practicing" cell
   redirects user to the "Tests" tab of the controller. */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let iconName = self.sections[indexPath.row].iconNames[0]
    switch iconName {
      case SFSymbols.tests:
      self.tabBarController?.selectedIndex = 1
        break
      case SFSymbols.book:
        self.tabBarController?.selectedIndex = 2
        break
      case SFSymbols.progress:
        self.tabBarController?.selectedIndex = 3
        break
      case SFSymbols.settings:
        self.tabBarController?.selectedIndex = 4
        break
      case SFSymbols.notifications:
        /* Create a study schedule. */
        let viewController = CCEDatePickerVC()
        viewController.parentVC = self
        self.present(viewController, animated: true) {
          // code...
        }
        break
      default:
        self.tabBarController?.selectedIndex = 0
        break
    }
  }

}
