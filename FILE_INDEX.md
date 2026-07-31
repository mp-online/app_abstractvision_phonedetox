# File Index

## Handoff and policy

- `PR_DESCRIPTION.md` — PR-003 scope, automated verification, remaining device QA, and restrictions.
- `CODEX_HANDOFF.md` — exact verification and manual-device handoff.
- `AGENTS.md` — persistent repository and PR-003 startup constraints.
- `docs/ARCHITECTURE.md` — root startup, Flutter/Kotlin ownership, channels, persistence, and enforcement.
- `docs/PLAY_POLICY.md` — Home-role and Accessibility policy boundaries.
- `docs/ROADMAP.md` — PR-003 activation milestone and later work.
- `docs/adr/0001-flutter-kotlin-boundary.md` — platform boundary.
- `docs/adr/0002-accessibility-based-detox-enforcement.md` — optional blocking enforcement.
- `docs/adr/0003-home-role-activation-and-startup.md` — OS-authoritative Home activation and reboot model.

## Flutter source

- `lib/features/startup/domain/` — immutable startup state/status and dedicated preferences contract.
- `lib/features/startup/data/` — informational `SharedPreferencesAsync` adapter.
- `lib/features/startup/presentation/` — root lifecycle coordinator, gate, activation, role-lost, loading, unavailable, and error surfaces.
- `lib/features/launcher/domain/home_role_*.dart` — typed status and request-result wire models.
- `lib/features/launcher/` — component discovery, launcher state/UI, typed platform adapter, and launch decisions.
- `lib/features/detox/` — optional disclosure, package selection, session state, and enforcement reconciliation.
- `lib/l10n/` — generated English/German localization sourced from metadata-complete ARB files.

## Android source

- `MainActivity.kt` — thin Activity Result registration and channel owner.
- `launcher/AndroidHomeRoleGateway.kt` — Android 10+ RoleManager and older resolved-Home/status settings fallback.
- `launcher/HomeRoleRequestCoordinator.kt` — single pending request and post-result role recheck.
- `launcher/LauncherPlatformHandler.kt` — primitive/versioned launcher MethodChannel adapter.
- `detox/PhoneDetoxAccessibilityService.kt` — Android-owned package-only enforcement service with connect-time expiry cleanup.

## Tests

- `test/features/startup/` — state, controller, lifecycle, concurrency, localization, and large-text coverage.
- `test/features/launcher/` — wire parsing, sorting/filtering, persistence transitions, and launch decisions.
- `test/features/detox/` — session, controller, and widget regression coverage.
- `android/app/src/test/.../launcher/` — Home-role request coordinator decisions.
- `android/app/src/test/.../detox/` — decision engine and snapshot validation.
