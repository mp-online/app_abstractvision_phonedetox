# Google Play policy constraints

## PR-001

PR-001 requests no runtime permission or sensitive special access. Installed launchable activities are discovered through an intent-scoped `MAIN` plus `LAUNCHER` query. `QUERY_ALL_PACKAGES` is prohibited. Inventory stays in memory and is never logged or transmitted.

## Sensitive capabilities

Accessibility Service, notification access, usage access, VPN, device administration, overlays, and exact alarms require an approved feature design and a dedicated policy note before implementation.

An Accessibility Service must have a separate prominent in-app disclosure and affirmative consent before Android access is requested. Phone Detox must not claim `isAccessibilityTool=true`, prevent uninstall, obstruct settings, or prevent access from being disabled.

## User control

The user can always select another Home app, disable granted access, or uninstall Phone Detox. No feature may interfere with those recovery paths.