# Codex handoff — PR-005.2

PR-005.2 clarifies the existing Detox feature as a strict temporary block without changing enforcement.

## Product semantics

1. Mindful Opening pauses before entry and does not measure in-app duration.
2. Block apps now makes selected packages unavailable between fixed start/end timestamps.
3. Usage Limit is approved for PR-006 but does not exist in the product yet. It is per-app opt-in, off by default, and suggests 15 minutes only after enabling.

See `docs/PRODUCT_MODES.md` and `docs/adr/0006-detox-terminology-and-usage-limit-direction.md`.

## Implementation notes

- `DetoxStartBlocker` centralizes the single disabled reason.
- Presets remain 15/30/60/120 minutes; Custom reveals the 5-minute-to-8-hour field.
- The same `DetoxSession` is created with unchanged selected packages and timestamps.
- Launcher strict-block precedence over Mindful Opening is unchanged.
- No Kotlin, permission, dependency, or persistence schema changed.

## Verification boundary

Analyzer, 76 Flutter tests, Kotlin unit tests, and the debug APK build pass; details are in `PR_DESCRIPTION.md`. Do not claim empty-state, five-minute live blocking, Mindful-versus-duration, Pixel, Samsung, older Android, TalkBack, Home-button, reboot, deep-link, or active-enforcement QA without actual device evidence.
