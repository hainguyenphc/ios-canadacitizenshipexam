//
//  CCEUsersData.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-10.
//

import Foundation

class CCEUsersData {

  var readChapters: [String]!

  var finishedTests: [CCEFinishedTest]!

  init() {
    self.finishedTests = []
    self.readChapters = []
  }

  init (finishedTests: [CCEFinishedTest], readChapters: [String]) {
    self.readChapters = readChapters
    self.finishedTests = finishedTests
  }

}
