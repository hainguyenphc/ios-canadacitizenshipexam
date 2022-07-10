//
//  CCETest.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import Foundation

struct CCEQuestion: Codable {

  var answers: [String]!

  var correctAnswer: String!

  var isMultipleChoice: Bool!

  var explanation: String!

  var question: String!

  // TODO: Deals with statistics.
  var stats: Dictionary<String, Int?>!

  init(answers: [String],
       name: String = "",
       correctAnswer: String,
       isMultipleChoice: Bool,
       explanation: String,
       question: String,
       stats: [String:Int?]
  ) {
    self.answers = answers
    self.correctAnswer = correctAnswer
    self.isMultipleChoice = isMultipleChoice
    self.explanation = explanation
    self.question = question
    self.stats = stats
  }

}

// The original question & the user answer.
struct CCEDirtyQuestion {

  // The original question.
  var question: CCEQuestion!

  // What user picked.
  var userAnswer: String!

  var timeOnQuestion: Int?

  init(question: CCEQuestion, userAnswer: String, timeOnQuestion: Int = 0) {
    self.question = question
    self.userAnswer = userAnswer
    self.timeOnQuestion = timeOnQuestion
  }

}

// The collection of questions & potentially metadata of the test.
struct CCETest: Codable {

  var id: String!

  // User-friendly name.
  var name: String!

  // A test comprises of questions.
  var questions: [CCEQuestion]!

  // How long does it take?
  var timeOnTest: Int!

  var totalSubmissions: Int!

  // On average, how do people perform on the test?
  var communityAverageScore: Int!

  init() {
    self.id = ""
    self.name = ""
    self.questions = []
    self.timeOnTest = 0
    self.totalSubmissions = 0
    self.communityAverageScore = 0
  }

  // TODO: Other metadata related to the test?

}

struct CCEChapter: Codable {

  var id: String!

  var title: String!

  init() {
    self.id = ""
    self.title = ""
  }

  init (title: String) {
    self.title = title
  }

}
