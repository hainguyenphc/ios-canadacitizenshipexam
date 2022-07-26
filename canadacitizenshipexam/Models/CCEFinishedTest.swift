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

  var timestamp: Date! = Date()

  static func ==(lhs: CCEFinishedTest, rhs: CCEFinishedTest) -> Bool {
    if let lhsTimestamp = lhs.timestamp, let rhsTimestamp = rhs.timestamp {
      return lhsTimestamp == rhsTimestamp
    }
    return lhs.testID == rhs.testID
  }

  static func <(lhs: CCEFinishedTest, rhs: CCEFinishedTest) -> Bool {
    if let lhsTimestamp = lhs.timestamp, let rhsTimestamp = rhs.timestamp {
      return lhsTimestamp < rhsTimestamp
    }
    return lhs.testID == rhs.testID
  }

}
