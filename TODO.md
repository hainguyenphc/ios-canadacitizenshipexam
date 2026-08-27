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
