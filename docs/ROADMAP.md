# Delivery roadmap

Each milestone is independently reviewable and preserves `PLAY_POLICY.md`.

1. **PR-001 — Launcher foundation:** implemented; Home qualification, discovery/launch, search, favourites, hiding, persistence, localization, and tests.
2. **PR-002 — Active Detox sessions and blocking:** implemented in code; manual Pixel/Samsung/reboot enforcement QA remains incomplete.
3. **PR-003 — Home-role activation and startup:** implemented in code; typed role flow, root startup, and revocation recovery; OEM/reboot QA remains incomplete.
4. **PR-004 — Jail Break and Home-role exit:** active milestone; always-visible recovery, active-session cleanup, Android Home selection, intentional role-loss handling, tests, and OEM QA.
5. **PR-005 — Focus schedules:** local schedule model and deterministic evaluation.
6. **PR-006 — Local insights:** optional on-device summaries with deletion controls; no telemetry.
7. **PR-007 — Optional notification controls:** separate design and disclosure only if approved.
8. **PR-008 — Lifetime billing:** one-time Google Play entitlement; no subscription.

Later capabilities must not be pulled into PR-004. Schedules, insights, notification control, and billing remain out of scope.
