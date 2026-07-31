# Codex Handoff — PR-005.1 Admission Loop QA

## Implemented

The confirmed-launch race is fixed with schema-v2 two-phase admission:

1. Flutter clears the pending request.
2. Native grants AWAITING_TARGET with a 15-second target deadline.
3. Flutter launches the target.
4. Phone Detox, keyboards, System UI, permission controller, and package installer preserve awaiting admission.
5. The target foreground event persists ACTIVE without invoking Home.
6. Active admission preserves the target/transient surfaces and clears on Phone Detox, Settings, the dialer, another meaningful app, global disable, Jail Break, or its 12-hour safety expiry.

Launch failure clears admission and leaves no pending request. Schema-v1, unknown-phase, and corrupted admission records are invalidated. Direct and external decision paths suppress duplicate requests while admission exists.

Settings explain that Mindful Opening controls app entry, not time spent in an app or 15-minute reminders. Global enabled/disabled status, configured count, and zero-app state are visible in English and German.

## Automated verification completed

- Flutter dependency resolution and localization generation: passed.
- Dart format check: passed with zero changes.
- Flutter analyzer: no issues.
- Flutter tests: 68 passed.
- Android app Kotlin unit tests: passed.
- Debug APK: built at build/app/outputs/flutter-apk/app-debug.apk.

Gradle emitted existing Kotlin/AGP deprecation warnings; they did not fail compilation or tests.

## Manual verification still required

No device or emulator QA was performed. Do not mark these complete without execution evidence:

- Chrome direct countdown confirmation and Home/reopen reproduction.
- External Recents, notification, and browser-link flow.
- Einbürgerungscoach left open for more than 15 minutes.
- Pixel, Samsung/One UI, Android 10, TalkBack, Home button, reboot/process death, permission dialogs, or live Jail Break enforcement.

The existing external-flow limitation remains: confirmation opens the target application's primary launcher activity and does not restore the original notification or deep-link destination.