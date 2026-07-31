# Architecture

## Context

Phone Detox is a Flutter application that also acts as an Android Home launcher. Flutter remains the product architecture; Kotlin is a platform adapter.

## High-level structure

```text
Flutter UI
  -> Riverpod controller
    -> domain repository interface
      -> MethodChannel repository
        -> Kotlin Android adapter
          -> PackageManager / RoleManager / Intent
```

Persistence is separate:

```text
Riverpod controller
  -> preferences repository
    -> SharedPreferencesAsync / Android DataStore Preferences
```

## Ownership

### Dart owns

- screens and interaction design
- state transitions
- sorting, filtering, favourites, hiding
- future focus schedules and launch friction
- future purchase entitlement
- localization
- user-facing error handling

### Kotlin owns

- discovery of launchable Android activities
- explicit component launching
- Home-role status and request
- Android settings intents
- future Android services and special-access status

## Boundary rules

The channel name is:

```text
com.abstractvision.phonedetox/launcher
```

PR-001 methods:

```text
getLaunchableApps() -> List<Map<String, String>>
isDefaultLauncher() -> bool
requestDefaultLauncher() -> void
launchApp(packageName, activityName) -> void
openAppDetails(packageName) -> void
```

`LauncherRepository` is the only Dart abstraction exposed to controllers. Method-channel details must stay in `PlatformLauncherRepository`.

## Data identity

An app entry is a launchable Android component, not only a package:

```text
id = packageName/activityName
```

This prevents ambiguity when one package exposes multiple launcher activities.

Do not persist labels because they can change with locale or app updates. Persist component IDs and reconcile them against current discovery results.

## Persistence

Use `SharedPreferencesAsync` while persistent data consists only of small, non-critical settings collections:

- favourite component IDs
- hidden component IDs

Add Drift later only when the app needs queryable durable records such as:

- focus sessions
- launch attempts
- daily aggregates
- schedule history
- migrations across richer schemas

## Error strategy

Kotlin returns stable platform error codes:

- `invalid_arguments`
- `activity_not_found`
- `security_exception`
- `native_failure`

Dart initially presents a generic recovery state. Add code-specific user messaging only when it creates a meaningful recovery action.

## Performance

- Query package activities asynchronously through the method channel.
- Sort/filter small lists in Dart.
- Do not load app icons in PR-001.
- Refresh on app resume to capture installs/uninstalls and Home-role changes.
- If OEM devices show slow package discovery, add an isolate/cache only after profiling.

## Security and privacy

- Installed-app inventory remains in memory and on-device.
- Persist only selected component IDs.
- Do not log package inventory in release builds.
- Do not transmit package inventory.
- Do not request broad package visibility while intent-scoped visibility works.
