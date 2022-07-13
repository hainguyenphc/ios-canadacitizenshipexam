//
//  TestsVC+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import UIKit

extension TestsVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(
      withIdentifier: K.sectionCellIdentifier, for: indexPath)
    as! CCESectionCell_Complex
    rcell.configureCell(section: sections[indexPath.row], at: 0)
    return rcell
  }

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

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    self.headingView.isHidden = offsetY > -170
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tryToResume = self.sections[indexPath.row].iconNames[0] == SFSymbols.restart
    let testvc = TestVC(with: self.tests[indexPath.row].id, tryToResume: tryToResume)
    testvc.title = sections[indexPath.row].primaryTitleTexts[0]
    self.navigationController?.pushViewController(testvc, animated: true)
  }

}
