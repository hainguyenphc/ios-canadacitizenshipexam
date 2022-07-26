//
//  ProgressVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit
import FirebaseAuth

class ProgressVC: UIViewController {

  /* Contains the CCEHeadingView instance representing Practice Progress. */
  @IBOutlet var practiceProgressView: UIView!
  var practiceProgressHeadingView = CCEHeadingView(
    progress: Float(100.0),
    title: "Pratice Progress",
    bodyOne: "0 Daily Questions Answered",
    bodyTwo: "0 of 35 Tests Completed")

  /* Contains the CCEHeadingView instance representing Reading Progress. */
  @IBOutlet var readingProgressView: UIView!
  var readingProgressHeadingView = CCEHeadingView(
    progress: Float(100.0),
    title: "Reading Progress",
    bodyOne: "0 of 28 Sections Read",
    bodyTwo: "Progress: 0%")

  @IBOutlet var lastTestScoreLabel: UILabel!

  @IBOutlet var lastFiveTestsScoreLabel: UILabel!

  @IBOutlet var lastTenTestsScoreLabel: UILabel!

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureHeadingView()
    // Seeder.seedTestsV2()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.configureScoreStatsView()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureHeadingView() -> Void {
    //TODO: deal with the heading
  }

  func configureScoreStatsView() -> Void {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }
    ScoreStatsManager.shared.getLastTestScore(userID: userID) { [weak self] result in
      guard let self = self else { return }
      switch (result) {
        case .success(let score):
          self.lastTestScoreLabel.text = "\(score)%"
        case .failure(let error):
          //TODO: handle error
          print(error)
      }
    }
  }

  func configureUI() {
    self.practiceProgressView.addSubview(self.practiceProgressHeadingView)
    self.readingProgressView.addSubview(self.readingProgressHeadingView)
  }

}
