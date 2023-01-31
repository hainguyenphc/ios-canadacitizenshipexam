//
//  TestsView.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

/*
 Build the UI of TestsVC_.
 */
extension TestsVC_: ScrollProtocol {

  func setupScrollView() {
    scrollView.overrideUserInterfaceStyle = .light
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    view.addSubview(scrollView)

    if unlockPremiumFeaturesView != nil {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (unlockPremiumFeaturesView! as UIView).bottomAnchor, constant: 10)
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

    //

    f()

    //

    var cards: [CardProtocol] = []

    var x: CardProtocol? = nil
    var previousView: UIView? = nil
    var distanceToTop: CGFloat = 0
    var index = 0
    for each in cards {
      x = each.build(scrollView: scrollView, previous: (index == 0) ? nil : previousView)
      NSLayoutConstraint.activate([
        (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
        (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        (x!).theView!.heightAnchor.constraint(equalToConstant: each.theHeight!),
        (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
      ])
      previousView = (each).theView
      distanceToTop += each.theHeight! + DISTANCE_BETWEEN_CARDS
      index += 1
    }

    scrollView.contentSize = CGSize(width: 100, height: distanceToTop * 2)
  }

  func f() {
    let titleLabel = UIBuildingManager.shared.buildTheTitleLabel(title: "Practice Tests", textColor: .label)
    let taglineLabel = UIBuildingManager.shared.buildTheTaglineLabel(tagline: "35 Tests", textColor: .secondaryLabel)
    let imageView = UIBuildingManager.shared.buildTheImageNextToTitleLabel(systemName: "")
    let options = CompletionPercentageOptions(position: .left, textColor: UIColor.label.cgColor)
    let completionPercentageView = UIBuildingManager.shared.buildTheCompletionPercentageView(percent: 0.5, options: options)
    let completionDetailsView = UIBuildingManager.shared.buildTheCompletionDetailsView(textColor: .label)

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

    view.addSubview(hStack)

    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: unlockPremiumFeaturesView != nil ? unlockPremiumFeaturesView!.bottomAnchor : view.safeAreaLayoutGuide.topAnchor, constant: 10),
      hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      hStack.heightAnchor.constraint(equalToConstant: BOUNDS.height * 0.05)
    ])

    hStack.addArrangedSubview(titleLabel)

    view.addSubview(hStack)

    if let taglineLabel = taglineLabel {
      view.addSubview(taglineLabel)
      NSLayoutConstraint.activate([
        taglineLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 5),
        taglineLabel.leadingAnchor.constraint(equalTo: hStack.leadingAnchor)
      ])
    }

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
