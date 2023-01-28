//
//  CCEDatePickerVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-27.
//

import Foundation
import UIKit

class CCEDatePickerVC: UIViewController {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var titleLabel = CCELevelOneTitleLabel(text: "Set Practice Reminder", textAlignment: .center)

  let datePicker = UIDatePicker()

  let confirmButton = CCEButton(backgroundColor: .systemBlue, title: "Confirm")

  var parentVC = HomeVC()

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    configureUI()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  @objc func confirm() {
    self.dismiss(animated: true) {
      // self.parentVC.registerAppointment(self.datePicker.date)
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() {
    self.confirmButton.setTitle("Confirm", for: .normal)
    self.view.backgroundColor = .systemBackground

    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.datePicker)
    self.view.addSubview(self.confirmButton)

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.datePicker.translatesAutoresizingMaskIntoConstraints = false
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.defaultPadding),
      self.titleLabel.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.datePicker.topAnchor.constraint(
        equalTo: self.titleLabel.bottomAnchor, constant: 50),
      self.datePicker.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.defaultPadding),
      self.datePicker.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.confirmButton.topAnchor.constraint(
        equalTo: self.datePicker.bottomAnchor, constant: Dimensions.defaultPadding),
      self.confirmButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.defaultPadding),
      self.confirmButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.defaultPadding),
    ])
  }

}
