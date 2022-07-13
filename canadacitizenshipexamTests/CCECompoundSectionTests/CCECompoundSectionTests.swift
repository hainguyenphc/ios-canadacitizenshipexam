//
//  CCECompoundSectionTests.swift
//  canadacitizenshipexamTests
//
//  Created by hainguyen on 2022-07-13.
//

import XCTest

@testable import canadacitizenshipexam
class CCECompoundSectionTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test_CCECompoundSection_init_with_valid_titles_bodyTexts_iconNames() {
    let titles: [String] = [
      "Read the study book",
      "Progress metrics"
    ]
    let bodyTexts: [String] = [
      "Discover Canada is official study guide",
      "See how you perform"
    ]
    let iconNames: [String] = [
      SFSymbols.book,
      SFSymbols.progress,
    ]
    XCTAssertEqual(titles.count, bodyTexts.count)
    XCTAssertEqual(bodyTexts.count, iconNames.count)
    let cceCompoundSection = CCECompoundSection(
      titles: titles, bodyTexts: bodyTexts, iconNames: iconNames)
    XCTAssertNotNil(cceCompoundSection)
    XCTAssertEqual(cceCompoundSection.titles.count, titles.count)
    XCTAssertEqual(cceCompoundSection.bodyTexts.count, bodyTexts.count)
    XCTAssertEqual(cceCompoundSection.iconNames.count, iconNames.count)
  }

  /* Initializer of `CCECompoundSection` expects 3 arrays of equal sizes. */
  func test_CCECompoundSection_init_with_invalid_titles_bodyTexts_iconNames() {
    let titles: [String] = [
      "Read the study book",
      "Progress metrics"
    ]
    let bodyTexts: [String] = [
      "Discover Canada is official study guide",
      "See how you perform"
    ]
    let iconNames: [String] = [
      SFSymbols.book,
      SFSymbols.progress,
      // This is an excess causing a fatal error.
      SFSymbols.home
    ]

    // See XCTestCase+FatalError.swift file.
    self.expectFatalError(expectedMessage: CCEErrorMessage.cceCompoundSectionArraysSizesMismatchFailure) {
      let _ = CCECompoundSection(titles: titles, bodyTexts: bodyTexts, iconNames: iconNames)
    }
  }

}
