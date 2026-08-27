//
//  PremiumPaywallVC.swift
//  canadacitizenshipexam
//

import UIKit
import StoreKit

// The paywall sheet presented from every "Details" button / "Unlock
// Premium Features" entry point across the app (see
// UnlockPremiumFeatureProtocol.presentPremiumPaywall() and Home's own
// card5 in Home+Cards.swift). A single non-consumable purchase
// (PremiumManager.premiumUnlockProductID) unlocks everything at once, so
// there's only ever one product to show here.
class PremiumPaywallVC: UIViewController {

  private var product: Product?

  private let titleLabel = CCELevelOneTitleLabel(
    text: "Unlock All Premium Features", textAlignment: .center, fontSize: 20)
  private let descriptionLabel = CCEBodyLabel(
    text: "Maximize your chances by practicing with every premium test.",
    textAlignment: .center, fontSize: 14)
  private let priceLabel = CCEBodyLabel(text: "Loading price…", textAlignment: .center, fontSize: 16)
  private let purchaseButton = CCEButton(backgroundColor: APP_ACCENT_COLOR, title: "Unlock Now")
  private let restoreButton = UIButton(type: .system)
  private let closeButton = UIButton(type: .system)
  private let activityIndicator = UIActivityIndicatorView(style: .medium)

  init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .crossDissolve
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    loadProduct()
  }

  private func configureUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

    let panel = UIView()
    panel.translatesAutoresizingMaskIntoConstraints = false
    panel.backgroundColor = .secondarySystemGroupedBackground
    panel.layer.cornerRadius = 16
    view.addSubview(panel)

    panel.addSubview(titleLabel)
    panel.addSubview(descriptionLabel)
    panel.addSubview(priceLabel)

    purchaseButton.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
    purchaseButton.isEnabled = false
    panel.addSubview(purchaseButton)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.hidesWhenStopped = true
    panel.addSubview(activityIndicator)

    restoreButton.setTitle("Restore Purchases", for: .normal)
    restoreButton.setTitleColor(.secondaryLabel, for: .normal)
    restoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    restoreButton.translatesAutoresizingMaskIntoConstraints = false
    restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
    panel.addSubview(restoreButton)

    closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    closeButton.tintColor = .secondaryLabel
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    panel.addSubview(closeButton)

    NSLayoutConstraint.activate([
      panel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      panel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      panel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
      panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),

      closeButton.topAnchor.constraint(equalTo: panel.topAnchor, constant: 12),
      closeButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -12),
      closeButton.widthAnchor.constraint(equalToConstant: 28),
      closeButton.heightAnchor.constraint(equalToConstant: 28),

      titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 4),
      titleLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      descriptionLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
      priceLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      priceLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      purchaseButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
      purchaseButton.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      purchaseButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
      purchaseButton.heightAnchor.constraint(equalToConstant: 46),

      activityIndicator.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: purchaseButton.centerYAnchor),

      restoreButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 12),
      restoreButton.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
      restoreButton.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20),
    ])
  }

  private func loadProduct() {
    PremiumManager.shared.fetchProduct { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let product):
          self.product = product
          self.priceLabel.text = product.displayPrice
          self.purchaseButton.isEnabled = true
        case .failure(let error):
          self.priceLabel.text = error.message
      }
    }
  }

  @objc private func purchaseTapped() {
    guard let product = product else { return }
    setLoading(true)
    PremiumManager.shared.purchase(product) { [weak self] result in
      guard let self = self else { return }
      self.setLoading(false)
      switch result {
        case .success:
          self.dismiss(animated: true)
        case .failure(let error):
          guard error.isUserFacing else { return }
          self.presentErrorAlert(message: error.message)
      }
    }
  }

  @objc private func restoreTapped() {
    setLoading(true)
    PremiumManager.shared.restorePurchases { [weak self] result in
      guard let self = self else { return }
      self.setLoading(false)
      switch result {
        case .success:
          if PremiumManager.shared.isPremiumUnlocked {
            self.dismiss(animated: true)
          } else {
            self.presentErrorAlert(message: "No previous purchase was found for this Apple ID.")
          }
        case .failure(let error):
          self.presentErrorAlert(message: error.message)
      }
    }
  }

  @objc private func closeTapped() {
    dismiss(animated: true)
  }

  private func setLoading(_ loading: Bool) {
    purchaseButton.isEnabled = !loading && product != nil
    restoreButton.isEnabled = !loading
    if loading {
      activityIndicator.startAnimating()
      purchaseButton.setTitle("", for: .normal)
    } else {
      activityIndicator.stopAnimating()
      purchaseButton.setTitle("Unlock Now", for: .normal)
    }
  }

  private func presentErrorAlert(message: String) {
    let alert = UIAlertController(title: "Purchase", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

}
