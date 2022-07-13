//
//  CCESectionCell_Complex.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-01.
//

import UIKit

class CCESectionCell_Complex: UITableViewCell {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  let cornnerRadius : CGFloat = 20
  let shadowOfSetWidth : CGFloat = 10
  let shadowOfSetHeight : CGFloat = 10
  let shadowColour : UIColor = UIColor.gray
  let shadowOpacity : CGFloat = 0.5
  var primaryTitleTexts: [String] = []
  var bodyTexts: [String] = []

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var primaryTitles = [CCELevelTwoTitleLabel]()
  var bodies = [CCEBodyLabel]()
  var icons = [UIImageView]()
  var iconNames = [String]()

  // ===========================================================================
  // Initializer
  // ===========================================================================

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
  }

  init(primaryTitleTexts: [String], bodyTexts: [String], iconNames: [String]) {
    super.init(style: .default, reuseIdentifier: K.sectionCellIdentifier)
    for (index, primaryTitleText) in primaryTitleTexts.enumerated() {
      let primaryTitle = CCELevelTwoTitleLabel(
        text: primaryTitleText, textAlignment: .left, fontSize: 18)
      let body = CCEBodyLabel(
        text: bodyTexts[index], textAlignment: .left, fontSize: 12)
      let icon = UIImageView()
      self.primaryTitles.append(primaryTitle)
      self.bodies.append(body)
      self.icons.append(icon)
      self.iconNames.append(iconNames[index])
    }
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    for (index, _) in self.primaryTitles.enumerated() {
      if (index > self.primaryTitles.count) {
        return
      }

      self.addSubview(self.primaryTitles[index])
      self.addSubview(self.bodies[index])
      self.addSubview(self.icons[index])
      // Configures the primary title.
      self.primaryTitles[index].translatesAutoresizingMaskIntoConstraints = false
      // Configure the bodies.
      self.bodies[index].translatesAutoresizingMaskIntoConstraints = false
      self.bodies[index].adjustsFontSizeToFitWidth = true
      self.bodies[index].lineBreakMode = .byWordWrapping
      self.bodies[index].numberOfLines = 10
      // Configure the icons.
      self.icons[index].translatesAutoresizingMaskIntoConstraints = false
      self.icons[index].image = UIImage(systemName: self.iconNames[index])
      self.icons[index].tintColor = .systemRed

      let p15: CGFloat = (CGFloat) (15)
      let unitHeight: CGFloat = (CGFloat) (45 * (index + 1))

      NSLayoutConstraint.activate([
        // primary title
        self.primaryTitles[index].topAnchor.constraint(
          equalTo: self.topAnchor, constant: index < 1 ? p15 : unitHeight),
        self.primaryTitles[index].leadingAnchor.constraint(
          equalTo: self.leadingAnchor, constant: p15),
        self.primaryTitles[index].trailingAnchor.constraint(
          equalTo: self.trailingAnchor, constant: p15),
        // body
        self.bodies[index].topAnchor.constraint(
          equalTo: self.primaryTitles[index].bottomAnchor, constant: p15),
        self.bodies[index].leadingAnchor.constraint(
          equalTo: self.leadingAnchor, constant: p15),
        self.bodies[index].widthAnchor.constraint(
          equalToConstant: 280),
        // icon/image
        self.icons[index].topAnchor.constraint(
          equalTo: self.primaryTitles[index].topAnchor, constant: p15),
        self.icons[index].trailingAnchor.constraint(
          equalTo: self.trailingAnchor, constant: -p15),
        self.icons[index].heightAnchor.constraint(equalToConstant: 30),
        self.icons[index].widthAnchor.constraint(equalToConstant: 30),
      ])
    } // end for
  }

  override func layoutSubviews() {
    self.backgroundColor = .systemBackground
    self.layer.cornerRadius = cornnerRadius
    self.layer.borderWidth = 0.1
  }

  func configureCell(section cceSection: CCECompoundSection, at index: Int) -> Void {
    // Resets all labels and images to nil.
    var counter = 0
    for (_, _) in self.primaryTitleTexts.enumerated() {
      self.primaryTitles[counter].text = nil
      self.bodies[counter].text = nil
      self.icons[counter].image = nil
      counter += 1
    }
    // Clears all elements in the arrays.
    self.primaryTitleTexts.removeAll()
    self.bodyTexts.removeAll()
    self.iconNames.removeAll()
    self.primaryTitles.removeAll()
    self.bodies.removeAll()
    self.icons.removeAll()
    // Populates the arrays with fresh data.
    counter = 0
    for (each) in cceSection.titles {
      self.primaryTitleTexts.append(each)
      self.bodyTexts.append(cceSection.bodyTexts[counter])
      self.iconNames.append(cceSection.iconNames[counter])
      counter += 1
    }
    self.prepareUIElements()
    self.configureUI()
  }

  func prepareUIElements() -> Void {
    for (index, primaryTitleText) in self.primaryTitleTexts.enumerated() {
      let primaryTitle = CCELevelTwoTitleLabel(
        text: primaryTitleText, textAlignment: .left, fontSize: 18)
      let body = CCEBodyLabel(
        text: bodyTexts[index], textAlignment: .left, fontSize: 12)
      let icon = UIImageView()
      self.primaryTitles.append(primaryTitle)
      self.bodies.append(body)
      self.icons.append(icon)
      self.iconNames.append(iconNames[index])
    }
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
