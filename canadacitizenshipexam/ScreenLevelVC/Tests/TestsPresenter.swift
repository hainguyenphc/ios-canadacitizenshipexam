//
//  TestsPresenter.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-10-01.
//

import Foundation

typealias CallbackWithTests = ([CCETest]) -> Void

protocol TestsPresenter {

  func loadTests(finished: @escaping CallbackWithTests) -> Void

}

class TestsPresenterImpl: TestsPresenter {

  func loadTests(finished: @escaping CallbackWithTests) -> Void {
    NetworkManager.shared.getTests { [weak self] result in
      switch (result) {
        case .success(let cceTests):
          finished(cceTests)
        case .failure(let error):
        // TODO: properly handle error - a modal?
        print(error)
      } // end switch
    } // end closure
  } // end function

}
