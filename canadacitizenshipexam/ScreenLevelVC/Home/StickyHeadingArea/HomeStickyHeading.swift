//
//  HomeStickyHeading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit

extension HomeVC_ {

  // @remove: setupHeaderBackgroundView()
  func setupStickyHeadingView() {
    let multiplier = deviceIdiom == .pad ? 0.33 : 0.45
    let rectangle = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.height * multiplier)
    stickyHeadingView = UIView(frame: rectangle)
    stickyHeadingView.layer.backgroundColor = APP_ACCENT_COLOR.cgColor
    view.addSubview(stickyHeadingView)
  }

}
