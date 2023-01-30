//
//  ActionableLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-29.
//

import UIKit

class ActionableLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(
    text: String,
    imageName: String
  ) {
    super.init(frame: .zero)
    let attachment = NSTextAttachment()
    attachment.image = UIImage(systemName: imageName)?.withTintColor(APP_ACCENT_COLOR)
    let imageString = NSMutableAttributedString(attachment: attachment)
    let textString = NSAttributedString(string: " \(text)")
    imageString.append(textString)
    self.attributedText = imageString
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

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
