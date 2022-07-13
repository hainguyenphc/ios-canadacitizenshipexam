  //
  //  CCEConstants.swift
  //  canadacitizenshipexam
  //
  //  Created by hainguyen on 2022-04-30.
  //

import UIKit

struct CCECollections {

  /* A list of all online tests. */
  static let tests = "Tests"
  /* A list of read chapters. */
  static let chapters = "Chapters"
  /* A list of finished tests. */
  static let finishedTests = "FinishedTests"
  /* A list of data specific to user. */
  static let Users_Data = "Users_Data"

}

struct K {

  static let passingScoreInPercent                = 75
  static let sectionCellIdentifier                = "cceSectionCell"
  static let standardCharacterCountForTableCell   = 72

}

enum Dimensions {

  static let cardViewTopPadding: CGFloat            = 20
  static let cardViewLeadingPadding: CGFloat        = 20
  static let cardViewTrailingPadding: CGFloat       = 20
  static let defaultPadding: CGFloat                = 15
  static let bottomPaddingForAnswerLabel: CGFloat   = -30
}

enum  TabBarItemID {

  case home
  case tests
  case book
  case progress
  case settings

}

enum SFSymbols {

  static let home                     = "house.fill"
  static let tests                    = "square.stack.3d.up"
  static let book                     = "books.vertical"
  static let progress                 = "chart.pie"
  static let settings                 = "gear"
  static let notifications            = "bell"
  static let premium                  = "plus"
  static let lock                     = "lock.fill"
  static let openLock                 = "lock.open.fill"
  static let info                     = "info.circle"
  static let sectionFallbackImageName = "doc.text"
  static let tryAgain                 = "arrow.uturn.backward"
  static let restart                  = "restart.circle.fill"
  static let read                     = "studentdesk"
  static let userProfile              = "person.crop.circle.fill"
  static let finished                 = "checkmark.seal.fill"

}

enum CCEScreens {

  static let home                     = "home"
  static let tests                    = "tests"
  static let book                     = "book"
  static let progress                 = "progress"
  static let settings                 = "settings"

}

enum CCEErrorMessage {

  // Initialization failures
  static let cceCompoundSectionArraysSizesMismatchFailure = "Arrays to construct CCECompoundSection must have equal sizes."
  static let chapterLoadingFailure = "Something went wrong loading chapter."

}

enum CCEFailure: String, Error {

  // Networking failures
  case getTestByIdFailure = "There was probleam loading the test with that ID."

  // Parsing failures
  case parseUsersDataFailure = "There was problem parsing users data to correct format."
  case parseTestDataFailure = "There was problem parsing test data to correct format."
  case questionsMissingFailure = "Questions were missing from the test data."
  case communityAverageScoreMissingFailure = "Community average score was missing from the test data."
  case totalSubmissionsMissingFailure = "Total submissions were missing from the test data."
  case nameMissingFailure = "Name was missing from the test data."
  case statsMissingFailure = "Statistics were missing from the test data."

}

struct Chapters {

  static let storage = [
    [
      "id": "947E5DF8-A14D-4A59-BA4E-CBC5BC1F5F6F",
      "title": "Applying for citizenship"
    ],
    [
      "id": "60EBFD59-74CC-439B-B25A-5CB90222FAA4",
      "title": "Rights and responsibilities"
    ]
  ]

}
