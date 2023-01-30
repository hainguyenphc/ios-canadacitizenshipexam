//
//  ScreenTitleLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-28.
//

import UIKit

class ScreenTitleLabel: UILabel {

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
    if let imageName = imageName {
      super.init(frame: .zero)
      let attachment = NSTextAttachment()
      attachment.image = UIImage(systemName: imageName)?.withTintColor(APP_ACCENT_COLOR)
      let imageString = NSMutableAttributedString(attachment: attachment)
      let textString = NSMutableAttributedString(string: "\(text)    ")
      textString.append(imageString)
      self.attributedText = textString
      self.configureUI()
    } else {
      super.init(frame: .zero)
      self.text = text
      self.textColor = textColor // UIColor.white
      self.textAlignment = textAlignment
      self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
      self.configureUI()
    }



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

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
