//
//  Progress+Cards.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-02-05.
//

import UIKit

extension ProgressVC_ {

  // A single "Last N tests" row: a leading label, a gray track bar, and a trailing score.
  // Returns the assembled row so callers can position it on the scroll view.
  private func buildScoreStatRow(label: String, score: String, isEmphasized: Bool) -> UIView {
    let hStack = UIStackView()
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.distribution = .fill
    hStack.spacing = 10
    hStack.translatesAutoresizingMaskIntoConstraints = false

    let label = ScreenTitleLabel(
      text: label,
      textColor: .label,
      textAlignment: .right,
      fontSize: 16,
      fontWeight: isEmphasized ? .bold : .regular
    )
    label.setContentHuggingPriority(.required, for: .horizontal)

    let track = UIView()
    track.translatesAutoresizingMaskIntoConstraints = false
    track.backgroundColor = UIColor.systemGray4
    track.layer.cornerRadius = 4

    let scoreLabel = ScreenTitleLabel(
      text: score,
      textColor: .label,
      textAlignment: .left,
      fontSize: 16,
      fontWeight: .regular
    )
    scoreLabel.setContentHuggingPriority(.required, for: .horizontal)

    hStack.addArrangedSubview(label)
    hStack.addArrangedSubview(track)
    hStack.addArrangedSubview(scoreLabel)

    NSLayoutConstraint.activate([
      label.widthAnchor.constraint(equalToConstant: 130),
      track.heightAnchor.constraint(equalToConstant: 8),
      scoreLabel.widthAnchor.constraint(equalToConstant: 24)
    ])

    return hStack
  }

  func buildTheCards() {
    // The height of the heading area (title, tagline, and the two progress rows).
    distanceToTop = 290

    // MARK: - Score Statistics (plain section, no card background)

    let scoreStatisticsTitle = UIBuildingManager.shared.buildTheTitleLabel(title: "Score Statistics", textColor: .label)
    scoreStatisticsTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    scrollView.addSubview(scoreStatisticsTitle)

    NSLayoutConstraint.activate([
      scoreStatisticsTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      scoreStatisticsTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      scoreStatisticsTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

    distanceToTop += 40

    let rows: [(label: String, score: String, isEmphasized: Bool)] = [
      ("Last test", "-", false),
      ("Last 5 tests", "-", false),
      ("Last 10 tests", "-", false),
      ("Last 20 tests", "-", false),
      ("All tests (0)", "-", true)
    ]

    for row in rows {
      let rowView = buildScoreStatRow(label: row.label, score: row.score, isEmphasized: row.isEmphasized)
      scrollView.addSubview(rowView)

      NSLayoutConstraint.activate([
        rowView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
        rowView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
        rowView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        rowView.heightAnchor.constraint(equalToConstant: 24)
      ])

      distanceToTop += 24 + 14
    }

    distanceToTop += 20

    // MARK: - Improve your score (card)

    var improveCard: CardProtocol = Card()
    improveCard = CardPrimaryTitleLabel(card: improveCard, text: "Improve your score")
    improveCard = CardActionableItem(card: improveCard, text: "Take practice tests.", imageName: SFSymbols.tests)
    improveCard = CardActionableItem(card: improveCard, text: "Study by reading the official handbook. Tap here to start.", imageName: SFSymbols.book)
    improveCard = CardActionableItem(card: improveCard, text: "Turn on notifications in Settings to get daily practice reminders.", imageName: "alarm")

    let x = improveCard.build(scrollView: scrollView, previous: nil)
    NSLayoutConstraint.activate([
      (x!).theView!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      (x!).theView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      (x!).theView!.heightAnchor.constraint(equalToConstant: improveCard.theHeight!),
      (x!).theView!.widthAnchor.constraint(equalToConstant: BOUNDS.width * 0.95)
    ])

    distanceToTop += improveCard.theHeight! + DISTANCE_BETWEEN_CARDS + 10

    // MARK: - "Practice tests are more difficult" info section (plain, no card background)

    let image = UIImage(systemName: SFSymbols.info)!.withTintColor(.label)
    let attachment = NSTextAttachment()
    attachment.image = image
    let infoTitleText = NSMutableAttributedString(attachment: attachment)
    infoTitleText.append(NSMutableAttributedString(string: " Practice tests are more difficult", attributes: [
      .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
      .foregroundColor: UIColor.label
    ]))

    let infoTitleLabel = UILabel()
    infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    infoTitleLabel.attributedText = infoTitleText
    scrollView.addSubview(infoTitleLabel)

    NSLayoutConstraint.activate([
      infoTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: distanceToTop),
      infoTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      infoTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

    distanceToTop += 30

    let infoBodyLabel = ScreenTitleLabel(
      text: "The practice questions are designed to help candidates become well-equipped in answering the official citizenship test, which covers a broader range of topics and requires a deeper understanding of the material.",
      textColor: .secondaryLabel,
      textAlignment: .left,
      fontSize: 15,
      fontWeight: .regular
    )
    scrollView.addSubview(infoBodyLabel)

    NSLayoutConstraint.activate([
      infoBodyLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 8),
      infoBodyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LEFT_SPACE),
      infoBodyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

    distanceToTop += 100
  }

}
