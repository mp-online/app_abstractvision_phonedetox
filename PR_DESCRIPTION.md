# PR-003 — Default Launcher Activation, First-Run Setup, and Reboot Readiness

## Summary

Phone Detox now starts through a Flutter-owned root coordinator. First launch without the Android Home role shows a dedicated explanation and explicit activation actions. Kotlin completes `requestHomeRole` only after Android's Activity Result returns and the actual role is rechecked. Held roles enter the launcher directly; previously completed users whose role is missing receive a recovery screen.

Android remains authoritative. `startup.hasSeenLauncherExplanation` and `startup.hasCompletedLauncherActivation` are informational only.

## Platform API

- `getHomeRoleStatus()`: `held`, `notHeld`, `unavailable`.
- `requestHomeRole()`: `granted`, `denied`, `cancelled`, `alreadyHeld`, `openedSettings`, `unavailable`.
- `openHomeSettings()`: explicit, recoverable settings action.
- Stable request errors: `home_role_request_in_progress`, `home_role_request_failed`.
- Stable settings error: `home_settings_unavailable`.

Android 10+ uses `RoleManager`. Older Android resolves `ACTION_MAIN` + `CATEGORY_HOME` with `MATCH_DEFAULT_ONLY`. `FlutterFragmentActivity` registers the Activity Result launcher before STARTED and delegates results to a testable coordinator.

## Privacy, permissions, and startup

No permission was added or removed. There is no `RECEIVE_BOOT_COMPLETED`, boot receiver, background activity launch, foreground service, polling, WorkManager, alarm, OEM autostart permission, battery exemption, Usage Access, notification access, overlay, `QUERY_ALL_PACKAGES`, network, analytics, account, billing, or schedule.

After restart and unlock, Android starts the selected Home application. Phone Detox performs normal cold-start loading, role lookup, Detox reconciliation, and app discovery without flashing activation when the role is held.

Accessibility remains optional and separate. Home activation never opens Accessibility Settings.

## Automated acceptance status

- [x] Root startup coordinator replaces unconditional `LauncherScreen` root.
- [x] Typed status and request-result models validate all native values.
- [x] Android 10+ RoleManager and older resolved-Home status paths exist.
- [x] Activity Result completion rechecks actual role state.
- [x] Concurrent role requests are rejected.
- [x] Activation, waiting, cancelled/denied, unavailable/error, and role-lost recovery UI exist.
- [x] Resume checks are centralized and refresh overlap is coalesced.
- [x] Informational startup preferences never override Android.
- [x] English/German strings include ARB metadata.
- [x] Dart startup/domain/widget tests pass.
- [x] App Kotlin unit tests pass.
- [x] No boot receiver or background activity launch was added.

## Manual Android QA — not completed

- [ ] Pixel Android 15+ Home-button activation, reboot/unlock, revoke/restore.
- [ ] Samsung current One UI button/gesture Home, reboot/unlock, revoke/restore.
- [ ] Pre-Android-10 fallback status/settings and reboot behavior.
- [ ] Role cancellation/denial and OEM settings fallback on devices.
- [ ] Detox external blocking and restart regression.
- [ ] Large-text and TalkBack device QA.

PR-002 manual QA remains incomplete and is not marked complete by this PR.

## Known environment issue

On this Windows checkout, aggregate `android/gradlew testDebugUnitTest` crosses the `E:` project/build path and `C:` Pub cache. Through a temporary same-drive junction it reaches all tests, but one dependency-owned `shared_preferences_android` Robolectric test fails with `NoSuchFileException`. `gradlew :app:testDebugUnitTest` passes and covers the project Kotlin tests.

## Device matrix

No Pixel, Samsung, older-Android device, or emulator was available in this execution. Home-button, reboot/unlock, role-revocation device behavior, and Detox enforcement regression therefore remain unverified.
