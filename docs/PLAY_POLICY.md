# Google Play policy constraints

## Current capabilities

Phone Detox is a Home launcher with optional Accessibility-based blocking for user-selected timed sessions. Android Home-role assignment and removal require explicit system confirmation and remain reversible through default-app settings. Phone Detox does not silently assign or remove a Home role.

Jail Break is always visible in the launcher header and redundantly available in Settings. It ends active enforcement, then opens Android's Home-app settings so the user can select another launcher. Cleanup failure preserves links to Home settings and Accessibility settings. Intentional exit never obstructs selecting another launcher, disabling special access, or uninstalling.

Home activation and Accessibility are separate. Startup never opens Accessibility Settings. Before Accessibility Settings opens, a prominent disclosure explains package-only observation, blocking behavior, excluded information, local processing, and reversible controls. Jail Break does not disable Accessibility programmatically; without an active native session, no blocking occurs.

## Data handling

Launchable-app inventory, Home-role state, and foreground package information remain on device and are never logged or transmitted. There is no account, analytics, tracking, crash-reporting SDK, network client, or backend. Discovery remains an intent-scoped `MAIN` + `LAUNCHER` query; `QUERY_ALL_PACKAGES` is prohibited.

The Accessibility Service cannot retrieve window content and uses only `event.packageName`. It never accesses nodes, text, passwords, messages, browser content, notifications, images, contacts, or files.

## Prohibited expansion

Do not add Usage Access, notification access, VPN, device administration, overlays, exact alarms, foreground services, boot receivers, background activity launching, background polling, OEM autostart permissions, battery-exemption requests, uninstall prevention, Settings obstruction, Accessibility-disable prevention, or Home-role auto-reclaim without a separate approved design and policy review.

## User control and Play review

Users can choose another Home app through Jail Break or Android settings, cancel Home activation, end a session, use emergency exit, disable Accessibility, restore Phone Detox later, or uninstall it. Play Console Accessibility declarations, the store listing, and reviewer instructions must accurately describe optional app blocking and local package processing before release.
