# File Index

- `PR_DESCRIPTION.md` — PR-005.1 admission-race patch and evidence status.
- `CODEX_HANDOFF.md` — automated and manual QA handoff.
- `docs/COMMERCIAL_PRINCIPLES.md` — permanent no-subscription/no-ad/account and €7.99 lifetime ceiling.
- `docs/adr/0005-mindful-opening-and-admission.md` — package-only detection, two-phase admission, 15-second target deadline, and Home safety.
- `lib/features/mindful_opening/domain/` — immutable rules, requests, sources, repositories, and safe-package policy.
- `lib/features/mindful_opening/data/` — SharedPreferences and typed MethodChannel adapters.
- `lib/features/mindful_opening/presentation/` — controller/state, pause screen, editor, and management.
- `android/app/src/main/kotlin/com/abstractvision/phonedetox/mindful/` — native models, stores, and platform handler.
- `android/app/src/main/kotlin/com/abstractvision/phonedetox/foreground/` — package classifier, Home resolver, decisions, and pure engine.
- `detox/PhoneDetoxAccessibilityService.kt` — thin package-only event adapter with initialized stores.
- `test/features/mindful_opening/` and Android `foreground` tests — controller launch ordering, localized settings behavior, schema migration, phase transitions, and the admission-loop regression.
## PR-005.2 product clarity

- `lib/features/detox/presentation/detox_state.dart` — typed start-blocker priority and deliberate custom-duration state.
- `lib/features/detox/presentation/detox_setup_screen.dart` — three-step Block apps now setup, dynamic explanation/action, and one disabled reason.
- `lib/features/detox/presentation/detox_app_selection_screen.dart` — explicit Apps to block selection and Done action.
- `lib/features/detox/presentation/detox_active_screen.dart` — active-block countdown and recovery terminology.
- `docs/PRODUCT_MODES.md` — authoritative separation of Mindful Opening, Temporary Block, and future Usage Limit.
- `docs/adr/0006-detox-terminology-and-usage-limit-direction.md` — accepted terminology and PR-006 direction.
