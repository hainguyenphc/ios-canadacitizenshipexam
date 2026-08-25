//
//  CardActionableItem.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

class CardActionableItem: ActionableLabel, CardDecoratoProtocol {

  // Always overwritten in init with a height measured from the actual content.
  var theHeight: CGFloat?

  var theView: UIView?

  var card: CardProtocol?

  // Most actionable items are plain bullet rows (no gesture attached, same
  // as before); passing onTap opts a specific row into being tappable.
  private var onTap: (() -> Void)?

  init(card: CardProtocol, text: String, imageName: String, onTap: (() -> Void)? = nil) {
    super.init(text: text, imageName: imageName)
    self.card = card
    self.theView = self
    // A flat height assumes a single line, which undercounts rows whose text
    // wraps (leaving them clipped) and overcounts short ones (leaving a gap).
    // Measure this label's own attributed text at the width it will actually
    // render at, so the row's contribution always matches its real content.
    let width = BOUNDS.width * 0.85
    let measuredHeight = self.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height
    self.theHeight = measuredHeight + 15 + (self.card?.theHeight ?? 0)

    if let onTap = onTap {
      self.onTap = onTap
      self.isUserInteractionEnabled = true
      self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func handleTap() {
    onTap?()
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: nil)
    // blockView anchors our vertical position (below the previous row);
    // cardBackground is the actual card container every row should be a
    // flat sibling inside, rather than nested inside one another. UILabel
    // defaults to isUserInteractionEnabled = false, and a subview
    // positioned outside its "parent"'s own bounds — as every row here is,
    // since each sits below the previous row's bottom edge rather than
    // actually inside it — never gets hit-tested at all if that ancestor is
    // disabled, no matter what the subview's own interaction settings are.
    let blockView: UIView = (self.card!).theView!
    let cardBackground: UIView = result!.theView!
    cardBackground.addSubview(self)
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 15),
      self.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 15),
      // Without an explicit width, the label has no boundary to wrap against and
      // just grows to fit its text on one line, overflowing the card. Match the
      // width CardPrimaryTitleLabelWithImage already uses for the same reason.
      self.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.85),
    ])

    return result
  }

}
