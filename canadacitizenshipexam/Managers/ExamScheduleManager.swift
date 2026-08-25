//
//  ExamScheduleManager.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import Foundation

class ExamScheduleManager {

  // Singleton pattern.
  static let shared = ExamScheduleManager()

  static let examDateDefaultsKey = "scheduledExamDate"

  private init() {
    // Leaves empty.
  }

  // The user's own chosen exam date/time, if they've scheduled one. Date
  // bridges to NSDate, a property-list type, so UserDefaults stores it
  // directly — no need to round-trip through a TimeInterval by hand.
  var examDate: Date? {
    get { UserDefaults.standard.object(forKey: ExamScheduleManager.examDateDefaultsKey) as? Date }
    set { UserDefaults.standard.set(newValue, forKey: ExamScheduleManager.examDateDefaultsKey) }
  }

  // "Exam: Jan 15, 2027 at 9:00 AM"-style text once a date is set, or the
  // original call-to-action text otherwise — for display on the Home
  // screen's "Schedule your Exam" row, which carries no separate label of
  // its own.
  var examDateDisplayText: String {
    guard examDate != nil else {
      return "Schedule your Exam"
    }
    return "Exam: \(examDateValueText)"
  }

  // "Jan 15, 2027, 9:00 AM"-style value only (no leading label or "Exam:"
  // prefix), for the Settings screen's disclosure row, which already
  // carries its own "Exam Date" label alongside this value.
  var examDateValueText: String {
    guard let examDate = examDate else {
      return "Not Set"
    }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: examDate)
  }

}
