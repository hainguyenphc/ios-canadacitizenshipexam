  //
  //  Settings.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2022-04-30.
  //

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

  var titleLabel = CCELevelOneTitleLabel(text: "Settings", textAlignment: .center, fontSize: 25)

  var logoutButton: CCEButton = CCEButton(backgroundColor: .systemRed, title: "Log out")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureButtons()
  }

  func configureButtons() -> Void {
    self.logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
  }

  @objc func logoutButtonPressed() -> Void {
    do {
      if let userID = Auth.auth().currentUser?.uid {
        try Auth.auth().signOut()
        NetworkManager.shared.removedCachedUsersData(userID: userID)
        // Upon landing on the Home VC, as there is no active session for any user,
        // he will be redirected to Register VC.
        self.navigationController?.pushViewController(HomeVC(), animated: true)
        self.navigationController?.popToRootViewController(animated: false)
      }
    }
    catch {
      print("Error signing user out.")
    }
  }

  func configureUI() -> Void {
    self.view.backgroundColor = .secondarySystemBackground

    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.logoutButton)

    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.defaultPadding),
      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.defaultPadding),
      self.titleLabel.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.logoutButton.topAnchor.constraint(
        equalTo: self.titleLabel.bottomAnchor, constant: Dimensions.defaultPadding),
      self.logoutButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.logoutButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
    ])
  }

}
