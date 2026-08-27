# TODO

## Home screen

- **Share sheet is missing the App Store link.** The share icon on Home
  (`HomeVC_.shareAppTapped`, in `HomeVC_.swift`) currently shares text only:
  > "Check out Discover Canada — a free app to help you study for the
  > Canadian citizenship test!"

  The app hasn't been published yet, so there's no link to include. Once
  it's live on the App Store, append the App Store URL to `shareText` in
  `shareAppTapped(_:)`. Marked in code with a `@todo` at
  `HomeVC_.swift:229`.

## Premium / In-App Purchase

`PremiumManager` + `PremiumBannerView` + `PremiumPaywallVC` implement a
3-tier "Premium" auto-renewable subscription (weekly/monthly/yearly, one
subscription group — see `SubscriptionTier`), wired up to every existing
"Details" button (Home/Progress/Tests/Book/Settings) and Home's "Unlock
Premium Features" card. The paywall lets the user pick a duration (a
`UISegmentedControl`), shows that plan's price, and offers "Manage
Subscription" (Apple's own sheet — an app can't cancel a subscription
directly) once already subscribed. Real money can't actually change hands
yet, though — a few things still need doing:

- **No real products exist yet.** The app isn't published, so there's no
  App Store Connect listing to create In-App Purchase products in. Once
  one exists: create one subscription group ("Premium") containing 3
  auto-renewable subscriptions — weekly/monthly/yearly — with product IDs
  `com.haiphcnguyen.canadacitizenshipexam.premium.weekly` /
  `.premium.monthly` / `.premium.yearly` (must match exactly — see
  `SubscriptionTier.productID`), set real pricing/localization
  (`Configuration.storekit`'s $2.99/$7.99/$49.99 are placeholders, not
  decided prices — picked only to look like a plausible weekly < monthly
  < yearly-discounted spread), and submit alongside the app.
- **Local testing needs one manual step in Xcode**: Product ▸ Scheme ▸
  Edit Scheme… ▸ Run ▸ Options ▸ StoreKit Configuration ▸ select
  `Configuration.storekit` (at `canadacitizenshipexam/Configuration.storekit`).
  Without this, `PremiumManager.fetchProducts` will fail with
  `.productNotFound` in the Simulator, since there's nothing to find until
  either that's wired up or the App Store Connect products above exist.
- **Grace period / billing retry isn't specially handled.** `PremiumManager`
  treats "active until `expirationDate`" as the only signal — it doesn't
  distinguish a healthy subscription from one that's in Apple's grace
  period or billing retry state. A more complete implementation would
  check `Product.SubscriptionInfo.Status` for that nuance (see the note in
  `PremiumManager.handle(transactionResult:)`).
- **Nothing is actually gated behind premium yet.** Subscribing currently
  only dismisses the banners/paywall — no test, chapter, or other content
  changes behavior based on `PremiumManager.shared.isPremiumUnlocked`.
  Deciding what "premium" actually unlocks (which tests? all of Book?
  something else?) is a product decision, not something to invent
  unilaterally — the data model doesn't currently distinguish any test as
  locked/premium at all (see the existing note in `Tests+Cards.swift`).
