# Delivery roadmap

Each milestone is independently reviewable and must preserve the privacy and policy constraints in `PLAY_POLICY.md`.

1. **PR-001 — Launcher foundation:** Home role, app discovery and launch, search, favourites, hiding, persistence, localization, and tests.
2. **PR-002 — Intentional opening:** configurable pause and conscious-choice prompt before selected apps open.
3. **PR-003 — Focus schedules:** local schedule model and deterministic schedule evaluation.
4. **PR-004 — Blocking disclosure:** prominent disclosure and affirmative consent before any Accessibility Service is introduced.
5. **PR-005 — Active blocking:** narrowly scoped Android service gated by the PR-004 consent and Play-policy review.
6. **PR-006 — Local insights:** on-device launch attempts and focus-session summaries with deletion controls.
7. **PR-007 — Optional notification controls:** separate design, disclosure, and access request only if user value is approved.
8. **PR-008 — Lifetime billing:** Google Play Billing for a €9.99 lifetime entitlement; no subscription.

Capabilities from later milestones must not be pulled into earlier PRs.