//
//  Settings+Heading.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit

// buildTheUnlockPremiumFeatureView() is no longer implemented here — see
// UnlockPremiumFeatureProtocol's default implementation, which now covers
// this (and 3 other screens') identical banner.
extension SettingsVC_: UnlockPremiumFeatureProtocol {
}

extension SettingsVC_ {

  func buildTheHeadingView() {
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Settings", textColor: .label)
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "Manage your account and preferences", textColor: .secondaryLabel)

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.distribution = .fill
    hStack.spacing = 10
    hStack.translatesAutoresizingMaskIntoConstraints = false

    scrollView.addSubview(hStack)

    if isTheHeadingViewSticky {
      NSLayoutConstraint.activate([
        hStack.topAnchor.constraint(equalTo: unlockPremiumFeaturesView != nil ? unlockPremiumFeaturesView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
      ])
    } else {
      NSLayoutConstraint.activate([
        hStack.topAnchor.constraint(equalTo: scrollView != nil ? scrollView!.topAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
      ])
    }

    NSLayoutConstraint.activate([
      hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      hStack.heightAnchor.constraint(equalToConstant: BOUNDS.height * 0.05)
    ])

    hStack.addArrangedSubview(titleLabel)

    if let taglineLabel = taglineLabel {
      scrollView.addSubview(taglineLabel)
      NSLayoutConstraint.activate([
        taglineLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 5),
        taglineLabel.leadingAnchor.constraint(equalTo: hStack.leadingAnchor)
      ])
    }
  }

}
