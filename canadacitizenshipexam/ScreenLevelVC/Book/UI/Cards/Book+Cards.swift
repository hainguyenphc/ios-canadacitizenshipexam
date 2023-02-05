//
//  Book+Cards.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-04.
//

import UIKit

extension BookVC_ {

  func buildTheCards() {
    var cards: [CardProtocol] = []

    var card: CardProtocol = Card()
    card = CardPrimaryTitleLabelWithImage(
      card: card,
      text: "Free Practice Test",
      imageName: "circle.fill",
      tintColor: UIColor.systemGreen
    )
    card = CardActionableItem(card: card, text: "20 Exam Questions", imageName: "")
    cards.append(card)

    var card2: CardProtocol = Card()
    card2 = CardPrimaryTitleLabelWithImage(
      card: card2,
      text: "Discover Canada Test 1",
      imageName: "lock.fill",
      tintColor: UIColor.lightGray
    )
    card2 = CardActionableItem(card: card2, text: "20 Exam Questions", imageName: "")
    cards.append(card2)

    let bodyText = "After generating your fancy text symbols, you can copy and paste the \"fonts\" to most websites and text processors. You could use it to generate a fancy Agario name (yep, weird text in agario is probably generated using a fancy text converter similar to this), to generate a creative-looking instagram, facebook, tumblr, or twitter post, for showing up n00bs on Steam, or just for sending messages full of beautiful text to your buddies.\nThe only exception is if your paste destination has a font which doesn't support some unicode characters. For example, you'll might find that some websites don't use a unicode font, or if they do, the font doesn't have all the characters required. In that case, you'll see a generic \"box\" in which was created when the browser tries to create a fancy letter. This doesn't mean there's an error with this translator, it just means the website's font doesn't support that character."
    let decoratedBodyText = NSMutableAttributedString(string: "\n\(bodyText)", attributes: [
      .font: UIFont.systemFont(ofSize: 16, weight: .regular),
    ])

    let image = UIImage(systemName: "bubble.left.and.exclamationmark.bubble.right")!
      .withTintColor(APP_ACCENT_COLOR)
    let attachment = NSTextAttachment()
    attachment.image = image
    let attributedText = NSMutableAttributedString(attachment: attachment)

    let titleText = "How difficult is the official test?";
    let decoratedTitleText = NSMutableAttributedString(string: " \(titleText)", attributes: [
      .font: UIFont.systemFont(ofSize: 16, weight: .bold),
      .foregroundColor: UIColor.label,
      .strokeColor: UIColor.red,
    ])

    attributedText.append(decoratedTitleText)
    attributedText.append(decoratedBodyText)

    var card7: CardProtocol = Card()
    card7 = CardTextView(card: card7, text: attributedText)

    cards.insert(card7, at: 1)

    var x: CardProtocol? = nil
    var previousView: UIView? = nil
      // The height of the heading area.
    distanceToTop = 200
    var index = 0
    for each in cards {
      x = each.build(scrollView: scrollView, previous: (index == 0) ? self.completionCircularProgressView : previousView)
      NSLayoutConstraint.activate([
        (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
        (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        (x!).theView!.heightAnchor.constraint(equalToConstant: each.theHeight!),
        (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
      ])
      previousView = (each).theView
      distanceToTop += each.theHeight! + DISTANCE_BETWEEN_CARDS
      index += 1
    }
  }

}
