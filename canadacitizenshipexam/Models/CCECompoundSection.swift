//
//  CCESection_Complex.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-01.
//

import Foundation

struct CCECompoundSection {

  var titles = [String]()
  var bodyTexts = [String]()
  var iconNames = [String]()

  init(titles: [String], bodyTexts: [String], iconNames: [String]) {
    if (titles.count == bodyTexts.count && bodyTexts.count == iconNames.count) {
      for each in titles {
        self.titles.append(each)
      }
      for each in bodyTexts {
        self.bodyTexts.append(each)
      }
      for each in iconNames {
        self.iconNames.append(each)
      }
    }
    else {
      fatalError(CCEErrorMessage.cceCompoundSectionArraysSizesMismatchFailure)
    }
  }

}
