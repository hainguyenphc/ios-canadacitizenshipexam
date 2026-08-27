//
//  TestResultVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-07.
//

import UIKit

/* Represents a screen showing test result and recap. */
class TestResultVC: UIViewController {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var test: CCETest!

  var messageLabel: CCELevelOneTitleLabel!

  var circularProgressLabel: CCECircularProgressLabel!

  var summaryLabels: [CCEBodyLabel]! = []

  var tableView: UITableView = UITableView()

  // Shown while the attempt is being scored server-side (see
  // submitAttemptToServer()) — the score isn't known synchronously anymore,
  // so there's a real gap to cover before messageLabel/circularProgressLabel/
  // summaryLabels exist at all.
  var loadingIndicator = UIActivityIndicatorView(style: .large)

  var storage: [CCESection] = [
    CCESection(
      title: "Return to Main Menu",
      bodyText: "",
      iconName: SFSymbols.home),
    CCESection(
      title: "Try Again",
      bodyText: "Restart this test",
      iconName: SFSymbols.tryAgain),
    CCESection(
      title: "How am I doing?",
      bodyText: "See your progress metric",
      iconName: SFSymbols.progress),
  ]

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var dirtyQuestions: [CCEDirtyQuestion]!

  // Populated once score_quiz_attempt responds (see submitAttemptToServer())
  // — nothing on this screen computes a score itself anymore. nil until
  // then, which is exactly the gap loadingIndicator covers.
  var attemptResult: CCEQuizAttemptResult?

  // ===========================================================================
  // Initializer
  // ===========================================================================
  
  init(test: CCETest, dirtyQuestions: [CCEDirtyQuestion]) {
    super.init(nibName: nil, bundle: nil)
    self.test = test
    self.dirtyQuestions = dirtyQuestions
    // messageLabel/circularProgressLabel/summaryLabels used to be built
    // right here, synchronously, from a locally-computed score. Scoring is
    // server-authoritative now (see submitAttemptToServer()), so none of
    // that can happen until the server actually responds — see
    // finishConfiguringUI(), called from viewDidLoad()'s network callback.
  }

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .secondarySystemBackground
    // The review section only compares against data already on the client
    // (each question's correctAnswer, which the client legitimately has —
    // see the note on buildTestReviewSection()), so unlike the score
    // summary it doesn't need to wait on the server.
    self.storage.append(self.buildTestReviewSection())
    // Configures the table.
    self.configureTableView()
    // Shows a spinner where the score summary will go, then asks the
    // server to score this attempt.
    self.configureLoadingIndicator()
    self.submitAttemptToServer()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.hidesBackButton = true
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureTableView() -> Void {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(
      UINib(nibName: "CardCell", bundle: nil),
      forCellReuseIdentifier: "CardCell")
    self.view.addSubview(self.tableView)
    self.tableView.pin(to: self.view)
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.tableView.contentInset = UIEdgeInsets(
      top: 250, left: 0, bottom: 0, right: 0)
    // Makes the table cell height dynamic.
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 600
  }

  // Shown centered near the top of the screen (same area messageLabel/
  // circularProgressLabel/summaryLabels occupy once they exist) while
  // waiting on score_quiz_attempt.
  func configureLoadingIndicator() -> Void {
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.loadingIndicator)
    self.loadingIndicator.startAnimating()
    NSLayoutConstraint.activate([
      self.loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.loadingIndicator.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
    ])
  }

  // Only called once attemptResult is populated (see finishConfiguringUI())
  // — everything here reads the server's score, never computes one.
  func configureUI() -> Void {
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.messageLabel)

    self.circularProgressLabel.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.circularProgressLabel)

    // Deals with the percent label.
    if let attemptResult = self.attemptResult {
      self.circularProgressLabel.progressLabel.text = "\(Int(attemptResult.scorePercent))%"
    }

    for summaryLabel in self.summaryLabels {
      summaryLabel.translatesAutoresizingMaskIntoConstraints = false
      self.view.addSubview(summaryLabel)
    }

    NSLayoutConstraint.activate([
      //
      self.messageLabel.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.defaultPadding),
      self.messageLabel.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor, constant: Dimensions.defaultPadding),
      self.messageLabel.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.circularProgressLabel.topAnchor.constraint(
        equalTo: self.messageLabel.bottomAnchor, constant: Dimensions.defaultPadding),
      self.circularProgressLabel.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor, constant: Dimensions.defaultPadding),
      self.circularProgressLabel.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.summaryLabels[0].topAnchor.constraint(
        equalTo: self.circularProgressLabel.bottomAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[0].leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[0].trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.summaryLabels[1].topAnchor.constraint(
        equalTo: self.summaryLabels[0].bottomAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[1].leadingAnchor.constraint(
        equalTo: self.summaryLabels[0].leadingAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[1].trailingAnchor.constraint(
        equalTo: self.summaryLabels[0].trailingAnchor, constant: -Dimensions.defaultPadding),
      //
      self.summaryLabels[2].topAnchor.constraint(
        equalTo: self.summaryLabels[1].bottomAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[2].leadingAnchor.constraint(
        equalTo: self.summaryLabels[1].leadingAnchor, constant: Dimensions.defaultPadding),
      self.summaryLabels[2].trailingAnchor.constraint(
        equalTo: self.summaryLabels[1].trailingAnchor, constant: -Dimensions.defaultPadding),
    ])

    // Deals with positioning the circle (centering it).
    let x = self.view.frame.size.width / 2
    let y = self.circularProgressLabel.roundView.frame.size.width / 2
    self.circularProgressLabel.roundView.frame.origin.x = x - (y + y / 2)
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  // Submits the user's picks to score_quiz_attempt — this, not anything on
  // the client, is what decides correctness and records the result
  // (Users_Data/{uid}.finishedTests). See the ios-canadacitizenshipexam-cloud-functions
  // repo. questionIndex is this question's position in self.test.questions
  // (dirtyQuestions is built in that same order — see TestVC.updateDirtyQuestions).
  func submitAttemptToServer() {
    let answers = self.dirtyQuestions.enumerated().map { (index, dirtyQuestion) in
      (questionIndex: index, selectedAnswer: dirtyQuestion.userAnswer!)
    }
    NetworkManager.shared.submitQuizAttempt(testID: self.test.id, answers: answers) { [weak self] result in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
        switch result {
          case .success(let attemptResult):
            self.attemptResult = attemptResult
            self.finishConfiguringUI()
            // The community-stats update is a separate, pre-existing
            // feature — not part of server-authoritative scoring — so it
            // stays a client-side write against the Tests document.
            self.updateCommunityStatsOnServer()
          case .failure(let error):
            self.showSubmissionErrorAlert(error)
        } // end switch
      } // end main.async
    } // end closure
  } // end func

  // Builds the score summary (messageLabel/circularProgressLabel/
  // summaryLabels) now that the server has actually scored this attempt —
  // this used to happen synchronously in init(), before there was a score
  // to build it from.
  func finishConfiguringUI() {
    guard let attemptResult = self.attemptResult else { return }

    let message = Int(attemptResult.scorePercent) < K.passingScoreInPercent
      ? "Try Again"
      : "Congratulations!"
    self.messageLabel = CCELevelOneTitleLabel(
      text: message, textAlignment: .center, fontSize: 32)
    self.circularProgressLabel = CCECircularProgressLabel(completed: attemptResult.scorePercent)

    self.summaryLabels.append(CCEBodyLabel(
      text: "\(attemptResult.correctCount!) correct answers out of \(attemptResult.totalQuestions!) questions",
      textAlignment: .center, fontSize: 14))

    var timeOnTest = 0
    for dirtyQuestion in self.dirtyQuestions {
      if let timeOnQuestion = dirtyQuestion.timeOnQuestion {
        timeOnTest += timeOnQuestion
      }
    }
    self.summaryLabels.append(CCEBodyLabel(
      text: "Time on test: \(timeOnTest.convertToHumanReadableTimeInterval())",
      textAlignment: .center, fontSize: 14))

    if let totalSubmissionsForTest = self.test.totalSubmissions {
      let communityAverageScore =
        (self.test.communityAverageScore * totalSubmissionsForTest + Int(attemptResult.scorePercent))
          / (totalSubmissionsForTest + 1)
      self.summaryLabels.append(CCEBodyLabel(
        text: "Community average score: \(communityAverageScore)%",
        textAlignment: .center, fontSize: 14))
    }

    self.configureUI()
  }

  // Shown when submitAttemptToServer() fails — without this, a user who
  // loses connectivity right after finishing a test would otherwise be
  // stuck looking at a permanent spinner with no way forward.
  func showSubmissionErrorAlert(_ error: CCEFailure) {
    let alert = UIAlertController(
      title: "Couldn't Submit Test",
      message: error.rawValue,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.configureLoadingIndicator()
      self.submitAttemptToServer()
    })
    self.present(alert, animated: true)
  }

  // The community-average-score / per-answer-stats update on the Tests
  // document — a separate, pre-existing feature from server-authoritative
  // scoring (that's Users_Data/{uid}.finishedTests, now handled entirely by
  // score_quiz_attempt). This still writes directly from the client, same
  // as before this change, including its existing known limitation: two
  // concurrent submissions can race and clobber each other's stats update,
  // since it overwrites the whole questions/stats fields rather than using
  // an atomic increment. Not fixed here — out of scope for this change.
  func updateCommunityStatsOnServer() {
    guard let attemptResult = self.attemptResult else { return }

    var countA: Int? = nil
    var countB: Int? = nil
    var stats = [String:Any]()
    var questions = [[String:Any]]()

    for (_, each) in self.test.questions.enumerated() {
      guard let eachStats = each.stats else {
        return
      }
      if let _ = eachStats["countA"]! {
        countA = eachStats["countA"]!
      }
      if let _ = eachStats["countB"]! {
        countB = eachStats["countB"]!
      }
      stats["countA"] = countA
      stats["countB"] = countB
      stats["countC"] = each.stats["countC"]!!
      stats["countD"] = each.stats["countD"]!!
      questions.append([
        "answers": each.answers!,
        "correctAnswer": each.correctAnswer!,
        "explanation": each.explanation!,
        "isMultipleChoice": each.isMultipleChoice!,
        "question": each.question!,
        "stats": stats
      ])
    } // end for

    guard let totalSubmissionsForTest = self.test.totalSubmissions else {
      return
    }
    let communityAverageScore =
      (self.test.communityAverageScore * totalSubmissionsForTest + Int(attemptResult.scorePercent))
        / (totalSubmissionsForTest + 1)

    NetworkManager.shared.updateTest(with: self.test.id, fields: [
      "name": self.test.name!,
      "totalSubmissions": totalSubmissionsForTest + 1,
      "communityAverageScore": communityAverageScore,
      "questions": questions
    ])
  } // end func

  func buildTestReviewSection() -> CCESection {
    let text = NSMutableAttributedString(string: "")
    let questionAttribute: [NSMutableAttributedString.Key: Any] = [
      .foregroundColor: UIColor.label,
      .font: UIFont.boldSystemFont(ofSize: 18)
    ]
    for (questionIndex, dirtyQuestion) in self.dirtyQuestions.enumerated() {
      text.append(NSMutableAttributedString(
        string: dirtyQuestion.question.question,
        attributes: questionAttribute))
      text.append(NSMutableAttributedString(string: "\n\n"))
      for (answerIndex, answer) in dirtyQuestion.question.answers.enumerated() {
        if self.dirtyQuestions[questionIndex].userAnswer == answer {
          if (answerIndex == 0 && self.test.questions[questionIndex].stats["countA"] != nil) {
            self.test.questions[questionIndex].stats["countA"]!! += 1
          }
          else if (answerIndex == 1 && self.test.questions[questionIndex].stats["countB"] != nil) {
            self.test.questions[questionIndex].stats["countB"]!! += 1
          }
          else if (answerIndex == 2) {
            self.test.questions[questionIndex].stats["countC"]!! += 1
          }
          else {
            self.test.questions[questionIndex].stats["countD"]!! += 1
          }
        }
        // This is what user chooses. Places a sign to let him know its correctness.
        if (answer == dirtyQuestion.userAnswer) {
          let imageAttachment = NSTextAttachment()
          let isCorrect =  dirtyQuestion.question.correctAnswer == answer
          let imageSystemName = isCorrect ? "checkmark" : "xmark"
          let imageTintColor: UIColor = isCorrect ? .systemGreen : .systemRed
          imageAttachment.image = UIImage(systemName: imageSystemName)?
            .withTintColor(imageTintColor)
          text.append(NSAttributedString(attachment: imageAttachment))
          text.append(NSAttributedString(string: answer))
          text.append(NSMutableAttributedString(string: "\n\n"))
        }
        else {
          // This is the correct answer that user has missed. Places a green check mark to notify him.
          if (answer == dirtyQuestion.question.correctAnswer) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "checkmark")?
              .withTintColor(.systemGreen)
            text.append(NSAttributedString(attachment: imageAttachment))
            text.append(NSAttributedString(string: answer))
            text.append(NSMutableAttributedString(string: "\n\n"))
          }
          // This is wrong answer and user did not choose it, just places a bland brown minus sign.
          else {
            if (answer != "") {
              let imageAttachment = NSTextAttachment()
              let imageSystemName = "minus"
              let imageTintColor: UIColor = .systemBrown
              imageAttachment.image = UIImage(systemName: imageSystemName)?
                .withTintColor(imageTintColor)
              text.append(NSAttributedString(attachment: imageAttachment))
              text.append(NSAttributedString(string: answer))
              text.append(NSMutableAttributedString(string: "\n\n"))
            }
          }
        }
      }
      text.append(NSAttributedString(string: dirtyQuestion.question.explanation))
      text.append(NSMutableAttributedString(string: "\n\n"))
    }

    return CCESection(title: "Review", attributedBodyText: text, iconName: nil)
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
