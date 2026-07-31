# Phone Detox

Phone Detox is a privacy-first Android replacement Home launcher built with Flutter and a narrow Kotlin adapter. It combines searchable app launching, strict timed Detox sessions, explicit Jail Break recovery, and per-app Mindful Opening pauses.

Mindful Opening supports 5/10/15/30-second pauses and an optional intention gate. Direct launcher taps work without Accessibility. After the version-two disclosure, the existing package-only Accessibility Service can also catch configured apps opened through Recents, notifications, links, assistants, or other apps while Phone Detox remains Home. Android does not expose the original external intent, so confirmation opens the app's primary launcher activity.

All rules and temporary enforcement snapshots stay local. Intentions and behavioral history are never persisted. The app has no account, ads, analytics, tracking, network communication, broad package visibility, Usage Access, overlay, VPN, foreground service, boot receiver, or subscription.

## Development

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
cd android && gradlew testDebugUnitTest
flutter build apk --debug
```

Manual Pixel, Samsung, Android 10, external-intent, reboot/process-death, accessibility, and Jail Break QA must not be claimed without execution evidence.
