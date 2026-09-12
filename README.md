# Blossom Rain

Blossom Rain is a native SwiftUI app for iPhone, iPad, and Mac that calculates
Lotus Water mineral drops for coffee brewing recipes. It supports iOS 17+
and macOS 14+ and has no third-party app dependencies. The Mac app uses
native SwiftUI/AppKit, not Mac Catalyst or an iPad compatibility mode.

## Building and running

Open `Darwin/BlossomRain.xcodeproj` in Xcode 16 or later (Swift 6), select the
`BlossomRain` scheme, and choose **My Mac**, an iPhone/iPad simulator, or a device.
Build and run with Xcode. For a physical device, select your development
team in Signing & Capabilities. Use Xcode 26 or later to build with the
iOS 26/macOS 26 SDKs.

To build for the iOS Simulator from the repository root:

```sh
xcodebuild \
  -project Darwin/BlossomRain.xcodeproj \
  -scheme BlossomRain \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build
```

To build the native Mac app, use the same project and scheme:

```sh
xcodebuild \
  -project Darwin/BlossomRain.xcodeproj \
  -scheme BlossomRain \
  -configuration Debug \
  -destination 'generic/platform=macOS' \
  -derivedDataPath .build/macOS \
  CODE_SIGNING_ALLOWED=NO \
  build
```

The Mac app has a resizable recipe window and a separate native Settings
window, available from the toolbar or **BlossomRain > Settings…** (`⌘,`).
Custom recipe Save and Cancel actions support Return and Escape. Screen-sleep
prevention is an iOS-only setting. Mac sandboxing and hardened runtime are
configured for signed builds; the commands above produce local unsigned builds.

## Project layout

- `Sources/BlossomRain/` contains the SwiftUI app, recipes, and calculators.
- `Sources/BlossomRain/Resources/Localizable.xcstrings` contains translations.
- `Darwin/` contains the Xcode project, app icons, and signing configuration.

The Xcode app target compiles the Swift sources directly. App identity,
version numbers, and deployment settings live in `Darwin/BlossomRain.xcconfig`.

## State, calculations, and OS compatibility

`BRState` owns transient volume input; `RecipeLibrary` owns recipe selection,
drafts, and persistence. Both use main-actor-isolated Observation, owned by the
app with `@State` and passed through the SwiftUI environment. There is no
mutable global application state. Persisted preference keys and the
`customRecipes.v1` JSON format remain unchanged.

`RecipeVolumeSection` and `RecipeDropsSection` observe brewing input separately
from the chart and ion views. `RecipeCalculator` is the single production drop
calculator used by the UI and verification checks. It retains Lotus's exact
arithmetic order and rejects negative, non-finite, or overflowing inputs before
integer conversion. Manual volume input accepts the current locale's decimal
separator. Unit metadata no longer creates throwaway UUIDs during rendering.

All app APIs are available at the declared minimum versions. iOS keyboard and
navigation modifiers are isolated behind platform checks; macOS has its own
window/settings scenes and mineral-row backgrounds. Standard SwiftUI controls
provide the system appearance on each OS, including Liquid Glass when built
with the 26 SDKs and run on those systems. No iOS 26-only API or forced
appearance override is required. Screen-sleep prevention follows the app's
active scene state instead of remaining enabled when it becomes inactive.

Apple's relevant guidance:

- [Migrating to Observation](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)
- [Configuring a multiplatform app](https://developer.apple.com/documentation/xcode/configuring-a-multiplatform-app-target)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)

## Lotus recipe source

The published presets were refreshed from the
[Lotus recipe calculator](https://lotuscoffeeproducts.com/pages/product-instructions)
on September 12, 2026. The extracted recipe data, source URL, retrieval date,
and original page SHA-256 are saved in `Reference/Lotus/recipes.json`.
`Reference/Lotus/calculate_values.js` preserves the upstream calculator function
for comparison. These reference files are not bundled with the app.

To maintain the port, compare the page's recipe option data and
`calculate_values()` with `Sources/BlossomRain/Recipes.swift`,
`RecipeDetails.swift`, `Calculators.swift`, and `RecipeDropsSection.swift`. Verify every mineral, both dropper
styles, and all three volume units, including half-drop rounding boundaries.
Keep existing recipe raw values stable because they are saved in user defaults.
The `rao_perger` selection now resolves to the updated Rao's Recipe.

The snapshot covers the seven published presets. Both espresso variants
intentionally share the description and Lance Hedrick attribution of their
corresponding filter recipes, even when the website leaves those descriptions
blank. Preserve that attribution when refreshing upstream data.

## Custom recipes and water profiles

Choose **Custom Recipe** in the recipe picker to adjust calcium, magnesium,
potassium, and sodium targets. Each target accepts 0–150 ppm as CaCO₃, using
either a slider or decimal input. Enter a name and choose **Save Recipe**.
Saved recipes appear in both the recipe picker and the default-recipe settings.
They can be edited or deleted; cancelling an edit preserves the saved version.

Custom recipes are stored locally on the device in user defaults. They survive
app restarts and are not synced between devices. Existing preset default
selections remain compatible. Deleting a custom default selects Light & Bright.

Every preset, saved recipe, and valid custom draft shows a native scatter chart
with alkalinity on X and hardness on Y, plus calcium, magnesium, potassium,
sodium, chloride, and bicarbonate ion concentrations. These describe the target
water before rounding drops. Batch volume and individual dropper styles affect
drop counts, while the target profile stays the same.

## Recipe verification

With Xcode and Node.js installed, run:

```sh
python3 scripts/verify-recipes.py
```

The checks compile the production models in Swift 6 mode for the macOS 14
minimum, with compiler warnings treated as errors. They exercise creator attribution, custom input validation, saving,
editing, cancelling, loading, defaults, deletion, and unreadable-data handling.
They also cover independent brewing sessions, unit changes, stored preferences,
localized manual volume, and invalid/overflowing calculation inputs.
They also execute the saved Lotus JavaScript and compare it with the SwiftUI
drop calculations and Swift chart/ion calculations for all published presets,
custom targets, all volume units, and uniform and mixed dropper styles.
No network connection or third-party app dependency is required.

For platform validation, build both commands above and build a Release version
with `-destination 'generic/platform=iOS'`. Minimum deployment targets are
checked by the compiler; these builds do not replace runtime checks on older
OS installations. The generic Mac destination builds both Apple silicon and
Intel architectures.

## Distribution

The optional Fastlane configuration in `Darwin/fastlane/` builds and submits
iOS releases. See its README for setup instructions.
