//
//  CardTaglineLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardTaglineLabel: ScreenTitleLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 40

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol, text: String) {
    super.init(text: text,
               textColor: .label,
               textAlignment: .left,
               fontSize: 16,
               fontWeight: .thin)
    self.card = card
    self.theView = self
    self.theHeight! += (self.card?.theHeight!)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: nil)
    let blockView: UIView = (self.card!).theView!
    blockView.addSubview(self)
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 10),
      self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0),
    ])

    return result
  }

}
