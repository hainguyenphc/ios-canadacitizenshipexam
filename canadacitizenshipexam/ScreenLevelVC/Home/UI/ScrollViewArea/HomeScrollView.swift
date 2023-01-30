  //
  //  HomeScrollView.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-01-29.
  //

import UIKit

extension HomeVC_: ScrollProtocol {

  func setupScrollView() {
    scrollView.overrideUserInterfaceStyle = .light
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    // We set this until the very end.
    // scrollView.contentSize = CGSize(width: 100, height: 1000)
    view.addSubview(scrollView)

    if completionPercentageView != nil {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (completionPercentageView! as UIView).bottomAnchor, constant: 20)
      ])
    } else {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide).topAnchor, constant: 20)
      ])
    }

    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SCROLL_VIEW_LEFT_AND_RIGHT_SPACE),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -SCROLL_VIEW_LEFT_AND_RIGHT_SPACE),
      scrollView.heightAnchor.constraint(equalToConstant: BOUNDS.height * 0.7)
    ])

    var cards: [CardProtocol] = []

    var card1: CardProtocol = Card()
    card1 = CardPrimaryTitleLabel(card: card1, text: "Create a Study Schedule")
    card1 = CardTaglineLabel(card: card1, text: "Make a schedule to meet your goals.\nTurn on notifications for study reminders.")
    card1 = CardActionableItem(card: card1, text: "Turn on Notifications", imageName: "bell")
    card1 = CardActionableItem(card: card1, text: "Schedule your Exam", imageName: "calendar")
    card1 = CardActionableItem(card: card1, text: "Practice Time: 10:00 AM", imageName: "clock")

    cards.append(card1)

    var card2: CardProtocol = Card()
    card2 = CardPrimaryTitleLabel(card: card2, text: "Daily Question", imageName: "exclamationmark.circle")
    cards.append(card2)

    var card3: CardProtocol = Card()
    card3 = CardPrimaryTitleLabel(card: card3, text: "Start Practicing", imageName: SFSymbols.tests)
    cards.append(card3)

    var card4: CardProtocol = Card()
    card4 = CardPrimaryTitleLabel(card: card4, text: "Read the Study Book", imageName: SFSymbols.book)
    cards.append(card4)

    var card5: CardProtocol = Card()
    card5 = CardPrimaryTitleLabel(card: card5, text: "Unlock Premimum Features", imageName: SFSymbols.premium)
    card5 = CardTaglineLabel(card: card5, text: "Maximize your chances by practicing with premium \ntests.")
    cards.append(card5)

    var card6: CardProtocol = Card()
    card6 = CardPrimaryTitleLabel(card: card6, text: "Progress Metrics", imageName: SFSymbols.progress)
    card6 = CardTaglineLabel(card: card6, text: "View past test scores and trends.")
    cards.append(card6)

    var x: CardProtocol? = nil
    var previousView: UIView? = nil
    var distanceToTop: CGFloat = 0
    var index = 0
    for each in cards {
      x = each.build(scrollView: scrollView, previous: (index == 0) ? nil : previousView)
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

    scrollView.contentSize = CGSize(width: 100, height: distanceToTop + 100)
  }

}
