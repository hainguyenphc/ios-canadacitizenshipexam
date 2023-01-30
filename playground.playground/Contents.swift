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

  // func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol?

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

  func getHeight() -> CGFloat {
    return 0
  }

}

protocol CardDecoratoProtocol: UIView, CardProtocol {

  var card: CardProtocol? {get set}

  // func getHeight() -> CGFloat

}

class CardPrimaryTitleLabel: ScreenTitleLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 31

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol) {
    super.init(text: "Create a study schedule",
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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}

class CardTaglineLabel: ScreenTitleLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 21

  var theView: UIView?

  var card: CardProtocol?

  init(card: CardProtocol) {
    super.init(text: "Make a schedule to meet your goals.\nTurn on notifications for study reminders.",
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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}

class CardActionableItem: ActionableLabel, CardDecoratoProtocol {

  var theHeight: CGFloat? = 11

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

  func getHeight() -> CGFloat {
    return self.theHeight!
  }

}

//


var card3: CardProtocol = Card()
card3 = CardPrimaryTitleLabel(card: card3) //31
card3 = CardTaglineLabel(card: card3) //21
card3 = CardTaglineLabel(card: card3) //21
print("Line 132: \((card3 as! CardDecoratoProtocol).getHeight())")
card3 = CardActionableItem(card: card3, text: "Hello World", imageName: "clock") //11
print("Line 134: \((card3 as! CardDecoratoProtocol).getHeight())")
card3 = CardActionableItem(card: card3, text: "Heal the World", imageName: "calendar") //11
print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")
card3 = CardActionableItem(card: card3, text: "Heal the World", imageName: "calendar") //11
print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")
card3 = CardPrimaryTitleLabel(card: card3) //31
print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")

// var card3: CardProtocol = Card()
// card3 = CardPrimaryTitleLabel(card: card3) //31
// print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")
// card3 = CardTaglineLabel(card: card3) //21
// print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")
// card3 = CardPrimaryTitleLabel(card: card3) // 31
// print("Line 136: \((card3 as! CardDecoratoProtocol).getHeight())")
