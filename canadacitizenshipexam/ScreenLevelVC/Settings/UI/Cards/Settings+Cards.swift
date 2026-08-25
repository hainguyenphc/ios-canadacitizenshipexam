//
//  Settings+Cards.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit
import FirebaseAuth

extension SettingsVC_ {

  // Builds a small leading-icon + label pair, matching the icon language used
  // by the actionable rows elsewhere in the app, but in the neutral label
  // color rather than the accent red reserved for call-to-action rows.
  private func buildIconLabelRow(imageName: String, text: String) -> (row: UIView, icon: UIImageView, label: UILabel) {
    let icon = UIImageView(image: UIImage(systemName: imageName))
    icon.tintColor = APP_ACCENT_COLOR
    icon.translatesAutoresizingMaskIntoConstraints = false

    let label = ScreenTitleLabel(text: text, textColor: .label, textAlignment: .left, fontSize: 16, fontWeight: .regular)

    let row = UIView()
    row.translatesAutoresizingMaskIntoConstraints = false
    row.addSubview(icon)
    row.addSubview(label)

    NSLayoutConstraint.activate([
      icon.leadingAnchor.constraint(equalTo: row.leadingAnchor),
      icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
      icon.widthAnchor.constraint(equalToConstant: 20),

      label.topAnchor.constraint(equalTo: row.topAnchor),
      label.bottomAnchor.constraint(equalTo: row.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
      label.trailingAnchor.constraint(equalTo: row.trailingAnchor)
    ])

    return (row, icon, label)
  }

  func buildTheCards() {
    // The height of the heading area (title and tagline only — Settings has
    // no completion circle, unlike Tests/Book/Progress).
    distanceToTop = 130

    // MARK: - Account (card)

    var accountCard: CardProtocol = Card()
    accountCard = CardPrimaryTitleLabel(card: accountCard, text: "Account")
    let builtAccount = accountCard.build(scrollView: scrollView, previous: nil)
    let accountCardView = builtAccount!.theView!

    let signedInText: String
    if let email = Auth.auth().currentUser?.email {
      signedInText = "Signed in as \(email)"
    } else {
      signedInText = "You're not signed in"
    }

    let accountRow = buildIconLabelRow(imageName: SFSymbols.userProfile, text: signedInText)
    accountCardView.addSubview(accountRow.row)

    let logOutButton = CCEButton(backgroundColor: .systemRed, title: "Log Out")
    logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
    accountCardView.addSubview(logOutButton)

    NSLayoutConstraint.activate([
      accountRow.row.topAnchor.constraint(equalTo: accountCard.theView!.bottomAnchor, constant: 15),
      accountRow.row.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor, constant: 15),
      accountRow.row.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor, constant: -15),
      accountRow.row.heightAnchor.constraint(equalToConstant: 40),

      logOutButton.topAnchor.constraint(equalTo: accountRow.row.bottomAnchor, constant: 15),
      logOutButton.leadingAnchor.constraint(equalTo: accountCardView.leadingAnchor, constant: 15),
      logOutButton.trailingAnchor.constraint(equalTo: accountCardView.trailingAnchor, constant: -15),
      logOutButton.heightAnchor.constraint(equalToConstant: 40)
    ])

    // title (accountCard.theHeight!) + gap + row + gap + button + bottom padding.
    let accountCardHeight: CGFloat = accountCard.theHeight! + 15 + 40 + 15 + 40 + 15

    NSLayoutConstraint.activate([
      accountCardView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      accountCardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      accountCardView.heightAnchor.constraint(equalToConstant: accountCardHeight),
      accountCardView.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    distanceToTop += accountCardHeight + DISTANCE_BETWEEN_CARDS

    // MARK: - Preferences (card)

    var preferencesCard: CardProtocol = Card()
    preferencesCard = CardPrimaryTitleLabel(card: preferencesCard, text: "Preferences")
    let builtPreferences = preferencesCard.build(scrollView: scrollView, previous: nil)
    let preferencesCardView = builtPreferences!.theView!

    let reminderRow = buildIconLabelRow(imageName: SFSymbols.notifications, text: "Daily Practice Reminders")

    let reminderSwitch = UISwitch()
    reminderSwitch.translatesAutoresizingMaskIntoConstraints = false
    reminderSwitch.isOn = NotificationManager.shared.isDailyReminderEnabled
    reminderSwitch.onTintColor = APP_ACCENT_COLOR
    reminderSwitch.addTarget(self, action: #selector(dailyReminderSwitchToggled(_:)), for: .valueChanged)
    self.dailyReminderSwitch = reminderSwitch

    preferencesCardView.addSubview(reminderRow.row)
    preferencesCardView.addSubview(reminderSwitch)

    NSLayoutConstraint.activate([
      reminderRow.row.topAnchor.constraint(equalTo: preferencesCard.theView!.bottomAnchor, constant: 15),
      reminderRow.row.leadingAnchor.constraint(equalTo: preferencesCardView.leadingAnchor, constant: 15),
      reminderRow.row.trailingAnchor.constraint(equalTo: reminderSwitch.leadingAnchor, constant: -10),
      reminderRow.row.heightAnchor.constraint(equalToConstant: 31),

      reminderSwitch.centerYAnchor.constraint(equalTo: reminderRow.row.centerYAnchor),
      reminderSwitch.trailingAnchor.constraint(equalTo: preferencesCardView.trailingAnchor, constant: -15)
    ])

    let darkModeRow = buildIconLabelRow(imageName: "moon.fill", text: "Dark Mode")

    let darkModeSwitch = UISwitch()
    darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
    darkModeSwitch.isOn = isDarkModeOn
    darkModeSwitch.onTintColor = APP_ACCENT_COLOR
    darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchToggled(_:)), for: .valueChanged)

    preferencesCardView.addSubview(darkModeRow.row)
    preferencesCardView.addSubview(darkModeSwitch)

    NSLayoutConstraint.activate([
      darkModeRow.row.topAnchor.constraint(equalTo: reminderRow.row.bottomAnchor, constant: 15),
      darkModeRow.row.leadingAnchor.constraint(equalTo: preferencesCardView.leadingAnchor, constant: 15),
      darkModeRow.row.trailingAnchor.constraint(equalTo: darkModeSwitch.leadingAnchor, constant: -10),
      darkModeRow.row.heightAnchor.constraint(equalToConstant: 31),

      darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeRow.row.centerYAnchor),
      darkModeSwitch.trailingAnchor.constraint(equalTo: preferencesCardView.trailingAnchor, constant: -15)
    ])

    // title + gap + reminder row + gap + dark mode row + bottom padding.
    let preferencesCardHeight: CGFloat = preferencesCard.theHeight! + 15 + 31 + 15 + 31 + 15

    NSLayoutConstraint.activate([
      preferencesCardView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      preferencesCardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      preferencesCardView.heightAnchor.constraint(equalToConstant: preferencesCardHeight),
      preferencesCardView.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    distanceToTop += preferencesCardHeight + DISTANCE_BETWEEN_CARDS

    // MARK: - Support (card)

    var supportCard: CardProtocol = Card()
    supportCard = CardPrimaryTitleLabel(card: supportCard, text: "Support")
    supportCard = CardActionableItem(card: supportCard, text: "Rate This App", imageName: "star.fill")
    supportCard = CardActionableItem(card: supportCard, text: "Send Feedback", imageName: "envelope")
    supportCard = CardActionableItem(card: supportCard, text: "Privacy Policy", imageName: "hand.raised")
    supportCard = CardActionableItem(card: supportCard, text: "Terms of Service", imageName: "doc.text")

    let builtSupport = supportCard.build(scrollView: scrollView, previous: nil)

    NSLayoutConstraint.activate([
      builtSupport!.theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      builtSupport!.theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      builtSupport!.theView!.heightAnchor.constraint(equalToConstant: supportCard.theHeight!),
      builtSupport!.theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    distanceToTop += supportCard.theHeight! + DISTANCE_BETWEEN_CARDS

    // MARK: - App version (plain, no card background)

    let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    let versionLabel = ScreenTitleLabel(
      text: "Version \(bundleVersion)",
      textColor: .secondaryLabel,
      textAlignment: .center,
      fontSize: 13,
      fontWeight: .regular
    )
    scrollView.addSubview(versionLabel)

    NSLayoutConstraint.activate([
      versionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop + 10),
      versionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      versionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

    distanceToTop += 10 + 30
  }

}
