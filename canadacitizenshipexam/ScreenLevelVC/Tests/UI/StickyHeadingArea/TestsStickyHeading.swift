//
//  TestsStickyHeading.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-31.
//

import UIKit

extension TestsVC_: UnlockPremiumFeatureProtocol {

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

}
