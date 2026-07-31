# Phone Detox

Phone Detox is a privacy-first Android replacement Home launcher built with Flutter and a narrow Kotlin platform adapter.

## Development

Requirements: Flutter 3.35 or newer, Dart 3.9 or newer, and an Android SDK.

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug
```

Install the debug APK on an Android device, select Phone Detox in the Home-app role prompt, and complete the manual QA matrix in `PR_DESCRIPTION.md`.

PR-001 has no account, network calls, analytics, billing, Accessibility Service, usage access, notification access, or broad package visibility.