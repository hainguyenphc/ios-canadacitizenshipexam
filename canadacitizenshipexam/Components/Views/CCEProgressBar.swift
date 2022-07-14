//
//  CCEProgressBar.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-07-14.
//

import UIKit

// This annotation allows us to use this class in a storyboard.
@IBDesignable
class CCEProgressBar: UIView {

  // This annotation allows defining the property of this class's instance in a storyboard.
  @IBInspectable var color: UIColor? = .gray

  var progress: CGFloat = 0.5

  // override func draw(_ rect: CGRect) {
  //   self.backgroundColor?.setFill()
  //   UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).fill()
  // }

  override func draw(_ rect: CGRect) {
    let backgroundMask = CAShapeLayer()
    backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
    self.layer.mask = backgroundMask

    let progressLayer = CALayer()
    progressLayer.frame = CGRect(origin: .zero, size: CGSize(width: rect.width * self.progress, height: rect.height))
    progressLayer.backgroundColor = self.color?.cgColor
    self.layer.addSublayer(progressLayer)
  }

}
