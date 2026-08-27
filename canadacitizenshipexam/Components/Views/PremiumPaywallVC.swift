//
//  PremiumPaywallVC.swift
//  canadacitizenshipexam
//

import UIKit
import StoreKit

// The paywall sheet presented from every "Details" button / "Unlock
// Premium Features" entry point across the app (see
// UnlockPremiumFeatureProtocol.presentPremiumPaywall() and Home's own
// card5 in Home+Cards.swift). Three billing durations of the same
// "Premium" subscription group (see SubscriptionTier) — picking one is a
// crossgrade within the group, not a separate purchase, and only one can
// ever be active at a time.
class PremiumPaywallVC: UIViewController {

  private var productsByTier: [SubscriptionTier: Product] = [:]
  private var selectedTier: SubscriptionTier = .yearly

  private let titleLabel = CCELevelOneTitleLabel(
    text: "Unlock All Premium Features", textAlignment: .center, fontSize: 20)
  private let descriptionLabel = CCEBodyLabel(
    text: "Maximize your chances by practicing with every premium test.",
    textAlignment: .center, fontSize: 14)
  private let subscribedLabel = CCEBodyLabel(text: "", textAlignment: .center, fontSize: 14)
  private let tierControl = UISegmentedControl(items: SubscriptionTier.allCases.map { $0.displayTitle })
  private let priceLabel = CCEBodyLabel(text: "Loading plans…", textAlignment: .center, fontSize: 16)
  private let purchaseButton = CCEButton(backgroundColor: APP_ACCENT_COLOR, title: "Subscribe")
  private let manageButton = UIButton(type: .system)
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
    loadProducts()
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

    subscribedLabel.translatesAutoresizingMaskIntoConstraints = false
    subscribedLabel.textColor = .systemGreen
    subscribedLabel.isHidden = true
    panel.addSubview(subscribedLabel)

    tierControl.translatesAutoresizingMaskIntoConstraints = false
    tierControl.selectedSegmentIndex = SubscriptionTier.allCases.firstIndex(of: selectedTier) ?? 0
    tierControl.addTarget(self, action: #selector(tierChanged), for: .valueChanged)
    panel.addSubview(tierControl)

    panel.addSubview(priceLabel)

    purchaseButton.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
    purchaseButton.isEnabled = false
    panel.addSubview(purchaseButton)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.hidesWhenStopped = true
    panel.addSubview(activityIndicator)

    manageButton.setTitle("Manage Subscription", for: .normal)
    manageButton.setTitleColor(APP_ACCENT_COLOR, for: .normal)
    manageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    manageButton.translatesAutoresizingMaskIntoConstraints = false
    manageButton.addTarget(self, action: #selector(manageTapped), for: .touchUpInside)
    manageButton.isHidden = true
    panel.addSubview(manageButton)

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

      subscribedLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
      subscribedLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      subscribedLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      tierControl.topAnchor.constraint(equalTo: subscribedLabel.bottomAnchor, constant: 16),
      tierControl.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      tierControl.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      priceLabel.topAnchor.constraint(equalTo: tierControl.bottomAnchor, constant: 12),
      priceLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      priceLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),

      purchaseButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
      purchaseButton.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      purchaseButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
      purchaseButton.heightAnchor.constraint(equalToConstant: 46),

      activityIndicator.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: purchaseButton.centerYAnchor),

      manageButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 12),
      manageButton.centerXAnchor.constraint(equalTo: panel.centerXAnchor),

      restoreButton.topAnchor.constraint(equalTo: manageButton.bottomAnchor, constant: 8),
      restoreButton.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
      restoreButton.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20),
    ])
  }

  private func loadProducts() {
    PremiumManager.shared.fetchProducts { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let products):
          for product in products {
            if let tier = SubscriptionTier(productID: product.id) {
              self.productsByTier[tier] = product
            }
          }
          self.refreshSubscriptionState()
          self.updatePriceLabel()
        case .failure(let error):
          self.priceLabel.text = error.message
      }
    }
  }

  // Reflects whether the user is already subscribed (to any tier) —
  // swaps the purchase controls for a "you're subscribed" state with a
  // Manage Subscription button, rather than letting them "buy" something
  // they already have.
  private func refreshSubscriptionState() {
    guard PremiumManager.shared.isPremiumUnlocked, let activeTier = PremiumManager.shared.activeTier else {
      subscribedLabel.isHidden = true
      manageButton.isHidden = true
      tierControl.isHidden = false
      priceLabel.isHidden = false
      purchaseButton.isHidden = false
      purchaseButton.isEnabled = productsByTier[selectedTier] != nil
      return
    }
    subscribedLabel.text = "You're subscribed (\(activeTier.displayTitle))"
    subscribedLabel.isHidden = false
    manageButton.isHidden = false
    tierControl.isHidden = true
    priceLabel.isHidden = true
    purchaseButton.isHidden = true
  }

  @objc private func tierChanged() {
    selectedTier = SubscriptionTier.allCases[tierControl.selectedSegmentIndex]
    updatePriceLabel()
  }

  private func updatePriceLabel() {
    guard let product = productsByTier[selectedTier] else {
      priceLabel.text = "Unavailable"
      purchaseButton.isEnabled = false
      return
    }
    priceLabel.text = "\(product.displayPrice)\(periodSuffix(for: product))"
    purchaseButton.isEnabled = true
  }

  private func periodSuffix(for product: Product) -> String {
    guard let unit = product.subscription?.subscriptionPeriod.unit else { return "" }
    switch unit {
      case .day: return " / day"
      case .week: return " / week"
      case .month: return " / month"
      case .year: return " / year"
      @unknown default: return ""
    }
  }

  @objc private func purchaseTapped() {
    guard let product = productsByTier[selectedTier] else { return }
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

  @objc private func manageTapped() {
    guard let scene = view.window?.windowScene else { return }
    PremiumManager.shared.presentManageSubscriptions(in: scene)
  }

  @objc private func closeTapped() {
    dismiss(animated: true)
  }

  private func setLoading(_ loading: Bool) {
    purchaseButton.isEnabled = !loading && productsByTier[selectedTier] != nil
    restoreButton.isEnabled = !loading
    tierControl.isEnabled = !loading
    if loading {
      activityIndicator.startAnimating()
      purchaseButton.setTitle("", for: .normal)
    } else {
      activityIndicator.stopAnimating()
      purchaseButton.setTitle("Subscribe", for: .normal)
    }
  }

  private func presentErrorAlert(message: String) {
    let alert = UIAlertController(title: "Purchase", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

}
