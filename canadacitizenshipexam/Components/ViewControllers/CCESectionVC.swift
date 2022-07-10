//
//  CCESectionVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCESectionVC: UIViewController {

  var targetScreen: String!

  let stackView = UIStackView()
  let sectionView = CCESectionView()


  override func viewDidLoad() {
    self.configureBackgroundView()
    self.configureUI()

//    let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.handleClickEvent))
//    self.view.addGestureRecognizer(tap)
  }

  func configureBackgroundView() -> Void {
    self.view.layer.cornerRadius = 18
    self.view.backgroundColor = .secondarySystemBackground
    self.view.layer.borderColor = UIColor.red.cgColor
    self.view.layer.borderWidth = 10
  }

  func configureUI() -> Void {
    self.stackView.axis = .vertical
    self.stackView.distribution = .equalSpacing
    self.stackView.addArrangedSubview(self.sectionView)

    self.stackView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(self.stackView)
  }

}
