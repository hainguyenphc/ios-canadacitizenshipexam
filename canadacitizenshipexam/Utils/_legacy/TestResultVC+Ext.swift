//
//  TestResultVC+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import UIKit

extension TestResultVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell

    var attributedText = NSMutableAttributedString()

    if let heading = self.storage[indexPath.row].title {
      let attributedHeading = NSMutableAttributedString(
        string: heading,
        attributes: [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
          NSAttributedString.Key.foregroundColor : UIColor.label
        ]
      )
      attributedText = attributedHeading
    }

    if let body = self.storage[indexPath.row].bodyText, body != "" {
      let attributedBody = NSMutableAttributedString(
        string: body,
        attributes: [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
          NSAttributedString.Key.foregroundColor : UIColor.systemRed
        ]
      )
      attributedText.append(NSMutableAttributedString(string: "\n\n"))
      attributedText.append(attributedBody)
    }

    if let attributedBodyText = self.storage[indexPath.row].attributedBodyText, attributedBodyText.string != "" {
      attributedText.append(NSMutableAttributedString(string: "\n\n"))
      attributedText.append(attributedBodyText)
    }

    cell.label.attributedText = attributedText

      // Handles the right hand icon.
    if let iconName_ = self.storage[indexPath.row].iconName {
      cell.accessoryView = UIImageView(image: UIImage(systemName: iconName_))
      cell.accessoryView?.tintColor = .systemRed
    }

    cell.label.numberOfLines = 0

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.storage.count
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 600
  }

  /* Scrolling down hides its heading view. Scrolling up to the top shows it. */
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // messageLabel/circularProgressLabel don't exist until the server has
    // scored the attempt (see TestResultVC.finishConfiguringUI()) — the
    // table can fire scroll events before then (e.g. from its own initial
    // layout while the loading indicator is still showing), so this has to
    // tolerate that gap instead of force-unwrapping into it.
    guard let messageLabel = self.messageLabel,
          let circularProgressLabel = self.circularProgressLabel else {
      return
    }
    let offsetY = scrollView.contentOffset.y
    if offsetY > -340 {
      messageLabel.isHidden = true
      circularProgressLabel.isHidden = true
      for x in self.summaryLabels {
        x.isHidden = true
      }
    }
    else {
      messageLabel.isHidden = false
      circularProgressLabel.isHidden = false
      for x in self.summaryLabels {
        x.isHidden = false
      }
    }
  }

}

extension TestResultVC: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch self.storage[indexPath.row].iconName {
      case SFSymbols.home:
        self.navigationController?.popToRootViewController(animated: true)
          // self.tabBarController?.selectedIndex = 0
        break
      case SFSymbols.tryAgain:
        let testVC = TestVC(with: self.test.id!)
        self.navigationController?.pushViewController(testVC, animated: true)
        break
      case SFSymbols.progress:
        self.navigationController?.pushViewController(ProgressVC_(), animated: true)
        break
      default:
        break
    }
  }

}
