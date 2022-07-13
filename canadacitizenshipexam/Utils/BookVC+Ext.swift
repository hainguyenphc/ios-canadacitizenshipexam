//
//  BookVC+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import UIKit

extension BookVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.chapters.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rcell = self.tableView.dequeueReusableCell(
      withIdentifier: K.sectionCellIdentifier, for: indexPath)
    as! CCESectionCompoundCell
    rcell.selectionStyle = .none
    rcell.configureCell(section: sections[indexPath.row], at: 0)
    return rcell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = sections[indexPath.row]
    let count = section.titles.count
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
    let chapterVC = ChapterVC(chapterIndex: indexPath.row)
    chapterVC.title = sections[indexPath.row].titles[0]
    self.navigationController?.pushViewController(chapterVC, animated: true)
  }

}
