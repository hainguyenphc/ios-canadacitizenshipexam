//
//  CCEUsersData.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-10.
//

import Foundation

class CCEUsersData {

  var finishedTests: [String]!

  var readChapters: [String]!

  init() {
    self.finishedTests = []
    self.readChapters = []
  }

  init (finishedTests: [String], readChapters: [String]) {
    self.finishedTests = finishedTests
    self.readChapters = readChapters
  }

}
