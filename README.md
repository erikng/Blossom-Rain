# Blossom Rain

Blossom Rain is a native SwiftUI app for iPhone and iPad that calculates
Lotus Water mineral drops for coffee brewing recipes. It supports iOS 17
and later and has no third-party app dependencies.

## Building and running

Open `Darwin/BlossomRain.xcodeproj` in Xcode 15 or later, select the
`BlossomRain` scheme, and choose an iPhone or iPad simulator or device.
Build and run with Xcode. For a physical device, select your development
team in Signing & Capabilities.

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

## Project layout

- `Sources/BlossomRain/` contains the SwiftUI app, recipes, and calculators.
- `Sources/BlossomRain/Resources/Localizable.xcstrings` contains translations.
- `Darwin/` contains the Xcode project, app icons, and signing configuration.

The Xcode app target compiles the Swift sources directly. App identity,
version numbers, and deployment settings live in `Darwin/BlossomRain.xcconfig`.

## Lotus recipe source

The published presets were refreshed from the
[Lotus recipe calculator](https://lotuscoffeeproducts.com/pages/product-instructions)
on September 12, 2026. The extracted recipe data, source URL, retrieval date,
and original page SHA-256 are saved in `Reference/Lotus/recipes.json`.
`Reference/Lotus/calculate_values.js` preserves the upstream calculator function
for comparison. These reference files are not bundled with the app.

To maintain the port, compare the page's recipe option data and
`calculate_values()` with `Sources/BlossomRain/Recipes.swift`,
`RecipeDetails.swift`, `Calculators.swift`, and `RecipesTab.swift`. Verify every mineral, both dropper
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

The checks exercise creator attribution, custom input validation, saving,
editing, cancelling, loading, defaults, deletion, and unreadable-data handling.
They also execute the saved Lotus JavaScript and compare it with the SwiftUI
drop calculations and Swift chart/ion calculations for all published presets,
custom targets, all volume units, and uniform and mixed dropper styles.
No network connection or third-party app dependency is required.

## Distribution

The optional Fastlane configuration in `Darwin/fastlane/` builds and submits
iOS releases. See its README for setup instructions.
