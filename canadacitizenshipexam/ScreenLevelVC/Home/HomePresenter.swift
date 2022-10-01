//
//  HomePresenter.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-10-01.
//

import UIKit
import FirebaseAuth

typealias UsersData = (CCEUsersData) -> Void

protocol HomePresenterProtocol {

  func loadProgress(finished: @escaping UsersData) -> Void

  func registerAppointment(_ appointment: Date) -> Void

}

class HomePresenterImpl: HomePresenterProtocol {

  func loadProgress(finished: @escaping UsersData) -> Void {
    guard let userID = Auth.auth().currentUser?.uid else {
      return
    }
    NetworkManager.shared.getUsersData(userID: userID) { result in
      switch (result) {
        case .success(let usersData):
          finished(usersData)
        case .failure(let error):
          print(error)
      } // end switch
    } // end closure
  }

  /* Users picked a date time to start practicing. */
  func registerAppointment(_ appointment: Date) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [
      .alert,
      .badge,
      .sound
    ]) { granted, error in
      // code
    }
    let content = UNMutableNotificationContent()
    content.title = "Practice Reminder"
    content.body = "You booked a pratice session."
    let dateComponents = Calendar.current.dateComponents([
      .year,
      .month,
      .day,
      .hour,
      .minute,
      .second
    ], from: appointment) // let date = Date().addingTimeInterval(15)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    center.add(request) { error in
      // @TODO: handle errors
    }
  }

}
