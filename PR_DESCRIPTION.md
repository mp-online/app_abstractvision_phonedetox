# PR-005 — Mindful Opening

## Summary

Adds local per-app launch friction with 5, 10, 15, or 30 second pauses and optional memory-only intention selection. Direct launcher taps create a native pending request; package-only Accessibility events can intercept external foreground transitions after disclosure version 2 while Phone Detox remains Home.

The Accessibility initialization crash is fixed by calling `super.onServiceConnected()`, constructing every store and resolver, and only then reading/clearing persisted snapshots. The service now delegates precedence to a pure foreground decision engine.

## Implemented and automated

- [x] Validated immutable Dart rules and UTC request model.
- [x] SharedPreferences product rules/global toggle; no history store.
- [x] Versioned native rules, five-minute request, and twelve-hour admission stores.
- [x] Direct launch gate, countdown, optional intention, immediate Go back, and admission-before-launch.
- [x] External package interception guarded by disclosure v2 and current Home resolution.
- [x] Detox hard block precedence, request deduplication, transient-system admission preservation, and meaningful-transition clearing.
- [x] Startup pending-request recovery and stale expiry through the sole lifecycle coordinator.
- [x] Jail Break clears request/admission while preserving rules.
- [x] Long-press editor, launcher indicators, Settings toggle/management, English/German localization.
- [x] No permission, service, receiver, runtime dependency, billing, subscription, analytics, or network feature added.

## Verification status

Flutter analysis, Flutter tests, and app Kotlin tests pass. Aggregate Gradle and debug APK results are recorded in the implementation handoff. No device or emulator QA was performed; Pixel, Samsung, Android 10, external notification/deep-link, reboot/process-death, TalkBack, and live Jail Break enforcement checks remain unverified.

## Known platform limitation

Accessibility supplies the visible package but not the original launch intent. External confirmation opens the package's primary launcher activity; notification and deep-link destinations are not restored.
