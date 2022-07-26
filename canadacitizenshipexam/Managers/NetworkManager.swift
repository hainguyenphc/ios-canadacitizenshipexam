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

  private let firestore = Firestore.firestore()

  // Singleton pattern.
  static let shared = NetworkManager()

  private init() {
    // Leaves empty.
  }

  func addTests(tests: [CCETest]) {
    for test in tests {
      var questions = [[String: Any]]()
      for each in test.questions {
        let answers = each.answers
        let correctAnswer = each.correctAnswer
        let explanation = each.explanation
        let isMultipleChoice = each.isMultipleChoice
        let questionString = each.question
        var stats = [String: Any]()
        for (_, stat) in each.stats.enumerated() {
          stats[stat.key] = stat.value
        }
        let question: [String: Any] = [
          "answers": answers!,
          "correctAnswer": correctAnswer!,
          "explanation": explanation!,
          "isMultipleChoice": isMultipleChoice!,
          "question": questionString!,
          "stats": stats
        ]
        questions.append(question)
      }
      let data: [String: Any] = [
        "communityAverageScore": test.communityAverageScore!,
        "name": test.name!,
        "totalSubmissions": test.totalSubmissions!,
        "questions": questions
      ]
      firestore.collection(CCECollections.tests)
        .document(UUID().uuidString)
        .setData(data) { error in
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

  /* Fetches all online tests. */
  func getTests(completed: @escaping(Result<[CCETest], CCEFailure>) -> Void) {
    firestore.collection(CCECollections.tests)
      .getDocuments { querySnapshot, error in
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
          var cceTest = CCETest(
            id: document.documentID,
            name: name,
            questions: [],
            timeOnTest: 0,
            totalSubmissions: totalSubmissions,
            communityAverageScore: communityAverageScore)
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
          } // end for counter in 0...(total - 1)
          cceTests.append(cceTest)
        } // end for document in querySnapshot!.documents
        completed(.success(cceTests))
      }
    }
  }

  /* Gets a test by a given test ID. */
  func getTest(with testID: String, completed: @escaping(Result<CCETest, CCEFailure>) -> Void) {
    firestore.collection(CCECollections.tests)
      .document(testID)
      .getDocument() { document, error in
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
      var cceTest = CCETest(
        id: testID,
        name: name,
        questions: [],
        timeOnTest: 0,
        totalSubmissions: totalSubmissions,
        communityAverageScore: communityAverageScore)
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

  func generateUsersDataOnServerIfNil(userID: String) {
    firestore.collection(CCECollections.Users_Data)
      .document(userID)
      .getDocument(source: .server) { (documentSnapshot, error) in
        if let documentSnapshot = documentSnapshot {
          guard let _ = documentSnapshot.data() else {
            self.firestore.collection(CCECollections.Users_Data)
              .document(userID)
              .setData([
                "finishedTests": [],
                "readChapters": [],
              ])
            return
          }
        }
        else {
          //TODO: handle error
          print("Document does not exist in cache")
        }
      }
  }

  func getUsersData(userID: String, completed: @escaping(Result<CCEUsersData, CCEFailure>) -> Void) {
    let usersData = firestore.collection(CCECollections.Users_Data).document(userID)
    usersData.getDocument() { document, error in
      if error != nil {
        completed(.failure(.getTestByIdFailure))
        return
      }
      guard let data = document?.data() else {
        completed(.success(CCEUsersData()))
        return
      }
      guard let finishedTestsRawArray = data["finishedTests"] as? [NSDictionary] else {
        completed(.failure(.parseUsersDataFailure))
        return
      }
      guard let readChapters = data["readChapters"] as? [String] else {
        completed(.failure(.parseUsersDataFailure))
        return
      }
      var finishedTests = [CCEFinishedTest]()
      for (_, each) in finishedTestsRawArray.enumerated() {
        let testID = each["testID"] as? String
        let score = each["score"] as? Float
        let timestamp = each["timestamp"] as? Date
        finishedTests.append(CCEFinishedTest(testID: testID, score: score, timestamp: timestamp))
      }
      completed(.success(CCEUsersData(finishedTests: finishedTests, readChapters: readChapters)))
    }
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
