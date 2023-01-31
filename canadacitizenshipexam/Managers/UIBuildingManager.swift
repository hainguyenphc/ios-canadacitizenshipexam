//
//  UIBuildingManager.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

class UIBuildingManager {

  // Singleton pattern.
  static let shared = UIBuildingManager()

  private init() {
    // Leaves empty.
  }

  func buildTheBackgroundView(multiplier: CGFloat) -> UIView? {
    // let multiplier = DEVICE_IDIOM == .pad ? 0.33 : 0.50
    let rectangle = CGRect(x: 0, y: 0, width: BOUNDS.size.width, height: BOUNDS.height * multiplier)
    let stickyHeadingView = UIView(frame: rectangle)
    stickyHeadingView.layer.backgroundColor = APP_ACCENT_COLOR.cgColor

    return stickyHeadingView
  }

  func buildTheTitleLabel(title: String, textColor: UIColor = UIColor.white) -> UILabel {
    let titleLabel = ScreenTitleLabel(
      text: title,
      textColor: textColor,
      textAlignment: .left,
      fontSize: 35,
      fontWeight: .bold
    )

    return titleLabel;
  }

  func buildTheImageNextToTitleLabel(systemName: String, tintColor: UIColor = .white) -> UIImageView? {
    let config = UIImage.SymbolConfiguration(
      pointSize: 10,
      weight: .thin,
      scale: .small
    )
    let image = UIImage(
      systemName: systemName,
      withConfiguration: config
    )
    image?.withTintColor(tintColor)

    let shareImageView = UIImageView(image: image)
    shareImageView.tintColor = tintColor
    shareImageView.translatesAutoresizingMaskIntoConstraints = false

    return shareImageView
  }

  func buildTheTaglineLabel(tagline: String, textColor: UIColor = UIColor.white) -> UILabel? {
    let taglineLabel = ScreenTitleLabel(
      text: tagline,
      textColor: textColor,
      textAlignment: .left,
      fontSize: 16,
      fontWeight: .regular
    )

    return taglineLabel;
  }

  func buildTheCompletionPercentageView(percent: Float, options: CompletionPercentageOptions) -> UIView? {
    let blockView = UIView()
    blockView.translatesAutoresizingMaskIntoConstraints = false

    let circularProgressView = CircularProgressView(
      frame: CGRect(x: 0, y: 0, width: 60, height: 60),
      lineWidth: 7,
      rounded: false
    )

    let roundedPercent = Int(percent * 100)
    circularProgressView.progress = percent

    blockView.addSubview(circularProgressView)

    NSLayoutConstraint.activate([
      circularProgressView.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 0),
      circularProgressView.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0)
    ])

    let numberLabel = ScreenTitleLabel(
      text: "\(roundedPercent)%",
      textColor: UIColor(cgColor: options.textColor),
      textAlignment: .left,
      fontSize: 16,
      fontWeight: .semibold
    )

    blockView.addSubview(numberLabel)

    NSLayoutConstraint.activate([
      numberLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 12),
      numberLabel.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 5),
      numberLabel.widthAnchor.constraint(equalToConstant: 50),
      numberLabel.heightAnchor.constraint(equalToConstant: 50)
    ])

    return blockView
  }

  /*
   @todo generalize the texts in here.
   */
  func buildTheCompletionDetailsView(textColor: UIColor = .white) -> UIView? {
    let blockView = UIView()
    blockView.translatesAutoresizingMaskIntoConstraints = false

    let primaryLabel = ScreenTitleLabel(
      text: "Practice Progress",
      textColor: textColor,
      textAlignment: .left,
      fontSize: 20,
      fontWeight: .bold
    )

    blockView.addSubview(primaryLabel)

    NSLayoutConstraint.activate([
      primaryLabel.topAnchor.constraint(equalTo: blockView.topAnchor),
      primaryLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor)
    ])

    let secondaryLabel = ScreenTitleLabel(
      text: "1 Daily Question Answered\n0 of 35 Tests Completed",
      // textColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8),
      textColor: textColor,
      textAlignment: .left,
      fontSize: 15,
      fontWeight: .regular
    )

    blockView.addSubview(secondaryLabel)
    NSLayoutConstraint.activate([
      secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 5),
      secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor)
    ])

    return blockView
  }

}
