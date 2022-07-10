import UIKit

// let x = 677341810
// let y = 677341710
// let diff = x - y
// print(diff)
// 
// func f(_ duration: Int) -> String {
//   var duration_ = duration
//   let hours = duration_ / 60
//   duration_ = duration_ - (60 * hours)
//   let minutes = duration_ % 60
//   if (minutes < 10) {
//     return "\(hours):0\(minutes)"
//   }
//   else {
//     return "\(hours):\(minutes)"
//   }
// }
// 
// print(f(96))

// var myString:NSString = "I AM KIRIT MODI"
// var myMutableString = NSMutableAttributedString()
//
// func viewDidLoad() {
//   myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
//   myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:2,length:4))
//     // set label Attribute
//   labName.attributedText = myMutableString
//   super.viewDidLoad()
// }
//
// myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:10,length:5))
//
//
// let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.green]
// let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.white]
// let attributedString1 = NSMutableAttributedString(string:"Drive", attributes:attrs1)
// let attributedString2 = NSMutableAttributedString(string:"safe", attributes:attrs2)
// attributedString1.append(attributedString2)
// self.lblText.attributedText = attributedString1

// extension String {
//   func split(usingRegex pattern: String) -> [String] {
//       //### Crashes when you pass invalid `pattern`
//     let regex = try! NSRegularExpression(pattern: pattern)
//     let matches = regex.matches(in: self, range: NSRange(0..<utf16.count))
//     let ranges = [startIndex..<startIndex] + matches.map{Range($0.range, in: self)!} + [endIndex..<endIndex]
//     return (0...matches.count).map {String(self[ranges[$0].upperBound..<ranges[$0+1].lowerBound])}
//   }
// }
//
// let regex = "[\n]+"
// var text = "Try Again\nRestart this test"
// // let tokens = text.components(separatedBy: "\n\n")
// let tokens = text.split(usingRegex: regex)
// print(tokens)

import FirebaseCore
import FirebaseFirestore

FirebaseApp.configure()
let firestore = Firestore.firestore()

class Seeder {

  static func seedTests() {
    let tests = firestore.collection(CCECollections.tests)
    let test: [String: Any] = [
      "communityAverageScore": 0,
      "name": "Sample Free Test",
      "totalSubmissions": 0,
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
    // set()
    tests.document("\(UUID().uuidString)").setData(test)
  }

  static func addUsersTests() {
    let users_tests = firestore.collection(CCECollections.Users_Data)
    let userID = "lHdC3431nTam8dYERQzOABDT42x1"
    let finishedTests: [String] = [
      "A0D1E030-D738-4370-86D1-ADF408955CA5",
    ]
    let readChapters: [String] = []
    let data: [String: Any] = [
      "finishedTests": finishedTests,
      "readChapters": readChapters,
    ]
    users_tests.document(userID).setData(data)
  }

  static func updateUsersTests() {
    let users_tests = firestore.collection(CCECollections.Users_Data)
    let userID = "lHdC3431nTam8dYERQzOABDT42x1"
    let user_test = users_tests.document(userID)
    let fields: [String:Any] = [
      "readChapters": [
        "lpJCc2DZnfkxZycUgjxh"
      ]
    ]
    user_test.updateData(fields) { error in
      print(error)
    }
  }

  static func getUsersTests() {
    let users_tests = firestore.collection(CCECollections.Users_Data)
    users_tests
      .whereField("userID", isEqualTo: "lHdC3431nTam8dYERQzOABDT42x1")
      .getDocuments { querySnapshot, error in
        if let err = error {
          print("Error getting documents: \(err)")
        } else {
          for document in querySnapshot!.documents {
            print("\(document.documentID) => \(document.data())")
          }
        }
      }
  }

}

// Seeder.seedTests()
// Seeder.addUsersTests()
// Seeder.updateUsersTests()
// Seeder.getUsersTests()
for i in 0..<6 {
  print(UUID().uuidString)
  print("\n")
}
print("hello")

/*
let testCollection = firestore.collection("questions")
let testID = "pEqRZfnX9rKX4LFcOzsS"
let test = testCollection.document(testID)
test.getDocument { documentSnapshot, error in
  if error != nil {
    print("Error getting Test document \(testID): \(error?.localizedDescription)")
    return
  }
  guard let data = documentSnapshot?.data() else {
    print("Error parsing Test document \(testID): \(error?.localizedDescription)")
    return
  }
  guard let questions = data["questions"] as? NSMutableArray else {
    print("Error accessing \"questions\" key of data.")
    return
  }

  if let question1 = questions[0] as? NSMutableDictionary {
    // Alters the question label.
    if var answers = question1["answers"] as? [String] {
      answers[0] = "-1"
      (questions[0] as? NSMutableDictionary)?["answers"] = answers
    }
    // Alters the stats
    if let stats = question1["stats"] as? NSMutableDictionary {
      if var countA = stats["countA"] as? Int  {
        countA += 1
        stats["countA"] = countA
      }
    }
    //
    // let fields: [String:Any] = [
    //   "questions": questions
    // ]
    // test.updateData(fields) { error in
    // }
  }

  let newQuestion: [String:Any] = [
    "answers": ["unsalted", "peanuts", "arachides", "sans sel"],
    "correctAnswer": "peanuts",
    "explanation": "lorem ipsum",
    "isMultipleChoice": true,
    "question": "have you ever solved this?",
    "stats": [
      "countA": 101,
      "countB": 102,
      "countC": 103,
      "countD": 104,
    ]
  ]
  questions.add(newQuestion)
  
  let fields: [String:Any] = [
    "questions": questions
  ]
  test.updateData(fields) { error in
  }
}
*/

