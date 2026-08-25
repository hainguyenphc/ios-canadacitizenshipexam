//
//  CardPrimaryTitleLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardPrimaryTitleLabel: ScreenTitleLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 55

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol, text: String) {
    super.init(
      text: text,
      textColor: .label,
      textAlignment: .left,
      fontSize: 20,
      fontWeight: .regular)

    self.card = card
    self.theView = self
    self.theHeight! += (self.card?.theHeight!)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: nil)
    // blockView anchors our vertical position (here, always the top, since
    // this is always the first decorator in a card); cardBackground is the
    // actual card container every row should be a flat sibling inside,
    // rather than nested inside one another (see CardActionableItem.build()
    // for why that matters).
    let blockView: UIView = (self.card!).theView!
    let cardBackground: UIView = result!.theView!
    cardBackground.addSubview(self)
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15),
      self.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
    ])

    return result
  }

}
