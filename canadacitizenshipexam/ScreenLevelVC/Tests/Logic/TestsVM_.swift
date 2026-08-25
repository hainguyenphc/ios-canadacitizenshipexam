//
//  TestsVM_.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import Foundation

class TestsVM_ {

  // Fetches every test currently published to Firestore's "Tests"
  // collection — nothing here is bundled/static, so the Tests screen
  // always reflects whatever is actually in the collection right now.
  // Failures are logged and surfaced as an empty list rather than
  // propagated, so the Tests screen has just one case to render for
  // "nothing to show" (no tests yet, or the fetch failed) instead of two.
  func loadTests(completion: @escaping ([CCETest]) -> Void) {
    NetworkManager.shared.getTests { result in
      switch result {
        case .success(let tests):
          completion(tests)
        case .failure(let error):
          print("TestsVM_: error loading tests: \(error)")
          completion([])
      }
    }
  }

}
