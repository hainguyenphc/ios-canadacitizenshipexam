  //
  //  Card.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-01-28.
  //

import UIKit

protocol CardProtocol {

  var theView: UIView? {get set}

  var theHeight: CGFloat? {get set}

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol?

}

class Card: UIViewController, CardProtocol {

  var theHeight: CGFloat? = 0

  var theView: UIView?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    self.theView = self.view
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func build(scrollView: UIScrollView, previous: UIView? = nil) -> CardProtocol? {
    view.overrideUserInterfaceStyle = .light
    view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.4
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 10
    scrollView.addSubview(view)
    return self
  }

}

protocol CardDecoratoProtocol: UIView, CardProtocol {

  var card: CardProtocol? {get set}

}

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
    let blockView: UIView = (self.card!).theView!
    blockView.addSubview(self)
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15),
      self.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15),
    ])

    return result
  }

}

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
