//
//  CCEFinishedTest.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-14.
//

import Foundation

struct CCEFinishedTest: Comparable {

  var testID: String!

  var score: Float!

  var timestamp: Date!

  static func ==(lhs: CCEFinishedTest, rhs: CCEFinishedTest) -> Bool {
    return lhs.timestamp == rhs.timestamp
  }

  static func <(lhs: CCEFinishedTest, rhs: CCEFinishedTest) -> Bool {
    return lhs.timestamp < rhs.timestamp
  }

}
