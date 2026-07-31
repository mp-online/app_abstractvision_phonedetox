# ADR 0002: Accessibility-based detox enforcement

- Status: Accepted
- Date: 2026-07-31

## Context

Phone Detox must enforce an active, user-configured block list when Flutter is not visible, after process death, through Recents and deep links, and after device restart. Android does not provide a narrow dedicated app-blocking API.

## Decision

Use an opt-in `AccessibilityService` that receives only window-state and window-change events. It reads only the foreground package name. If a locally persisted, unexpired session blocks that package, it invokes `GLOBAL_ACTION_HOME`. Because Phone Detox is the selected Home application, Android returns to its launcher.

Flutter remains the product authority for selection, consent, duration, session UI, and recovery. Kotlin persists a minimal enforcement snapshot in private Android `SharedPreferences` so the service does not depend on a Flutter engine. The native state determines whether enforcement is active during reconciliation.

## Alternatives rejected

- Usage Access was rejected because it is polling-oriented, less immediate, and exposes broader usage history than the single foreground package needed here.
- Overlays were rejected because drawing over other apps is unnecessary, adds a sensitive permission, and creates fragile interaction and policy risks.
- A foreground service was rejected because Accessibility event delivery is sufficient; no continuous work, notification, or background polling is required.
- Reopening a Flutter activity was rejected because it is visually disruptive and cannot reliably survive process death.

## Intentional data limits

The service does not retrieve window content and does not access event sources, node trees, screen text, typed text, passwords, messages, browser content, notifications, images, contacts, or files. Foreground package names and installed-app inventory remain on device and are not logged or transmitted.

## Safety and user control

Phone Detox, System UI, Settings, enabled input methods, permission/package installer surfaces, phone/emergency UI, setup, and recovery surfaces are exempt. Users can always end a session, use an immediate emergency exit, disable Accessibility access, choose another Home application, or uninstall Phone Detox.

## Google Play implications

Accessibility access is sensitive special access. Before opening Android settings, the app presents a separate prominent disclosure and requires affirmative, versioned consent. Store listing and Play Console declarations must accurately describe app-blocking use, data handling, and user controls. Phone Detox does not declare itself an accessibility tool and does not set `isAccessibilityTool=true`.
