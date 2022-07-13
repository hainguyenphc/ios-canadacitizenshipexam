//
//  TestResultVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-07.
//

import UIKit
import FirebaseAuth

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

  var testResult: [String: Any] {
    let name = self.test.name!
    var timeOnTest = 0
    var numberOfCorrectAnswers = 0
    let totalNumberOfAnswers = self.dirtyQuestions.count
    for dirtyQuestion in self.dirtyQuestions {
      if let theQuestion = dirtyQuestion.question {
        if dirtyQuestion.userAnswer == theQuestion.correctAnswer {
          numberOfCorrectAnswers += 1
        }
      }
      // Accumulates all time spent on the test.
      if let timeOnQuestion = dirtyQuestion.timeOnQuestion {
        timeOnTest += timeOnQuestion
      }
    }
    let testScoreInPercent = (numberOfCorrectAnswers * 100) / totalNumberOfAnswers
    let testScoreInPercentFloat = Float((numberOfCorrectAnswers * 100) / totalNumberOfAnswers)
    let message = testScoreInPercent < K.passingScoreInPercent
      ? "Try Again"
      : "Congratulations!"
    //
    var totalSubmissions = 0
    var communityAverageScore = 0
    if let totalSubmissionsForTest = self.test.totalSubmissions {
      totalSubmissions = totalSubmissionsForTest + 1
      communityAverageScore =
        (self.test.communityAverageScore * totalSubmissionsForTest + testScoreInPercent) / (totalSubmissionsForTest + 1)
    }
    return [
      "name": name,
      "message": message,
      "communityAverageScore": communityAverageScore,
      "totalSubmissions": (totalSubmissions),
      "testScoreInPercent": testScoreInPercent,
      "testScoreInPercentFloat": testScoreInPercentFloat,
      "numberOfCorrectAnswers": numberOfCorrectAnswers,
      "totalNumberOfAnswers": totalNumberOfAnswers,
      "timeOnTest": timeOnTest.convertToHumanReadableTimeInterval(),
    ]
  }

  // ===========================================================================
  // Initializer
  // ===========================================================================
  
  init(test: CCETest, dirtyQuestions: [CCEDirtyQuestion]) {
    super.init(nibName: nil, bundle: nil)
    self.test = test
    self.dirtyQuestions = dirtyQuestions
    if let message = self.testResult["message"] as? String {
      self.messageLabel = CCELevelOneTitleLabel(
        text: message,
        textAlignment: .center,
        fontSize: 32
      )
    }
    if let testScoreInPercentFloat = self.testResult["testScoreInPercentFloat"] as? Float {
      self.circularProgressLabel = CCECircularProgressLabel(
        completed: testScoreInPercentFloat
      )
    }
    if let numberOfCorrectAnswers = self.testResult["numberOfCorrectAnswers"] as? Int,
       let totalNumberOfAnswers = self.testResult["totalNumberOfAnswers"] as? Int
    {
      self.summaryLabels.append(CCEBodyLabel(
        text: "\(numberOfCorrectAnswers) correct answers out of \(totalNumberOfAnswers) questions",
        textAlignment: .center,
        fontSize: 14
      ))
    }
    if let timeOnTest = self.testResult["timeOnTest"] as? String {
      self.summaryLabels.append(CCEBodyLabel(
        text: "Time on test: \(timeOnTest)",
        textAlignment: .center,
        fontSize: 14
      ))
    }
    if let communityAverageScore = self.testResult["communityAverageScore"] as? Int {
      self.summaryLabels.append(CCEBodyLabel(
        text: "Community average score: \(communityAverageScore)%",
        textAlignment: .center,
        fontSize: 14
      ))
    }
    // Configures the UI.
    self.configureUI()
  }

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .secondarySystemBackground
    // By the time `viewDidLoad()` runs, the `testResult` calculated property is ready.
    self.storage.append(self.buildTestReviewSection())
    // Configures the table.
    self.configureTableView()
    // Makes a network request to update the test data.
    self.updateTestOnServer()
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

  func configureUI() -> Void {
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.messageLabel)

    self.circularProgressLabel.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.circularProgressLabel)

    // Deals with the percent label.
    if let testScoreInPercent = self.testResult["testScoreInPercent"] as? Int {
      self.circularProgressLabel.progressLabel.text = "\(testScoreInPercent)%"
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

  func updateTestOnServer() {
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

    NetworkManager.shared.updateTest(with: self.test.id, fields: [
      "name": self.testResult["name"]!,
      "totalSubmissions": self.testResult["totalSubmissions"]!,
      "communityAverageScore": self.testResult["communityAverageScore"]!,
      "questions": questions
    ])

    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }
    NetworkManager.shared.getUsersData(userID: userID) { [weak self] result in
      guard let self = self else { return }
      switch (result) {
        case .success(let usersData):
          let redoTest = usersData.finishedTests.contains(self.test.id)
            // Only if this is a fresh new test (1st time user takes it), updates the
            // list of taken tests for user.
          if (!redoTest) {
            usersData.finishedTests.append(self.test.id)
            let fields: [String: Any] = [
              "finishedTests": usersData.finishedTests!
            ]
            NetworkManager.shared.updateUsersData(
              userID: userID,
              fields: fields
            )
          }
        case .failure(let error):
          print(error)
      } // end switch
    } // end closure
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
            let imageSystemName = "checkmark"
            let imageTintColor: UIColor = .systemGreen
            imageAttachment.image = UIImage(systemName: imageSystemName)?
              .withTintColor(imageTintColor)
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
