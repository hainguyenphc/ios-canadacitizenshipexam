//
//  CCEChapter.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-12.
//

import Foundation

struct CCEChapter: Codable {

  var id: String!

  var title: String!

  init() {
    self.id = ""
    self.title = ""
  }

  init (title: String) {
    self.title = title
  }

}
