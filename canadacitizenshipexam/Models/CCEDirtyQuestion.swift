//
//  CCEDirtyQuestion.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import Foundation

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
