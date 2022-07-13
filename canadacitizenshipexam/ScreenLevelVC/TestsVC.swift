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

  var sections: [CCECompoundSection] = []

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
    self.view.backgroundColor = .secondarySystemBackground
    self.tableView.separatorStyle = .none
    self.loadTests()
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
                self?.sections.append(CCECompoundSection(
                  titles: [test.name],
                  bodyTexts: ["\(test.questions.count) Exam Questions.\nResume the in-proress test."],
                  iconNames: [SFSymbols.restart])
                )
              }
              else {
                self?.sections.append(CCECompoundSection(
                  titles: [test.name],
                  bodyTexts: ["\(test.questions.count) Exam Questions."],
                  iconNames: [SFSymbols.lock])
                )
              }
            }
            catch {
              // TODO: properly handle error
              print(error)
            }
          } // end for
          // Any UI-related updates are done on the main thread.
          DispatchQueue.main.async {
            guard let currentUser = Auth.auth().currentUser else {
              return
            }
            NetworkManager.shared.getUsersData(userID: currentUser.uid) { [weak self] result in
              guard let self = self else { return }
              switch (result) {
                case .success(let usersData):
                  let totalTestsFinished = usersData.finishedTests.count
                  let totalTests = cceTests.count
                  let progress = Float(totalTestsFinished * 100 / totalTests)
                  self.headingView = CCEHeadingView(
                    progress: progress,
                    title: "Practice Progress",
                    bodyOne: "\(totalTestsFinished) out of \(totalTests) tests finished",
                    bodyTwo: "Progress: \(progress)%"
                  )
                  self.configureTableView()
                  self.configureHeadingView()
                  self.tableView.reloadData()
                case .failure(let error):
                  print(error)
              }
            }
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
