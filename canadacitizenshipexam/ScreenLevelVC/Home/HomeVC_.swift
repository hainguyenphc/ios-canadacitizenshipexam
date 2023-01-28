//
//  HomeVC_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-27.
//

import UIKit

class HomeVC_: UIViewController {

  let bounds = UIScreen.main.bounds
  let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom

  // @remove headerBackgroundView
  var stickyHeadingView: UIView!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupStickyHeadingView()
  }

}
