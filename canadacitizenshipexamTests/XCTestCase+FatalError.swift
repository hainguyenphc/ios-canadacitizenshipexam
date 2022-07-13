  //
  //  XCTestCase+FatalError.swift
  //  canadacitizenshipexamTests
  //
  //  Created by hainguyen on 2022-07-13.
  //

import Foundation
import XCTest

// See FatalErrorUtil.swift file
@testable import canadacitizenshipexam
extension XCTestCase {

  private func unreachable() -> Never {
    repeat {
      RunLoop.current.run()
    } while (true)
  }

  func expectFatalError(expectedMessage: String, testCase: @escaping() -> Void) {
    let expectation = self.expectation(description: "expectingFatalError")
    var assertionMessage: String? = nil

    FatalErrorUtil.replaceFatalError { message, _, _ in
      assertionMessage = message
      expectation.fulfill()
      self.unreachable()
    }

    DispatchQueue.global(qos: .userInitiated).async(execute: testCase)

    waitForExpectations(timeout: 2) { _ in
      XCTAssertEqual(assertionMessage, expectedMessage)
      FatalErrorUtil.restoreFatalError()
    }
  }

}
