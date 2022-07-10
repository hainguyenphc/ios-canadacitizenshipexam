//
//  CCEButton.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import Foundation
import UIKit

class CCEButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(backgroundColor: UIColor, title: String) {
    super.init(frame: .zero)
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
    self.configure()
  }

    // While the button title/text and its background color may change, there are
    // several properties that remain consistent:
    // corner radius, title text color, title font and auto layout constraints.
  private func configure() -> Void {
    self.layer.cornerRadius     = 10
      // self.titleLabel?.textColor  = .white
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font       = UIFont.preferredFont(forTextStyle: .headline)
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  func set(backgroundColor: UIColor, title: String) -> Void {
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
  }

}
