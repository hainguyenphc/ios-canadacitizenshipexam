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

  var calculatedHeight: CGFloat?

  // UIImage.withTintColor bakes a color into a static bitmap, so an icon
  // embedded via NSTextAttachment inside the attributed text can't just be a
  // dynamic UIColor — it needs to be rebuilt by hand whenever the interface
  // style changes. Storing the builder (not just its one-time output, and
  // handed the icon color to use rather than reading APP_ACCENT_COLOR
  // itself) makes that possible.
  private var attributedTextBuilder: ((UIColor) -> NSMutableAttributedString)?

  init(card: CardProtocol? = nil, attributedTextBuilder: @escaping (UIColor) -> NSMutableAttributedString) {
    super.init(frame: .zero, textContainer: nil)
    self.attributedTextBuilder = attributedTextBuilder
    self.attributedText = attributedTextBuilder(APP_ACCENT_COLOR.resolvedColor(with: traitCollection))
    self.configure()
    self.card = card
    self.theView = self
    self.theHeight = 0
    self.theHeight! += (self.card?.theHeight!)!
    self.theHeight! += self.calculatedHeight!
  }

  func calculatedHeight(for text: String, width: CGFloat) -> CGFloat {
    let frame = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
    let label = UILabel(frame: frame)
    label.numberOfLines = 0
    label.text = text
    label.sizeToFit()

    return label.frame.height + 15
  }

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol? {
    let result = self.card?.build(scrollView: scrollView, previous: previous)
    let blockView: UIView = (self.card!).theView!
    blockView.addSubview(self)

    return result
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Once this view is actually attached to a window, its traitCollection
  // reliably reflects the app's real appearance for the first time — redo
  // the icon tint against that, then keep it in sync on later changes.
  private func reapplyAttributedText() {
    guard let attributedTextBuilder = attributedTextBuilder else { return }
    self.attributedText = attributedTextBuilder(APP_ACCENT_COLOR.resolvedColor(with: traitCollection))
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    if window != nil {
      reapplyAttributedText()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      reapplyAttributedText()
    }
  }

  func configure() {
    self.isEditable = false
    // UITextView defaults to a plain white background, which reads as a
    // mismatched box once the card underneath it turns dark. Match the
    // card's own adaptive background instead.
    self.backgroundColor = .secondarySystemGroupedBackground
    self.layer.cornerRadius = 16
    self.textAlignment = .natural
    self.showsVerticalScrollIndicator = false
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
    var multiplier: CGFloat = 0
    let modelName = UIDevice.modelName
    switch (modelName) {
      case "Simulator iPhone 14 Plus":
        multiplier = 0.95
        break
      case "Simulator iPhone 14":
        multiplier = 0.85
        break
      case "Simulator iPhone SE (3rd generation)":
        multiplier = 0.90
        break
      case "Simulator iPad (10th generation)":
        multiplier = 0.85
        break
      default:
        multiplier = 0.9
        break
    }

    self.calculatedHeight = calculatedHeight(for: self.attributedText.string, width: BOUNDS.width * multiplier)
    self.frame = CGRect(x: 0, y: 0, width: BOUNDS.width * 0.95, height: self.calculatedHeight!)

  }

}
