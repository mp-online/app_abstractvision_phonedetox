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

## Active PR-003 startup constraints

- Android's current Home-role state is authoritative; persisted onboarding flags are informational only.
- First run and role-revocation recovery belong to the root Flutter startup coordinator.
- Home-role requests must use Activity Result completion and recheck the role before reporting success.
- Only one native Home-role request may be pending.
- Centralize cold-start/resume reconciliation; do not add overlapping screen lifecycle observers.
- Home activation and optional Accessibility setup must remain separate explicit user actions.
- Do not add a boot receiver, boot permission, background activity launch, foreground service, polling, alarms, OEM autostart settings, or battery exemption.
- Reboot readiness means Android resolves the selected Home app after restart and unlock.
- Do not claim Pixel, Samsung, older-Android, Home-button, reboot, revocation, or Detox device QA without actual execution evidence.
- See `docs/adr/0003-home-role-activation-and-startup.md` for the accepted decision.

## Active PR-004 Jail Break constraints

- Jail Break must remain visible in the launcher header and redundantly available in Settings.
- Android Home-app settings and an authoritative resume role check are required; never claim the app removes its own Home role.
- Stop active native and Flutter Detox session state before opening Home settings, while preserving Home and Accessibility recovery actions if cleanup fails.
- Do not disable Accessibility programmatically; an enabled service without an active native session performs no blocking.
- StartupController remains the only lifecycle observer and distinguishes intentional Jail Break from unexpected role loss.
- Do not add a second platform channel, process kill, background activity launch, Home-role auto-reclaim, permission, or service for Jail Break.
- Do not claim Pixel, Samsung, older-Android, TalkBack, Home-button, or active-enforcement QA without execution evidence.
- See `docs/adr/0004-jail-break-and-home-role-exit.md`.


## Active PR-005 Mindful Opening constraints

- Strict Detox hard blocks always precede Mindful Opening.
- External Mindful interception requires disclosure version 2 and Phone Detox as current Home.
- Accessibility handling remains package-name-only; never inspect nodes, content, notifications, URLs, or original intents.
- Persist rules, one temporary request, and one temporary admission only. Never persist intentions or behavioral history.
- Admission ends on meaningful package transitions and survives keyboards/System UI/permission surfaces.
- Admission schema v2 has AWAITING_TARGET and ACTIVE phases; awaiting preserves Phone Detox and transient surfaces, activates on the target, and expires after 15 seconds.
- Clear the pending request before granting admission immediately before launch; launch failure clears admission.
- Mindful Opening controls app entry only. In-app reminders and daily budgets remain PR-008 work.
- Jail Break and global disable clear request/admission but preserve configured rules.
- Do not claim external deep-link restoration or device QA without execution evidence.
- Do not add Usage Access, notification access, overlay, VPN, foreground service, boot receiver, billing, subscription, analytics, network communication, or a backend.
- See `docs/adr/0005-mindful-opening-and-admission.md`.
## Active PR-005.2 terminology constraints

- Product-facing Detox setup is **Block apps now**: selected apps are completely unavailable between fixed start and end timestamps.
- Mindful Opening is friction before entry and never implies a time allowance inside an app.
- Usage Limit is approved for PR-006 only. Do not advertise or implement it in PR-005.2.
- Future Usage Limit is opt-in per app, off by default, and suggests 15 minutes only after explicit enablement.
- Never claim Android force-stops another app; future expiry returns Home and applies an explicit reopening consequence.
- Do not rename `DetoxSession`, persistence keys, or native session models for presentation terminology.
- PR-005.2 must not change native enforcement, Accessibility event handling, package matching, timestamps, precedence, expiry, Mindful admission, Home-role behavior, or Jail Break recovery.
