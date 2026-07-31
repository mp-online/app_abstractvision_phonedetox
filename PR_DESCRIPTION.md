# PR-005.1 — Fix Mindful Admission Loop and Clarify Feature Behaviour

## Summary

Fixes the admission race that could reopen a confirmed application for about one second and then return immediately to the Mindful Opening countdown. The native admission is now schema version 2 with explicit AWAITING_TARGET and ACTIVE phases.

Flutter clears the pending request before granting an awaiting-target admission immediately before launch. Phone Detox and transient Android surfaces preserve that phase; the target package activates it. Active admission remains valid for the target and transient surfaces, and clears on Home, Settings, the dialer, another meaningful app, global disable, Jail Break, or safety expiry.

Mindful Opening settings now state that the feature delays app entry only. It does not monitor time spent in an app or show 15-minute reminders; those remain PR-008 work. Settings also show global status and the configured-app count, including the zero-app state.

## Root cause

The previous Flutter sequence granted admission while Phone Detox was still foreground. The following Phone Detox Accessibility event used the active-admission clearing rule, deleted that admission before the target appeared, and allowed the target's next event to create another request. Two-phase admission makes the authorization-to-target transition explicit and safe under nondeterministic Android event ordering.

## Persistence and privacy

Admission schema version 2 stores only:

- schemaVersion
- packageName
- phase
- grantedAtEpochMs
- targetDeadlineEpochMs
- expiresAtEpochMs

Awaiting target has a 15-second deadline; active admission retains the 12-hour safety expiry. Phase-less schema-v1 records, unknown phases, and corrupted timelines are cleared and never inferred as active. No intention, duration, behavioral history, content, notification, URL, or original intent is stored.

No permission, dependency, service, receiver, analytics, network, Usage Access, overlay, VPN, billing, subscription, or foreground service was added.

## Automated verification

- flutter pub get: passed.
- flutter gen-l10n: passed.
- dart format --set-exit-if-changed lib test: passed, zero changes.
- flutter analyze --no-pub: passed, no issues.
- flutter test --no-pub: passed, 68 tests.
- android/gradlew :app:testDebugUnitTest: passed.
- flutter build apk --debug: passed; output at build/app/outputs/flutter-apk/app-debug.apk.

Automated coverage includes both admission phases, strict Detox precedence, transient surfaces, target activation/deadlines, schema decoding/migration rejection, exact Chrome event regression behavior, Flutter launch ordering/failure cleanup, localized settings/count/empty states, and large text scaling.

## Manual verification still required

No device or emulator was used in this change. Chrome direct-launch reproduction, external Recents/notification/link behavior, and the Einbürgerungscoach 15-minute expectation remain unverified. Pixel, Samsung/One UI, Android 10, TalkBack, Home-button, reboot/process-death, permission-dialog, and live Jail Break enforcement checks also remain unverified.