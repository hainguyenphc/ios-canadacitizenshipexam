//
//  LoginVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-10.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

  var titleLabel = CCELevelOneTitleLabel(text: "Login", textAlignment: .center, fontSize: 25)

  var emailLabel: CCELevelTwoTitleLabel = CCELevelTwoTitleLabel(text: "Email", textAlignment: .center, fontSize: 15)
  var emailTextField: UITextField = UITextField()
  var emailStackView: UIStackView = UIStackView()

  var passwordLabel: CCELevelTwoTitleLabel = CCELevelTwoTitleLabel(text: "Password", textAlignment: .center, fontSize: 15)
  var passwordTextField: UITextField = UITextField()
  var passwordStackView: UIStackView = UIStackView()

  var loginButton: CCEButton = CCEButton(backgroundColor: .systemGreen, title: "Login")

  var goToRegisterVCButton: CCEButton = CCEButton(backgroundColor: .darkGray, title: "Register here")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureButtons()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.setHidesBackButton(true, animated: false)
    self.tabBarController?.tabBar.isHidden = true
  }

  func configureButtons() -> Void {
    self.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    self.goToRegisterVCButton.addTarget(self, action: #selector(goToRegisterVC), for: .touchUpInside)
  }

  @objc func goToRegisterVC(_ sender: CCEButton!) -> Void {
    let registerVC = RegisterVC()
    self.navigationController?.pushViewController(registerVC, animated: true)
  }

  @objc func loginButtonPressed(_ sender: CCEButton!) -> Void {
    if let email = self.emailTextField.text, let password = self.passwordTextField.text {
      Auth.auth().signIn(withEmail: email, password: password) { authResult, authError in
        if let e = authError {
          //TODO: handle error
          print(e.localizedDescription)
        }
        else {
          let homeVC = HomeVC()
          // self.navigationController?.popToRootViewController(animated: false)
          self.navigationController?.pushViewController(homeVC, animated: true)
        }
      }
    }
  }

  func configureUI() -> Void {
    self.view.backgroundColor = .secondarySystemBackground

    self.emailTextField.autocapitalizationType = .none
    self.emailTextField.text = "hai.nguyen.phc@gmail.com"
    self.emailTextField.textAlignment = .center
    self.emailStackView.axis = .vertical
    self.emailStackView.alignment = .fill
    self.emailStackView.distribution = .fill
    self.emailStackView.spacing = 8
    self.emailStackView.contentMode = .scaleToFill
    self.emailStackView.addArrangedSubview(self.emailLabel)
    self.emailStackView.addArrangedSubview(self.emailTextField)

    self.passwordTextField.isSecureTextEntry = true
    self.passwordTextField.autocapitalizationType = .none
    self.passwordTextField.text = "abc123"
    self.passwordTextField.textAlignment = .center
    self.passwordStackView.axis = .vertical
    self.passwordStackView.alignment = .fill
    self.passwordStackView.distribution = .fill
    self.passwordStackView.spacing = 8
    self.passwordStackView.contentMode = .scaleToFill
    self.passwordStackView.addArrangedSubview(self.passwordLabel)
    self.passwordStackView.addArrangedSubview(self.passwordTextField)

    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.emailStackView)
    self.view.addSubview(self.passwordStackView)
    self.view.addSubview(self.loginButton)
    self.view.addSubview(self.goToRegisterVCButton)

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.emailStackView.translatesAutoresizingMaskIntoConstraints = false
    self.passwordStackView.translatesAutoresizingMaskIntoConstraints = false
    self.loginButton.translatesAutoresizingMaskIntoConstraints = false
    self.goToRegisterVCButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      self.titleLabel.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.defaultPadding),
      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.defaultPadding),
      self.titleLabel.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.emailStackView.topAnchor.constraint(
        equalTo: self.titleLabel.bottomAnchor, constant: Dimensions.defaultPadding),
      self.emailStackView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.emailStackView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
      //
      self.passwordStackView.topAnchor.constraint(
        equalTo: self.emailStackView.bottomAnchor, constant: Dimensions.defaultPadding),
      self.passwordStackView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.passwordStackView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
      //
      self.loginButton.topAnchor.constraint(
        equalTo: self.passwordStackView.bottomAnchor, constant: Dimensions.defaultPadding),
      self.loginButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.loginButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
      //
      self.goToRegisterVCButton.topAnchor.constraint(
        equalTo: self.loginButton.bottomAnchor, constant: Dimensions.defaultPadding),
      self.goToRegisterVCButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.goToRegisterVCButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
    ])
  }

}
