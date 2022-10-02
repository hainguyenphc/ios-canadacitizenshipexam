//
//  BookVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit
import FirebaseAuth

class BookVC: CCEBaseUIViewController {

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
    }
    guard let userID = Auth.auth().currentUser?.uid else {
      self.navigationController?.pushViewController(RegisterVC(), animated: true)
      return
    }
    NetworkManager.shared.getUserReadingProgress(userID: userID, viewController: self)
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
