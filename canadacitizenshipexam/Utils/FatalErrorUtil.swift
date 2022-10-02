//
//  FatalErrorUtil.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-13.
//

import Foundation

struct FatalErrorUtil {

  private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

  static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

  static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
    fatalErrorClosure = closure
  }

  static func restoreFatalError() {
    fatalErrorClosure = defaultFatalErrorClosure
  }

}

/* Overrides the default `fatalError` function. */
public func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
  FatalErrorUtil.fatalErrorClosure(message(), file, line)
}
