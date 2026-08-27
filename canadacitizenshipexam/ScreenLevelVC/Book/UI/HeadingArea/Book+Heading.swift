//
//  Chapters+Heading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-04.
//

import UIKit

// buildTheUnlockPremiumFeatureView() is no longer implemented here — see
// UnlockPremiumFeatureProtocol's default implementation, which now covers
// this (and 3 other screens') identical banner.
extension BookVC_: UnlockPremiumFeatureProtocol {
}

extension BookVC_ {

  func buildTheHeadingView() {
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Study Book", textColor: .label)
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "35 Chapters", textColor: .secondaryLabel)
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.label)
    let completionPercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0.5, options: options)
    let completionDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView(
      textColor: .label,
      titleText: "Reading Progress",
      subtitleText: "0 of 28 Sections Read\nProgress: 0%"
    )

    self.completionPercentageView = completionPercentageView

    self.completionCircularProgressView = completionPercentageView?
      .subviews
      .compactMap{$0 as? CircularProgressView}
      .first

    (self.completionCircularProgressView)!.progressColor = .systemGray

    self.completionPercentageLabel = completionPercentageView?
      .subviews
      .compactMap{$0 as? UILabel}
      .first

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
      // If we want the heading to be sticky.
      // hStack.topAnchor.constraint(equalTo: unlockPremiumFeaturesView != nil ? unlockPremiumFeaturesView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
      // If we want the heading to be scrollable.
      // hStack.topAnchor.constraint(equalTo: scrollView != nil ? scrollView!.topAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
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

    if let blockView = completionPercentageView {
      scrollView.addSubview(blockView)
      NSLayoutConstraint.activate([
        blockView.topAnchor.constraint(equalTo: taglineLabel != nil ? taglineLabel!.bottomAnchor : titleLabel.bottomAnchor, constant: 20),
        blockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        blockView.heightAnchor.constraint(equalToConstant: 60),
        blockView.widthAnchor.constraint(equalToConstant: 60)
      ])
    }

    if let completionDetailsView = completionDetailsView, let previousBlock = completionPercentageView {
      scrollView.addSubview(completionDetailsView)
      NSLayoutConstraint.activate([
        completionDetailsView.topAnchor.constraint(equalTo: previousBlock.topAnchor),
        completionDetailsView.leadingAnchor.constraint(equalTo: previousBlock.trailingAnchor, constant: 20),
        completionDetailsView.heightAnchor.constraint(equalToConstant: 60),
        completionDetailsView.widthAnchor.constraint(equalToConstant: 300)
      ])
    }
  }

}
