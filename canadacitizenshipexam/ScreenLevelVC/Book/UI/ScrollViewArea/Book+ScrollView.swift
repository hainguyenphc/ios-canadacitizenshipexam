//
//  Book+ScrollView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-04.
//

import UIKit

extension BookVC_: ScrollProtocol {

  func setupScrollView() {
    scrollView.overrideUserInterfaceStyle = .light
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    view.addSubview(scrollView)

    if unlockPremiumFeaturesView != nil {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (unlockPremiumFeaturesView! as UIView).bottomAnchor, constant: 10)
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
  }

  func specifyScrollViewHeight() {
    scrollView.contentSize = CGSize(width: 100, height: distanceToTop * 2)
  }

}

