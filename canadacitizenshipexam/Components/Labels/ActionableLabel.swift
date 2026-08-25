//
//  ActionableLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-29.
//

import UIKit

class ActionableLabel: UILabel {

  private var storedText: String?
  private var storedImageName: String?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(
    text: String,
    imageName: String
  ) {
    super.init(frame: .zero)
    self.storedText = text
    self.storedImageName = imageName
    self.applyAttributedText()
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.textColor = APP_ACCENT_COLOR
    self.textAlignment = .left
    self.numberOfLines = 0
    self.minimumScaleFactor = 0.85
    self.lineBreakMode = .byWordWrapping
    self.adjustsFontSizeToFitWidth = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
  }

  // UIImage.withTintColor bakes the color into a static bitmap, unlike
  // textColor above (a genuine dynamic UIColor that re-resolves on its own).
  // Rebuild the leading icon once this label is actually attached to a
  // window — the first point its traitCollection reliably reflects the
  // app's real appearance — and again on every later Light/Dark Mode change.
  private func applyAttributedText() {
    guard let text = storedText, let imageName = storedImageName else { return }

    let textString = NSAttributedString(string: " \(text)")

    if !(imageName.isEmpty) {
      let attachment = NSTextAttachment()
      attachment.image = UIImage(systemName: imageName)?.withTintColor(APP_ACCENT_COLOR.resolvedColor(with: traitCollection))
      let imageString = NSMutableAttributedString(attachment: attachment)
      imageString.append(textString)
      self.attributedText = imageString
    } else {
      self.attributedText = textString
    }
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
