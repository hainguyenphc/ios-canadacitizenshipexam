//
//  CCESectionCell(Empty).swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-01.
//

import UIKit

class CCESectionCell: UITableViewCell {

  let cornnerRadius : CGFloat     = 20
  let shadowOfSetWidth : CGFloat  = 10
  let shadowOfSetHeight : CGFloat = 10
  let shadowColour : UIColor      = UIColor.gray
  let shadowOpacity : CGFloat     = 0.5

  var primaryTitle  = CCELevelTwoTitleLabel(text: "Notifications", textAlignment: .left, fontSize: 18)
  var body          = CCEBodyLabel(text: "Get updates on daily questions and study reminders", textAlignment: .left, fontSize: 12)
  var icon          = UIImageView()
  var iconName      = ""

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
  }

  init(primaryTileText: String, bodyText: String, iconName: String) {
    super.init(style: .default, reuseIdentifier: K.sectionCellIdentifier)
    self.primaryTitle  = CCELevelTwoTitleLabel(text: primaryTileText, textAlignment: .left, fontSize: 18)
    self.body          = CCEBodyLabel(text: bodyText, textAlignment: .left, fontSize: 12)
    self.icon          = UIImageView()
    self.iconName      = iconName
    self.configureUI()
  }

  func configureUI() -> Void {
    self.addSubview(self.primaryTitle)
    self.addSubview(self.body)
    self.addSubview(self.icon)
    self.primaryTitle.translatesAutoresizingMaskIntoConstraints = false
    self.body.translatesAutoresizingMaskIntoConstraints = false
    self.icon.translatesAutoresizingMaskIntoConstraints = false
    self.body.adjustsFontSizeToFitWidth = true
    self.body.lineBreakMode             = .byWordWrapping
    self.body.numberOfLines             = 2
    self.icon.image                     = UIImage(systemName: self.iconName )
    self.icon.tintColor                 = .systemRed
    NSLayoutConstraint.activate([
      // primary title
      self.primaryTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      self.primaryTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      self.primaryTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 15),
      // body
      self.body.topAnchor.constraint(equalTo: self.primaryTitle.bottomAnchor, constant: 15),
      self.body.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      self.body.widthAnchor.constraint(equalToConstant: 280),
      // icon/image
      self.icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
      self.icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      self.icon.heightAnchor.constraint(equalToConstant: 30),
      self.icon.widthAnchor.constraint(equalToConstant: 30),
    ])
  }

  override func layoutSubviews() {
    backgroundColor       = .systemBackground
    layer.cornerRadius    = cornnerRadius
    layer.shadowColor     = shadowColour.cgColor
    layer.shadowOffset    = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
    let shadowPath        = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
    layer.shadowPath      = shadowPath.cgPath
    layer.shadowOpacity   = Float(shadowOpacity)
  }

  func set_(section cceSection: CCESection) -> Void {
    self.primaryTitle.text = cceSection.primaryTitleText
    self.body.text = cceSection.bodyText
    self.icon.image = UIImage(systemName: cceSection.iconName ?? SFSymbols.book)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
