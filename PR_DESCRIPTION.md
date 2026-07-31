# PR-002 — Active Detox Sessions and Android App Blocking

## Summary

Implement the first real, fully local Phone Detox enforcement flow. Users select app packages, choose a 5–480 minute session, accept a prominent versioned disclosure, enable Phone Detox Accessibility access, and start a session. A blocked foreground package triggers `GLOBAL_ACTION_HOME`; direct launches from Phone Detox are rejected in Dart without a launch/return flash.

Flutter owns product state and UI. Kotlin owns only Android platform access and the minimal process-independent enforcement snapshot.

## Privacy and architecture

- Launcher entries retain component identity; Detox selection deduplicates to package identity.
- Flutter preferences store selected packages, default duration, disclosure version, and product session.
- Android private preferences store only session ID, UTC epoch start/end, and blocked package names.
- Native state is authoritative during recovery; Flutter repairs stale product state and both sides clear expiry.
- The Accessibility Service listens only for window-state/window-change events and reads only `event.packageName`.
- It cannot retrieve window content and never accesses nodes, text, passwords, messages, browser content, notifications, images, contacts, or files.
- Phone Detox, System UI, Settings, enabled input methods, permission/package installer surfaces, phone/emergency UI, setup, and recovery surfaces are exempt centrally.

## New special access

Adds an optional `AccessibilityService` bound with the system-only `BIND_ACCESSIBILITY_SERVICE` permission. This is special access enabled by the user in Android Settings, not a runtime permission requested by the app. The service is not marked `isAccessibilityTool=true`.

No Usage Access, `QUERY_ALL_PACKAGES`, overlay, device admin, VPN, notification listener, exact alarm, foreground service, boot receiver, background polling, network communication, analytics, account, backend, Drift, billing, schedule, or uninstall prevention is added.

## Dependency decision

No runtime dependency was added. JUnit 4.13.2 is added only to the Android unit-test configuration for the pure native decision and snapshot tests.

## Automated acceptance status

- [x] Package selection is persisted locally and component duplicates deduplicate by package.
- [x] Hidden state and blocked state remain independent.
- [x] Unknown selected packages are removed during reconciliation.
- [x] Preset and validated custom durations from 5–480 minutes are supported.
- [x] Prominent Accessibility disclosure gates Android Settings behind affirmative consent version 1.
- [x] Accessibility status is rechecked on resume.
- [x] Session start requires selected packages, valid duration, consent, and enabled access.
- [x] Native start failure rolls back Flutter persistence.
- [x] Native state restores Flutter state and expired state clears on both sides.
- [x] Active and active-but-not-enforced states are distinct.
- [x] Direct launcher taps return a typed blocked decision during enforced sessions.
- [x] Countdown derives from the persisted end time rather than stored ticks.
- [x] Deliberate 3-second hold exit and immediate confirmed emergency exit are present.
- [x] English and German ARB entries include metadata.
- [x] Native decision logic covers no session, expiry, blocked/allowed, own app, System UI, Settings, input methods, and blank packages.
- [x] `dart format --set-exit-if-changed lib test` passes.
- [x] `flutter analyze --no-pub` passes.
- [x] `flutter test --no-pub` passes.
- [x] Kotlin unit tests pass.
- [x] Debug APK builds.

## Manual Android QA — not yet completed

- [ ] Pixel device/emulator on Android 15+.
- [ ] Samsung device on current One UI.
- [ ] Android 10 coverage.
- [ ] Android 13 coverage.
- [ ] Android 15+ coverage.
- [ ] Home-role selection and repeated Home navigation.
- [ ] Disclosure appears before Android Accessibility Settings and cancellation remains disabled in-app.
- [ ] Blocked launch from Phone Detox is prevented without flashing the target app.
- [ ] Blocked launch through Recents returns Home.
- [ ] Blocked notification/deep-link launch returns Home.
- [ ] Allowed apps, Settings, Accessibility Settings, permission dialogs, keyboard, phone, and emergency surfaces remain usable.
- [ ] Enforcement survives Flutter activity/process destruction.
- [ ] Enforcement resumes after device restart while the session is valid.
- [ ] Expiry restores blocked apps.
- [ ] Disabling access during a session produces the honest warning; re-enabling resumes enforcement.
- [ ] Deliberate end and emergency exit both stop native and Flutter state.
- [ ] Another Home app can be selected and Phone Detox can be uninstalled.
- [ ] Large-text and TalkBack device QA.

## Google Play work before release

Complete the Accessibility API declaration, store-listing disclosure, and reviewer instructions. Describe the core app-blocking purpose, package-only on-device processing, prominent consent flow, data exclusions, and reversible controls. Provide disclosure screenshots/video if requested.

## Known limitations

Automated tests cannot prove OEM Home behavior, event delivery, reboot recreation, input-method quirks, or Samsung/Pixel safety. Those items remain explicitly unverified until the manual matrix above is executed.

## Rollback

The user can end a session, use Emergency exit, disable the service, select another Home app, or uninstall Phone Detox. The app never obstructs these paths.
