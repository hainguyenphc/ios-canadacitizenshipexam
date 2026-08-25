//
//  SettingsVC_.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit
import FirebaseAuth

protocol SettingsVCDelegate {

}

// MARK: View/ViewController

class SettingsVC_: UIViewController, SettingsVCDelegate {

  // MARK: - View Model & Logic variables

  // Whether the heading view should be sticky.
  let isTheHeadingViewSticky: Bool = false

  var distanceToTop: CGFloat = 0

  var isFirstTimeLoaded: Bool = true

  // The key daily reminders are persisted under, so the switch reflects the
  // user's last choice the next time this screen is opened.
  static let dailyReminderDefaultsKey = "dailyRemindersEnabled"

  var isDailyReminderOn: Bool {
    get { UserDefaults.standard.bool(forKey: SettingsVC_.dailyReminderDefaultsKey) }
    set { UserDefaults.standard.set(newValue, forKey: SettingsVC_.dailyReminderDefaultsKey) }
  }

  // MARK: - Sub-views

  var unlockPremiumFeaturesView: UIView?

  // The scroll view containing several cards.
  var scrollView: UIScrollView! = UIScrollView()

  // MARK: - Life-cyle methods

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if isFirstTimeLoaded {
      // Build the Unlock view first since other views depend on it.
      unlockPremiumFeaturesView = buildTheUnlockPremiumFeatureView()

      // The Settings view has its heading area attached to the scroll view.
      // I.e., the heading area is not sticky.
      // Hence, we set up the scroll view first.
      setupScrollView()
      // Then we build the heading.
      buildTheHeadingView()
      // Next, we construct the cards below the heading.
      buildTheCards()
      // Finally, establish the scroll view height.
      specifyScrollViewHeight()

      isFirstTimeLoaded = !isFirstTimeLoaded
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1.0)
  }

  // MARK: - Actions

  @objc func logOutButtonPressed() {
    do {
      if let _ = Auth.auth().currentUser?.uid {
        // User would like to sign out.
        try Auth.auth().signOut()
        // Upon landing on the Home VC, as there is no active session any more,
        // he will be redirected to Register VC.
        self.tabBarController?.selectedIndex = 0
      }
    } catch {
      // @TODO: handle error
      print("Error signing user out.")
    }
  }

  @objc func dailyReminderSwitchToggled(_ sender: UISwitch) {
    isDailyReminderOn = sender.isOn
    // @TODO: schedule/cancel the local notification once the notifications
    // infrastructure lands. For now this only persists the user's choice.
  }

}
