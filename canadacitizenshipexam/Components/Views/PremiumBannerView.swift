//
//  PremiumBannerView.swift
//  canadacitizenshipexam
//

import UIKit

// The "Unlock All Premium Features" banner shown across Home, Progress,
// Tests, Book, and Settings — previously duplicated nearly byte-for-byte
// as each of those 5 screens' own buildTheUnlockPremiumFeatureView()
// implementation. UnlockPremiumFeatureProtocol's default implementation
// (see StickyHeadingProtocol.swift) is the only remaining caller of this.
class PremiumBannerView: UIView {

  private let label = UILabel()
  private let button = UIButton()

  var onDetailsTapped: (() -> Void)?

  // `hostView` is the presenting screen's own root view — purely so this
  // banner's label/button can be positioned against ITS safeAreaLayoutGuide,
  // exactly as the original 5 copies did. This banner itself is
  // intentionally 2x the screen's width, offset half off-screen to the
  // left (see the constraints below), so its own leading/trailing edges
  // aren't a usable positioning anchor for its own content — reaching out
  // to the host's safe area is what the original implementation did, kept
  // as-is here rather than reworked, to avoid any visual regression across
  // 5 screens this refactor otherwise touches.
  init(hostView: UIView) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1

    let multiplier = DEVICE_IDIOM == .pad ? 0.09 : 0.1

    hostView.addSubview(self)
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: BOUNDS.size.width * 2),
      heightAnchor.constraint(equalToConstant: BOUNDS.size.height * multiplier),
      topAnchor.constraint(equalTo: hostView.safeAreaLayoutGuide.topAnchor, constant: 0),
      leadingAnchor.constraint(equalTo: hostView.safeAreaLayoutGuide.leadingAnchor, constant: -(BOUNDS.size.width / 2)),
    ])

    // The red background must end exactly where the banner ends, since the
    // scroll view starts right after the banner. A height computed
    // independently of the banner (e.g. a fixed fraction of the screen)
    // drifts out of sync with it, leaving either a gap of bare red or
    // having the scroll view cover its tail.
    let backgroundView = UIView()
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.backgroundColor = APP_ACCENT_COLOR
    hostView.insertSubview(backgroundView, belowSubview: self)
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: hostView.topAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: hostView.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: hostView.trailingAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Unlock All Premium Features"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: hostView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      label.widthAnchor.constraint(equalToConstant: BOUNDS.size.width * 0.6),
      label.topAnchor.constraint(equalTo: topAnchor, constant: BOUNDS.size.height * 0.04),
    ])

    button.setTitle("Details", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    button.layer.cornerRadius = 12
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.backgroundColor = UIColor.white.cgColor
    button.setTitleColor(UIColor(red: 153 / 255, green: 1 / 255, blue: 7 / 255, alpha: 1.0), for: .normal)
    button.addTarget(self, action: #selector(detailsTapped), for: .touchUpInside)
    addSubview(button)
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 70),
      button.trailingAnchor.constraint(equalTo: hostView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      button.topAnchor.constraint(equalTo: topAnchor, constant: BOUNDS.size.height * 0.033),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func detailsTapped() {
    onDetailsTapped?()
  }

  // Called once PremiumManager confirms the purchase — swaps this banner
  // into a simple confirmation state without touching any constraints,
  // since removing/collapsing it live would require re-deriving every
  // constraint that anchors off its bottomAnchor across 5 different
  // screens' own hand-rolled layouts. This is only the in-the-moment
  // fallback for whichever screen the purchase was actually made from —
  // once the user leaves and comes back to any screen (including this
  // one, on its next appearance), or relaunches the app,
  // UnlockPremiumFeatureProtocol's buildTheUnlockPremiumFeatureView() sees
  // isPremiumUnlocked and skips building the banner at all.
  func markUnlocked() {
    label.text = "Premium Features Unlocked"
    button.isHidden = true
  }

}
