//
//  ScreenTitleLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-28.
//

import UIKit

class ScreenTitleLabel: UILabel {

  private var storedText: String?
  private var storedImageName: String?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(
    text: String,
    textColor: UIColor,
    textAlignment: NSTextAlignment,
    fontSize: CGFloat,
    fontWeight: UIFont.Weight,
    imageName: String? = nil
  ) {
    super.init(frame: .zero)

    if let imageName = imageName {
      self.storedText = text
      self.storedImageName = imageName
      self.applyAttributedText()
    } else {
      self.text = text
      self.textColor = textColor // UIColor.white
      self.textAlignment = textAlignment
      self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }

    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.numberOfLines = 0
    self.minimumScaleFactor = 0.85
    self.lineBreakMode = .byWordWrapping
    self.adjustsFontSizeToFitWidth = true
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  // UIImage.withTintColor bakes the color into a static bitmap. Rebuild the
  // trailing icon once this label is actually attached to a window — the
  // first point its traitCollection reliably reflects the app's real
  // appearance — and again on every later Light/Dark Mode change.
  private func applyAttributedText() {
    guard let text = storedText, let imageName = storedImageName else { return }

    let attachment = NSTextAttachment()
    attachment.image = UIImage(systemName: imageName)?.withTintColor(APP_ACCENT_COLOR.resolvedColor(with: traitCollection))
    let imageString = NSMutableAttributedString(attachment: attachment)
    let textString = NSMutableAttributedString(string: "\(text)    ")
    textString.append(imageString)
    self.attributedText = textString
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    if window != nil {
      applyAttributedText()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      applyAttributedText()
    }
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
