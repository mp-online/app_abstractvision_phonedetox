# ADR 0003: Home-role activation and startup

- Status: Accepted
- Date: 2026-07-31

## Context

Phone Detox is an Android application whose primary activity also qualifies as a Home application. Android launchers do not replace the operating system: Android assigns one installed application the Home role and resolves that application when the user presses Home or reaches the unlocked Home surface after restart.

Role assignment is an explicit, reversible Android choice. Application preferences cannot grant the role and cannot reliably describe its current state after default-app changes, data clearing, restore, or OEM updates.

## Decision

Use `RoleManager.ROLE_HOME` on Android 10 and newer and resolved `ACTION_MAIN`/`CATEGORY_HOME` status on older Android versions. Request the role through the Activity Result API, complete the Flutter platform call only after the Android surface returns, and always recheck actual role state before reporting success.

Flutter owns a root startup coordinator with loading, activation-required, requesting, ready, role-lost, unavailable, and error states. The operating-system role state is authoritative. `startup.hasSeenLauncherExplanation` and `startup.hasCompletedLauncherActivation` are informational preferences only; they distinguish first-run explanation from revocation recovery but never override Android.

When a previously completed user no longer holds the role, Phone Detox shows an explicit recovery screen. It never opens Settings without a tap and always permits choosing another launcher, disabling Accessibility, ending a session, or uninstalling the application.

## Rejected alternatives

- A boot receiver is unnecessary because Android starts the selected Home application after restart and unlock.
- Background activity launching is unreliable, disruptive, and prohibited by modern Android behavior.
- Foreground services, polling, alarms, and OEM autostart permissions add no value to Home-role startup.
- Persisting a boolean such as `isDefaultLauncher` would become stale and could falsely expose launcher UI after role revocation.

## Accessibility separation

Home-role activation is required for launcher and Home-button behavior. Accessibility remains a separate, optional, prominently disclosed capability used only during a user-selected Detox session. Home activation never opens Accessibility settings or grants Accessibility access.

## Consequences and QA

Cold start renders a stable loading surface until role, Detox, and launcher state are reconciled. No activation screen flashes when the role is already held. Activity Result registration requires the Activity Result-capable Flutter host and early lifecycle registration.

Automated tests cover decision and startup transitions, but reboot persistence and OEM Home behavior require manual testing on Pixel, Samsung/One UI, and a supported pre-Android-10 device. Those checks remain unverified until the devices are actually restarted, unlocked, and exercised.
