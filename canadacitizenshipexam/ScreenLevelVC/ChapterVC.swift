//
//  ChapterVC.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-30.
//

import UIKit
import FirebaseAuth

class ChapterVC: UIViewController {

  // ===========================================================================
  // Logic variables
  // ===========================================================================

  var chapterIndex: Int! = 0

  var isChapterRead: Bool! = false

  // ===========================================================================
   // UI variables
   // ===========================================================================

  var textView: UITextView! = UITextView(
    frame: CGRect(x: 10.0, y: 90.0, width: 350.0, height: 750.0))

  // ===========================================================================
  // Initializer
  // ===========================================================================

  init(chapterIndex: Int, isChapterRead: Bool = false) {
    super.init(nibName: nil, bundle: nil)
    self.chapterIndex = chapterIndex
    self.isChapterRead = isChapterRead
  }

  // ===========================================================================
  // Lifecycle methods
  // ===========================================================================

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = Chapters.storage[self.chapterIndex]["title"]!
    self.configureTextView()
    self.updateReadChaptersOnServer()
  }

  // ===========================================================================
  // Helper functions
  // ===========================================================================

  func updateReadChaptersOnServer() {
    if let userID = Auth.auth().currentUser?.uid {
      // Loads the logged in user data from cache.
      let usersData = NetworkManager.shared.getUsersData(userID: userID)
      let chapterID = Chapters.storage[self.chapterIndex]["id"]!
      // Checks if this is a chapter user has read before.
      let redoTest = usersData?.readChapters.contains(chapterID) ?? false
      // Only if this is a fresh new chapter (1st time user visits it), updates
      // the list of read chapters for user.
      if (!redoTest) {
        usersData?.readChapters.append(chapterID)
        let fields: [String: Any] = [
          "readChapters": usersData?.readChapters ?? []
        ]
        NetworkManager.shared.updateUsersData(
          userID: userID,
          fields: fields
        )
      }
    }
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureTextView() {
    self.textView.contentInsetAdjustmentBehavior = .automatic
    self.textView.center = self.view.center
    self.textView.textAlignment = .justified
    self.textView.textColor = .label
    self.textView.showsVerticalScrollIndicator = false
    self.textView.showsHorizontalScrollIndicator = false
    self.textView.font = .systemFont(ofSize: 20)
    self.textView.backgroundColor = .systemBackground
    self.textView.text = Chapters.storage[self.chapterIndex]["content"]!

    self.textView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(self.textView)
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
