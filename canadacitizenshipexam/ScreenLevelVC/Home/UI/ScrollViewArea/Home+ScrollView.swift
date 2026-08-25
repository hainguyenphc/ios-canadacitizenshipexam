  //
  //  HomeScrollView.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-01-29.
  //

import UIKit

extension HomeVC_: ScrollProtocol {

  func setupScrollView() {
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
      // Fill the space actually available down to the tab bar instead of guessing
      // a fraction of the screen height, which left a gap when the guess ran short.
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  func specifyScrollViewHeight() -> Void {
    // distanceToTop already tracks the real bottom of the last card added; a small
    // fixed cushion is enough headroom, rather than doubling it into dead scroll space.
    scrollView.contentSize = CGSize(width: 100, height: distanceToTop + 40)
  }

}
