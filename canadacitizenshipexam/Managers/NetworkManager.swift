//
//  NetworkManager.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class NetworkManager {

  // TODO: query an API endpoint as an alternative for Firebase?
  private let BaseUrl = ""

  private let firestore = Firestore.firestore()

  // Singleton pattern.
  static let shared = NetworkManager()
  static let cache = NSCache<NSString, CCEUsersData>()

  private init() {
    // Leaves empty.
  }

  /* Fetches all online tests. */
  func getTests(completed: @escaping(Result<[CCETest], CCEError>) -> Void) {
    let tests = firestore.collection(CCECollections.tests)
    tests.getDocuments { querySnapshot, error in
      if let err = error {
        print("Error getting documents: \(err)")
      }
      else {
      var cceTests = [CCETest]()
        for document in querySnapshot!.documents {
          let data = document.data()
          guard let name = data["name"] as? String else {
            completed(.failure(.nameMissingFailure))
            return
          }
          guard let questions = data["questions"] as? NSMutableArray else {
            completed(.failure(.questionsMissingFailure))
            return
          }
          guard let communityAverageScore = data["communityAverageScore"] as? Int else {
            completed(.failure(.communityAverageScoreMissingFailure))
            return
          }
          guard let totalSubmissions = data["totalSubmissions"] as? Int else {
            completed(.failure(.totalSubmissionsMissingFailure))
            return
          }
          var cceTest = CCETest()
          cceTest.id = document.documentID
          cceTest.name = name
          cceTest.questions = []
          cceTest.communityAverageScore = communityAverageScore
          cceTest.totalSubmissions = totalSubmissions
          // (total - 1) is to adjust for 0-based indexing.
          for counter in 0...(questions.count - 1) {
            if let questionObject = questions[counter] as? NSDictionary {
                // The whole answer label. E.g., "Lake Erie".
              let correctAnswer = questionObject["correctAnswer"] as! String
              let explanation = questionObject["explanation"] as! String
              let isMultipleChoice = questionObject["isMultipleChoice"] as! Bool
              let questionLabel = questionObject["question"] as! String
              // An array of answer labels.
              let answerLabels = questionObject["answers"] as! [String]
              let stats = questionObject["stats"] as! [String:Int?]
              // Constructs CCEQuestion object.
              let cceQuestion = CCEQuestion(
                answers: answerLabels,
                name: name,
                correctAnswer: correctAnswer,
                isMultipleChoice: isMultipleChoice,
                explanation: explanation,
                question: questionLabel,
                stats: stats
              )
                // Appends the CCEQuestion object to the CCETest's questions.
              cceTest.questions.append(cceQuestion)
            }
          } // end for counter in 0...(total - 1)
          cceTests.append(cceTest)
        } // end for document in querySnapshot!.documents
        completed(.success(cceTests))
      }
    }
  }

  /* Gets a test by a given test ID. */
  func getTest(with testID: String, completed: @escaping(Result<CCETest, CCEError>) -> Void) {
    let test = firestore.collection(CCECollections.tests).document(testID)
    test.getDocument() { document, error in
      if error != nil {
        completed(.failure(.getTestByIdFailure))
        return
      }
      guard let data = document?.data() else {
        completed(.failure(.parseTestDataFailure))
        return
      }
      guard let name = data["name"] as? String else {
        completed(.failure(.nameMissingFailure))
        return
      }
      guard let questions = data["questions"] as? NSMutableArray else {
        completed(.failure(.questionsMissingFailure))
        return
      }
      guard let communityAverageScore = data["communityAverageScore"] as? Int else {
        completed(.failure(.communityAverageScoreMissingFailure))
        return
      }
      guard let totalSubmissions = data["totalSubmissions"] as? Int else {
        completed(.failure(.totalSubmissionsMissingFailure))
        return
      }
      var cceTest = CCETest()
      cceTest.id = testID
      cceTest.name = name
      cceTest.totalSubmissions = totalSubmissions
      cceTest.communityAverageScore = communityAverageScore
      // (total - 1) is to adjust for 0-based indexing.
      for counter in 0...(questions.count - 1) {
        if let questionObject = questions[counter] as? NSDictionary {
          // The whole answer label. E.g., "Lake Erie".
          let correctAnswer = questionObject["correctAnswer"] as! String
          let explanation = questionObject["explanation"] as! String
          let isMultipleChoice = questionObject["isMultipleChoice"] as! Bool
          let questionLabel = questionObject["question"] as! String
          // An array of answer labels.
          let answerLabels = questionObject["answers"] as! [String]
          let stats = questionObject["stats"] as! [String:Int?]
          // Constructs CCEQuestion object.
          let cceQuestion = CCEQuestion(
            answers: answerLabels,
            correctAnswer: correctAnswer,
            isMultipleChoice: isMultipleChoice,
            explanation: explanation,
            question: questionLabel,
            stats: stats
          )
          // Appends the CCEQuestion object to the CCETest's questions.
          cceTest.questions.append(cceQuestion)
        }
      } // end for
      // Successfully populates the questions for the test.
      if (cceTest.questions.count > 0) {
        completed(.success(cceTest))
      }
      else {
        completed(.failure(.questionsMissingFailure))
      }
    }
  }

  /* Updates a test by a given test ID. */
  func updateTest(with testID: String, fields: [AnyHashable: Any]) -> Void {
    firestore.collection(CCECollections.tests)
      .document(testID)
      .updateData(fields) { error in
      if let error = error {
        print("Error updating test: \(error)")
      }
      else {
        print("Document successfully updated")
      }
    }
  }

  // ===========================================================================
  // USER-SPECIFIC
  // ===========================================================================

  func removedCachedUsersData(userID: String) {
    NetworkManager.cache.removeObject(forKey: userID as NSString)
  }

  func cacheUsersData(userID: String) {
    firestore.collection(CCECollections.Users_Data)
      .document(userID)
      .getDocument(source: .server) { (documentSnapshot, error) in
        if let documentSnapshot = documentSnapshot {
          if let data = documentSnapshot.data() {
            let cceUsersData = CCEUsersData()
            guard let readChapters = data["readChapters"] as? [String] else {
              return
            }
            guard let finishedTests = data["finishedTests"] as? [String] else {
              return
            }
            cceUsersData.readChapters = readChapters
            cceUsersData.finishedTests = finishedTests
            NetworkManager.cache.setObject(cceUsersData, forKey: userID as NSString)
          }
          else {
            self.firestore.collection(CCECollections.Users_Data)
              .document(userID)
              .setData([
                "finishedTests": [],
                "readChapters": [],
              ])
            let cceUsersData = CCEUsersData()
            cceUsersData.readChapters = []
            cceUsersData.finishedTests = []
            NetworkManager.cache.setObject(cceUsersData, forKey: userID as NSString)
          }
        }
        else {
          //TODO: handle error
          print("Document does not exist in cache")
        }
      }
  }

  func getUsersData(userID: String) -> CCEUsersData? {
    let usersData = NetworkManager.cache.object(forKey: userID as NSString)
    return usersData
  }

  func updateUsersData(userID: String, fields: [AnyHashable: Any]) {
    firestore.collection(CCECollections.Users_Data)
      .document(userID)
      .updateData(fields) { error in
        if let error = error {
          print("Error adding a test to \(CCECollections.tests) collection.")
          print(error.localizedDescription)
        }
        else {
          print("Successfully added test(s) to \(CCECollections.tests) collection.")
        }
      }
  }

}
