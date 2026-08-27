//
//  Progress+Heading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-05.
//

import UIKit

// buildTheUnlockPremiumFeatureView() is no longer implemented here — see
// UnlockPremiumFeatureProtocol's default implementation, which now covers
// this (and 3 other screens') identical banner.
extension ProgressVC_: UnlockPremiumFeatureProtocol {
}

extension ProgressVC_ {

  // The vertical gap between the "Practice Progress" row and the "Reading Progress" row.
  static let distanceBetweenProgressRows: CGFloat = 40

  func buildTheHeadingView() {
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Study Progress", textColor: .label)
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "Track your exam readiness", textColor: .secondaryLabel)

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.distribution = .fill
    hStack.spacing = 10
    hStack.translatesAutoresizingMaskIntoConstraints = false

    scrollView.addSubview(hStack)

    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
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

    // Row 1: Practice Progress. The circle sits on the left, its details to the right,
    // mirroring the layout used by the Tests and Book screens' single heading row.
    let practiceOptions = CompletionPercentageOptions(position: .left, textColor: UIColor.label)
    let practicePercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0, options: practiceOptions)
    let practiceDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView(
      textColor: .label,
      titleText: "Practice Progress",
      subtitleText: "0 Daily Questions Answered\n0 of 35 Tests Completed"
    )

    self.practiceCompletionPercentageView = practicePercentageView
    self.practiceCompletionCircularProgressView = practicePercentageView?
      .subviews
      .compactMap { $0 as? CircularProgressView }
      .first
    self.practiceCompletionCircularProgressView?.progressColor = .systemGray

    if let practicePercentageView = practicePercentageView {
      scrollView.addSubview(practicePercentageView)
      NSLayoutConstraint.activate([
        practicePercentageView.topAnchor.constraint(equalTo: taglineLabel != nil ? taglineLabel!.bottomAnchor : titleLabel.bottomAnchor, constant: 20),
        practicePercentageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        practicePercentageView.heightAnchor.constraint(equalToConstant: 60),
        practicePercentageView.widthAnchor.constraint(equalToConstant: 60)
      ])
    }

    if let practiceDetailsView = practiceDetailsView, let practicePercentageView = practicePercentageView {
      scrollView.addSubview(practiceDetailsView)
      NSLayoutConstraint.activate([
        practiceDetailsView.topAnchor.constraint(equalTo: practicePercentageView.topAnchor),
        practiceDetailsView.leadingAnchor.constraint(equalTo: practicePercentageView.trailingAnchor, constant: 20),
        practiceDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -LEFT_SPACE),
        practiceDetailsView.heightAnchor.constraint(equalToConstant: 60)
      ])
    }

    // Row 2: Reading Progress. Mirrored — the details sit on the left (right-aligned
    // text), with the circle on the right, matching the design.
    let readingOptions = CompletionPercentageOptions(position: .right, textColor: UIColor.label)
    let readingPercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0, options: readingOptions)
    let readingDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView(
      textColor: .label,
      titleText: "Reading Progress",
      subtitleText: "0 of 28 Sections Read\nProgress: 0%",
      textAlignment: .right
    )

    self.readingCompletionPercentageView = readingPercentageView
    self.readingCompletionCircularProgressView = readingPercentageView?
      .subviews
      .compactMap { $0 as? CircularProgressView }
      .first
    self.readingCompletionCircularProgressView?.progressColor = .systemGray

    if let readingPercentageView = readingPercentageView, let practicePercentageView = practicePercentageView {
      scrollView.addSubview(readingPercentageView)
      NSLayoutConstraint.activate([
        readingPercentageView.topAnchor.constraint(equalTo: practicePercentageView.bottomAnchor, constant: ProgressVC_.distanceBetweenProgressRows),
        readingPercentageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -LEFT_SPACE),
        readingPercentageView.heightAnchor.constraint(equalToConstant: 60),
        readingPercentageView.widthAnchor.constraint(equalToConstant: 60)
      ])
    }

    if let readingDetailsView = readingDetailsView, let readingPercentageView = readingPercentageView {
      scrollView.addSubview(readingDetailsView)
      NSLayoutConstraint.activate([
        readingDetailsView.topAnchor.constraint(equalTo: readingPercentageView.topAnchor),
        readingDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        readingDetailsView.trailingAnchor.constraint(equalTo: readingPercentageView.leadingAnchor, constant: -20),
        readingDetailsView.heightAnchor.constraint(equalToConstant: 60)
      ])
    }
  }

}
