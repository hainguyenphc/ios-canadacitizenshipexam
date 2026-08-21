# Canada Citizenship Exam iOS app

## Overview

An iOS app (Swift/UIKit, programmatic UI — no storyboards) that helps users
study for the Canadian citizenship test: read study-guide chapters, take
practice tests, and track progress.

## Architecture

- **`ScreenLevelVC/`** — one folder per screen (Home, Book, Chapter, Test,
  TestResult, Tests, Progress, Settings, Login/Register). Home and Tests use a
  `*Presenter` protocol/impl pair (MVP-lite); other VCs talk to managers
  directly.
- **`CCEBaseUIViewController`** — shared base class most screens subclass:
  owns a `UITableView` + `CCEHeadingView` (progress ring) and generic
  "compound section" rendering.
- **`Components/`** — hand-rolled design system: labels
  (`CCELevelOneTitleLabel`, `CCEBodyLabel`, …), buttons, cells, a circular
  progress label, section/heading views. Also uses the third-party
  **CardParts** pod for `CardCell`.
- **`Managers/`** — singletons: `NetworkManager` (Firestore CRUD for tests &
  user data), `ScoreStatsManager` (aggregate score stats across users),
  `DimensionManager` (layout constants).
- **`Models/`** — `CCETest`/`CCEQuestion` (Codable, for Firestore + bundled
  JSON), `CCEChapter`/`CCESection`/`CCECompoundSection` (study content),
  `CCEUsersData`/`CCEFinishedTest`/`CCEProgressReport`, `CCEDirtyQuestion`
  (mid-test answer tracking).
- **Local persistence** — a small Core Data model (`Test` ↔ `State`
  entities) lets an in-progress test resume after the app is killed;
  `TestVC` loads/saves via `AppDelegate.persistentContainer`.
- **`Utils/`** — extensions (`+Ext.swift` per VC), constants, a `Seeder` that
  one-time-loads bundled `tests.json` into Firestore via
  `NetworkManager.addTests`.
- **`data/`** — bundled, localized (`Base.lproj`/`en.lproj`) chapter text
  files and `tests.json` (seed content).

## Backend

Firebase: `FirebaseUI` (Email + Google sign-in) for auth, **Firestore** for
tests and per-user progress (`readChapters`, `finishedTests`). Firebase/
Database and Analytics pods are present but not obviously used yet. No
custom backend server.

## Tests

XCTest unit tests for the section/test models (`CCECompoundSectionTests`,
`CCESectionTests`, `CCETestTests`) plus a UI test target scaffold.

## Notable oddities

- This README previously read as an original spec/plan (tab bar layout, nav
  controller names, a component list) rather than a description of the
  current state — some classes it named (e.g. `CCEGenericSectionInfoVC`)
  never existed in the code. That aspirational version has been replaced by
  this scaffold summary.
- The root `package.json` only contains `@openai/codex` — unrelated to the
  iOS app, likely a stray dev-tool leftover worth removing or explaining.
- The working tree can show `Podfile`/`Podfile.lock` modified alongside the
  entire `Pods/AppAuth` source tree deleted — that's an in-progress
  `pod install`/pod update; finish or revert it before committing other
  changes so the repo isn't left with a half-updated Pods directory.
- `composites-designs/` holds design mockup screenshots (`IMG_0019.PNG`–
  `IMG_0026.PNG`), useful as visual reference for intended screens.

