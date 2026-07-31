# Phone Detox product modes

Phone Detox uses three distinct intervention concepts. UI copy, architecture, tests, and future implementation must keep them separate.

## Mindful Opening

Mindful Opening adds friction before entry:

- A configured app pauses before opening.
- The pause uses a short countdown.
- The user may optionally choose or enter an intention.
- After confirmation, the app opens normally.
- Mindful Opening does not limit time spent inside the app.
- Intentions are transient and behavioral history is not retained.

## Temporary Block

The existing Detox implementation is a strict temporary block:

- The user selects apps and a fixed duration.
- Start and end timestamps are fixed when the user presses **Start blocking**.
- Selected apps are unavailable throughout that interval.
- The duration is not an allowance and does not begin when an app opens.
- Attempts to open a selected app return the user Home when strict blocking access is enabled.
- The user can deliberately end the block early or use the existing emergency and Jail Break recovery paths.

The internal `DetoxSession` name and persisted schema remain unchanged. Product-facing copy uses **Block apps now**, **active block**, and **Apps blocked**.

## Usage Limit ? approved, not implemented

Usage Limit is a separate future mechanism planned for PR-006:

- It is opt-in per app and disabled by default globally and per package.
- Enabling it for an app suggests 15 minutes; the suggestion is not an automatic default for installed apps.
- Initial planned presets are 5, 10, 15, 30, and 60 minutes.
- It measures one foreground-use interval per opening.
- When the allowance expires, Phone Detox returns Home and prevents immediate reopening according to an explicit consequence.
- Android cannot reliably force-stop another app, and Phone Detox must never claim that it can.
- It remains independent of Temporary Block and Mindful Opening.
- Configuration and enforcement data remain entirely local.

No critical app is configured automatically. Dialer/emergency apps, authenticators, banking apps, navigation, keyboards, Android Settings, System UI, package installers, and Phone Detox itself must be excluded or prominently warned about.

PR-006 must independently define and test foreground transitions, split-screen, picture-in-picture, screen lock and interactivity, calls, permission surfaces, custom tabs, process death, reboot, and rapid package transitions. The recommended first expiry consequence is to return Home and require Mindful Opening before reopening. Cooldowns, until-tomorrow blocks, and extensions are later options, not current behavior.
