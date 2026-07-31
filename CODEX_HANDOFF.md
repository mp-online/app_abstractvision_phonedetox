# Codex Handoff — PR-005 Mindful Opening QA

## Implemented

Mindful rules, global enablement, direct and external request creation, full-screen countdown/intention UI, admission, strict Detox precedence, current-Home safety, disclosure v2, centralized startup recovery, Jail Break cleanup, indicators, Settings management, English/German localization, and native/Dart decision tests.

No permission, runtime dependency, service, receiver, billing, subscription, analytics, network call, or behavioral history was added. External notification/deep-link destinations are not restored; the primary launcher activity opens after confirmation.

## Automated verification

Run `flutter pub get`, `flutter gen-l10n`, `dart format --set-exit-if-changed lib test`, `flutter analyze --no-pub`, `flutter test --no-pub`, `android/gradlew :app:testDebugUnitTest`, `android/gradlew testDebugUnitTest`, and `flutter build apk --debug`. Preserve the known cross-drive aggregate Gradle result if it remains.

## Manual verification still required

- Pixel Android 15+, current Samsung/One UI, and Android 10.
- Direct pause/cancel/confirm, navigation within an admitted app, Home then reopen.
- External Recents, notification, browser link, other app, and assistant opening.
- Accessibility disabled partial coverage and v1-to-v2 disclosure migration.
- Jail Break with pending/admitted state and rules preserved after restoring Home.
- Reboot and Flutter process death with valid and expired requests.
- Gesture/buttons, large text, TalkBack order, and recovery paths.
