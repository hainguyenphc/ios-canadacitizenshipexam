//
//  TestVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import CoreData
import UIKit

/* Represents a running test. */
class TestVC: UIViewController {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var testID: String!

  var cceTest: CCETest!

  var counter: Int! = 0

  var userHasAnswered: Bool! = false

  var userAnswer: String! = ""

  var dirtyQuestions: [CCEDirtyQuestion]!

  // The timestamp when a question first loads up.
  var startTimestamp: Double?

  var duration: Int!

  var isTestDone: Bool! = false

  // The persistent container's view context to access CoreData.
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  var tryToResume: Bool!
  var cdTest: Test!
  var cdStates: [State]!

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var questionLabel = CCELevelOneTitleLabel(text: "", textAlignment: .left, fontSize: 26)

  var answerButtons = [
    CCEButton(backgroundColor: .secondaryLabel, title: ""),
    CCEButton(backgroundColor: .secondaryLabel, title: ""),
    CCEButton(backgroundColor: .secondaryLabel, title: ""),
    CCEButton(backgroundColor: .secondaryLabel, title: "")
  ]

  /* The Next button. */
  var nextButton = CCEButton(backgroundColor: .secondaryLabel, title: "Next")

  // ===========================================================================
  // Initializer
  // ===========================================================================

  init(with testID: String, tryToResume: Bool = false) {
    super.init(nibName: nil, bundle: nil)
    self.testID = testID
    self.tryToResume = tryToResume
  }

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadTest()
    self.configureUI()
    self.configureNextButton()
    // Since the answer buttons are yet prepared (network call has not finished)
    // invoking this function in the loadTest() in case of success network call.
    // self.configureAnswerButtons()

    // A test just finishes up loading.
    self.startTimestamp = NSDate().timeIntervalSinceReferenceDate
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.hidesBackButton = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    if (!self.isTestDone) {
      // Persists the in-progress test and states as the app abruptly terminates.
      self.saveInprogressTest()
    }
    else {
      do {
        let testRequest: NSFetchRequest<Test> = Test.fetchRequest()
        testRequest.predicate = NSPredicate(format: "testID CONTAINS[cd] %@", testID)
        let tests = try self.context.fetch(testRequest)
        if (tests.count > 0) {
          for each in tests {
            self.context.delete(each)
          }
        }
        let stateRequest: NSFetchRequest<State> = State.fetchRequest()
        stateRequest.predicate = NSPredicate(format: "testID CONTAINS[cd] %@", testID)
        let states = try self.context.fetch(testRequest)
        if (states.count > 0) {
          for each in states {
            self.context.delete(each)
          }
        }
        else {
          // Leaves empty.
        }
        self.saveInprogressTest()
      }
      catch {
        // TODO: properly handle error
      }
    }
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func loadTest() -> Void {
    NetworkManager.shared.getTest(with: self.testID) { [weak self] result in
      guard let self = self else { return }
      switch (result) {
        case .success(let cceTest):
          // Any UI-related updates are done on the main thread.
          DispatchQueue.main.async {
            self.cceTest = cceTest
            self.resumeTest()
            self.prepareForNextQuestion()
            self.configureAnswerButtons()
          }
        case .failure(let error):
          // TODO: properly handle error - a modal?
          print(error)
      }
    }
  }

  func resumeTest() {
    self.dirtyQuestions = []
    self.cdTest = Test(context: self.context)
    self.cdTest.testID = testID
    self.cdTest.startedAt = Date.now
    self.cdStates = [State]()

    if self.tryToResume {
      do {
        let request: NSFetchRequest<State> = State.fetchRequest()
        request.predicate = NSPredicate(format: "testID CONTAINS[cd] %@", testID)
        let states = try self.context.fetch(request)
        if states.count > 0 {
          for state in states {
            self.cdStates.append(state)
            self.dirtyQuestions.append(CCEDirtyQuestion(
              question: self.cceTest.questions[Int(state.questionID)],
              userAnswer: state.userAnswer!,
              timeOnQuestion: Int(state.duration)))
          }
          self.counter = states.count
        }
        self.saveInprogressTest()
      }
      catch {
        // TODO: properly handle error
      }
    }
  }

  /* Establishes the event handler for the next button. */
  func configureNextButton() -> Void {
    self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
  }

  /* Establishes the event handler for the answer buttons. */
  func configureAnswerButtons() -> Void {
    for i in 0...3 {
      self.answerButtons[i].addTarget(self, action: #selector(answerButtonPressed), for: .touchUpInside)
    }
  }

  /* Handles the event when the next button is pressed. */
  @objc func nextButtonPressed(_ sender: CCEButton!) -> Void {
    if (!self.userHasAnswered) { return }
    // Records the dirty question.
    // The test is still in progress.
    if (self.counter < self.cceTest.questions.count - 1) {
      self.counter += 1
      self.prepareForNextQuestion()
      // Restarts the timer to determine duration for next question.
      self.startTimestamp = NSDate().timeIntervalSinceReferenceDate
    }
    // This is the end of the test.
    else {
      self.isTestDone = true
      // Navigates user to the Test Result screen.
      let testResultVC = TestResultVC(test: self.cceTest, dirtyQuestions: self.dirtyQuestions)
      self.navigationController?.pushViewController(testResultVC, animated: true)
    }
  }

  /* Handles when one of the answer button is pressed. */
  @objc func answerButtonPressed(_ sender: CCEButton!) -> Void {
    if self.userHasAnswered { return }
    self.userAnswer = sender.titleLabel?.text
    let correctAnswer = self.cceTest.questions[self.counter].correctAnswer
    if self.userAnswer != nil && correctAnswer != nil {
      self.userHasAnswered = true
      sender.backgroundColor = (self.userAnswer == correctAnswer) ? .systemGreen : .systemRed
    }
    //
    self.updateDirtyQuestions()
    //
    self.addDirtyQuestionToInprogressTest()
  }

  /* Executes any logic to make way for the first question or the next one. */
  func prepareForNextQuestion() -> Void {
    // Updates the next question label.
    self.questionLabel.text = self.cceTest.questions[self.counter].question
    // User has not answered the next question yet.
    self.userHasAnswered = false
    // Updates the next answer labels and colors.
    for i in 0...3 {
      self.answerButtons[i].setTitle(self.cceTest.questions[self.counter].answers[i],for: .normal)
      self.answerButtons[i].backgroundColor = .secondaryLabel
    }
    self.answerButtons[0].isHidden = !self.cceTest.questions[self.counter].isMultipleChoice
    self.answerButtons[1].isHidden = !self.cceTest.questions[self.counter].isMultipleChoice
  }

  /* Any logic to update the dirty question records. */
  func updateDirtyQuestions() -> Void {
    self.duration = 0
    if let start = self.startTimestamp {
      // Determines the duration spent on the most recent question.
      self.duration = (Int) (NSDate().timeIntervalSinceReferenceDate - start)
    }
    self.dirtyQuestions.append(CCEDirtyQuestion(
      question: self.cceTest.questions[self.counter],
      userAnswer: self.userAnswer,
      timeOnQuestion: self.duration
    ))
  }

  /* Adds the dirty question to the in-progress test so that user could resume
   the test later if he terminates the test now. */
  func addDirtyQuestionToInprogressTest() {
    let cdState = State(context: self.context)
    cdState.testID = self.testID
    cdState.questionID = Int16(self.counter!)
    cdState.userAnswer = self.userAnswer
    cdState.duration = Int16(self.duration)
    cdState.stateToTest = self.cdTest
    self.cdStates.append(cdState)
  }

  // ===========================================================================
  // CoreData to persist in-progress test
  // ===========================================================================

  func saveInprogressTest() {
    do {
      try self.context.save()
    }
    catch {
      print("Error saving the context \(error)")
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    // Note: Do not update the UI since it is not guaranteed the network request
    // has completed yet.
    // self.updateUI()
    //
    self.tabBarController?.tabBar.isHidden        = true
    // The title of this VC is set on the caller's side.
    // Background color.
    self.view.backgroundColor                     = UIColor.systemBackground
    // Tweaks the question label a bit just so it fits.
    self.view.addSubview(self.questionLabel)
    self.questionLabel.lineBreakMode              = .byWordWrapping
    self.questionLabel.adjustsFontSizeToFitWidth  = true
    self.questionLabel.numberOfLines              = 10

    for each in self.answerButtons {
      self.view.addSubview(each)
    }

    self.view.addSubview(self.nextButton)

    NSLayoutConstraint.activate([
      // The question.
      self.questionLabel.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor,
        constant: Dimensions.defaultPadding),
      self.questionLabel.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.questionLabel.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
      // The D answer.
      self.answerButtons[3].bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
        constant: Dimensions.bottomPaddingForAnswerLabel),
      self.answerButtons[3].leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.answerButtons[3].trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
      // The C answer.
      self.answerButtons[2].bottomAnchor.constraint(
        equalTo: self.answerButtons[3].topAnchor,
        constant: -Dimensions.defaultPadding),
      self.answerButtons[2].leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.answerButtons[2].trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
      // The B answer.
      self.answerButtons[1].bottomAnchor.constraint(
        equalTo: self.answerButtons[2].topAnchor,
        constant: -Dimensions.defaultPadding),
      self.answerButtons[1].leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.answerButtons[1].trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
      // The A answer.
      self.answerButtons[0].bottomAnchor.constraint(
        equalTo: self.answerButtons[1].topAnchor,
        constant: -Dimensions.defaultPadding),
      self.answerButtons[0].leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.answerButtons[0].trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
      // The "Next" button.
      self.nextButton.topAnchor.constraint(
        equalTo: self.questionLabel.bottomAnchor,
        constant: Dimensions.defaultPadding),
      self.nextButton.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: Dimensions.defaultPadding),
      self.nextButton.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -Dimensions.defaultPadding),
    ])
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
