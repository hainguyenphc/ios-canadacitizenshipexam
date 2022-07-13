  //
  //  CCESectionTests.swift
  //  canadacitizenshipexamTests
  //
  //  Created by hainguyen on 2022-07-13.
  //

import XCTest

@testable import canadacitizenshipexam
class CCESectionTests: XCTestCase {

  private static let DefaultTitle = "Practice now"
  private static let DefaultBodyText = "Practice makes perfect"

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test_CCESection_init_with_title() {
    let cceSection = CCESection(title: CCESectionTests.DefaultTitle)
    XCTAssertNotNil(cceSection)
    XCTAssertEqual(cceSection.title, CCESectionTests.DefaultTitle)
  }

  func test_CCESection_init_with_set_bodyText() {
    var cceSection = CCESection(title: CCESectionTests.DefaultTitle)
    XCTAssertNil(cceSection.bodyText)
    cceSection.bodyText = CCESectionTests.DefaultBodyText
    XCTAssertNotNil(cceSection.bodyText)
    XCTAssertEqual(cceSection.bodyText, CCESectionTests.DefaultBodyText)

    cceSection = CCESection(
      title: CCESectionTests.DefaultTitle,
      bodyText: CCESectionTests.DefaultBodyText)
    XCTAssertNotNil(cceSection.bodyText)
    XCTAssertEqual(cceSection.bodyText, CCESectionTests.DefaultBodyText)
  }

  // The same for `attributedBodyText` and `iconName` properties.

}
