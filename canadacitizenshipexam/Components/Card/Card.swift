  //
  //  Card.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-01-28.
  //

import UIKit

class Card: UIViewController, CardProtocol {

  var theHeight: CGFloat? = 0

  var theView: UIView?

  // A plain UIView's backgroundColor re-resolves automatically on a Light/Dark
  // Mode change, but layer.shadowColor is a CGColor — a frozen snapshot — so it
  // needs to be re-applied by hand whenever the interface style changes.
  private class ShadowAdaptiveView: UIView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
        layer.shadowColor = UIColor.systemGray.resolvedColor(with: traitCollection).cgColor
      }
    }
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    self.theView = self.view
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = ShadowAdaptiveView()
  }

  func build(scrollView: UIScrollView, previous: UIView? = nil) -> CardProtocol? {
    // A semantic background — near-white in Light Mode, dark gray in Dark
    // Mode — so the card keeps adapting live if the interface style changes
    // while it's already on screen, without needing to be rebuilt.
    view.backgroundColor = .secondarySystemGroupedBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    view.layer.shadowColor = UIColor.systemGray.resolvedColor(with: view.traitCollection).cgColor
    view.layer.shadowOpacity = 0.4
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 10
    scrollView.addSubview(view)
    return self
  }

}
