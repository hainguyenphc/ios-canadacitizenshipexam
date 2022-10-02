//
//  RegisterVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-09.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {

  var titleLabel = CCELevelOneTitleLabel(text: "Register", textAlignment: .center, fontSize: 25)

  var emailLabel: CCELevelTwoTitleLabel = CCELevelTwoTitleLabel(text: "Email", textAlignment: .center, fontSize: 15)
  var emailTextField: UITextField = UITextField()
  var emailStackView: UIStackView = UIStackView()

  var passwordLabel: CCELevelTwoTitleLabel = CCELevelTwoTitleLabel(text: "Password", textAlignment: .center, fontSize: 15)
  var passwordTextField: UITextField = UITextField()
  var passwordStackView: UIStackView = UIStackView()

  var registerButton: CCEButton = CCEButton(backgroundColor: .systemGreen, title: "Register")

  var goToLoginVCButton: CCEButton = CCEButton(backgroundColor: .darkGray, title: "Have an account?")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureButtons()
  }

  func configureButtons() -> Void {
    self.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
    self.goToLoginVCButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.setHidesBackButton(true, animated: false)
    self.tabBarController?.tabBar.isHidden = true
  }

  @objc func goToLoginVC(_ sender: CCEButton!) -> Void {
    let loginVC = LoginVC()
    self.navigationController?.pushViewController(loginVC, animated: true)
  }

  @objc func registerButtonPressed(_ sender: CCEButton!) -> Void {
    if let email = self.emailTextField.text, let password = self.passwordTextField.text {
      Auth.auth().createUser(withEmail: email, password: password) { authResult, authError in
        if let e = authError {
          //TODO: handle error
          print(e.localizedDescription)
        }
        else {
          let loginVC = LoginVC()
          self.navigationController?.pushViewController(loginVC, animated: true)
        }
      }
    }
  }

  func configureUI() -> Void {
    self.view.backgroundColor = .secondarySystemBackground

    self.emailTextField.autocapitalizationType = .none
    self.emailTextField.placeholder = "name@domain"
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
    self.passwordTextField.placeholder = "Your Password"
    self.passwordTextField.textAlignment = .center
    self.passwordStackView.axis = .vertical
    self.passwordStackView.alignment = .fill
    self.passwordStackView.distribution = .fill
    self.passwordStackView.spacing = 8
    self.passwordStackView.contentMode = .scaleToFill
    self.passwordStackView.addArrangedSubview(self.passwordLabel)
    self.passwordStackView.addArrangedSubview(self.passwordTextField)

    self.goToLoginVCButton.tintColor = .systemBlue

    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.emailStackView)
    self.view.addSubview(self.passwordStackView)
    self.view.addSubview(self.registerButton)
    self.view.addSubview(self.goToLoginVCButton)

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.emailStackView.translatesAutoresizingMaskIntoConstraints = false
    self.passwordStackView.translatesAutoresizingMaskIntoConstraints = false
    self.registerButton.translatesAutoresizingMaskIntoConstraints = false
    self.goToLoginVCButton.translatesAutoresizingMaskIntoConstraints = false

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
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
      self.emailStackView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
      //
      self.passwordStackView.topAnchor.constraint(
        equalTo: self.emailStackView.bottomAnchor, constant: Dimensions.defaultPadding),
      self.passwordStackView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
      self.passwordStackView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
      //
      self.registerButton.topAnchor.constraint(
        equalTo: self.passwordStackView.bottomAnchor, constant: Dimensions.defaultPadding),
      self.registerButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.registerButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
      //
      self.goToLoginVCButton.topAnchor.constraint(
        equalTo: self.registerButton.bottomAnchor, constant: Dimensions.defaultPadding),
      self.goToLoginVCButton.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
      self.goToLoginVCButton.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100)
    ])
  }

}
