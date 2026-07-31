# Codex Handoff — PR-003 device QA

## Implemented

PR-003 adds typed Home-role status/results, Activity Result-based asynchronous role requests, OS-state rechecks, settings fallback, one-request-at-a-time protection, first-run activation, root startup coordination, role-revocation recovery, centralized resume reconciliation, informational startup preferences, English/German UI, native/Dart tests, and service-connect expiry cleanup.

No permission was added. No boot receiver, foreground service, background activity launch, polling, alarm, OEM autostart request, battery exemption, or Accessibility auto-enablement was added.

## Automated verification

Run from the repository root:

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
cd android
gradlew :app:testDebugUnitTest
cd ..
flutter build apk --debug
```

On Windows with the repository and Pub cache on different drives, Gradle's aggregate `testDebugUnitTest` may fail while configuring or testing the `shared_preferences_android` dependency. The app-only task is the authoritative project Kotlin suite; preserve the aggregate-command output in the final report.

## Manual verification still required

- Pixel on Android 15+: fresh activation, cancel/retry, repeated Home, restart/unlock, revoke/restore.
- Current Samsung/One UI: button and gesture Home, restart/unlock, revoke/restore, confirm no OEM autostart prompt.
- One supported pre-Android-10 device: resolved-Home status, settings fallback, cancel/return, restart/unlock.
- Detox regression: disclosure, active blocking from external surfaces, restart during session, native reconciliation, and safe recovery paths.

Do not mark these complete until the named device or emulator was actually exercised. PR-002 manual QA also remains incomplete.
