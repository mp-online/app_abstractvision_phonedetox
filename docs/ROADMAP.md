# Delivery roadmap

Each milestone is independently reviewable and preserves `PLAY_POLICY.md`.

1. **PR-001 — Launcher foundation:** implemented; Home qualification, discovery/launch, search, favourites, hiding, persistence, localization, and tests.
2. **PR-002 — Active Detox sessions and app blocking:** implemented in code; manual Pixel/Samsung/reboot enforcement QA remains incomplete.
3. **PR-003 — Default launcher activation and reboot readiness:** active milestone; typed Home-role flow, first-run setup, root startup, revocation recovery, and OEM/reboot QA.
4. **PR-004 — Focus schedules:** local schedule model and deterministic evaluation.
5. **PR-005 — Local insights:** optional on-device summaries with deletion controls; no telemetry.
6. **PR-006 — Optional notification controls:** separate design and disclosure only if approved.
7. **PR-007 — Lifetime billing:** one-time Google Play entitlement; no subscription.

Later capabilities must not be pulled into PR-003. Schedules, insights, notification control, and billing remain out of scope.
