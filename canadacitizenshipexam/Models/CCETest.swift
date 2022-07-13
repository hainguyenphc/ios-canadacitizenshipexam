//
//  CCETest.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import Foundation

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

}
