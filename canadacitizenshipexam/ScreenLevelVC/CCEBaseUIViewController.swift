//
//  CCEBaseUIViewController.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-09-18.
//

import UIKit

class CCEBaseUIViewController: UIViewController {

  var sections: [CCECompoundSection] = []

  var headingView: CCEHeadingView!

  var tableView: UITableView = UITableView()

  func configureTableView() {
    self.tableView.separatorStyle = .none
    self.view.addSubview(self.tableView)
    self.tableView.register(
      CCESectionCompoundCell.self,
      forCellReuseIdentifier: K.sectionCellIdentifier)
    self.tableView.pin(to: self.view)
    self.tableView.backgroundColor = .secondarySystemBackground
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    // Moves table content down ... units down -> the Heading Label is visible.
    self.tableView.contentInset = UIEdgeInsets(
      top: DimensionManager.shared.getTopEdgeInset(),
      left: 0,
      bottom: 0,
      right: 0)
  }

  func configureHeadingView() {
    self.headingView.progress = 100
    self.view.addSubview(self.headingView)
    self.headingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.headingView.topAnchor.constraint(
        equalTo: self.view.topAnchor, constant: 10),
      self.headingView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor, constant: 10),
      self.headingView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor, constant: -10)
    ])
  }

}
