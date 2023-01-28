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
    bodyOne: "Loading...",
    bodyTwo: "")

  /* Contains the CCEHeadingView instance representing Reading Progress. */
  @IBOutlet var readingProgressView: UIView!
  var readingProgressHeadingView = CCEHeadingView(
    progress: Float(100.0),
    title: "Reading Progress",
    bodyOne: "Loading...",
    bodyTwo: "",
    alignment: .right)

  @IBOutlet var lastTestScoreLabel: UILabel!

  @IBOutlet var lastFiveTestsScoreLabel: UILabel!

  @IBOutlet var lastTenTestsScoreLabel: UILabel!

  @IBOutlet var allTestsScoreLabel: UILabel!

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.configureScoreStatsView()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureScoreStatsView() -> Void {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }

    ScoreStatsManager.shared.getAllTestsAverageScores(userID: userID) { [weak self] result in
      guard let self = self else { return }
      switch (result) {
        case .success(let progressReport):
          self.process(progressReport: progressReport)
        case .failure(let error):
          //TODO: handle error
          print(error)
      }
    }
  }

  func process(progressReport: CCEProgressReport) {
    let scores = progressReport.scores
    DispatchQueue.main.async {
      // Last test
      self.lastTestScoreLabel.text = "\(scores[0])%"
      // Last five tests
      let maxLength = scores.count
      var total = 0
      var count = min(5, maxLength)
      for index in 0..<count {
        total += scores[index]
      }
      total = total / count
      self.lastFiveTestsScoreLabel.text = "\(total)%"
      // Last ten tests
      total = 0
      count = min(10, maxLength)
      for index in 0..<count {
        total += scores[index]
      }
      total = total / count
      self.lastTenTestsScoreLabel.text = "\(total)%"
      // All tests
      total = 0
      count = maxLength
      for index in 0..<count {
        total += scores[index]
      }
      total = total / count
      self.allTestsScoreLabel.text = "\(total)%"
      // Renders the headings
      self.practiceProgressHeadingView.setBodyOne(
        content: "\(progressReport.numberOfFinishedTests) Tests completed")
      self.readingProgressHeadingView.setBodyOne(
        content: "\(progressReport.numberOfReadChapters) Chapters read")
      self.readingProgressHeadingView.setProgress(progress:
        (Float) (progressReport.numberOfReadChapters * 100 / Chapters.storage.count))
    }
  }

  func configureUI() {
    self.practiceProgressView.addSubview(self.practiceProgressHeadingView)
    self.readingProgressView.addSubview(self.readingProgressHeadingView)
  }

}
