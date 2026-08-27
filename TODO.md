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
single non-consumable "Unlock All Premium Features" purchase, wired up to
every existing "Details" button (Home/Progress/Tests/Book/Settings) and
Home's "Unlock Premium Features" card. Real money can't actually change
hands yet, though — three things still need doing:

- **No real product exists yet.** The app isn't published, so there's no
  App Store Connect listing to create an In-App Purchase product in. Once
  one exists: create a non-consumable product with product ID
  `com.haiphcnguyen.canadacitizenshipexam.premium_unlock` (must match
  exactly — see `PremiumManager.premiumUnlockProductID`), set real
  pricing/localization (`Configuration.storekit`'s `$4.99` is a
  placeholder, not a decided price), and submit it for review alongside
  the app.
- **Local testing needs one manual step in Xcode**: Product ▸ Scheme ▸
  Edit Scheme… ▸ Run ▸ Options ▸ StoreKit Configuration ▸ select
  `Configuration.storekit` (at `canadacitizenshipexam/Configuration.storekit`).
  Without this, `PremiumManager.fetchProduct` will fail with
  `.productNotFound` in the Simulator, since there's no real product to
  find until the App Store Connect one above exists.
- **Nothing is actually gated behind premium yet.** Purchasing currently
  only dismisses the banners/paywall — no test, chapter, or other content
  changes behavior based on `PremiumManager.shared.isPremiumUnlocked`.
  Deciding what "premium" actually unlocks (which tests? all of Book?
  something else?) is a product decision, not something to invent
  unilaterally — the data model doesn't currently distinguish any test as
  locked/premium at all (see the existing note in `Tests+Cards.swift`).
