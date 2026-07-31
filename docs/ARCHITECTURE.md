# Architecture

Phone Detox is a Flutter-owned Android Home launcher. Kotlin is a narrow adapter for platform APIs and event-driven enforcement.

## Root coordination

`StartupController` is the only lifecycle reconciler. After Android confirms Phone Detox still holds Home, it reconciles Detox, launcher inventory, Mindful rules, native synchronization, and a valid pending request in that order. Root routing prioritizes activation/recovery and Jail Break over a temporary Mindful screen.

## Boundaries and channels

Flutter owns UI, product rules, settings, intentions, sessions, startup, Jail Break, and SharedPreferences. Kotlin owns Home resolution, launchable inventory, explicit launching, special-access status, native enforcement snapshots, and Accessibility event adaptation.

- `com.abstractvision.phonedetox/launcher`: discovery, Home role/settings, explicit launch.
- `com.abstractvision.phonedetox/detox`: Accessibility state and strict session snapshot.
- `com.abstractvision.phonedetox/mindful`: versioned rules, pending request, and admission.

Widgets never call channels. Typed repositories validate primitive payloads.

## Foreground enforcement

`PhoneDetoxAccessibilityService` initializes all stores before reading them, reads only `event.packageName`, debounces repeated events, resolves current Home, and delegates product decisions. `ForegroundDecisionEngine` applies critical-surface allow, strict Detox, admission, then Mindful precedence. A Mindful request is committed before `GLOBAL_ACTION_HOME`; persistence failure allows the target.

Native rules contain package, mode, and delay. A request contains package/source/mode and UTC deadlines. Admission contains package and UTC grant/expiry. Intention text and behavioral history never cross the Flutter boundary or persist.

No process kill, boot receiver, background launch, foreground service, polling, Usage Access, overlay, VPN, or Home-role reclaim exists.
