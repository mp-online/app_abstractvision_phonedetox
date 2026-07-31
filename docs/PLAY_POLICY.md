# Google Play policy constraints

## Current capability

Phone Detox is a Home launcher with an optional Accessibility Service for user-selected, timed app blocking. Before Android Accessibility Settings opens, a separate prominent disclosure explains the observed foreground package, blocking behavior, excluded information, on-device processing, and reversible controls. Affirmative acceptance is persisted as disclosure version 1; access is rechecked after resume.

The service is not presented as an accessibility tool and does not set `isAccessibilityTool=true`. It listens only for window-state/window-change events, cannot retrieve window content, and uses only package names. It does not inspect text, nodes, passwords, messages, browser content, notifications, images, contacts, or files.

## Data handling

Launchable-app inventory and foreground package information remain on device and are never logged or transmitted. There is no account, analytics, tracking, crash-reporting SDK, network client, or backend. Package discovery remains an intent-scoped `MAIN` + `LAUNCHER` query; `QUERY_ALL_PACKAGES` is prohibited.

## Prohibited expansion

Do not add Usage Access, notification access, VPN, device administration, overlays, exact alarms, foreground services, boot receivers, background polling, uninstall prevention, Settings obstruction, or Accessibility-disable prevention without a separate approved feature design and policy review.

## User control and Play review

Users can end any session, use an immediate emergency exit, disable Accessibility access, choose another Home app, or uninstall Phone Detox. Play Console Accessibility declarations, the store listing, and reviewer instructions must accurately describe the app-blocking use case and disclosure flow before release.
