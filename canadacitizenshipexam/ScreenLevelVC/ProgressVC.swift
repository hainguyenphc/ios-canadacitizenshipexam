//
//  ProgressVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class ProgressVC: UIViewController {

  /* Contains the CCEHeadingView instance representing Practice Progress. */
  @IBOutlet var practiceProgressView: UIView!
  var practiceProgressHeadingView: CCEHeadingView!

  /* Contains the CCEHeadingView instance representing Reading Progress. */
  @IBOutlet var readingProgressView: UIView!
  var readingProgressHeadingView: CCEHeadingView!

  @IBOutlet var lastTestScoreLabel: UILabel!

  @IBOutlet var lastFiveTestsScoreLabel: UILabel!

  @IBOutlet var lastTenTestsScoreLabel: UILabel!

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureHeadingView()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureHeadingView() -> Void {
    self.practiceProgressHeadingView = CCEHeadingView(
      progress: Float(100.0),
      title: "Pratice Progress",
      bodyOne: "0 Daily Questions Answered",
      bodyTwo: "0 of 35 Tests Completed")
    self.practiceProgressView.addSubview(self.practiceProgressHeadingView)

    self.readingProgressHeadingView = CCEHeadingView(
      progress: Float(100.0),
      title: "Reading Progress",
      bodyOne: "0 of 28 Sections Read",
      bodyTwo: "Progress: 0%")
    self.readingProgressView.addSubview(self.readingProgressHeadingView)
  }

}
