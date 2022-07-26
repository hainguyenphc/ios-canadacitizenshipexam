//
//  CCEQuestion.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import Foundation

struct CCEQuestion: Codable {

  var answers: [String]!

  var correctAnswer: String!

  var isMultipleChoice: Bool!

  var explanation: String!

  var question: String!

  var stats: Dictionary<String, Int?>!

  init(answers: [String],
       correctAnswer: String,
       isMultipleChoice: Bool,
       explanation: String,
       question: String,
       stats: [String:Int?]
  ) {
    self.answers = answers
    self.correctAnswer = correctAnswer
    self.isMultipleChoice = answers.count == 4
    self.explanation = explanation
    self.question = question
    self.stats = stats
  }

}
