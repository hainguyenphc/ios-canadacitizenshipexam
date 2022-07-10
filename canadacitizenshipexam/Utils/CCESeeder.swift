//
//  CCESeeder.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-30.
//

import FirebaseCore
import FirebaseFirestore



class Seeder {

  /* Calls `Seeder.seedTests()` to populate the tests. */
  static func seedTests() {
    FirebaseApp.configure()
    let firestore = Firestore.firestore()
    print("Seeding data...")
    let tests = firestore.collection(CCECollections.tests)
    // Feel free to add more tests.
    let test: [String: Any] = [
      "communityAverageScore": 0,
      "name": "Sample Free Test",
      "totalSubmissions": 0,
      // Feel free to add more questions.
      "questions": [
        [
          "answers": [
            "1989",
            "1999",
            "2001",
            "2000"
          ],
          "correctAnswer": "1999",
          "explanation": "Nunavut became a territory in 1999.",
          "isMultipleChoice": true,
          "question": "When did Nunavut become a territory?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ],
        [
          "answers": [
            "Lake Erie",
            "Lake Ontario",
            "Lake Superior",
            "Lake Huron"
          ],
          "correctAnswer": "Lake Superior",
          "explanation": "Lake Superior is the world's largest fresh water lake by surface area, and the third largest freshwater lake by volume.",
          "isMultipleChoice": true,
          "question": "Which of the Great Lakes is the largest freshwater lake in the world?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ],
        [
          "answers": [
            "Nunavut",
            "Yukon",
            "Northwest Territories",
            "Alberta"
          ],
          "correctAnswer": "Yukon",
          "explanation": "Yukon holds the record for the coldest temperature ever recorded in Canada (-63C in the village of Snag, in 1947).",
          "isMultipleChoice": true,
          "question": "Where was the coldest temperature ever in Canada (-63C) recorded?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ]
      ] // end of "questions"
    ] // end of test
    tests.addDocument(data: test) { error in
      if let error = error {
        print("Error adding a test to \(CCECollections.tests) collection.")
        print(error.localizedDescription)
      }
      else {
        print("Successfully added test(s) to \(CCECollections.tests) collection.")
      }
    }
  }

  static func addUsersTests(test: CCETest) {
    FirebaseApp.configure()
    let firestore = Firestore.firestore()
    let test: [String: Any] = [
      "communityAverageScore": 0,
      "name": "Sample Free Test",
      "totalSubmissions": 0,
      // Feel free to add more questions.
      "questions": [
        [
          "answers": [
            "1989",
            "1999",
            "2001",
            "2000"
          ],
          "correctAnswer": "1999",
          "explanation": "Nunavut became a territory in 1999.",
          "isMultipleChoice": true,
          "question": "When did Nunavut become a territory?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ],
        [
          "answers": [
            "Lake Erie",
            "Lake Ontario",
            "Lake Superior",
            "Lake Huron"
          ],
          "correctAnswer": "Lake Superior",
          "explanation": "Lake Superior is the world's largest fresh water lake by surface area, and the third largest freshwater lake by volume.",
          "isMultipleChoice": true,
          "question": "Which of the Great Lakes is the largest freshwater lake in the world?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ],
        [
          "answers": [
            "Nunavut",
            "Yukon",
            "Northwest Territories",
            "Alberta"
          ],
          "correctAnswer": "Yukon",
          "explanation": "Yukon holds the record for the coldest temperature ever recorded in Canada (-63C in the village of Snag, in 1947).",
          "isMultipleChoice": true,
          "question": "Where was the coldest temperature ever in Canada (-63C) recorded?",
          "stats": [
            "countA": 0,
            "countB": 0,
            "countC": 0,
            "countD": 0,
          ]
        ]
      ] // end of "questions"
    ] // end of test
    // firestore.collection(CCECollections.Users_Tests)
    //   .document("7j9hiGPcpRCLU7KeJXUY")
    //   .collection(CCECollections.tests)
    //   .addDocument(data: test)
  }

  static func seedChapters() {
    
  }

}
