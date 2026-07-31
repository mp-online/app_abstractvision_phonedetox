# Phone Detox

Phone Detox is a privacy-first Android replacement Home launcher built with Flutter and a narrow Kotlin platform adapter. Users can select distracting app packages and start a timed session. With explicitly disclosed and enabled Accessibility access, opening a blocked package returns Android to Home.

All configuration and enforcement state stays on the device. The app has no account, advertising, analytics, tracking, network communication, broad package visibility, Usage Access, overlay, foreground service, boot receiver, device administration, or uninstall prevention.

## Development

Requirements: Flutter 3.35 or newer, Dart 3.9 or newer, and an Android SDK.

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
cd android && gradlew testDebugUnitTest
flutter build apk --debug
```

Install the debug APK, select Phone Detox as Home, accept the in-app disclosure, enable only the Phone Detox Accessibility Service, and complete the device matrix in `PR_DESCRIPTION.md`. Pixel and Samsung manual verification is required before release.
