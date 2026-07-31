# Google Play policy constraints

## Current capabilities

Phone Detox is a Home launcher with optional Accessibility-based blocking for user-selected timed sessions. Android Home-role assignment requires explicit system confirmation and remains reversible through default-app settings. The app does not silently assign itself, launch after boot from a receiver, or obstruct selecting another launcher or uninstalling.

Home activation and Accessibility are separate. Startup never opens Accessibility Settings. Before Accessibility Settings opens, a prominent disclosure explains package-only observation, blocking behavior, excluded information, local processing, and reversible controls.

## Data handling

Launchable-app inventory, Home-role state, and foreground package information remain on device and are never logged or transmitted. There is no account, analytics, tracking, crash-reporting SDK, network client, or backend. Discovery remains an intent-scoped `MAIN` + `LAUNCHER` query; `QUERY_ALL_PACKAGES` is prohibited.

The Accessibility Service cannot retrieve window content and uses only `event.packageName`. It never accesses nodes, text, passwords, messages, browser content, notifications, images, contacts, or files.

## Prohibited expansion

Do not add Usage Access, notification access, VPN, device administration, overlays, exact alarms, foreground services, boot receivers, background activity launching, background polling, OEM autostart permissions, battery-exemption requests, uninstall prevention, Settings obstruction, or Accessibility-disable prevention without a separate approved design and policy review.

## User control and Play review

Users can choose another Home app, cancel Home activation, end a session, use emergency exit, disable Accessibility, or uninstall Phone Detox. Play Console Accessibility declarations, the store listing, and reviewer instructions must accurately describe optional app blocking and local package processing before release.
