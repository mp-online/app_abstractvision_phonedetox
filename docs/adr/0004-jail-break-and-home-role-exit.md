# ADR 0004: Jail Break and Home-role exit

- Status: Accepted
- Date: 2026-07-31

## Context

Android owns the default Home application. Phone Detox can qualify for and request the Home role, but it cannot silently assign another launcher or relinquish the role on the user's behalf. A recovery path must therefore remain visible even while app discovery or Detox enforcement fails.

## Decision

Expose a localized Jail Break action beside the launcher clock and redundantly in Settings. One confirmation starts a Flutter-owned coordinator. If a Detox session is active, the coordinator first stops the native enforcement snapshot, clears the Flutter active-session preference and state, and then opens Android's Home-app settings through the existing OEM fallback chain.

The root startup coordinator remains the only lifecycle observer. On resume it queries Android's authoritative Home-role state, reconciles Detox state, and delivers the role result to the Jail Break controller. `notHeld` is intentional completion, `held` is cancellation rather than an error, and `unavailable` is a recoverable failure. Ordinary role loss still uses the unexpected role-loss recovery flow.

The existing launcher channel may open the currently selected Home activity only after confirming Phone Detox no longer holds the role. It rejects a resolution back to Phone Detox. Failure falls back to instructing the user to press Android Home; the Flutter process is never killed.

## Accessibility and recovery

Jail Break ends active enforcement but does not and cannot disable the Accessibility Service programmatically. An enabled service with no native active session performs no blocking. If session cleanup fails, the user can retry, open Home settings anyway, open Accessibility settings for manual control, or cancel. No application error may remove every recovery path.

## Rejected alternatives

- `RoleManager.createRequestRoleIntent()` requests Phone Detox as Home and is the wrong direction for exit.
- `SystemNavigator.pop()` or force-stopping Flutter does not select another Home app.
- A second lifecycle observer could race the PR-003 startup reconciliation.
- Background activity launch, polling, boot receivers, and automatic Home-role reclaim are unnecessary and would undermine explicit user choice.

## Consequences

Intentional role loss carries a typed reason and shows neutral completion copy. Selecting Phone Detox again leaves startup ready and produces a non-error message. Pixel, Samsung/One UI, older-Android, and active-enforcement behavior still require device QA before those acceptance items can be marked complete.
