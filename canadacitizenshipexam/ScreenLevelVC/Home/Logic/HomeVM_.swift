//
//  HomeVM_.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-28.
//

import Foundation
import FirebaseAuth

protocol HomeVMDelegate {

  /*
   Loads practice progress from server.
   */
  func loadPracticeProgress()

  /*
   Check if user is logged in.
   */
  func checkAuthorization()

}

class HomeVM_: HomeVMDelegate {

  var delegate: HomeVCDelegate?

  func loadPracticeProgress() {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }

    NetworkManager.shared.getUsersData(userID: userID) { result in
      switch (result) {
        case .success(let usersData):
          self.delegate?.handleSuccessLoadingUsersDataFromNetworkCall(usersData: usersData)
        case .failure(let error):
          self.delegate?.handleErrorLoadingUsersDataFromNetworkCall(error: error)
      }
    }
  }

  func checkAuthorization() {
    guard let _ = Auth.auth().currentUser else {
      if let delegate = delegate {
        (delegate as! HomeVC_)
          .navigationController?
          .pushViewController(RegisterVC(), animated: true)
      }
      return
    }
  }

}
