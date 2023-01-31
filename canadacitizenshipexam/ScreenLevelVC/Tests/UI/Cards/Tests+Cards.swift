//
//  Tests+Cards.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

extension TestsVC_ {

  func buildTheCards() {
    var cards: [CardProtocol] = []

    var card1: CardProtocol = Card()
    card1 = CardPrimaryTitleLabel(card: card1, text: "Create a Study Schedule")
    card1 = CardTaglineLabel(card: card1, text: "Make a schedule to meet your goals.\nTurn on notifications for study reminders.")
    card1 = CardActionableItem(card: card1, text: "Turn on Notifications", imageName: "bell")
    card1 = CardActionableItem(card: card1, text: "Schedule your Exam", imageName: "calendar")
    card1 = CardActionableItem(card: card1, text: "Practice Time: 10:00 AM", imageName: "clock")

    cards.append(card1)

    var card2: CardProtocol = Card()
    card2 = CardPrimaryTitleLabelWithImage(card: card2, text: "Daily Question", imageName: SFSymbols.info)
    cards.append(card2)

    var card3: CardProtocol = Card()
    card3 = CardPrimaryTitleLabelWithImage(card: card3, text: "Start Practicing", imageName: SFSymbols.tests)
    cards.append(card3)

    var card4: CardProtocol = Card()
    card4 = CardPrimaryTitleLabelWithImage(card: card4, text: "Read the Study Book", imageName: SFSymbols.book)
    cards.append(card4)

    var card5: CardProtocol = Card()
    card5 = CardPrimaryTitleLabelWithImage(card: card5, text: "Unlock Premimum Features", imageName: SFSymbols.premium)
    card5 = CardTaglineLabel(card: card5, text: "Maximize your chances by practicing with premium \ntests.")
    cards.append(card5)

    var card6: CardProtocol = Card()
    card6 = CardPrimaryTitleLabelWithImage(card: card6, text: "Progress Metrics", imageName: SFSymbols.progress)
    card6 = CardTaglineLabel(card: card6, text: "View past test scores and trends.")
    cards.append(card6)

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
    cards.append(card7)

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
