# Architecture

Phone Detox is a Flutter-owned Android Home launcher. Kotlin is a narrow adapter for platform APIs and the event-driven enforcement service.

## Root startup

```text
PhoneDetoxApp -> StartupGate -> loading
                              -> activation required / role lost
                              -> unavailable / recoverable error
                              -> LauncherScreen
```

`StartupController` is the single application lifecycle reconciler. On cold start and resume it queries Android's real Home-role status. When held, it refreshes Detox recovery and launchable apps before exposing the launcher. Concurrent feature refreshes are coalesced. A 10-second initialization timeout becomes a retryable error; it never assumes a role.

`startup.hasSeenLauncherExplanation` and `startup.hasCompletedLauncherActivation` describe prior UX only. Android role state always wins.

## Boundaries

```text
Flutter screen -> Riverpod controller -> typed repository -> MethodChannel adapter
                                                     -> Kotlin platform handler

Home Activity Result -> request coordinator -> role recheck -> pending Flutter result
Accessibility event -> native session store -> decision engine -> GLOBAL_ACTION_HOME
```

Dart owns UI, navigation, localization, startup/product state, consent, sessions, and Flutter preferences. Kotlin owns Home-role integration, package discovery, explicit launching, Accessibility status/settings, the minimal native enforcement snapshot, and service event handling.

Widgets and controllers never access `MethodChannel`. Native payloads are primitive, versionable, and validated at the Dart boundary.

## Channels

- `com.abstractvision.phonedetox/launcher`: app discovery, typed Home-role status/request/settings, explicit launch, app details.
- `com.abstractvision.phonedetox/detox`: Accessibility status/settings and native session start, stop, retrieval.

## Android Home integration

Android 10+ uses `RoleManager.isRoleAvailable/isRoleHeld`. Older versions resolve `ACTION_MAIN` + `CATEGORY_HOME` with `MATCH_DEFAULT_ONLY`. `MainActivity` uses the Activity Result-capable Flutter host, registers early, and delegates all decisions. Only one request can hold a channel callback; activity destruction completes and clears it safely.

No boot receiver or background launch exists. Android resolves the selected Home application after Home navigation and restart/unlock.

## Persistence and Accessibility

Flutter `SharedPreferencesAsync` stores launcher, Detox, and informational startup keys in separate repositories. Android private preferences store only the minimal Detox enforcement snapshot. The service reads package names only, clears expiry on connection/event reconciliation, and never starts Flutter.

Home role and Accessibility are independent. Accessibility is optional, prominently disclosed, and never opened by startup activation.
