# Google Play policy constraints

Phone Detox is a replacement Home launcher with optional, prominently disclosed Accessibility-based enforcement for strict Detox sessions and configured Mindful Opening apps. Home assignment and exit remain explicit Android choices; Jail Break clears active enforcement before opening Home settings.

Disclosure version 2 explains that the service may observe the foreground package to enforce Detox, detect a configured Mindful app, and return Home for its pause. Version-one consent does not enable external Mindful interception. The service never retrieves nodes, screen text, typed text, passwords, messages, browser content, notifications, images, contacts, files, URLs, or original intents.

External interception runs only while Phone Detox resolves as Home. Otherwise stale requests are cleared and apps are allowed. Processing is local; package inventory and foreground packages are neither logged nor transmitted. There is no account, analytics, tracking, crash SDK, network client, advertising, or backend.

Do not add broad package visibility, Usage Access, notification access, VPN, device administration, overlays, exact alarms, foreground services, boot receivers, background launches, polling, OEM autostart/battery exemptions, uninstall prevention, Settings obstruction, Accessibility-disable prevention, or Home-role reclaim without a separate approved design and policy review.
