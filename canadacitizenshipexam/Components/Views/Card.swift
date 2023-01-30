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

  func getHeight() -> CGFloat

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
    view.backgroundColor = .secondarySystemBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 20
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.4
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 10
    scrollView.addSubview(view)
    return self
  }

  func getHeight() -> CGFloat {
    return self.theHeight!
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
    super.init(text: text,
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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}

class CardTaglineLabel: ScreenTitleLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 45

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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}

class CardActionableItem: ActionableLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 34.5

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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}
