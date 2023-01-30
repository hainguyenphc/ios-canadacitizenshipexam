  //
  //  HomeScrollView.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2023-01-29.
  //

import UIKit

extension HomeVC_: ScrollProtocol {

  func setupScrollView() {
    scrollView.overrideUserInterfaceStyle = .light
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    scrollView.contentSize = CGSize(width: 100, height: 1000)
    view.addSubview(scrollView)

    if completionPercentageView != nil {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (completionPercentageView! as UIView).bottomAnchor, constant: 20)
      ])
    } else {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide).topAnchor, constant: 20)
      ])
    }

    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: SCROLL_VIEW_LEFT_AND_RIGHT_SPACE),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -SCROLL_VIEW_LEFT_AND_RIGHT_SPACE),
      scrollView.heightAnchor.constraint(equalToConstant: BOUNDS.height * 0.7)
    ])

    // setupScheduleBlockView()
    // setupScheduleBlockView2()

    var previousView: UIView? = nil
    var x: CardProtocol? = nil
    var distanceToTop: CGFloat = 0

    var card1: CardProtocol = Card()
    card1 = CardPrimaryTitleLabel(card: card1, text: "Create a Study Schedule")
    card1 = CardTaglineLabel(card: card1, text: "Make a schedule to meet your goals.\nTurn on notifications for study reminders.")
    card1 = CardActionableItem(card: card1, text: "Turn on Notifications", imageName: "bell")
    card1 = CardActionableItem(card: card1, text: "Schedule your Exam", imageName: "calendar")
    card1 = CardActionableItem(card: card1, text: "Practice Time: 10:00 AM", imageName: "clock")

    x = card1.build(scrollView: scrollView, previous: nil)

    NSLayoutConstraint.activate([
      (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      (x!).theView!.heightAnchor.constraint(equalToConstant: card1.getHeight()),
      (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    previousView = (card1).theView
    distanceToTop += card1.getHeight() + DISTANCE_BETWEEN_CARDS

    var card2: CardProtocol = Card()
    card2 = CardPrimaryTitleLabel(card: card2, text: "Daily Question")
    x = card2.build(scrollView: scrollView, previous: previousView)

    NSLayoutConstraint.activate([
      (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      (x!).theView!.heightAnchor.constraint(equalToConstant: card2.getHeight()),
      (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    previousView = (card2).theView
    distanceToTop += card2.getHeight() + DISTANCE_BETWEEN_CARDS

    var card3: CardProtocol = Card()
    card3 = CardPrimaryTitleLabel(card: card3, text: "Start Practicing")
    x = card3.build(scrollView: scrollView, previous: previousView)

    NSLayoutConstraint.activate([
      (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      (x!).theView!.heightAnchor.constraint(equalToConstant: card3.getHeight()),
      (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    previousView = (card3).theView
    distanceToTop += card2.getHeight() + DISTANCE_BETWEEN_CARDS

    var card4: CardProtocol = Card()
    card4 = CardPrimaryTitleLabel(card: card4, text: "Read the Study Book")
    x = card4.build(scrollView: scrollView, previous: previousView)

    NSLayoutConstraint.activate([
      (x!).theView!.topAnchor.constraint(equalTo: (previousView?.bottomAnchor)!, constant: distanceToTop),
      (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      (x!).theView!.heightAnchor.constraint(equalToConstant: card4.getHeight()),
      (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])
  }

}

// MARK: - code snippets

// func setupScheduleBlockView() {
//   blockView = UIView()
//   blockView.overrideUserInterfaceStyle = .light
//   blockView.backgroundColor = .secondarySystemBackground
//   blockView.translatesAutoresizingMaskIntoConstraints = false
//   blockView.layer.cornerRadius = 20
//   blockView.layer.shadowColor = UIColor.lightGray.cgColor
//   blockView.layer.shadowOpacity = 0.4
//   blockView.layer.shadowOffset = .zero
//   blockView.layer.shadowRadius = 10
//   scrollView.addSubview(blockView)
//   NSLayoutConstraint.activate([
//     blockView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
//     blockView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//     blockView.heightAnchor.constraint(equalToConstant: 150),
//     blockView.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
//   ])
//
//   let label = UILabel()
//   label.text = "Create a Study Schedule"
//   label.textColor = .label
//   label.translatesAutoresizingMaskIntoConstraints = false
//   label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//   blockView.addSubview(label)
//   NSLayoutConstraint.activate([
//     label.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15),
//     label.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15),
//   ])
//
//   let makeScheduleLabel = UILabel()
//   makeScheduleLabel.text = "Make a schedule to meet your goals."
//   makeScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
//   makeScheduleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//   makeScheduleLabel.textColor = .lightGray
//   blockView.addSubview(makeScheduleLabel)
//   NSLayoutConstraint.activate([
//     makeScheduleLabel.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15 * 3),
//     makeScheduleLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15),
//   ])
//
//   let attachment = NSTextAttachment()
//   attachment.image = UIImage(systemName: "calendar")?.withTintColor(APP_ACCENT_COLOR)
//   let imageString = NSMutableAttributedString(attachment: attachment)
//   let textString = NSAttributedString(string: " Schedule your Exam")
//   imageString.append(textString)
//   let scheduleLabel = UILabel()
//   scheduleLabel.attributedText = imageString
//   scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
//   scheduleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//   scheduleLabel.textColor = APP_ACCENT_COLOR
//   blockView.addSubview(scheduleLabel)
//   NSLayoutConstraint.activate([
//     scheduleLabel.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15 * 5),
//     scheduleLabel.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15)
//   ])
//
//   let attachment2 = NSTextAttachment()
//   attachment2.image = UIImage(systemName: "alarm")?.withTintColor(APP_ACCENT_COLOR)
//   let imageString2 = NSMutableAttributedString(attachment: attachment2)
//   let textString2 = NSAttributedString(string: " Practice Time: 8:30 AM")
//   imageString2.append(textString2)
//   let scheduleLabel2 = UILabel()
//   scheduleLabel2.attributedText = imageString2
//   scheduleLabel2.translatesAutoresizingMaskIntoConstraints = false
//   scheduleLabel2.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//   scheduleLabel2.textColor = APP_ACCENT_COLOR
//   blockView.addSubview(scheduleLabel2)
//   NSLayoutConstraint.activate([
//     scheduleLabel2.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 15 * 7),
//     scheduleLabel2.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 15)
//   ])
// }
//
// func setupScheduleBlockView2() {
//   blockView2 = UIView()
//   blockView2.overrideUserInterfaceStyle = .light
//   blockView2.backgroundColor = .secondarySystemBackground
//   blockView2.translatesAutoresizingMaskIntoConstraints = false
//   blockView2.layer.cornerRadius = 20
//   blockView2.layer.shadowColor = UIColor.lightGray.cgColor
//   blockView2.layer.shadowOpacity = 0.4
//   blockView2.layer.shadowOffset = .zero
//   blockView2.layer.shadowRadius = 10
//   scrollView.addSubview(blockView2)
//   NSLayoutConstraint.activate([
//     blockView2.topAnchor.constraint(equalTo: blockView.bottomAnchor, constant: 20),
//     blockView2.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//     blockView2.heightAnchor.constraint(equalToConstant: 150),
//     blockView2.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
//   ])
//
//   let label = UILabel()
//   label.text = "Create a Study Schedule II"
//   label.textColor = .label
//   label.translatesAutoresizingMaskIntoConstraints = false
//   label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//   blockView2.addSubview(label)
//   NSLayoutConstraint.activate([
//     label.topAnchor.constraint(equalTo: blockView2.topAnchor, constant: 15),
//     label.leadingAnchor.constraint(equalTo: blockView2.leadingAnchor, constant: 15),
//   ])
// }
