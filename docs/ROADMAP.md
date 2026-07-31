# Delivery roadmap

1. **PR-001 — Launcher foundation:** implemented.
2. **PR-002 — Active temporary blocking:** implemented in code; device QA remains.
3. **PR-003 — Home-role activation and startup:** implemented in code; OEM/reboot QA remains.
4. **PR-004 — Jail Break and Home-role exit:** implemented in code; OEM QA remains.
5. **PR-005 — Mindful Opening:** implemented in code; device and external-intent QA remains.
6. **PR-005.1 — Mindful admission-loop fix:** implemented in code; live regression QA remains.
7. **PR-005.2 — Detox terminology and UX clarity:** presentation, localization, tests, and product-mode documentation; device QA remains.
8. **PR-006 — Per-app usage limits:** approved, not implemented. Opt-in per app, off by default, with 15 minutes suggested only after enabling. See `PRODUCT_MODES.md` and ADR 0006.
9. **PR-007 — Focus schedules.**
10. **PR-008 — Folders and launcher organization.**
11. **PR-009 — Daily budgets and in-app reminders.**
12. **PR-010 — Notification filtering.**
13. **PR-011 — Local insights and deletion controls.**
14. **PR-012 — €7.99 lifetime Google Play entitlement.**

Website blocking remains an investigation. It is not committed until an implementation preserves the current privacy boundary.

## PR-006 Usage Limits

Implemented scope: global opt-in, per-app fixed presets, disclosure v3, continuous-foreground timing, screen-off pause, reached reopening lock, root Time-up choices, Settings/launcher management, Jail Break and strict-block cleanup, local persistence, and native/Dart tests.

Deferred: daily budgets, cumulative totals, historical charts, cross-device sync, notifications, background timing guarantees, and custom durations.
