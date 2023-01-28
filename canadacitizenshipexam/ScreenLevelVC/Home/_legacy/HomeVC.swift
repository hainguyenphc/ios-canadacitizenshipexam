  //
  //  HomeVC.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2022-04-30.
  //

import UIKit
import FirebaseAuth

// Legacy Home VC.
// @todo remove it.
class HomeVC: CCEBaseUIViewController {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var presenter: HomePresenterProtocol!

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
    self.presenter = HomePresenterImpl()
    // self.view.backgroundColor = .secondarySystemBackground
    // If there is no active user session, redirects user to the Register VC.
    guard let currentUser = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    // This is a good chance to cache the logged in user data.
    NetworkManager.shared.generateUsersDataOnServerIfNil(userID: currentUser.uid)
    self.presenter.loadProgress {[weak self] usersData in
      self?.userReadingProgressReceived(usersData)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    // Redirects user to Register screen if he is not logged in.
    guard let _ = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    // When user is back to Home tab, this de-selects the currently selected row.
    if let indexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRow(at: indexPath, animated: false)
    }
    // Do not hide the tab bar.
    self.tabBarController?.tabBar.isHidden = false
    // Do not show the Back button.
    self.navigationItem.setHidesBackButton(true, animated: false)
    self.presenter.loadProgress {[weak self] usersData in
      self?.userReadingProgressReceived(usersData)
    }
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func userReadingProgressReceived(_ usersData: CCEUsersData) {
    let totalChaptersRead = usersData.readChapters.count
    let totalChapters     = Chapters.storage.count
    let progress          = Float(totalChaptersRead * 100 / totalChapters)
    DispatchQueue.main.async {
      self.headingView = CCEHeadingView(
        progress: progress,
        title   : "Overall Progress",
        bodyOne : "\(totalChaptersRead) out of \(totalChapters) chapters read",
        bodyTwo : "Progress: \(progress)%"
      )
      self.configureTableView()
      self.configureHeadingView()
    }
  }

  func registerAppointment(_ appointment: Date) {
    self.presenter.registerAppointment(appointment)
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
