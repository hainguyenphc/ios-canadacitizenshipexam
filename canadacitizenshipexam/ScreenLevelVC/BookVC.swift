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

  var sections: [CCESection_Complex] = []

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
    self.view.backgroundColor     = .secondarySystemBackground
    self.tableView.separatorStyle = .none
    self.loadChapters()
    // Delays calling those configuration methods until a percentage is determined.
    // self.configureTableView()
    // self.configureHeadingView()
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
      self.sections.append(CCESection_Complex(
        primaryTitleTexts: ["Chapter \(index)"],
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

//MARK: Extension of BookVC

extension BookVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.chapters.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(
      withIdentifier: K.sectionCellIdentifier, for: indexPath)
    as! CCESectionCell_Complex
    rcell.selectionStyle = .none
    rcell.set_(section: sections[indexPath.row], at: 0)
    return rcell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section             = sections[indexPath.row]
    let count               = section.primaryTitleTexts.count
    let characterCount      = self.sections[indexPath.row].bodyTexts[0].count
    let numberOfRowsNeeded  = (Double) (characterCount / K.standardCharacterCountForTableCell).rounded(.up)
    if count == 1 {
      if numberOfRowsNeeded <= 2 {
        return (count == 1) ? (CGFloat) (100) : (CGFloat) (100 * count - 30)
      }
      else {
        return 190
      }
    }
    else {
      return (CGFloat) (100 * count - 30)
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    self.headingView.isHidden = offsetY > -170
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chapterVC = ChapterVC(chapterIndex: indexPath.row)
    chapterVC.title = sections[indexPath.row].primaryTitleTexts[0]
    self.navigationController?.pushViewController(chapterVC, animated: true)
  }

}
