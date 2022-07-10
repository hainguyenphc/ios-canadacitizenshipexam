//
//  CCESection_Complex.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-01.
//

import Foundation

struct CCESection_Complex {

  var primaryTitleTexts: [String] = []
  var bodyTexts: [String] = []
  var iconNames: [String] = []

  init(primaryTitleTexts: [String], bodyTexts: [String], iconNames: [String]) {
    for each in primaryTitleTexts {
      self.primaryTitleTexts.append(each)
    }
    for each in bodyTexts {
      self.bodyTexts.append(each)
    }
    for each in iconNames {
      self.iconNames.append(each)
    }
  }

}
