//
//  TestsVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreData

class TestsVC: UIViewController {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var headingView: CCEHeadingView!

  var tableView: UITableView = UITableView()

  var sections: [CCESection_Complex] = []

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var tests = [CCETest]()

  // The persistent container's view context to access CoreData.
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor     = .secondarySystemBackground
    self.tableView.separatorStyle = .none
    self.loadTests()


    // self.configureTableView()
    // // Deliberately configures the heading after the table so that the heading
    // // appears on top of the table.
    // self.configureHeadingView()
  }

  override func viewWillAppear(_ animated: Bool) {
    // Always show tab bar when this renders.
    self.tabBarController?.tabBar.isHidden = false
    self.loadTests()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func loadTests() {
    NetworkManager.shared.getTests { [weak self] result in
      switch (result) {
        case .success(let cceTests):
          self?.sections = []
          self?.tests = cceTests
          for test in self!.tests {
            do {
              // Looks for any tests that are abruptly terminated (in-progress)
              // from last runtime and notifies user to resume them.
              let request: NSFetchRequest<Test> = Test.fetchRequest()
              request.predicate = NSPredicate(format: "testID CONTAINS[cd] %@", test.id)
              let inprogressTest = try self?.context.fetch(request)
              if inprogressTest!.count > 0 {
                self?.sections.append(CCESection_Complex(
                  primaryTitleTexts: [test.name],
                  bodyTexts: ["\(test.questions.count) Exam Questions.\nResume the in-proress test."],
                  iconNames: [SFSymbols.restart])
                )
              }
              else {
                self?.sections.append(CCESection_Complex(
                  primaryTitleTexts: [test.name],
                  bodyTexts: ["\(test.questions.count) Exam Questions."],
                  iconNames: [SFSymbols.lock])
                )
              }
            }
            catch {
              // TODO: properly handle error
            }
          }
          // Any UI-related updates are done on the main thread.
          DispatchQueue.main.async {
            guard let currentUser = Auth.auth().currentUser else {
              return
            }
            guard let usersData = NetworkManager.shared.getUsersData(userID: currentUser.uid) else {
              return
            }
            let totalChaptersRead = usersData.readChapters.count
            let totalChapters = Chapters.storage.count
            let progress = Float(totalChaptersRead * 100 / totalChapters)
            self?.headingView = CCEHeadingView(
              progress: progress,
              title: "Practice Progress",
              bodyOne: "\(totalChaptersRead) out of \(totalChapters) chapters read",
              bodyTwo: "Progress: \(progress)%"
            )
            self?.tableView.reloadData()
            self?.configureTableView()
            self?.configureHeadingView()
          }
        case .failure(let error):
          // TODO: properly handle error - a modal?
          print(error)
      }
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

extension TestsVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(
      withIdentifier: K.sectionCellIdentifier, for: indexPath)
      as! CCESectionCell_Complex
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
    let tryToResume = self.sections[indexPath.row].iconNames[0] == SFSymbols.restart
    let testvc = TestVC(with: self.tests[indexPath.row].id, tryToResume: tryToResume)
    testvc.title = sections[indexPath.row].primaryTitleTexts[0]
    self.navigationController?.pushViewController(testvc, animated: true)
  }

}

