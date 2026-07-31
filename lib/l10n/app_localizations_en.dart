// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Phone Detox';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Open settings';

  @override
  String get searchLabel => 'Search apps';

  @override
  String get searchHint => 'Name or package';

  @override
  String get makeDefaultTitle => 'Make Phone Detox your Home app';

  @override
  String get makeDefaultBody =>
      'Choose Phone Detox when Android asks which Home app to use. You can change this at any time in system settings.';

  @override
  String get makeDefaultAction => 'Choose Home app';

  @override
  String get loadingApps => 'Loading apps…';

  @override
  String get loadAppsError =>
      'Apps could not be loaded. Android settings and navigation remain available.';

  @override
  String get retryAction => 'Retry';

  @override
  String get noApps => 'No launchable apps were found.';

  @override
  String get noSearchResults => 'No apps match your search.';

  @override
  String appActionsTitle(String appName) {
    return 'Actions for $appName';
  }

  @override
  String get favouriteAction => 'Add to favourites';

  @override
  String get unfavouriteAction => 'Remove from favourites';

  @override
  String get hideAction => 'Hide from launcher';

  @override
  String get launchFailed => 'This app could not be opened.';

  @override
  String get hiddenAppsTitle => 'Hidden apps';

  @override
  String get hiddenAppsDescription =>
      'Hidden apps stay installed and can always be restored here.';

  @override
  String get hiddenAppsEmpty => 'No apps are hidden.';

  @override
  String get restoreAction => 'Restore';

  @override
  String get detoxTooltip => 'Open Block apps now';

  @override
  String get detoxTitle => 'Block apps now';

  @override
  String get detoxLoading => 'Loading blocking settings…';

  @override
  String get detoxLoadError =>
      'Blocking settings could not be loaded. Try again.';

  @override
  String get detoxManageAppsTitle => 'Apps to block';

  @override
  String get detoxManageAppsDescription =>
      'These apps will be unavailable during an active block.';

  @override
  String get detoxNoAppsAvailable => 'No launchable apps are available.';

  @override
  String detoxSelectedApps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps selected',
      one: '1 app selected',
      zero: 'No apps selected',
    );
    return '$_temp0';
  }

  @override
  String get detoxEmptyList => 'Choose at least one app to block.';

  @override
  String get detoxDurationTitle => 'Block selected apps for';

  @override
  String detoxMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get detoxCustomDurationLabel => 'Custom block duration';

  @override
  String get detoxCustomDurationError =>
      'Enter a duration between 5 minutes and 8 hours.';

  @override
  String get detoxAccessibilityExplanation =>
      'Phone Detox can detect attempts to open selected apps and return you Home.';

  @override
  String get detoxAccessibilityEnabled => 'Strict blocking is ready';

  @override
  String get detoxAccessibilityDisabled => 'Strict blocking is not enabled';

  @override
  String get detoxAccessibilityUnavailable => 'Strict blocking is unavailable';

  @override
  String get detoxStartAction => 'Start blocking';

  @override
  String get detoxStartError =>
      'Blocking could not be started. Check blocking access and try again.';

  @override
  String get detoxAddAction => 'Add to apps to block';

  @override
  String get detoxRemoveAction => 'Remove from apps to block';

  @override
  String detoxBlockedUntil(String appName, String endTime) {
    return '$appName is unavailable until $endTime.';
  }

  @override
  String get detoxDisclosureTitle => 'How Accessibility access is used';

  @override
  String get detoxDisclosureWhatTitle => 'What access is used';

  @override
  String get detoxDisclosureWhatBody =>
      'Phone Detox observes which application package is currently visible while its Accessibility Service is enabled.';

  @override
  String get detoxDisclosureWhyTitle => 'Why it is used';

  @override
  String get detoxDisclosureWhyBody =>
      'During an active Detox session it detects selected blocked apps. It can also return you Home for Mindful Opening and, when you opt in per app, count one continuous foreground visit until its Usage Limit is reached.';

  @override
  String get detoxDisclosureNotAccessedTitle => 'What is not accessed';

  @override
  String get detoxDisclosureNotAccessedBody =>
      'Phone Detox does not read passwords, typed text, messages, screen or browser content, notifications, images, contacts, files, or Accessibility node trees.';

  @override
  String get detoxDisclosureDataTitle => 'Data handling';

  @override
  String get detoxDisclosureDataBody =>
      'Processing happens only on this device. Usage Limits store only configured rules, one current interval with remaining time and timestamps, and one reached lock. No usage history is kept. Foreground packages and installed-app information are never transmitted. There is no analytics or tracking.';

  @override
  String get detoxDisclosureControlTitle => 'You remain in control';

  @override
  String get detoxDisclosureControlBody =>
      'You can end a block, disable Accessibility access, choose another Home app, or uninstall Phone Detox at any time.';

  @override
  String get detoxDisclosureConsent =>
      'I understand how Accessibility access is used.';

  @override
  String get continueAction => 'Continue';

  @override
  String get detoxActiveTitle => 'Apps blocked';

  @override
  String detoxEndsAt(String endTime) {
    return 'Until $endTime';
  }

  @override
  String detoxBlockedAppsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps are currently blocked',
      one: '1 app is currently blocked',
    );
    return '$_temp0';
  }

  @override
  String get detoxEnforcementDisabledWarning =>
      'The block is still active, but blocking is not enforced because Accessibility access is disabled.';

  @override
  String get detoxOpenAccessibilitySettings => 'Open Accessibility settings';

  @override
  String get detoxEndSessionAction => 'End block early';

  @override
  String get detoxEndSessionTitle => 'End the block early?';

  @override
  String get detoxEndSessionBody =>
      'The selected apps will become available immediately. Hold the button for 3 seconds to confirm.';

  @override
  String get detoxHoldToEnd => 'Hold to end block';

  @override
  String get detoxEmergencyExitAction => 'Emergency exit';

  @override
  String get detoxEmergencyExitTitle => 'Use emergency exit?';

  @override
  String get detoxEmergencyExitBody =>
      'Immediately make the selected apps available again.';

  @override
  String get detoxEmergencyExitConfirm => 'Make apps available';

  @override
  String get detoxSessionComplete => 'The block has ended.';

  @override
  String get startupLoading => 'Preparing your Home screen…';

  @override
  String get startupActivationTitle => 'Make Phone Detox your Home screen';

  @override
  String get startupActivationExplanation =>
      'Phone Detox replaces your normal launcher and becomes the screen Android opens when you press Home.';

  @override
  String get startupAndroidConfirmationExplanation =>
      'Android requires you to approve this change. Choose Phone Detox on the system screen that opens.';

  @override
  String get startupReversibleChoiceExplanation =>
      'Your choice remains until you select another Home app. You can reverse it at any time in Android Settings.';

  @override
  String get startupChooseHomeAction => 'Choose Phone Detox as Home';

  @override
  String get startupOpenHomeSettingsAction => 'Open Home settings';

  @override
  String get startupWaitingForAndroid => 'Waiting for Android confirmation…';

  @override
  String get startupAccessGranted => 'Phone Detox is now your Home screen.';

  @override
  String get startupSelectionCancelled =>
      'Selection cancelled. Phone Detox cannot become your Home screen until you approve it.';

  @override
  String get startupAnotherLauncherSelected =>
      'Another launcher is still selected. Try again when you are ready.';

  @override
  String get startupSettingsOpened =>
      'Choose Phone Detox in Android Home settings, then return here.';

  @override
  String get startupHomeRoleUnavailableTitle => 'Home screen setup unavailable';

  @override
  String get startupHomeRoleUnavailable =>
      'Android did not provide a supported Home-app selection screen. Open Settings and choose the default Home app manually.';

  @override
  String get startupRoleLostTitle => 'Phone Detox is no longer your Home app';

  @override
  String get startupRoleLostExplanation =>
      'Android currently uses another Home app. Restore Phone Detox to resume Home-button and launcher behavior.';

  @override
  String get startupRestoreHomeAction => 'Restore Phone Detox as Home';

  @override
  String get startupFailureTitle => 'Phone Detox could not start';

  @override
  String get startupFailureMessage =>
      'The Home-screen status could not be checked. Try again or use Android Settings to confirm your Home app.';

  @override
  String get startupStrictBlockingTitle => 'Enable strict app blocking';

  @override
  String get startupStrictBlockingExplanation =>
      'Optional Accessibility access can return you Home when a selected blocked app opens during a Detox session.';

  @override
  String get startupStrictBlockingAction => 'Set up strict blocking';

  @override
  String get jailBreakTooltip => 'Leave Phone Detox Home mode';

  @override
  String get jailBreakDialogTitle => 'Leave Phone Detox?';

  @override
  String get jailBreakDialogBody =>
      'Android will open the Home app settings. Select your previous launcher, such as Pixel Launcher or One UI Home, to stop using Phone Detox as your Home screen.';

  @override
  String get jailBreakPlatformExplanation =>
      'Phone Detox cannot change the default Home app without your confirmation.';

  @override
  String get jailBreakConfirmAction => 'Jail Break';

  @override
  String get jailBreakActiveDialogTitle =>
      'End the block and leave Phone Detox?';

  @override
  String get jailBreakActiveDialogBody =>
      'Jail Break immediately ends the active block, makes the selected apps available, and opens Android Home-app settings.';

  @override
  String get jailBreakActiveConfirmAction => 'End block and Jail Break';

  @override
  String get jailBreakEndingSession => 'Ending active block…';

  @override
  String get jailBreakOpeningSettings => 'Opening Android Home app settings…';

  @override
  String get jailBreakWaitingForSelection =>
      'Waiting for your Home app selection…';

  @override
  String get jailBreakCompletedTitle => 'Jail Break complete';

  @override
  String get jailBreakCompletedBody =>
      'Phone Detox is no longer your Home app. Press Home to open the launcher you selected.';

  @override
  String get jailBreakOpenHomeAction => 'Open Home screen';

  @override
  String get jailBreakUseAgainAction => 'Use Phone Detox again';

  @override
  String get jailBreakCancelledMessage => 'Phone Detox is still your Home app.';

  @override
  String get jailBreakFailureTitle => 'Jail Break could not be completed';

  @override
  String get jailBreakFailureBody =>
      'Android\'s Home app status could not be confirmed. Open default-app settings or try again.';

  @override
  String get jailBreakActiveCleanupFailureBody =>
      'Phone Detox could not fully remove the active block.';

  @override
  String get jailBreakRetryAction => 'Try again';

  @override
  String get jailBreakOpenSettingsAnywayAction => 'Open Home settings anyway';

  @override
  String get jailBreakOpenHomeSettingsAction => 'Open default-app settings';

  @override
  String get jailBreakOpenAccessibilityAction => 'Open Accessibility settings';

  @override
  String get jailBreakAccessibilityStillEnabled =>
      'The active block is ended. Phone Detox Accessibility access may remain enabled, but it blocks no apps without an active block.';

  @override
  String get jailBreakSettingsSectionTitle => 'Recovery';

  @override
  String get jailBreakSettingsDescription =>
      'Choose another Android Home application and stop using Phone Detox as your launcher.';

  @override
  String get jailBreakOpenHomeFailed =>
      'Press the Android Home button to open the launcher you selected.';

  @override
  String get mindfulTakeBreath => 'Take a breath before continuing.';

  @override
  String get mindfulExternalExplanation =>
      'This app was opened outside Phone Detox. Continuing opens its main launcher screen; the original notification or link destination cannot be restored.';

  @override
  String get mindfulDirectExplanation =>
      'Pause for a moment, then choose whether opening this app still supports what you meant to do.';

  @override
  String get mindfulWhyQuestion => 'Why are you opening this app?';

  @override
  String get mindfulIntentionReply => 'Reply to someone';

  @override
  String get mindfulIntentionTask => 'Complete a specific task';

  @override
  String get mindfulIntentionSearch => 'Search for something';

  @override
  String get mindfulIntentionCreate => 'Create or publish something';

  @override
  String get mindfulIntentionOther => 'Other';

  @override
  String get mindfulOtherLabel => 'Write your intention';

  @override
  String get mindfulGoBack => 'Go back';

  @override
  String get mindfulOpenIntentionally => 'Open intentionally';

  @override
  String get mindfulAppUnavailable =>
      'This app is no longer available. Go back to continue.';

  @override
  String get mindfulModeOff => 'Off';

  @override
  String get mindfulModePause => 'Pause';

  @override
  String get mindfulModePauseIntention => 'Pause + intention';

  @override
  String get mindfulDelayTitle => 'Delay';

  @override
  String get mindfulManageApps => 'Manage apps';

  @override
  String get mindfulNoConfiguredApps =>
      'No apps are configured yet. Long-press an app in the launcher to add Mindful Opening.';

  @override
  String get mindfulOpeningAction => 'Mindful opening';

  @override
  String get mindfulConfiguredSemantics => 'Mindful Opening configured';

  @override
  String get mindfulSettingsTitle => 'Mindful Opening';

  @override
  String get mindfulSettingsDescription =>
      'Pause before an app opens.\n\nMindful Opening does not limit time spent inside the app.';

  @override
  String get mindfulEnabledTitle => 'Enable Mindful Opening';

  @override
  String get mindfulEnabledStatus => 'Mindful Opening: Enabled';

  @override
  String get mindfulDisabledStatus => 'Mindful Opening: Disabled';

  @override
  String get mindfulPartialCoverageWarning =>
      'Mindful Opening works from Phone Detox. Enable Accessibility access and accept the updated disclosure to also catch apps opened from notifications, links, Recents, and other apps.';

  @override
  String get saveAction => 'Save';

  @override
  String mindfulSecondsRemaining(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds remaining',
      one: '1 second remaining',
      zero: 'Ready to continue',
    );
    return '$_temp0';
  }

  @override
  String mindfulRuleTitle(String appName) {
    return 'Mindful Opening for $appName';
  }

  @override
  String mindfulDelaySeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String mindfulRuleSummary(int seconds) {
    return '$seconds-second pause';
  }

  @override
  String mindfulConfiguredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps configured',
      one: '1 app configured',
      zero: 'No apps configured',
    );
    return '$_temp0';
  }

  @override
  String get detoxChooseAppsStepTitle => '1. Choose apps';

  @override
  String get detoxChooseAppsStepDescription =>
      'Selected apps will be completely unavailable while the block is active.';

  @override
  String get detoxNoAppsSelectedDescription =>
      'Choose at least one app to block.';

  @override
  String get detoxChooseAppsAction => 'Choose apps';

  @override
  String get detoxChangeSelectionAction => 'Change selection';

  @override
  String get detoxDurationStepTitle => '2. Block them for';

  @override
  String get detoxDurationStepDescription =>
      'The countdown starts when you press Start blocking.';

  @override
  String detoxDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String detoxDurationHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get detoxCustomDurationOption => 'Custom';

  @override
  String get detoxCustomDurationSupportingText =>
      'Between 5 minutes and 8 hours';

  @override
  String get detoxBlockingAccessStepTitle => '3. Blocking access';

  @override
  String get detoxBlockingAccessReady => 'Strict blocking is ready';

  @override
  String get detoxBlockingAccessReadyDescription =>
      'Phone Detox can detect attempts to open selected apps and return you Home.';

  @override
  String get detoxBlockingAccessDisabled => 'Strict blocking is not enabled';

  @override
  String get detoxBlockingAccessDisabledDescription =>
      'Enable Accessibility access so Phone Detox can enforce the block outside the launcher.';

  @override
  String get detoxReviewBlockingAccessAction => 'Review and enable access';

  @override
  String get detoxWhatWillHappenTitle => 'What will happen?';

  @override
  String get detoxWhatWillHappenEmpty =>
      'Choose at least one app to see exactly what will be blocked.';

  @override
  String detoxWhatWillHappenSummary(
    int count,
    String appName,
    String duration,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected apps will be blocked for $duration.',
      one: '$appName will be blocked for $duration.',
    );
    return '$_temp0';
  }

  @override
  String get detoxWhatWillHappenAvailability =>
      'You will not be able to open them until the block ends or you deliberately end the block.';

  @override
  String detoxNotUsageAllowance(String duration) {
    return 'This does not give you $duration of usage inside an app.';
  }

  @override
  String get detoxChooseAppsToContinue => 'Choose apps to continue';

  @override
  String detoxDynamicStartAction(int count, String appName, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Block $count apps for $duration',
      one: 'Block $appName for $duration',
    );
    return '$_temp0';
  }

  @override
  String get detoxBlockerNoApps => 'Choose at least one app to block.';

  @override
  String get detoxBlockerInvalidDuration => 'Enter a valid blocking duration.';

  @override
  String get detoxBlockerDisclosure => 'Review how blocking access is used.';

  @override
  String get detoxBlockerAccessibility => 'Enable strict blocking access.';

  @override
  String get detoxBlockerAlreadyActive => 'A block is already active.';

  @override
  String get detoxBlockerControllerError =>
      'Blocking settings could not be loaded. Try again.';

  @override
  String detoxSelectionDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Done — $count selected',
      one: 'Done — 1 selected',
      zero: 'Done — no apps selected',
    );
    return '$_temp0';
  }

  @override
  String get detoxMindfulOpeningConfigured => 'Mindful Opening configured';

  @override
  String get detoxBlockEndsIn => 'Block ends in';

  @override
  String detoxCountdownSemantics(String remainingTime) {
    return 'Block ends in $remainingTime';
  }

  @override
  String get detoxBlockedAppsHeading => 'Blocked apps';

  @override
  String get detoxBlockedAppExplanation =>
      'It is included in your active block.';

  @override
  String get detoxViewActiveBlock => 'View active block';

  @override
  String get settingsHowItWorksTitle => 'How Phone Detox works';

  @override
  String get settingsMindfulDefinition => 'Pause before selected apps open.';

  @override
  String get settingsMindfulDisabled => 'Disabled';

  @override
  String get settingsMindfulNoApps => 'No apps configured';

  @override
  String settingsMindfulEnabledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enabled for $count apps',
      one: 'Enabled for 1 app',
    );
    return '$_temp0';
  }

  @override
  String get settingsTemporaryBlockDefinition =>
      'Make selected apps completely unavailable for a chosen period.';

  @override
  String get settingsTemporaryBlockInactive => 'No active block';

  @override
  String settingsTemporaryBlockActive(int count, String endTime) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps blocked until $endTime',
      one: '1 app blocked until $endTime',
    );
    return '$_temp0';
  }

  @override
  String get usageLimitTitle => 'Usage Limits';

  @override
  String get usageLimitDescription =>
      'Optional per-app limits for one continuous foreground visit. No daily totals or usage history are recorded.';

  @override
  String get usageLimitEnabledTitle => 'Enable Usage Limits';

  @override
  String get usageLimitEnabledStatus => 'Enabled';

  @override
  String get usageLimitDisabledStatus => 'Off by default';

  @override
  String get usageLimitManageApps => 'Manage app limits';

  @override
  String usageLimitConfiguredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps configured',
      one: '1 app configured',
      zero: 'No apps configured',
    );
    return '$_temp0';
  }

  @override
  String get usageLimitAppAction => 'Usage limit';

  @override
  String usageLimitEditorTitle(String appName) {
    return 'Usage limit for $appName';
  }

  @override
  String get usageLimitWarning =>
      'When time is up, Phone Detox returns Home and prevents reopening until you choose what to do. Android does not force-stop the app.';

  @override
  String get usageLimitAcknowledge =>
      'I understand what happens when time is up.';

  @override
  String get usageLimitOff => 'Off';

  @override
  String usageLimitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get usageLimitEnableAndSave => 'Enable and save';

  @override
  String get usageLimitNotNow => 'Not now';

  @override
  String get usageLimitSave => 'Save limit';

  @override
  String get usageLimitTimeUpTitle => 'Time\'s up';

  @override
  String usageLimitTimeUpBody(String appName) {
    return 'Your continuous visit to $appName reached its limit.';
  }

  @override
  String get usageLimitStayOut => 'Stay out';

  @override
  String get usageLimitContinue => 'Continue';

  @override
  String get usageLimitChange => 'Change limit';

  @override
  String get usageLimitReachedSemantics => 'Usage limit reached';

  @override
  String get usageLimitConfiguredSemantics => 'Usage limit configured';

  @override
  String get usageLimitDisclosureRequired =>
      'Review and accept the updated Accessibility disclosure before enabling Usage Limits.';

  @override
  String get usageLimitEnablePrompt =>
      'Usage Limits are off. Enable them globally and save this app\'s 15-minute suggestion?';

  @override
  String get usageLimitEmpty =>
      'No configurable launchable apps are available.';
}
