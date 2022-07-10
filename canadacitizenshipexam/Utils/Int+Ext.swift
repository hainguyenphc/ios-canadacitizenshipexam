//
//  Float+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-06-19.
//

import Foundation

extension Int {

  func convertToHumanReadableTimeInterval() -> String {
    var duration = self.magnitude
    let hours = duration / 60
    duration = duration - (60 * hours)
    let minutes = duration % 60
    return (minutes < 10) ? "\(hours):0\(minutes)" : "\(hours):\(minutes)"
  }

}
