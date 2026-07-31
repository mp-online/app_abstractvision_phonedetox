# Architecture

Phone Detox is a Flutter-owned Android Home launcher. Kotlin is a narrow adapter for platform APIs and the event-driven enforcement service.

## Boundaries

```text
Flutter screen -> Riverpod controller -> typed repository -> MethodChannel adapter
                                                     -> Kotlin platform handler

Accessibility event -> native session store -> decision engine -> GLOBAL_ACTION_HOME
```

Dart owns UI, navigation, localization, package selection, consent, durations, product state, session reconciliation, direct-launch decisions, and Flutter preferences. Kotlin owns launchable-app discovery, explicit launching, Home-role integration, Accessibility status/settings, the minimal native enforcement snapshot, and `AccessibilityService` event handling.

Widgets and controllers never access `MethodChannel`. Native payloads contain only primitive versionable values and are validated at both boundaries.

## Channels

- `com.abstractvision.phonedetox/launcher`: app discovery, Home role, explicit launch, app details.
- `com.abstractvision.phonedetox/detox`: Accessibility status/settings and native session start, stop, and retrieval.

## Identity and persistence

Launcher identity remains component-based (`packageName/activityName`). Detox identity is package-based because Accessibility events reliably expose package names; multiple components therefore deduplicate to one blocked package.

Flutter `SharedPreferencesAsync` stores `detox.blockedPackageNames`, `detox.defaultDurationMinutes`, `detox.accessibilityDisclosureVersion`, and `detox.activeSession`. Android private `SharedPreferences` named `phone_detox_native_session` stores only session ID, UTC epoch start/end, and blocked packages. Native state is authoritative for enforcement recovery; Flutter repairs its product state from native state and clears expired snapshots.

## Accessibility data boundary

The service listens only for `TYPE_WINDOW_STATE_CHANGED` and `TYPE_WINDOWS_CHANGED`, reads only `event.packageName`, and cannot retrieve window content. It never reads sources, nodes, text, content descriptions, notifications, or user content. Processing is local and no inventory or foreground-package data is transmitted.

## Recovery and safety

Exemptions are centralized in `DetoxDecisionEngine`: Phone Detox, System UI, Settings, enabled input methods, permission/package installer surfaces, phone/emergency UI, setup, and recovery surfaces. No overlay, Usage Access, foreground service, boot receiver, polling, exact alarm, device admin, VPN, or broad package visibility is used.
