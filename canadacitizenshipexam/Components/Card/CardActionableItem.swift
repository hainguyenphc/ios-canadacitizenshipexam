//
//  CardActionableItem.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardActionableItem: ActionableLabel, CardDecoratoProtocol {

  // Always overwritten in init with a height measured from the actual content.
  var theHeight: CGFloat?

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol, text: String, imageName: String) {
    super.init(text: text, imageName: imageName)
    self.card = card
    self.theView = self
    // A flat height assumes a single line, which undercounts rows whose text
    // wraps (leaving them clipped) and overcounts short ones (leaving a gap).
    // Measure this label's own attributed text at the width it will actually
    // render at, so the row's contribution always matches its real content.
    let width = BOUNDS.width * 0.85
    let measuredHeight = self.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height
    self.theHeight = measuredHeight + 15 + (self.card?.theHeight ?? 0)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: nil)
    let blockView: UIView = (self.card!).theView!
    blockView.addSubview(self)
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 15),
      self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0),
      // Without an explicit width, the label has no boundary to wrap against and
      // just grows to fit its text on one line, overflowing the card. Match the
      // width CardPrimaryTitleLabelWithImage already uses for the same reason.
      self.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.85),
    ])

    return result
  }

}
