//
//  HomeVC+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import UIKit

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(
      withIdentifier: K.sectionCellIdentifier, for: indexPath) as! CCESectionCell_Complex
    rcell.configureCell(section: sections[indexPath.row], at: 0)
    return rcell
  }

  /* Dynamically determines the table row height. */
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = sections[indexPath.row]
    let count = section.primaryTitleTexts.count
    let characterCount = self.sections[indexPath.row].bodyTexts[0].count
    let numberOfRowsNeeded = (Double) (characterCount / K.standardCharacterCountForTableCell).rounded(.up)
    if count == 1 {
      if numberOfRowsNeeded <= 2 {
        return (count == 1) ? (CGFloat) (100) : (CGFloat) (100 * count - 30)
      }
      else {
        return 190
      }
    }
    else {
      return (CGFloat) (100 * count - 30)
    }
  }

  /* Scrolling down hides its heading view. Scrolling up to the top shows it. */
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    self.headingView.isHidden = offsetY > -170
  }

  /* Configures the tab bar controller. Clicking on "Start Practicing" cell
   redirects user to the "Tests" tab of the controller. */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let iconName = self.sections[indexPath.row].iconNames[0]
    switch iconName {
      case SFSymbols.tests:
        self.tabBarController?.selectedIndex = 1
        break
      case SFSymbols.book:
        self.tabBarController?.selectedIndex = 2
        break
      case SFSymbols.progress:
        self.tabBarController?.selectedIndex = 3
        break
      case SFSymbols.settings:
        self.tabBarController?.selectedIndex = 4
        break
      case SFSymbols.notifications:
        /* Create a study schedule. */
        let viewController = CCEDatePickerVC()
        viewController.parentVC = self
        self.present(viewController, animated: true) {
          // code...
        }
        break
      default:
        self.tabBarController?.selectedIndex = 0
        break
    }
  }

}
