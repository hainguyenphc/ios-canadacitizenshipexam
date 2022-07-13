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

  /* Updates the user profile to acknowledge that he has read this chapter. */
  func updateReadChaptersOnServer() -> Void {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }
    // Loads the logged in user data from cache.
    NetworkManager.shared.getUsersData(userID: userID) { [weak self] result in
      guard let self = self else { return }
      switch (result) {
        case .success(let usersData):
          let chapterID = Chapters.storage[self.chapterIndex]["id"]!
          // Checks if this is a chapter user has read before.
          let redoTest = usersData.readChapters.contains(chapterID)
          // Only if this is a fresh new chapter (1st time user visits it), updates
          // the list of read chapters for user.
          if (!redoTest) {
            usersData.readChapters.append(chapterID)
            let fields: [String: Any] = [
              "readChapters": usersData.readChapters!
            ]
            NetworkManager.shared.updateUsersData(
              userID: userID,
              fields: fields
            )
          }
        case .failure(let error):
          print(error)
      } // end switch
    } // end closure
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  /* Handles the content for the whole chapter. */
  func configureTextView() -> Void {
    self.textView.isEditable = false
    self.textView.contentInsetAdjustmentBehavior = .automatic
    self.textView.center = self.view.center
    self.textView.textAlignment = .justified
    self.textView.textColor = .label
    self.textView.showsVerticalScrollIndicator = false
    self.textView.showsHorizontalScrollIndicator = false
    self.textView.font = .systemFont(ofSize: 15)
    self.textView.backgroundColor = .systemBackground
    self.textView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.textView)

    // E.g., "/Users/admin/Library/Developer/CoreSimulator/Devices/B2E4BFBC-8542-4CE5-8690-6C41CA12687A/data/Containers/Bundle/Application/C7B563D6-85F1-49BF-8F21-A60EDE981A2A/canadacitizenshipexam.app/en.lproj/947E5DF8-A14D-4A59-BA4E-CBC5BC1F5F6F.txt"
    let path = Bundle.main.path(forResource: Chapters.storage[chapterIndex]["id"], ofType: "txt")
    do {
      let content = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
      self.textView.text = content
    }
    catch {
      //TODO: handle error
      self.textView.text = CCEErrorMessage.chapterLoadingFailure
    }

  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
