This configuration builds and distributes the Blossom Rain iOS app.
To use fastlane to distribute your app:

1. Update the metadata text files in metadata/en-US/
2. Add screenshots to screenshots/en-US
3. Download your App Store Connect API JSON file to apikey.json
4. From the `Darwin` directory, run `fastlane assemble` to build the app
5. From the `Darwin` directory, run `fastlane release` to submit a new release to the App Store

The app name, bundle identifier, and version numbers are configured in
`../BlossomRain.xcconfig`. The App Store bundle identifier is also set in
`Appfile`. Optional build overrides belong in `AppStore.xcconfig`.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
