# ADR 0005: Mindful Opening and admission

- Status: Accepted
- Date: 2026-07-31

## Context

Strict Detox sessions are time-bounded hard blocks. Mindful Opening is different: it adds a short, per-app pause and optional intention gate, after which the user may continue. It must cover both launcher taps and foreground transitions detected by the existing Accessibility Service without collecting behavioral history.

Android Accessibility events expose the foreground package, not the initiating notification, URL, deep link, or original intent. Reconstructing that destination is therefore not reliable.

## Decision

Flutter owns rules, the full-screen pause UI, transient intention state, global enablement, and startup routing. A dedicated typed repository uses the versioned `com.abstractvision.phonedetox/mindful` channel. Kotlin stores only enforcement rules, one five-minute pending request, and one schema-v2 admission with a twelve-hour safety limit.

The existing Accessibility Service remains package-name-only and delegates decisions to `ForegroundDecisionEngine`. Priority is: invalid or critical package, strict Detox block, active admission, Mindful rule, allow. External interception is active only after disclosure version 2 and only while Phone Detox resolves as the current Home app.

Confirmation clears the pending request, then grants an AWAITING_TARGET admission immediately before launching the package's primary launcher activity. Phone Detox, keyboards, permission/package-installer surfaces, and System UI preserve this phase. The target must appear within 15 seconds, at which point the service persists an ACTIVE admission without returning Home. A different meaningful app or deadline expiry clears an awaiting admission. Active admission avoids repeated prompts from internal windows, dialogs, keyboards, permission surfaces, and System UI. Active admission ends when Phone Detox, Settings, the dialer, or another meaningful application becomes foreground, on its twelve-hour safety expiry, global disable, cancellation, or Jail Break. Old phase-less admission records and unknown phases are invalidated rather than inferred as active.

This two-phase lifecycle resolves a race where Phone Detox's own foreground event could clear an admission before the target appeared and immediately restart the countdown. External requests retain only the package name. After confirmation Phone Detox opens the primary launcher activity and does not claim to restore the original deep-link or notification destination.

Mindful Opening controls app entry only. In-app duration reminders and daily budgets remain a separate PR-008 feature.

## Privacy and rejected alternatives

No intention, text, launch count, cancellation, duration, URL, notification content, or history is persisted or transmitted. Package-only observation remains sufficient, so Usage Access, overlays, VPN, notification access, foreground services, polling, alarms, and a backend are rejected. Phone Detox must remain Home before bouncing to `GLOBAL_ACTION_HOME`; otherwise it clears stale requests and allows the application.
