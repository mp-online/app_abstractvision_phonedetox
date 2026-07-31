# File Index

## Handoff and policy

- `PR_DESCRIPTION.md` — PR-002 scope, verified acceptance status, QA matrix, and restrictions.
- `CODEX_HANDOFF.md` — verification and manual-device handoff.
- `AGENTS.md` — persistent repository constraints.
- `docs/ARCHITECTURE.md` — Flutter/Kotlin ownership, channels, persistence, and enforcement flow.
- `docs/PLAY_POLICY.md` — Accessibility disclosure, data limits, prohibited expansion, and Play work.
- `docs/ROADMAP.md` — PR-002 active milestone and later work.
- `docs/adr/0001-flutter-kotlin-boundary.md` — platform-boundary decision.
- `docs/adr/0002-accessibility-based-detox-enforcement.md` — enforcement and policy decision.

## Flutter source

- `lib/features/launcher/` — component discovery, launcher state/UI, package-aware launch decisions.
- `lib/features/settings/` — launcher preferences and hidden-app settings.
- `lib/features/detox/domain/` — immutable session, typed repositories, Accessibility status.
- `lib/features/detox/data/` — MethodChannel and `SharedPreferencesAsync` adapters.
- `lib/features/detox/presentation/` — setup, package selection, disclosure, active countdown, exit flows, controller/state.
- `lib/l10n/` — generated English/German localization sourced from ARB files with metadata.

## Android source

- `MainActivity.kt` — thin channel registration owner.
- `launcher/LauncherPlatformHandler.kt` — launcher-specific Android adapter.
- `detox/DetoxPlatformHandler.kt` — Detox channel and Accessibility status/settings.
- `detox/DetoxSessionSnapshot.kt` and `DetoxSessionStore.kt` — validated native enforcement persistence.
- `detox/DetoxDecisionEngine.kt` — pure block/allow/expiry decision and safe exemptions.
- `detox/PhoneDetoxAccessibilityService.kt` — package-only event enforcement.
- `res/xml/phone_detox_accessibility_service.xml` — minimal Accessibility event configuration.

## Tests

- `test/features/detox/` — session, controller, and Detox widget coverage.
- `test/features/launcher/` — sorting, filtering, persistence transitions, and launch decisions.
- `android/app/src/test/.../detox/` — decision engine and snapshot validation.
