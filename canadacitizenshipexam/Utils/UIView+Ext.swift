//
//  UIView+Ext.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-05-01.
//

import UIKit

extension UIView {

  func pin(to superview: UIView) {
    translatesAutoresizingMaskIntoConstraints                             = false
    topAnchor.constraint(equalTo: superview.topAnchor).isActive           = true
    leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive   = true
    trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive     = true
  }

}
