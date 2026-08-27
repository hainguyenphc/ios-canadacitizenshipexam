//
//  HomeStickyHeading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit

/*
 An extension of the HomeVC_.
 It builds the Sticky Heading View for Home.
 */
// buildTheUnlockPremiumFeatureView() used to be implemented here (Home's
// own copy of what 4 other screens also duplicated) — see
// UnlockPremiumFeatureProtocol's default implementation instead
// (HomeVC_ now formally conforms, in HomeVC_.swift).
extension HomeVC_ {

  func buildTheHeadingView() -> Void {
    /*
     Initialize all the views.
     The order is important; We must build the background view first or it overlaps the others.
     */

    let multiplier = DEVICE_IDIOM == .pad ? 0.33 : 0.50
    let backgroundView = UIBuildingManager.shared.buildTheBackgroundView(multiplier: multiplier)
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Discover Canada")
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "Canada Citizenship Test 2023")
    let imageView = UIBuildingManager.shared.buildTheImageNextToTitleLabel(systemName: "square.and.arrow.up")
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.white)
    let completionPercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0, options: options)
    // Placeholder text: "Practice Progress" / "0 Daily Questions Answered / 0 of 35
    // Tests Completed" stand in until real progress data is wired up (see the
    // completionCircularProgressView update snippet at the bottom of HomeVC_.swift).
    let completionDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView(
      textColor: .white,
      titleText: "Practice Progress",
      subtitleText: "0 Daily Questions Answered\n0 of 35 Tests Completed"
    )

    /*
     Save the references to those views for future update.
     */

    self.completionPercentageView = completionPercentageView

    self.completionCircularProgressView = completionPercentageView?
      .subviews
      .compactMap{$0 as? CircularProgressView}
      .first

    (self.completionCircularProgressView)!.progressColor = .white

    self.completionPercentageLabel = completionPercentageView?
      .subviews
      .compactMap{$0 as? UILabel}
      .first

    /*
     First, lay out the background.
     */

    if let backgroundView = backgroundView {
      view.addSubview(backgroundView)
    }

    // The Unlock Premium view (if any — see UnlockPremiumFeatureProtocol)
    // is already added to `view` and fully constrained by
    // PremiumBannerView's own initializer by the time this runs
    // (viewWillAppear builds it before calling buildTheHeadingView) — only
    // its bottomAnchor is still needed below, to hang the title/image
    // hStack beneath it.

    /*
     Next, lay out the title and the associated image.
     */

    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.distribution = .fill
    hStack.spacing = 10
    hStack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(hStack)

    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: unlockPremiumFeaturesView != nil ? unlockPremiumFeaturesView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
      hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      hStack.heightAnchor.constraint(equalToConstant: BOUNDS.height * 0.05)
    ])

    hStack.addArrangedSubview(titleLabel)

    if let imageView = imageView {
      hStack.addArrangedSubview(imageView)
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: hStack.topAnchor),
        imageView.trailingAnchor.constraint(equalTo: hStack.trailingAnchor),
        imageView.widthAnchor.constraint(equalTo: hStack.heightAnchor, multiplier: 0.9),
      ])
      // A plain UIImageView ignores touches by default — opt in, then wire
      // up the share sheet (see HomeVC_.shareAppTapped()).
      imageView.isUserInteractionEnabled = true
      imageView.addGestureRecognizer(
        UITapGestureRecognizer(target: self, action: #selector(shareAppTapped)))
    }

    /*
     Next, lay out the tag line.
     */

    if let taglineLabel = taglineLabel {
      view.addSubview(taglineLabel)
      NSLayoutConstraint.activate([
        taglineLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 5),
        taglineLabel.leadingAnchor.constraint(equalTo: hStack.leadingAnchor)
      ])
    }

    /*
     Finally, lay out the completion percentage and completion details views.
     */

    if let blockView = completionPercentageView {
      view.addSubview(blockView)
      NSLayoutConstraint.activate([
        blockView.topAnchor.constraint(equalTo: taglineLabel != nil ? taglineLabel!.bottomAnchor : titleLabel.bottomAnchor, constant: 20),
        blockView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        blockView.heightAnchor.constraint(equalToConstant: 60),
        blockView.widthAnchor.constraint(equalToConstant: 60)
      ])
    }

    if let completionDetailsView = completionDetailsView, let previousBlock = completionPercentageView {
      view.addSubview(completionDetailsView)
      NSLayoutConstraint.activate([
        completionDetailsView.topAnchor.constraint(equalTo: previousBlock.topAnchor),
        completionDetailsView.leadingAnchor.constraint(equalTo: previousBlock.trailingAnchor, constant: 20),
        completionDetailsView.heightAnchor.constraint(equalToConstant: 60),
        completionDetailsView.widthAnchor.constraint(equalToConstant: 300)
      ])
    }
  }

}
