# PR-004 — Jail Break: Leave Phone Detox Home Mode

## Summary

Phone Detox now exposes an always-visible, localized Jail Break action beside the launcher clock and an equivalent recovery action in Settings. After one confirmation, the shared Flutter coordinator ends an active Detox session, opens Android's Home-app settings through the existing OEM fallback chain, and waits for the root startup coordinator to verify the actual Home role on resume.

Android remains authoritative. Phone Detox does not claim to remove itself as Home: the user must select another launcher in Android settings. A not-held role becomes neutral intentional completion; a held role is cancellation and keeps startup ready; unavailable or failed checks preserve recovery actions.

## Design and platform API

- `JailBreakController`: immutable idle, confirming, ending, opening, waiting, completed, cancelled, and typed error state.
- Active cleanup calls the existing `DetoxController.stopSession()` before Home settings, clearing native enforcement, Flutter persistence, and active state.
- Cleanup failure offers retry, Home settings anyway, Accessibility settings, and cancel.
- `StartupController` remains the only lifecycle observer and delivers the authoritative resume result.
- `HomeRoleLossReason.intentionalJailBreak` distinguishes intentional exit from PR-003 revocation.
- Existing launcher channel adds `openCurrentHome()`, guarded by a fresh not-held check and rejection of Phone Detox as the resolved Home activity.
- Existing `openHomeSettings()` fallback remains unchanged: Home settings, default-app settings, general settings.

No runtime dependency was added. No permission was added or removed. No second platform channel, boot receiver, foreground service, process kill, background activity launch, polling, device administrator, uninstall prevention, Accessibility auto-disable, or Home-role auto-reclaim was added.

## Automated acceptance status

- [x] Jail Break icon is directly beside the clock, before Detox and Settings, and uses `Icons.lock_open_rounded` with a stable key and localized tooltip.
- [x] Launcher and Settings use the same coordinator and confirmation dialog.
- [x] Inactive and active-session confirmation copy is distinct and localized in English/German with ARB metadata.
- [x] Active native and Flutter Detox session state is cleared before Home settings opens.
- [x] Duplicate requests are ignored and processing actions are disabled.
- [x] Cancellation, completion, unavailable state, settings failure, and cleanup failure are typed and recoverable.
- [x] Home settings and Accessibility settings remain available after cleanup failure.
- [x] Accessibility is never disabled programmatically.
- [x] Intentional role loss uses neutral completion; ordinary role loss retains PR-003 recovery.
- [x] Large-text and localized widget coverage passes.
- [x] Flutter analysis and all Flutter tests pass.
- [ ] Aggregate `gradlew testDebugUnitTest` configures the dependency-owned task unsuccessfully because the E: build and C: Pub cache have different roots.
- [x] `gradlew :app:testDebugUnitTest` passes the project Kotlin suite.
- [x] `flutter build apk --debug` succeeds.

## Manual Android QA — not completed

- [ ] Pixel: cancel/keep/select Pixel Launcher, repeated Home, reopen, active-session exit.
- [ ] Samsung/One UI: cancel/keep/select One UI Home, button/gesture Home, no auto-reclaim.
- [ ] Older Android: OEM fallback and resolved-Home behavior.
- [ ] Accessibility enabled/disabled and active-session external blocking regression.
- [ ] Rotation, process death while Settings is open, and device TalkBack.

No Android device or emulator has been exercised in this implementation session. These items must not be marked complete until actual execution evidence exists.

## Verification commands

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

The aggregate Gradle task was run and failed while creating the dependency-owned `shared_preferences_android:testDebugUnitTest` task because the E: build and C: Pub cache have different roots. The app-only Kotlin task passes; the aggregate failure remains reported rather than hidden.
