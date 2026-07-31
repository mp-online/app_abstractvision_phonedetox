# Phone Detox — Agent Instructions

## Mission

Build an Android-first, privacy-first screen-time reduction product. Flutter owns the user experience and reusable business logic. Kotlin is used only where Android platform APIs are required.

The first product is a functional replacement Home launcher, not a mock UI.

The active milestone includes optional, prominently disclosed Accessibility-based blocking for user-selected timed sessions. The service observes package names only, cannot retrieve window content, and must preserve all user recovery paths.

## Read first

Before modifying code, read:

1. `PR_DESCRIPTION.md`
2. `docs/ARCHITECTURE.md`
3. `docs/ROADMAP.md`
4. `docs/PLAY_POLICY.md`
5. Relevant ADRs under `docs/adr/`

## Product principles

- Reduce unconscious phone use by adding deliberate friction.
- Preserve useful smartphone capabilities.
- Prefer one-time payment over subscription.
- No account for the Android MVP.
- No advertisements.
- No analytics or network calls by default.
- Store user configuration locally.
- Ask only for capabilities that are necessary for an active user-facing feature.
- Never make an app impossible to uninstall or a permission impossible to disable.

## Architecture boundaries

- Flutter is the primary architecture.
- Dart owns UI, navigation, state, settings, schedules, purchase entitlement, and product rules.
- Kotlin owns Android Home-role integration, package discovery, explicit app launching, special-access status, and Android services.
- Access Kotlin through small typed repository interfaces. Do not call `MethodChannel` directly from widgets or controllers.
- Do not introduce a third-party installed-app/launcher plugin unless native implementation is proven insufficient and the dependency passes a security and maintenance review.
- Keep native payloads primitive and versionable: strings, booleans, numbers, lists, and maps.

## Dependency policy

- Keep dependencies minimal.
- Every new runtime dependency requires a short justification in the PR description.
- Prefer Flutter/Dart SDK APIs over packages.
- Do not add Drift until durable event/history data actually exists.
- Do not add routing libraries while `Navigator` is sufficient.
- Do not add code generation for Riverpod.
- Add Google Play Billing only in the monetization PR.

## Android permissions and policy

- Do not add `QUERY_ALL_PACKAGES`. Discover launchable apps through a `MAIN` + `LAUNCHER` query.
- Do not add an Accessibility Service in an unrelated PR.
- Do not set `isAccessibilityTool=true`; Phone Detox is not primarily an accessibility product.
- Before adding Accessibility Service, implement a separate, prominent in-app disclosure and affirmative consent flow.
- Do not add notification access, usage access, VPN, device-admin, overlay, or exact-alarm capabilities without an approved feature design and policy note.
- Never collect or transmit installed-app inventory.
- Do not use Accessibility APIs to prevent uninstalling, changing settings, or disabling Phone Detox.
- Keep Accessibility event handling package-name-only. Never access event sources, node trees, text, content descriptions, notifications, or user content.
- Keep all safe package exemptions centralized in the Detox decision engine.

## Flutter conventions

- Use feature-first folders under `lib/features/`.
- Separate `domain`, `data`, and `presentation` where a feature crosses platform or persistence boundaries.
- Use Riverpod Notifiers for mutable feature state.
- Widgets must not know about `MethodChannel`.
- Keep widgets small and prefer immutable state.
- Handle loading, empty, error, and success states.
- Avoid `dynamic`; validate platform payloads at the boundary.
- Respect system text scaling and do not clamp accessibility font sizes without a documented reason.
- Use Material 3 and system light/dark mode.

## Localization

- Never hard-code user-facing text in Dart widgets.
- English is the template and fallback locale.
- Add every new key to every supported ARB file.
- Use descriptive, feature-oriented lower-camel-case keys.
- Add `@key` metadata with a concrete description for every ARB key.
- Use placeholders for dynamic values instead of string concatenation.
- Run `flutter gen-l10n` after editing ARB files.
- Never manually edit generated localization Dart files.

## Native Android conventions

- Kotlin package: `com.abstractvision.phonedetox` unless explicitly changed before release.
- Keep `MainActivity` thin. Extract services or adapters when a native feature exceeds roughly 150 lines.
- Return structured Flutter errors with stable error codes.
- Use explicit intents to launch the exact activity returned during discovery.
- Exclude Phone Detox itself from the app list.
- Keep the Home and Launcher intent filters separate.
- Test role selection and app launching on at least Pixel and Samsung devices.

## Testing

For every change:

```bash
flutter pub get
flutter gen-l10n
flutter analyze --no-pub
flutter test --no-pub
```

For Android-native changes also run:

```bash
flutter build apk --debug
```

Add tests for:

- sorting and filtering rules
- persistence transformations
- controller state transitions
- disclosure/consent gates
- schedule evaluation
- purchase entitlement decisions

Manual launcher QA is required because Home-role behavior cannot be validated by widget tests alone.

## Definition of done

A change is complete only when:

- acceptance criteria are met
- no unnecessary permission or dependency was added
- localization metadata is complete
- failure and empty states exist
- tests cover product rules
- Android behavior was manually verified when applicable
- documentation reflects any new platform capability
