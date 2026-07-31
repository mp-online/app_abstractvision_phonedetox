# Architecture

Phone Detox is a Flutter-owned Android Home launcher. Kotlin is a narrow adapter for platform APIs and the event-driven enforcement service.

## Root startup and Jail Break

```text
PhoneDetoxApp -> StartupGate -> loading
                              -> activation required / unexpected role lost
                              -> launcher -> Jail Break confirmation
                              -> intentional Jail Break completion / recovery
```

`StartupController` is the single application lifecycle reconciler. On cold start and resume it queries Android's real Home-role status. On resume it reconciles Detox state, notifies a pending Jail Break operation, and then applies normal routing. Concurrent feature refreshes are coalesced. A 10-second initialization timeout becomes a retryable error; it never assumes a role.

`JailBreakController` owns immutable confirmation, cleanup, settings, waiting, completion, cancellation, and typed failure state. It stops an active Detox session before opening the existing Android Home settings fallback. A held role after resume is cancellation; a not-held role is intentional completion. Widgets do not inspect platform state.

## Boundaries

```text
Flutter screen -> Riverpod controller -> typed repository -> MethodChannel adapter
                                                     -> Kotlin platform handler

Home Activity Result -> request coordinator -> role recheck -> pending Flutter result
Home settings resume -> StartupController -> Detox reconcile -> JailBreakController
Accessibility event -> native session store -> decision engine -> GLOBAL_ACTION_HOME
```

Dart owns UI, navigation, localization, startup/product state, Jail Break coordination, consent, sessions, and Flutter preferences. Kotlin owns Home-role integration, Home activity resolution, package discovery, explicit launching, Accessibility status/settings, the minimal native enforcement snapshot, and service event handling.

Widgets and controllers never access `MethodChannel`. Native payloads are primitive, versionable, and validated at the Dart boundary.

## Channels

- `com.abstractvision.phonedetox/launcher`: app discovery, typed Home-role status/request/settings, verified current-Home opening, explicit app launch, and app details.
- `com.abstractvision.phonedetox/detox`: Accessibility status/settings and native session start, stop, retrieval.

## Android Home integration

Android 10+ uses `RoleManager.isRoleAvailable/isRoleHeld`. Older versions resolve `ACTION_MAIN` + `CATEGORY_HOME` with `MATCH_DEFAULT_ONLY`. Jail Break opens `ACTION_HOME_SETTINGS`, `ACTION_MANAGE_DEFAULT_APPS_SETTINGS`, or general Settings in that order. `openCurrentHome` runs only after a not-held check and rejects Phone Detox as the resolved target.

No process kill, boot receiver, background launch, Home-role auto-reclaim, foreground service, or polling exists.

## Persistence and Accessibility

Flutter `SharedPreferencesAsync` stores launcher, Detox, and informational startup keys in separate repositories. Android private preferences store only the minimal Detox enforcement snapshot. The service reads package names only, clears expiry on connection/event reconciliation, and never starts Flutter.

Home role and Accessibility are independent. Jail Break clears active enforcement but leaves Accessibility access under the user's Android settings control. An enabled service without an active native session performs no blocking.
