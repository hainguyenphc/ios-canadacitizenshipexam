//
//  CCEScreenCollectiveSummary.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCEScreenCollectiveSummary: UIView {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var stackView = UIStackView()
  var metricsView: CCEScreenCollectiveMetricsView!    // right
  var progressView: CCEScreenCollectiveProgressView!  // left

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(completed percent: Float,
       title: String    = "",
       bodyOne: String  = "",
       bodyTwo: String  = ""
  ) {
    super.init(frame: .zero)
    self.progressView = CCEScreenCollectiveProgressView(completed: percent)
    self.metricsView  = CCEScreenCollectiveMetricsView(
      title: title, bodyOne: bodyOne, bodyTwo: bodyTwo)
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.stackView.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.stackView)

    self.stackView.axis           = .horizontal
    self.stackView.distribution   = .fillProportionally
    self.stackView.addArrangedSubview(self.progressView)
    self.stackView.addArrangedSubview(self.metricsView)

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
