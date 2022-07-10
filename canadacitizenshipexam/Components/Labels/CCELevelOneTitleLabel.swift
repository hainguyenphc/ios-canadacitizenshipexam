//
//  CCEScreenTitleLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCELevelOneTitleLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(text: String = "",textAlignment: NSTextAlignment = .left, fontSize: CGFloat = 20) {
    super.init(frame: .zero)
    self.text           = text
    self.textAlignment  = textAlignment
    self.font           = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.textColor                                 = .label
    self.minimumScaleFactor                        = 0.85
    self.lineBreakMode                             = .byTruncatingTail
    self.adjustsFontSizeToFitWidth                 = true
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
