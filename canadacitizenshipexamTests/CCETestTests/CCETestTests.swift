  //
  //  CCETestTests.swift
  //  canadacitizenshipexamTests
  //
  //  Created by hainguyen on 2022-07-13.
  //

import XCTest

@testable import canadacitizenshipexam
class CCETestTests: XCTestCase {

  private static let ID = "A0D1E030-D738-4370-86D1-ADF408955CA5"
  private static let Name = "Sample Free Test"
  private static let Questions: [CCEQuestion] = [
    CCEQuestion(
      answers: [
        "1989",
        "1999",
        "2000",
        "2001"
      ],
      correctAnswer: "1999.",
      isMultipleChoice: false,
      explanation: "Nunavut became a territory in 1999.",
      question: "When did Nunavut become a territory?",
      stats: [
        "countA": 10,
        "countB": 11,
        "countC": 12,
        "countD": 13,
      ])
  ]
  private static let TimeOnTest = 10
  private static let TotalSubmissions = 100
  private static let CommunityAverageScore = 76

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test_CCETest_init_with_details() {
    let cceTest = CCETest(
      id: CCETestTests.ID,
      name: CCETestTests.Name,
      questions: CCETestTests.Questions,
      timeOnTest: CCETestTests.TimeOnTest,
      totalSubmissions: CCETestTests.TotalSubmissions,
      communityAverageScore: CCETestTests.CommunityAverageScore)
    XCTAssertNotNil(cceTest)
    XCTAssertEqual(cceTest.id, CCETestTests.ID)
    XCTAssertEqual(cceTest.name, CCETestTests.Name)
    XCTAssertEqual(cceTest.questions.count, CCETestTests.Questions.count)
    XCTAssertEqual(cceTest.timeOnTest, CCETestTests.TimeOnTest)
    XCTAssertEqual(cceTest.totalSubmissions, CCETestTests.TotalSubmissions)
    XCTAssertEqual(cceTest.communityAverageScore, CCETestTests.CommunityAverageScore)

    for question in cceTest.questions {
      XCTAssertNotNil(question.answers)
      XCTAssertEqual(question.answers.count, 4)

      XCTAssertNotNil(question.stats)
      XCTAssertEqual(question.stats.count, 4)

      XCTAssertNotNil(question.isMultipleChoice, "`CCEQuestion.isMultipleChoice` property must be a `Bool`.")

      XCTAssertNotNil(question.correctAnswer)
      XCTAssertTrue(!question.correctAnswer.isEmpty, "`CCEQuestion.correctAnswer` must not be empty.")

      XCTAssertNotNil(question.explanation)
      XCTAssertTrue(!question.explanation.isEmpty, "`CCEQuestion.explanation` must not be empty.")

      XCTAssertNotNil(question.question)
      XCTAssertTrue(!question.question.isEmpty, "`CCEQuestion.question` must not be empty.")
    }
  }


}
