//
//  CCEScreenCollectiveSummary.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCEScreenCollectiveSummary: UIView {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var alignment: NSTextAlignment! = .left

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var stackView = UIStackView()
  var metricsView: CCEScreenCollectiveMetricsView!    // right
  var progressView: CCEScreenCollectiveProgressView!  // left

  // ===========================================================================
  // Initializer
  // ===========================================================================

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(completed percent: Float,
       title: String    = "",
       bodyOne: String  = "",
       bodyTwo: String  = "",
       alignment: NSTextAlignment = .left
  ) {
    super.init(frame: .zero)
    self.progressView = CCEScreenCollectiveProgressView(completed: percent)
    self.metricsView  = CCEScreenCollectiveMetricsView(
      title: title, bodyOne: bodyOne, bodyTwo: bodyTwo)
    self.alignment = alignment
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.stackView.translatesAutoresizingMaskIntoConstraints = false
    self.stackView.axis           = .horizontal
    self.stackView.distribution   = .fillProportionally

    if (self.alignment == .left) {
      self.stackView.addArrangedSubview(self.progressView)
      self.stackView.addArrangedSubview(self.metricsView)
    }
    else if (self.alignment == .right) {
      self.stackView.addArrangedSubview(self.metricsView)
      self.stackView.addArrangedSubview(self.progressView)
    }
    
    self.addSubview(self.stackView)

    NSLayoutConstraint.activate([
      self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
