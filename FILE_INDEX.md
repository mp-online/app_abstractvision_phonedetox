# File Index

## Handoff and policy

- `PR_DESCRIPTION.md` — PR-004 scope, automated acceptance, remaining device QA, and restrictions.
- `CODEX_HANDOFF.md` — exact verification and manual-device handoff.
- `AGENTS.md` — persistent repository, PR-003 startup, and PR-004 recovery constraints.
- `docs/ARCHITECTURE.md` — root startup, Jail Break coordination, Flutter/Kotlin ownership, channels, and enforcement.
- `docs/PLAY_POLICY.md` — Home-role exit and Accessibility policy boundaries.
- `docs/ROADMAP.md` — PR-001 through PR-008 sequence.
- `docs/adr/0001-flutter-kotlin-boundary.md` — platform boundary.
- `docs/adr/0002-accessibility-based-detox-enforcement.md` — optional blocking enforcement.
- `docs/adr/0003-home-role-activation-and-startup.md` — OS-authoritative activation and reboot model.
- `docs/adr/0004-jail-break-and-home-role-exit.md` — explicit Home selection, enforcement cleanup, and intentional exit.

## Flutter source

- `lib/features/jail_break/domain/` — immutable status, failure, and result models.
- `lib/features/jail_break/presentation/` — shared coordinator, confirmation/recovery dialog, and neutral completion screen.
- `lib/features/startup/` — the sole lifecycle reconciler, typed loss reason, and root routing.
- `lib/features/launcher/` — header entry point, component discovery, typed platform adapter, and verified current-Home opening.
- `lib/features/settings/` — hidden-app management and redundant Jail Break recovery action.
- `lib/features/detox/` — optional disclosure, package selection, session state, enforcement cleanup, and reconciliation.
- `lib/l10n/` — metadata-complete English/German ARB sources and generated localization.

## Android source

- `launcher/AndroidHomeRoleGateway.kt` — role status, OEM settings fallback, and guarded explicit current-Home launch.
- `launcher/LauncherPlatformHandler.kt` — existing launcher channel including `openCurrentHome`.
- `detox/PhoneDetoxAccessibilityService.kt` — package-only enforcement; inactive without a native session.

## Tests

- `test/features/jail_break/` — coordinator sequencing, duplicate suppression, failures, UI, localization, and accessibility layout.
- `test/features/startup/jail_break_startup_test.dart` — intentional/cancelled/unexpected role-loss regression.
- Existing launcher, Detox, startup, and Android unit suites remain regression coverage.
