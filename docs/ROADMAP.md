# Delivery roadmap

Each milestone is independently reviewable and preserves `PLAY_POLICY.md`.

1. **PR-001 — Launcher foundation:** implemented; Home role, app discovery/launch, search, favourites, hiding, persistence, localization, and tests.
2. **PR-002 — Active Detox sessions and Android app blocking:** active implementation milestone; package selection, duration, prominent disclosure, local session recovery, direct-launch prevention, and Accessibility-based enforcement.
3. **PR-003 — Focus schedules:** local schedule model and deterministic schedule evaluation.
4. **PR-004 — Local insights:** optional on-device summaries with deletion controls; no telemetry.
5. **PR-005 — Optional notification controls:** separate design and disclosure only if approved.
6. **PR-006 — Lifetime billing:** Google Play Billing for a one-time entitlement; no subscription.

Later capabilities must not be pulled into earlier milestones. Schedules, statistics, notification control, and billing are not part of PR-002.
