//
//  CardProtocol.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

protocol CardProtocol {

  var theView: UIView? {get set}

  var theHeight: CGFloat? {get set}

  func build(scrollView: UIScrollView, previous: UIView?) -> CardProtocol?

}
