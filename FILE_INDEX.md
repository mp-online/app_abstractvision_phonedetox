# File Index

## Handoff

- `CODEX_HANDOFF.md` — ordered execution instructions for Codex.
- `PR_DESCRIPTION.md` — paste-ready PR scope, acceptance criteria, QA, risks, and rollback.
- `AGENTS.md` — persistent repository rules for future coding agents.
- `README.md` — developer bootstrap and current behaviour.

## Product and engineering documentation

- `docs/PRODUCT.md` — product promise, target user, principles, and commercial baseline.
- `docs/ARCHITECTURE.md` — Flutter/Kotlin boundary and persistence rules.
- `docs/ROADMAP.md` — sequential PR plan through blocking, insights, notifications, and billing.
- `docs/PLAY_POLICY.md` — sensitive-capability constraints and disclosure requirements.
- `docs/adr/0001-flutter-kotlin-boundary.md` — architecture decision record.

## Implemented Flutter source

- `lib/main.dart` — ProviderScope bootstrap.
- `lib/app/phone_detox_app.dart` — localized Material application.
- `lib/core/theme/app_theme.dart` — monochrome system theme.
- `lib/core/widgets/clock_header.dart` — localized time/date header.
- `lib/features/launcher/` — app model, platform repository, state, controller, screen, tiles.
- `lib/features/settings/` — asynchronous local preferences and settings screen.
- `lib/l10n/` — English/German ARB resources with metadata.

## Implemented Android source

- `android/app/src/main/AndroidManifest.xml` — Launcher/Home registration and narrow app visibility.
- `android/app/src/main/kotlin/com/abstractvision/phonedetox/MainActivity.kt` — first-party platform bridge.
- `android/app/src/main/res/values*/strings.xml` — Android app label resources.

## Tests

- `test/features/launcher/launcher_state_test.dart`
- `test/features/launcher/launcher_controller_test.dart`
- `test/widget_test.dart`
