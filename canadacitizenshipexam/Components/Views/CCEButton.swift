//
//  CCEButton.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import Foundation
import UIKit

class CCEButton: UIButton {

  var isLarge: Bool = false

  // How to make the button contains its text with some paddings.
  override var intrinsicContentSize: CGSize {
    let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
    return CGSize(width: labelSize.width + 10, height: labelSize.height + 20)
  }

  // ===========================================================================
  // Initializer
  // ===========================================================================

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }

  init(backgroundColor: UIColor, title: String, isLarge: Bool = false) {
    super.init(frame: .zero)
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
    self.isLarge = isLarge
    self.configure()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  // While the button title/text and its background color may change, there are
  // several properties that remain consistent:
  // corner radius, title text color, title font and auto layout constraints.
  func configure() -> Void {
    // self.titleLabel?.lineBreakStrategy = .standard
    self.titleLabel?.lineBreakMode = .byWordWrapping
    self.titleLabel?.numberOfLines = 0
    self.titleLabel?.textAlignment = .center
    self.layer.cornerRadius = 10
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    self.translatesAutoresizingMaskIntoConstraints = false
    // Sets the height of the button.
    // NSLayoutConstraint.activate([
    //   NSLayoutConstraint(
    //     item: self,
    //     attribute: NSLayoutConstraint.Attribute.height,
    //     relatedBy: NSLayoutConstraint.Relation.equal,
    //     toItem: nil,
    //     attribute: NSLayoutConstraint.Attribute.notAnAttribute,
    //     multiplier: 1)
    // ])
  }

  func set(backgroundColor: UIColor, title: String) -> Void {
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
