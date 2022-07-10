//
//  CCEScreenCollectiveProgressView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

// The circle indicating the completion percentage.
// This will make up the left part of the collective summary view.
class CCEScreenCollectiveProgressView: UIView {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var circularProgressLabel: CCECircularProgressLabel!

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var progress: Float = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(completed percent: Float) {
    super.init(frame: .zero)
    self.progress = percent
    self.circularProgressLabel = CCECircularProgressLabel(completed: self.progress)
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.circularProgressLabel.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.circularProgressLabel)

    NSLayoutConstraint.activate([
      self.circularProgressLabel.topAnchor.constraint(
        equalTo: self.topAnchor, constant: 10),
      self.circularProgressLabel.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.circularProgressLabel.trailingAnchor.constraint(
        equalTo: self.trailingAnchor, constant: -10),
    ])
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
