//
//  CardActionableItem.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardActionableItem: ActionableLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 35

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol, text: String, imageName: String) {
    super.init(text: text, imageName: imageName)
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
      self.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 15),
      self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0),
    ])

    return result
  }

}
