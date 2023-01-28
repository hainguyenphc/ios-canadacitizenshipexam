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
    fontWeight: UIFont.Weight
  ) {
    super.init(frame: .zero)
    self.text = text
    self.textColor = textColor // UIColor.white
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.numberOfLines = 0
    self.minimumScaleFactor = 0.85
    self.lineBreakMode = .byTruncatingTail
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
