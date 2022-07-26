//
//  CCESeeder.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-30.
//

import FirebaseCore
import FirebaseFirestore

class Seeder {

  static func seedTestsV2() {
    if let path = Bundle.main.path(forResource: "tests", ofType: "json") {
      do {
        let data = try Data(
          contentsOf: URL(fileURLWithPath: path),
          options: .mappedIfSafe)
        let tests = try JSONDecoder().decode([CCETest].self, from: data)
        NetworkManager.shared.addTests(tests: tests)
      }
      catch {
        print(error)
      }
    }
  }

}
