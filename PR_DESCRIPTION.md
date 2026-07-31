# PR-005.2 — Clarify Detox behaviour and product modes

## Summary

Makes the existing strict temporary block unmistakable throughout the Flutter UI. The setup is now **Block apps now**, explains that selected apps become completely unavailable for a fixed period, and explicitly says that the duration is not usage time inside an app.

Setup has three numbered steps: choose apps, choose how long they remain blocked, and confirm blocking access. Custom duration is deliberate and hidden until selected. Dynamic explanations and actions use app labels/counts and localized durations. A typed `DetoxStartBlocker` exposes exactly one next-action reason in product priority order.

App selection, active-block state, early exit, emergency recovery, launcher feedback, Jail Break copy, and Settings mode explanations now use consistent block terminology. Settings advertises only Mindful Opening and Block apps now.

## Product decision

`docs/PRODUCT_MODES.md` and ADR 0006 distinguish Mindful Opening entry friction, fixed Temporary Block, and future Usage Limit. Usage Limit is approved for PR-006 but is not implemented or advertised as available. It is opt-in per app, off by default, local, and suggests 15 minutes only after enabling. Expiry returns Home; Android force-stop is not promised. Critical applications are never configured automatically.

## Architecture and privacy

This PR changes Dart presentation/state copy, localization, documentation, and tests only. It does not change Kotlin, platform channels, native session persistence, Accessibility event handling, package matching, precedence, timestamps, expiry, Mindful admission, Home-role behavior, or Jail Break recovery guarantees.

No permission, runtime dependency, persistence migration, Usage Access, usage-duration tracking, foreground service, alarm, WorkManager, schedule, cooldown, budget, reminder, notification, analytics, billing, subscription, advertisement, network call, or backend was added.

## Verification

Automated verification passed:

- `flutter pub get`
- `flutter gen-l10n`
- `dart format --set-exit-if-changed lib test` (78 files, zero changes)
- `flutter analyze --no-pub` (no issues)
- `flutter test --no-pub` (76 tests)
- `android/gradlew :app:testDebugUnitTest`
- `flutter build apk --debug` (`build/app/outputs/flutter-apk/app-debug.apk`)

Localization audit found complete metadata and English/German key parity. `git diff -- android` is empty. Device-only acceptance criteria remain unchecked because no device or emulator was used.
