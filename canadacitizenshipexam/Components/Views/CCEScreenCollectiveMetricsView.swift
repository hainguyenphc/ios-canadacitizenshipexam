//
//  CCEScreenCollectiveMetricsView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

// The section indicating how many questions are done, how many sections are learnt.
// This makes up the right part of the collective summary view.
class CCEScreenCollectiveMetricsView: UIView {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var titleLabel: CCELevelTwoTitleLabel!
  var bodyOne: CCEBodyLabel!
  var bodyTwo: CCEBodyLabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(title: String = "", bodyOne: String = "", bodyTwo: String = "") {
    super.init(frame: .zero)
    //
    self.titleLabel = CCELevelTwoTitleLabel(text: title, textAlignment: .left)
    // self.titleLabel.text = title
    self.bodyOne = CCEBodyLabel(text: bodyOne, textAlignment: .left)
    // self.bodyOne.text = bodyOne
    self.bodyTwo = CCEBodyLabel(text: bodyTwo, textAlignment: .left)
    // self.bodyTwo.text = bodyTwo
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.bodyOne.translatesAutoresizingMaskIntoConstraints = false
    self.bodyTwo.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.titleLabel)
    self.addSubview(self.bodyOne)
    self.addSubview(self.bodyTwo)

    NSLayoutConstraint.activate([
      // title
      self.titleLabel.topAnchor.constraint(
        equalTo: self.topAnchor, constant: 10),
      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.titleLabel.trailingAnchor.constraint(
        equalTo: self.trailingAnchor, constant: -10),
      // body one
      self.bodyOne.topAnchor.constraint(
        equalTo: self.titleLabel.bottomAnchor, constant: 10),
      self.bodyOne.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.bodyOne.trailingAnchor.constraint(
        equalTo: self.trailingAnchor, constant: -10),
      // body two
      self.bodyTwo.topAnchor.constraint(
        equalTo: self.bodyOne.bottomAnchor, constant: 10),
      self.bodyTwo.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.bodyTwo.trailingAnchor.constraint(
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
