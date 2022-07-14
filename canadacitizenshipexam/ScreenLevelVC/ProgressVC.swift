//
//  ProgressVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class ProgressVC: UIViewController {

  @IBOutlet var practiceProgressView: UIView!

  @IBOutlet var readingProgressView: UIView!

  @IBOutlet var lastTestScoreLabel: UILabel!

  @IBOutlet var lastFiveTestsScoreLabel: UILabel!

  @IBOutlet var lastTenTestsScoreLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureHeadingView()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureHeadingView() -> Void {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution   = .fillProportionally
    stackView.translatesAutoresizingMaskIntoConstraints = false

    let practiceProgressView = CCEHeadingView(
      progress: Float(100.0),
      title: "Pratice Progress",
      bodyOne: "0 Daily Questions Answered",
      bodyTwo: "0 of 35 Tests Completed"
    )
    self.practiceProgressView.addSubview(practiceProgressView)

    let readingProgressView = CCEHeadingView(
      progress: Float(100.0),
      title: "Reading Progress",
      bodyOne: "0 of 28 Sections Read",
      bodyTwo: "Progress: 0%")
    self.readingProgressView.addSubview(readingProgressView)
  }

}
