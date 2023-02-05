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
// extension HomeVC_: StickyHeadingProtocol {
extension HomeVC_ {

  // Do not call this function inside `assembleTheViews()`.
  // It should be called in `viewWillAppear()`.
  func buildTheUnlockPremiumFeatureView() -> UIView? {
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
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.white.cgColor)
    let completionPercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0, options: options)
    let completionDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView()

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

    /*
     Next, lay out the Unlock Premium view.
     */

    if let unlockPremiumFeaturesView = unlockPremiumFeaturesView {
      view.addSubview(unlockPremiumFeaturesView)
      let multiplier = DEVICE_IDIOM == .pad ? 0.09 : 0.1
      NSLayoutConstraint.activate([
        unlockPremiumFeaturesView.widthAnchor.constraint(equalToConstant: BOUNDS.size.width * 2),
        unlockPremiumFeaturesView.heightAnchor.constraint(equalToConstant: BOUNDS.size.height * multiplier),
        unlockPremiumFeaturesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        unlockPremiumFeaturesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -(BOUNDS.size.width / 2))
      ])
    }

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
