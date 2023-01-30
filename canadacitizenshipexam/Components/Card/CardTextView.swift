//
//  CardTextView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardTextView: UITextView, CardDecoratoProtocol {

  var card: CardProtocol?

  var theView: UIView?

  var theHeight: CGFloat?

  init(card: CardProtocol? = nil, text: NSMutableAttributedString) {
    super.init(frame: .zero, textContainer: nil)
    self.attributedText = text
    self.configure()
    self.card = card
    self.theView = self
    self.theHeight = 0
  }

  func calculatedHeight(for text: String, width: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width,
                                      height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = text
    label.sizeToFit()
    return label.frame.height
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: previous)
    let blockView: UIView = (self.card!).theView!
    blockView.addSubview(self)

      // Suprisingly, no need to constrain anything.

    return result
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    self.layer.cornerRadius = 16
    self.textAlignment = .natural
    self.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
    let height = calculatedHeight(for: self.attributedText.string, width: BOUNDS.width * 0.95)
    self.frame = CGRect(x: 0, y: 0, width: BOUNDS.width * 0.95, height: height)
    self.translatesAutoresizingMaskIntoConstraints = false
  }

}
