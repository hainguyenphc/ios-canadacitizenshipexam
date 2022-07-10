# Canada Citizenship Exam IOS app

## Overview

We need a tab bar controller called `PrimaryTabBarController` to house:

- A navigation controller called `HomeNC`
- A navigation controller called `TestNC`
- A navigation controller called `BookNC`
- A navigation controller called `ProgressNC`
- A navigation controller called `SettingsNC`

### Custom components

#### Buttons

#### Cells

Either a table cell or a grid cell.

Let's hard code all the section info items for now. Place them into a table view
later.

#### Labels

- `CCEScreenTitleLabel`. E.g., "Practice Tests"
- `CCESectionPrimaryLabel`. E.g., "Free Practice Test" in black.
- `CCESectionSecondaryLabel`. E.g., "20 Exam Questions" in red.
- `CCEBobyLabel`. E.g., "Progress 0%" in greyish.

#### Text fields

Pontentially a text field for filling the gap?

#### ViewControllers

- `CCEGenericSectionInfoVC` which potentially has an array of `CCESectionInfoView`.
- `CCEPracticeTestsScreenSectionInfoVC` extends `CCEGenericSectionInfoVC`.
- `CCEStudyBookScreenSectionInfoVC` extends `CCEGenericSectionInfoVC`.
 
The `CCEPracticeTestsScreenSectionInfoVC` handles the tap action in the manner
that it brings up a new view controller rendering corresponding test for the
section info.

The `CCEStudyBookScreenSectionInfoVC` handles the tap action by pushing up a new
view controller rendering a corresponding section of the Discovery Canada book
for the section info.

#### Views

- CCEGenericSectionInfoView. E.g., "Chapter 1" card view in "Study Book".

