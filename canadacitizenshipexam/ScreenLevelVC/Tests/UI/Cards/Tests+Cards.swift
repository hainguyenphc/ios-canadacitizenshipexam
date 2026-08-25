//
//  Tests+Cards.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

extension TestsVC_ {

  func buildTheCards() {
    // The height of the heading area.
    distanceToTop = 200

    let loadingLabel = ScreenTitleLabel(
      text: "Loading tests…",
      textColor: .secondaryLabel,
      textAlignment: .center,
      fontSize: 16,
      fontWeight: .regular
    )
    scrollView.addSubview(loadingLabel)

    NSLayoutConstraint.activate([
      loadingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      loadingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      loadingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

    distanceToTop += 30
    specifyScrollViewHeight()

    // Tests live in Firestore, not bundled with the app — fetch them fresh
    // every time this screen builds, so the list always reflects whatever
    // is actually published right now.
    testsVM.loadTests { [weak self] tests in
      guard let self = self else { return }
      DispatchQueue.main.async {
        loadingLabel.removeFromSuperview()
        self.tests = tests
        self.distanceToTop = 200
        self.populateCards()
        self.specifyScrollViewHeight()
      }
    }
  }

  private func populateCards() {
    var cards: [CardProtocol] = []

    if tests.isEmpty {
      let emptyLabel = ScreenTitleLabel(
        text: "No tests are available yet. Check back soon!",
        textColor: .secondaryLabel,
        textAlignment: .center,
        fontSize: 16,
        fontWeight: .regular
      )
      scrollView.addSubview(emptyLabel)

      NSLayoutConstraint.activate([
        emptyLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
        emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
      ])

      distanceToTop += 60
    } else {
      // Nothing in the data model distinguishes a "locked"/premium test
      // from a free one yet (that's still a @todo elsewhere in the app —
      // see HomeVC_'s unlockPremiumFeaturesView), so every test loaded
      // here is shown as open, rather than guessing at a lock rule that
      // isn't backed by any real data.
      for test in tests {
        var card: CardProtocol = Card(onTap: { [weak self] in self?.startTest(test) })
        card = CardPrimaryTitleLabelWithImage(
          card: card,
          text: test.name,
          imageName: "circle.fill",
          tintColor: .systemGreen
        )
        card = CardActionableItem(card: card, text: "\(test.questions.count) Exam Questions", imageName: "")
        cards.append(card)
      }
    }

    let bodyText = "After generating your fancy text symbols, you can copy and paste the \"fonts\" to most websites and text processors. You could use it to generate a fancy Agario name (yep, weird text in agario is probably generated using a fancy text converter similar to this), to generate a creative-looking instagram, facebook, tumblr, or twitter post, for showing up n00bs on Steam, or just for sending messages full of beautiful text to your buddies.\nThe only exception is if your paste destination has a font which doesn't support some unicode characters. For example, you'll might find that some websites don't use a unicode font, or if they do, the font doesn't have all the characters required. In that case, you'll see a generic \"box\" in which was created when the browser tries to create a fancy letter. This doesn't mean there's an error with this translator, it just means the website's font doesn't support that character."
    let decoratedBodyText = NSMutableAttributedString(string: "\n\(bodyText)", attributes: [
      .font: UIFont.systemFont(ofSize: 16, weight: .regular),
      .foregroundColor: UIColor.label,
    ])

    let titleText = "How difficult is the official test?";
    let decoratedTitleText = NSMutableAttributedString(string: " \(titleText)", attributes: [
      .font: UIFont.systemFont(ofSize: 16, weight: .bold),
      .foregroundColor: UIColor.label,
      .strokeColor: UIColor.red,
    ])

    var infoCard: CardProtocol = Card()
    // The bubble icon is tinted via UIImage.withTintColor, which bakes the
    // color into a static bitmap — CardTextView re-invokes this builder with
    // the correct icon color whenever the interface style changes.
    infoCard = CardTextView(card: infoCard) { iconColor in
      let image = UIImage(systemName: "bubble.left.and.exclamationmark.bubble.right")!
        .withTintColor(iconColor)
      let attachment = NSTextAttachment()
      attachment.image = image
      let attributedText = NSMutableAttributedString(attachment: attachment)
      attributedText.append(decoratedTitleText)
      attributedText.append(decoratedBodyText)
      return attributedText
    }
    cards.append(infoCard)

    for each in cards {
      let x = each.build(scrollView: scrollView, previous: nil)
      NSLayoutConstraint.activate([
        x!.theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
        x!.theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        x!.theView!.heightAnchor.constraint(equalToConstant: each.theHeight!),
        x!.theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
      ])
      distanceToTop += each.theHeight! + DISTANCE_BETWEEN_CARDS
    }
  }

  func startTest(_ test: CCETest) {
    guard let testID = test.id else { return }
    navigationController?.pushViewController(TestVC(with: testID), animated: true)
  }

}
