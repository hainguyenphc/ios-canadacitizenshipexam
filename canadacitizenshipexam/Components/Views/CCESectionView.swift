//
//  CCESection.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCESectionView: UIView {

  var titleLabel = CCELevelTwoTitleLabel()
  var symbolImageView = UIImageView() // icon
  // var horizontalStackView = UIStackView()
  var subtitleLabel = CCEBodyLabel() // In red
  var infoLabel = CCEBodyLabel() // In grey

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(title: String?, subtitle: String?, info: String?, symbol: String?) {
    super.init(frame: .zero)
    self.titleLabel.text = title ?? ""
    self.subtitleLabel.text = subtitle ?? ""
    self.infoLabel.text = info ?? ""
    let imageName = symbol ?? SFSymbols.sectionFallbackImageName
    let image = UIImage(systemName: imageName)
    self.symbolImageView.image = image
    self.configureUI()
  }

  func configureUI() -> Void {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.symbolImageView.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.titleLabel)
    self.addSubview(self.symbolImageView)
    self.addSubview(self.subtitleLabel)
    self.addSubview(self.infoLabel)

    NSLayoutConstraint.activate([
      self.symbolImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      self.symbolImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      self.symbolImageView.widthAnchor.constraint(equalToConstant: 30),
      self.symbolImageView.heightAnchor.constraint(equalToConstant: 30),

      self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.symbolImageView.leadingAnchor, constant: 10),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

      self.subtitleLabel.topAnchor.constraint(equalTo: self.symbolImageView.bottomAnchor, constant: 10),
      self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),

      self.infoLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 10),
      self.infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      self.infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
    ])

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
