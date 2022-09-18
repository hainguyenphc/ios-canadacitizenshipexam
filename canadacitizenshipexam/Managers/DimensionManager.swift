//
//  DimensionManager.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-09-18.
//

import UIKit

class DimensionManager {

  static let shared = DimensionManager()

  private init() {}

  func getTopEdgeInset() -> CGFloat {
    var top: CGFloat = 0.0
    switch (UIDevice.current.userInterfaceIdiom) {
      case .pad:
        top = 100
        break
      case .phone:
        top = 80
        break
      case .mac:
        break
      default:
        break
    }
    
    return top
  }

}
