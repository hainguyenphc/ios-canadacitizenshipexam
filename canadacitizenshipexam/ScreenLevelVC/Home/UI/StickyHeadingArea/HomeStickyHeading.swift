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
extension HomeVC_: StickyHeadingProtocol {

  func buildTheBackgroundView() -> UIView? {
    let multiplier = DEVICE_IDIOM == .pad ? 0.33 : 0.50
    let rectangle = CGRect(x: 0, y: 0, width: BOUNDS.size.width, height: BOUNDS.height * multiplier)
    let stickyHeadingView = UIView(frame: rectangle)
    stickyHeadingView.layer.backgroundColor = APP_ACCENT_COLOR.cgColor

    return stickyHeadingView
  }

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

  func buildTheTitleLabel(title: String) -> UILabel {
    let titleLabel = ScreenTitleLabel(
      text: title,
      textColor: UIColor.white,
      textAlignment: .left,
      fontSize: 35,
      fontWeight: .bold
    )

    return titleLabel;
  }

  func buildTheImageNextToTitleLabel(systemName: String) -> UIImageView? {
    let config = UIImage.SymbolConfiguration(
      pointSize: 10,
      weight: .thin,
      scale: .small
    )
    let image = UIImage(
      systemName: systemName,
      withConfiguration: config
    )
    image?.withTintColor(UIColor.white)

    let shareImageView = UIImageView(image: image)
    shareImageView.tintColor = .white
    shareImageView.translatesAutoresizingMaskIntoConstraints = false

    return shareImageView
  }

  func buildTheTaglineLabel(tagline: String) -> UILabel? {
    let taglineLabel = ScreenTitleLabel(
      // @todo VM to determine the year.
      text: tagline,
      textColor: UIColor.white,
      textAlignment: .left,
      fontSize: 16,
      fontWeight: .regular
    )

    return taglineLabel;
  }

  func buildTheCompletionPercentageView(percent: Float, options: CompletionPercentageOptions) -> UIView? {
    let blockView = UIView()
    blockView.translatesAutoresizingMaskIntoConstraints = false

    let circularProgressView = CircularProgressView(
      frame: CGRect(x: 0, y: 0, width: 60, height: 60),
      lineWidth: 7,
      rounded: false
    )
    circularProgressView.progress = 0.7

    blockView.addSubview(circularProgressView)

    NSLayoutConstraint.activate([
      circularProgressView.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 0),
      circularProgressView.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 0)
    ])

    let numberLabel = ScreenTitleLabel(
      text: "70%",
      textColor: UIColor.white,
      textAlignment: .left,
      fontSize: 16,
      fontWeight: .semibold
    )

    blockView.addSubview(numberLabel)

    NSLayoutConstraint.activate([
      numberLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 12),
      numberLabel.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 5),
      numberLabel.widthAnchor.constraint(equalToConstant: 50),
      numberLabel.heightAnchor.constraint(equalToConstant: 50)
    ])

    return blockView
  }

  func buildTheCompletionDetailsView() -> UIView? {
    let blockView = UIView()
    blockView.translatesAutoresizingMaskIntoConstraints = false

    let primaryLabel = ScreenTitleLabel(
      text: "Practice Progress",
      textColor: UIColor.white,
      textAlignment: .left,
      fontSize: 20,
      fontWeight: .bold
    )

    blockView.addSubview(primaryLabel)

    NSLayoutConstraint.activate([
      primaryLabel.topAnchor.constraint(equalTo: blockView.topAnchor),
      primaryLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor)
    ])

    let secondaryLabel = ScreenTitleLabel(
      text: "1 Daily Question Answered\n0 of 35 Tests Completed",
      textColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8),
      textAlignment: .left,
      fontSize: 15,
      fontWeight: .regular
    )

    blockView.addSubview(secondaryLabel)
    NSLayoutConstraint.activate([
      secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 5),
      secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor)
    ])

    return blockView
  }

  func assembleTheViews() -> Void {

    /*
     Initialize all the views.
     The order is important; We must build the background view first or it overlaps the others.
     */

    let backgroundView = buildTheBackgroundView()
    // Do not build the Unlock view in here.
    // It should be called before `assembleTheViews()` function.
    // let unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()
    let titleLabel = buildTheTitleLabel(title: "Discover Canada")
    let taglineLabel = buildTheTaglineLabel(tagline: "Canada Citizenship Test 2023")
    let imageView = buildTheImageNextToTitleLabel(systemName: "square.and.arrow.up")
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.white.cgColor)
    let completionPercentageView = buildTheCompletionPercentageView(percent: 0, options: options)
    let completionDetailsView = buildTheCompletionDetailsView()

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
