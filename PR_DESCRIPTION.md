# PR-001 â€” Android Launcher Foundation

## Summary

Create the first functional Phone Detox product slice: an Android replacement launcher implemented primarily in Flutter with a narrow Kotlin platform bridge.

This PR intentionally avoids high-risk Android capabilities. It does not add Accessibility Service, notification access, usage access, broad package visibility, analytics, accounts, backend communication, or billing.

## Why

Phone Detox needs a product core before adding behavioural-control features. The Home launcher is the natural base because it changes the user's default entry point into the phone without needing invasive permissions.

## User value

After this PR, a user can:

1. Install and open Phone Detox.
2. Select it as the Android default Home app.
3. See installed launchable apps as a calm text list.
4. Search and open an app.
5. Pin useful apps as favourites.
6. Hide distracting apps from the primary list.
7. Restore hidden apps from Settings.

## Scope

### Flutter

- Material 3 light/dark application shell.
- Riverpod state and repository wiring.
- Searchable launcher screen.
- Clock/date header.
- Default-launcher prompt.
- Favourite-first sorting.
- Hidden-app management.
- Local persistence through `shared_preferences`.
- English and German localization with ARB metadata.
- Unit and widget tests.

### Android/Kotlin

- Register `MainActivity` as both a normal app and eligible Home activity.
- Query activities matching `ACTION_MAIN` + `CATEGORY_LAUNCHER`.
- Return app ID, label, package name, and activity name to Dart.
- Launch an app through an explicit component intent.
- Detect whether Phone Detox is the current Home app.
- Request `RoleManager.ROLE_HOME` on Android 10+ with Settings fallback.
- Open the Android app-details page.

## Explicit non-goals

- No app blocking.
- No opening delay or session timer.
- No Accessibility Service.
- No notification filtering.
- No usage statistics.
- No Screen Time dashboard.
- No subscriptions or lifetime purchase.
- No cloud sync, login, backend, telemetry, crash reporting, or remote configuration.
- No iOS, macOS, web, Windows, or Linux target.
- No app icons inside the launcher list.

## Dependency decision

Runtime baseline:

- Flutter 3.35+ / Dart 3.9+ and Android minSdk 24 because `shared_preferences` 2.5.5 requires that baseline.
- `intl: any` so Flutter localizations selects its SDK-pinned compatible version.

Keep:

- `flutter_riverpod`: application state and replaceable repositories.
- `shared_preferences`: small, non-critical local sets for favourite/hidden app IDs, using the newer asynchronous API.
- `flutter_localizations`: generated localization support.

Remove for this milestone:

- `cupertino_icons`: no iOS/Cupertino UI.
- `drift`, `drift_flutter`, `drift_dev`, `sqlite3_flutter_libs`, `path`, `path_provider`: no relational or event data yet.
- `flutter_markdown_plus`, `markdown`: no rich legal/help documents yet.
- `build_runner`: no code generation in this milestone.
- `flutter_launcher_icons`: add when the final visual identity and source icon exist.

## Permission decision

Use a narrow `<queries>` declaration for launchable activities. Do not request `QUERY_ALL_PACKAGES`.

The app requests no runtime permission in this PR.

## Acceptance criteria

- [x] App builds on the team's supported Flutter stable version.
- [ ] Phone Detox appears in Android's Home-app selection.
- [ ] Pressing Home opens Phone Detox after selection.
- [x] Normal installed apps appear in alphabetical order.
- [ ] Phone Detox does not list itself.
- [ ] Tapping an entry launches the exact discovered activity.
- [x] Search matches app label and package name without case sensitivity.
- [x] Favourites sort above non-favourites.
- [x] Hidden apps disappear and can be restored.
- [ ] Preferences survive process death and device restart.
- [ ] Resuming Phone Detox refreshes app and Home-role state.
- [x] No `QUERY_ALL_PACKAGES`, Accessibility Service, usage access, or notification access exists in the manifest.
- [x] `flutter analyze --no-pub` passes.
- [x] `flutter test --no-pub` passes.
- [x] Debug APK builds.

## Manual QA matrix

### Devices

- Pixel / Android 15 or newer.
- Samsung Galaxy / current One UI.
- One older supported Android version.

### Scenarios

1. First launch before default-role selection.
2. Accept Home role and press Home repeatedly.
3. Reject/cancel Home role selection.
4. Search using mixed case.
5. Launch Settings, browser, phone, messages, camera, and a third-party app.
6. Favourite, restart, verify persistence.
7. Hide, restart, verify persistence, restore.
8. Install/uninstall another app while Phone Detox is backgrounded, then resume.
9. Rotate device and change system theme.
10. Increase Android font scale and verify no essential control becomes unreachable.

## Risks

- OEM launchers may provide slightly different Home-role flows.
- Some packages expose multiple launcher activities; the current ID is component-based so entries remain deterministic.
- A launcher can become a critical device surface. Crashes and blank states must always offer recovery through Android navigation/Settings.
- App inventory is sensitive user data; it must remain on-device and should not be logged or transmitted.

## Rollback

The user can select another default Home app through Android Settings or uninstall Phone Detox. This PR must never interfere with either action.
