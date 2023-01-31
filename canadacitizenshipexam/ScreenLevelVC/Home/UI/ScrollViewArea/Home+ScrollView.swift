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

    // scrollView.contentSize = CGSize(width: 100, height: distanceToTop * 2)
  }

  func specifyScrollViewHeight() -> Void {
    scrollView.contentSize = CGSize(width: 100, height: distanceToTop * 2)
  }

}
