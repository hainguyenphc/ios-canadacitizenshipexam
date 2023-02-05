//
//  Chapters+Heading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-04.
//

import UIKit

extension BookVC_: UnlockPremiumFeatureProtocol {

  func buildTheUnlockPremiumFeatureView() -> UIView? {
    let backgroundView = UIBuildingManager.shared.buildTheBackgroundView(
      multiplier: DEVICE_IDIOM == .pad ? 0.33 : 0.18)
    if let backgroundView = backgroundView {
      view.addSubview(backgroundView)
    }

    let multiplier = DEVICE_IDIOM == .pad ? 0.09 : 0.1

    let unlockPremiumFeaturesView = UIView()
    unlockPremiumFeaturesView.translatesAutoresizingMaskIntoConstraints = false
    unlockPremiumFeaturesView.layer.borderColor = UIColor.white.cgColor
    unlockPremiumFeaturesView.layer.borderWidth = 1

    // We must add the unlock view right here,
    // since the label and button are anchored to the unlock view's parent (self.view).
    view.addSubview(unlockPremiumFeaturesView)

    NSLayoutConstraint.activate([
      unlockPremiumFeaturesView.widthAnchor.constraint(equalToConstant: BOUNDS.size.width * 2),
      unlockPremiumFeaturesView.heightAnchor.constraint(equalToConstant: BOUNDS.size.height * multiplier),
      unlockPremiumFeaturesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      unlockPremiumFeaturesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -(BOUNDS.size.width / 2))
    ])

    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Unlock All Premium Features"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    unlockPremiumFeaturesView.addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      label.widthAnchor.constraint(equalToConstant: BOUNDS.size.width * 0.6),
      label.topAnchor.constraint(equalTo: unlockPremiumFeaturesView.topAnchor, constant: BOUNDS.size.height * 0.04)
    ])

    let button = UIButton()
    button.setTitle("Details", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    button.layer.cornerRadius = 12
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.backgroundColor = UIColor.white.cgColor
    button.setTitleColor(UIColor(red: 153 / 255, green: 1 / 255, blue: 7 / 255, alpha: 1.0), for: .normal)
    unlockPremiumFeaturesView.addSubview(button)

    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 70),
      button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      button.topAnchor.constraint(equalTo: unlockPremiumFeaturesView.topAnchor, constant: BOUNDS.size.height * 0.033)
    ])

    return unlockPremiumFeaturesView
  }

}

extension BookVC_ {

  func buildTheHeadingView() {
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Study Book", textColor: .label)
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "35 Chapters", textColor: .secondaryLabel)
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.label.cgColor)
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

    (self.completionCircularProgressView)!.progressColor = .gray

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
      view.addSubview(taglineLabel)
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
