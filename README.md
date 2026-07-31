# Phone Detox

Phone Detox is a privacy-first Android replacement Home launcher built with Flutter and a narrow Kotlin platform adapter. First run explains the Home replacement, asks Android for explicit Home-role confirmation, and waits for the actual result before exposing the launcher. A previously configured user sees recovery UI if Android later revokes the role.

Optional, prominently disclosed Accessibility access supports user-selected timed Detox sessions. Home activation and Accessibility are separate capabilities. All configuration and enforcement state stays on device.

The app has no account, advertising, analytics, tracking, network communication, broad package visibility, Usage Access, overlay, foreground service, boot receiver, background activity launch, device administration, or uninstall prevention.

## Startup model

Android's current Home-role state is authoritative. Informational onboarding preferences never grant or preserve the role. After restart and unlock, Android resolves the selected Home application; Phone Detox does not use a boot receiver or artificial boot-time activity launch.

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

Install the debug APK and complete the Pixel, Samsung, older-Android, Home-button, reboot/unlock, role-revocation, and Detox regression matrix in `PR_DESCRIPTION.md`. Never mark device checks complete without actual device or emulator evidence.
