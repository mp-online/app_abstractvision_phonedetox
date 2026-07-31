# Codex Handoff — PR-002 verification and device QA

## Implemented

PR-002 adds package-level Detox selection, durations from 5–480 minutes, prominent versioned Accessibility disclosure, Flutter/native session persistence and reconciliation, active countdown and exit flows, direct-launch prevention, a minimal Accessibility Service, centralized exemptions, English/German localization, and automated Dart/Kotlin tests.

## Required verification

Run from the repository root:

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
cd android
gradlew testDebugUnitTest
cd ..
flutter build apk --debug
```

Then install on Pixel and Samsung devices spanning Android 10, 13, and 15+ where available. Complete every manual scenario in `PR_DESCRIPTION.md`, especially Recents, notification/deep-link launch, Flutter process death, reboot recovery, Accessibility disable/re-enable, Settings/keyboard/phone safety, both exit flows, changing Home, and uninstall.

## Release work still required

- Complete Play Console Accessibility declaration and reviewer instructions.
- Ensure the store listing accurately describes app-blocking, local package processing, and user controls.
- Record screenshots/video of the prominent disclosure and enabled-service flow if requested by review.
- Do not mark device acceptance boxes complete without actual hardware/emulator evidence.

## Restrictions

Do not add `QUERY_ALL_PACKAGES`, Usage Access, overlays, notification access, foreground service, boot receiver, polling, device administration, VPN, exact alarms, analytics, network clients, accounts, backend, billing, or schedules in this milestone.
