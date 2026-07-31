# ADR 0006: Detox terminology and Usage Limit direction

- Status: Accepted
- Date: 2026-07-31

## Context

The Detox setup used generic terms such as "Session duration" and "Start session." That wording could reasonably be interpreted as an allowance that begins after an app opens, even though the implemented `DetoxSession` is a fixed interval during which selected packages are completely unavailable.

Mindful Opening already represents a different intervention: friction before entry followed by normal use. A proposed per-app maximum foreground duration is different from both existing modes and cannot share their product promises or enforcement model.

## Decision

Product-facing terminology defines three separate concepts:

- **Mindful Opening:** friction before entry. It may use a countdown and an optional intention, then admits the app. It does not measure or limit time inside the app.
- **Temporary Block / Block apps now:** selected apps are unavailable between fixed start and end timestamps. Its countdown starts when the user starts blocking, and it provides no usage allowance.
- **Usage Limit:** a future per-app foreground allowance per opening. It is approved for PR-006 but is not implemented or advertised as available in PR-005.2.

The existing persistence keys, native session snapshot, `DetoxSession`, timestamps, package matching, Accessibility event handling, strict precedence, and recovery behavior remain unchanged. This terminology change requires no migration.

Usage Limit is opt-in per app and globally off by default. No package receives a limit silently. When the user explicitly enables a limit, 15 minutes is only the suggested initial selection. Critical and recovery apps must be excluded or warned about.

Android cannot reliably force-stop another application. When a future allowance expires, Phone Detox will return Home and apply an explicit reopening consequence. It will not claim to close, kill, or force-stop the target process.

## Consequences

The setup UI explicitly says selected apps become completely unavailable, labels its three steps, hides custom duration until requested, explains the outcome dynamically, and exposes one prioritized reason when starting is unavailable. Active and exit UI consistently uses block terminology. Settings describes only the two implemented modes.

PR-006 requires an independent architecture, policy review, disclosure analysis, state model, persistence design, and device QA for foreground lifecycle edge cases. PR-005.2 adds no usage tracking, Usage Access, service, alarm, schedule, cooldown, budget, reminder, permission, dependency, or native enforcement change.
