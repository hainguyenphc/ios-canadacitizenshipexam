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

  func getAllTestsAverageScores(userID: String, completed: @escaping(Result<CCEProgressReport, CCEFailure>) -> Void) {
    firestore.collection(CCECollections.Users_Data)
      .getDocuments { querySnapshot, error in
        if error != nil {
          completed(.failure(.getTestByIdFailure))
          return
        }
        var progressReport = CCEProgressReport()
        var scores = [Int]()
        for document in querySnapshot!.documents{
          let data = document.data()
          guard let readChapters = data["readChapters"] as? [String] else {
            completed(.failure(.readChaptersMissingFailure))
            return
          }
          guard let finishedTests = data["finishedTests"] as? [NSDictionary] else {
            completed(.failure(.finishedTestsMissingFailure))
            return
          }
          for (_, finishedTest) in finishedTests.enumerated() {
            let score = finishedTest["score"] as! Int
            scores.append(score)
          } // end inner for
          progressReport.scores = scores
          progressReport.numberOfFinishedTests = finishedTests.count
          progressReport.numberOfReadChapters = readChapters.count
        } // end outer for
        completed(.success(progressReport))
      }
  }

}
