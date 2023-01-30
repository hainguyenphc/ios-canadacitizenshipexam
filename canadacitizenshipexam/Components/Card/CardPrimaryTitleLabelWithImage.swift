//
//  CardPrimaryTitleLabelWithImage.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardPrimaryTitleLabelWithImage: UIStackView, CardDecoratoProtocol {

  var card: CardProtocol?

  var theView: UIView?

  var theHeight: CGFloat? = 55

  var imageName: String?
  var imageView: UIImageView?

  var text: String!
  var titleLabel: ScreenTitleLabel!

  var hasPrecedentSibling: Bool!

  init(card: CardProtocol, text: String, imageName: String, hasPrecedentSibling: Bool = false) {
    super.init(frame: .zero)
    self.configureUI()

    self.imageName = imageName
    self.imageView = UIImageView(image: UIImage(systemName: imageName))
    self.imageView!.translatesAutoresizingMaskIntoConstraints = false
    self.imageView?.tintColor = APP_ACCENT_COLOR

    self.text = text
    self.titleLabel = ScreenTitleLabel(
      text: text,
      textColor: .label,
      textAlignment: .left,
      fontSize: 20,
      fontWeight: .regular)

    self.hasPrecedentSibling = hasPrecedentSibling

    self.card = card
    self.theView = self
    self.theHeight! += (self.card?.theHeight!)!
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: previous)
    let blockView: UIView = (self.card!).theView!
    self.addArrangedSubview(titleLabel!)
    self.addArrangedSubview(imageView!)
    blockView.addSubview(self)

      // There is no precedent sibling, which means this is the first decorator in a card.
    if (!hasPrecedentSibling) {
      NSLayoutConstraint.activate([
        self.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15),
        self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15),
        self.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.85)
      ])
    }
      // There is a precedent sibling.
    else {
        // The sibling is also a decorator.
      if self.card is CardDecoratoProtocol {
        NSLayoutConstraint.activate([
          self.topAnchor.constraint(equalTo: (self.card?.theView!.bottomAnchor)!, constant: 15),
          self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0),
          self.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.85)
        ])
      }
    }

    NSLayoutConstraint.activate([
      self.titleLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
      self.imageView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
    ])

    return result
  }

  func configureUI() {
    self.axis = .horizontal
    self.distribution = .equalSpacing
    self.translatesAutoresizingMaskIntoConstraints = false
    self.spacing = 0
    self.alignment = .center
  }

}
