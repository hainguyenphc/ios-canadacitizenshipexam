//
//  CCEHeadingView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCEHeadingView: UIView {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var screenCollectiveSummary: CCEScreenCollectiveSummary!

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var progress: Float! = 0

  // ===========================================================================
  // Initializer
  // ===========================================================================

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.screenCollectiveSummary = CCEScreenCollectiveSummary(
      completed: self.progress,
      title: "Practice Progress",
      bodyOne: "0 Daily Questions Answered",
      bodyTwo: "0 of 35 Tests Completed"
    )
    self.configureUI()
  }

  init(progress: Float = 0.0, title: String = "", bodyOne: String = "", bodyTwo: String = "") {
    super.init(frame: CGRect())
    self.progress = progress
    self.screenCollectiveSummary = CCEScreenCollectiveSummary(
      completed: self.progress,
      title: title,
      bodyOne: bodyOne,
      bodyTwo: bodyTwo
    )
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.screenCollectiveSummary.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.screenCollectiveSummary)

    NSLayoutConstraint.activate([
      self.screenCollectiveSummary.topAnchor.constraint(
        equalTo: self.topAnchor, constant: 50),
      self.screenCollectiveSummary.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.screenCollectiveSummary.trailingAnchor.constraint(
        equalTo: self.trailingAnchor, constant: -10),
    ])
  }

  // ===========================================================================
  // Event handlers, action handlers, etc.
  // ===========================================================================

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
