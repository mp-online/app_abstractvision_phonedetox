# Codex Handoff — PR-004 Jail Break QA

## Implemented

PR-004 adds the launcher-header and Settings Jail Break entry points, one shared confirmation UI, an immutable Riverpod coordinator, active Detox cleanup, existing Home-settings fallback reuse, centralized resume verification, typed intentional role loss, neutral completion UI, cancellation messaging, recovery after cleanup/status failures, and guarded current-Home opening on the existing launcher channel.

No permission or dependency was added. Accessibility is not disabled programmatically. Phone Detox never claims or attempts to silently remove its own Home role. No second lifecycle observer/channel, boot receiver, foreground service, background activity launch, polling, process kill, Home-role auto-reclaim, device administrator, or uninstall prevention was added.

## Automated verification

Run from the repository root:

```text
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
cd android
gradlew testDebugUnitTest
gradlew :app:testDebugUnitTest
cd ..
flutter build apk --debug
```

On Windows with the repository and Pub cache on different drives, aggregate Gradle tests may encounter the documented dependency-owned path issue. Preserve that result and separately report the app Kotlin task.

## Manual verification still required

- Pixel: header placement, confirmation cancel, keep Phone Detox, select Pixel Launcher, repeated Home, reopen, restore, active-session cleanup, Accessibility remains enabled but inert.
- Samsung/One UI: repeat with One UI Home and button/gesture navigation; confirm no autostart prompt or auto-reclaim.
- Supported pre-Android-10 device: settings fallback, resolved-Home result, cancel/return.
- Failure cases: native cleanup error, settings unavailable, process death/rotation while Android settings is open.
- Device accessibility: TalkBack order/labels and large system text.

Do not mark any manual device item complete without the named device or emulator evidence.
