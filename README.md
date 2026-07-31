# Phone Detox

Phone Detox is a privacy-first Android replacement Home launcher built with Flutter and a narrow Kotlin platform adapter. First run explains the Home replacement, asks Android for explicit Home-role confirmation, and waits for the actual result before exposing the launcher.

An always-visible **Jail Break** action lets the user end active Detox enforcement and open Android's Home-app settings to select a previous launcher. Android owns that selection; Phone Detox never claims to remove its own Home role automatically. Intentional exit is distinguished from unexpected role loss and the same recovery flow is available from Settings.

Optional, prominently disclosed Accessibility access supports user-selected timed Detox sessions. Jail Break removes the active native and Flutter session but does not disable Accessibility access programmatically. With no active native session, the service performs no blocking. All configuration and enforcement state stays on device.

The app has no account, advertising, analytics, tracking, network communication, broad package visibility, Usage Access, overlay, foreground service, boot receiver, background activity launch, device administration, Home-role auto-reclaim, or uninstall prevention.

## Startup model

Android's current Home-role state is authoritative. `StartupController` is the only lifecycle reconciler. Informational onboarding preferences never grant or preserve the role. After restart and unlock, Android resolves the selected Home application; Phone Detox does not use a boot receiver or artificial boot-time activity launch.

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

Install the debug APK and complete the Pixel, Samsung, older-Android, Home-button, reboot/unlock, role-revocation, Jail Break, and Detox regression matrix in `PR_DESCRIPTION.md`. Never mark device checks complete without actual device or emulator evidence.
