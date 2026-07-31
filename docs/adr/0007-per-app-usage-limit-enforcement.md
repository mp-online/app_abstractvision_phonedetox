# ADR 0007: Per-app Usage Limit enforcement

- Status: Accepted
- Date: 2026-07-31

## Context

Phone Detox needs an optional per-app consequence for one continuous foreground visit without building usage history, daily budgets, background tracking, or a second enforcement service.

## Decision

Usage Limits are globally off by default and opt-in per app. Enabling a rule suggests 15 minutes and allows only 5, 10, 15, 30, or 60 minutes. Disclosure version 3 is required before native rule synchronization can be enabled.

Flutter owns settings, rule persistence, labels, decisions, and the Time-up UI. Kotlin owns primitive validated rule snapshots, one persisted interval, one persisted reached lock, and a single `Handler` timeout while the existing package-name-only Accessibility Service is alive.

An interval counts only while its configured package is continuously foreground and the screen is interactive. Screen-off pauses it using monotonic elapsed time. Leaving for another ordinary app ends it. Keyboards, System UI, and permission surfaces preserve it; Settings and dialer/call surfaces pause it. Service recreation converts a persisted running interval to paused without guessing elapsed time.

Enforcement precedence is:

1. strict Detox block;
2. reached Usage Limit lock;
3. Mindful admission or configured Mindful Opening;
4. a fresh or resumed Usage Limit interval.

At expiry, native code rechecks foreground package, interactive state, Home role, configured rule, and strict Detox. It persists the reached lock before requesting Home. The root Time-up screen offers Stay out, Continue, and Change limit. Continue clears the lock, grants the existing one-time Mindful admission, launches explicitly, and restores the lock if launch fails.

Jail Break and Home-role loss clear interval/reached enforcement while preserving Flutter rules. Strict Detox clears an overlapping interval. Removing a rule clears matching runtime state.

## Consequences

- No Usage Access, overlay, foreground service, alarm, WorkManager, wake lock, receiver in the manifest, analytics, network traffic, daily totals, cumulative statistics, or usage history is added.
- Timing is intentionally best-effort while the Accessibility Service process is alive.
- Android is not claimed to force-stop apps; expiry returns Home and applies a reopening consequence.
- Device-specific behavior still requires manual Pixel and Samsung verification before it can be claimed.
