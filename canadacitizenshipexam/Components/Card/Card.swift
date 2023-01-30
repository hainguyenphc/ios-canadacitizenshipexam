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
