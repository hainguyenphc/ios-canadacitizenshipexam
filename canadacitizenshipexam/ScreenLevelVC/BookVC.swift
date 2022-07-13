//
//  BookVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit
import FirebaseAuth

class BookVC: UIViewController {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var headingView: CCEHeadingView!

  var tableView: UITableView = UITableView()

  var sections: [CCECompoundSection] = []

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var chapters = Chapters.storage

  var readChapters = [CCEChapter]()

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .secondarySystemBackground
    self.tableView.separatorStyle = .none
    self.loadChapters()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.loadChapters()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func loadChapters() {
    self.sections = []
    for (index, chapter) in self.chapters.enumerated() {
      self.sections.append(CCECompoundSection(
        titles: ["Chapter \(index)"],
        bodyTexts: [chapter["title"]!],
        iconNames: [SFSymbols.read]
      ))
    } // end for

    guard let currentUser = Auth.auth().currentUser else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    guard let usersData = NetworkManager.shared.getUsersData(userID: currentUser.uid) else {
      return
    }
    let totalRead = usersData.readChapters.count
    let total = self.sections.count
    let progress = Float(totalRead * 100 / total)
    DispatchQueue.main.async {
      self.headingView = CCEHeadingView(
        progress: progress,
        title: "Reading Progress",
        bodyOne: "\(totalRead) out of \(total) sections read",
        bodyTwo: "Progress: \(Int(progress))%"
      )
      self.configureTableView()
      self.configureHeadingView()
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureHeadingView() -> Void {
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
    self.headingView.reloadInputViews()
  }

  func configureTableView() {
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
