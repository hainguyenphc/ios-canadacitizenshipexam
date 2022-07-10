//
//  CCECircularProgressLabel.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class CCECircularProgressLabel: UIView {

  // ===========================================================================
  // UI variables
  // ===========================================================================

  var roundView: UIView!
  var progressLabel: CCELevelTwoTitleLabel!

  // ===========================================================================
  // Logic variables
  // ===========================================================================
  
  var progress: Float = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  init(completed completionPercent: Float) {
    super.init(frame: .zero)
    self.progress = completionPercent
    self.configureUI()
  }

  // ===========================================================================
  // UI configurations, constraints, etc.
  // ===========================================================================

  func configureUI() -> Void {
    self.progressLabel = CCELevelTwoTitleLabel(
      text: "\(Int(self.progress))%",
      textAlignment: .center
    )
    self.roundView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    self.roundView.backgroundColor    = UIColor.brown
    self.roundView.layer.cornerRadius = self.roundView.frame.size.width / 2
    let arcCenter = CGPoint (
      x: self.roundView.frame.size.width / 2,
      y: self.roundView.frame.size.height / 2
    )
    let circlePath = UIBezierPath(
      arcCenter: arcCenter,
      radius: self.roundView.frame.size.width / 2,
      startAngle: CGFloat(-0.5 * .pi),
      endAngle: CGFloat(1.5 * .pi),
      clockwise: true
    )

    let circleShape                   = CAShapeLayer()
    circleShape.path                  = circlePath.cgPath
    circleShape.strokeColor           = UIColor.red.cgColor
    circleShape.fillColor             = UIColor.white.cgColor
    circleShape.lineWidth             = 5
    circleShape.strokeStart           = 0.0
    // Tweak `strokeEnd` to the target percent.
    circleShape.strokeEnd             = CGFloat(self.progress / 100)
    self.roundView.layer.addSublayer(circleShape)

    // The order we add those subviews is important.f
    self.addSubview(self.roundView)
    self.addSubview(self.progressLabel)

    NSLayoutConstraint.activate([
      // Constraints the label.
      self.progressLabel.topAnchor.constraint(
        equalTo: self.topAnchor, constant: 24),
      self.progressLabel.leadingAnchor.constraint(
        equalTo: self.leadingAnchor, constant: 10),
      self.progressLabel.trailingAnchor.constraint(
        equalTo: self.trailingAnchor, constant: -10),
      // constraints the circle.
      self.roundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.roundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
    ])
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
