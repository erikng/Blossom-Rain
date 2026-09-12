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

## Distribution

The optional Fastlane configuration in `Darwin/fastlane/` builds and submits
iOS releases. See its README for setup instructions.
