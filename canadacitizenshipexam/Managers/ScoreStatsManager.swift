//
//  ScoreStatsManager.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-14.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class ScoreStatsManager {

  private let firestore = Firestore.firestore()

  // Singleton pattern.
  static let shared = ScoreStatsManager()

  private init() {
    // Leaves empty.
  }

  func getLastTestScore(userID: String, completed: @escaping(Result<Int, CCEFailure>) -> Void) {
    firestore.collection(CCECollections.Users_Data)
      .document(userID)
      .getDocument { document, error in
        if error != nil {
          completed(.failure(.getTestByIdFailure))
          return
        }
        guard let data = document?.data() else {
          completed(.failure(.parseTestDataFailure))
          return
        }
        guard let finishedTestsRawArray = data["finishedTests"] as? [NSDictionary] else {
          completed(.failure(.nameMissingFailure))
          return
        }
        if (finishedTestsRawArray.isEmpty) {
          completed(.success(0))
        }
        else {
          var finishedTests = [CCEFinishedTest]()
          for (_, each) in finishedTestsRawArray.enumerated() {
            let testID = each["testID"] as? String
            let score = each["score"] as? Float
            let timestamp = each["timestamp"] as? Date
            finishedTests.append(CCEFinishedTest(testID: testID, score: score, timestamp: timestamp))
          }
          let sortedFinishedTests = finishedTests.sorted()
          completed(.success(Int(sortedFinishedTests[0].score)))
        }
      }
  }

  func getLastFiveTestsAverageScore() -> Int {
    return 100
  }

  func getLastTenTestsAverageScore() -> Int {
    return 100
  }

  func getLastAllTestsAverageScore() -> Int {
    return 100
  }

}
