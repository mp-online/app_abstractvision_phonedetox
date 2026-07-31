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
  String get detoxTooltip => 'Open Detox';

  @override
  String get detoxTitle => 'Detox';

  @override
  String get detoxLoading => 'Loading Detox settings…';

  @override
  String get detoxLoadError => 'Detox settings could not be loaded. Try again.';

  @override
  String get detoxManageAppsTitle => 'Apps to block';

  @override
  String get detoxManageAppsDescription =>
      'These packages will be blocked during a session.';

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
  String get detoxEmptyList => 'Choose at least one distracting app.';

  @override
  String get detoxDurationTitle => 'Session duration';

  @override
  String detoxMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get detoxCustomDurationLabel => 'Custom duration (5–480 minutes)';

  @override
  String get detoxCustomDurationError => 'Enter a value from 5 to 480.';

  @override
  String get detoxAccessibilityExplanation =>
      'Strict blocking requires Accessibility access. It is only used to observe the visible app package during an active session.';

  @override
  String get detoxAccessibilityEnabled => 'Accessibility access enabled';

  @override
  String get detoxAccessibilityDisabled => 'Accessibility access disabled';

  @override
  String get detoxAccessibilityUnavailable =>
      'Accessibility access unavailable';

  @override
  String get detoxStartAction => 'Start session';

  @override
  String get detoxStartError =>
      'The session could not be started. Check Accessibility access and try again.';

  @override
  String get detoxAddAction => 'Add to detox list';

  @override
  String get detoxRemoveAction => 'Remove from detox list';

  @override
  String detoxBlockedUntil(String endTime) {
    return 'This app is blocked until $endTime.';
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
      'During an active Detox session it detects selected blocked apps. For configured apps, Phone Detox may also return you Home for the Mindful Opening pause.';

  @override
  String get detoxDisclosureNotAccessedTitle => 'What is not accessed';

  @override
  String get detoxDisclosureNotAccessedBody =>
      'Phone Detox does not read passwords, typed text, messages, screen or browser content, notifications, images, contacts, files, or Accessibility node trees.';

  @override
  String get detoxDisclosureDataTitle => 'Data handling';

  @override
  String get detoxDisclosureDataBody =>
      'Processing happens only on this device. Foreground packages and installed-app information are never transmitted. There is no analytics or tracking.';

  @override
  String get detoxDisclosureControlTitle => 'You remain in control';

  @override
  String get detoxDisclosureControlBody =>
      'You can end a session, disable Accessibility access, choose another Home app, or uninstall Phone Detox at any time.';

  @override
  String get detoxDisclosureConsent =>
      'I understand how Accessibility access is used.';

  @override
  String get continueAction => 'Continue';

  @override
  String get detoxActiveTitle => 'Detox session active';

  @override
  String detoxEndsAt(String endTime) {
    return 'Ends at $endTime';
  }

  @override
  String detoxBlockedAppsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocked apps',
      one: '1 blocked app',
    );
    return '$_temp0';
  }

  @override
  String get detoxEnforcementDisabledWarning =>
      'The session is still active, but blocking is not enforced because Accessibility access is disabled.';

  @override
  String get detoxOpenAccessibilitySettings => 'Open Accessibility settings';

  @override
  String get detoxEndSessionAction => 'End session';

  @override
  String get detoxEndSessionTitle => 'End this session?';

  @override
  String get detoxEndSessionBody =>
      'Hold the button for 3 seconds to end the session.';

  @override
  String get detoxHoldToEnd => 'Hold to end';

  @override
  String get detoxEmergencyExitAction => 'Emergency exit';

  @override
  String get detoxEmergencyExitTitle => 'Use emergency exit?';

  @override
  String get detoxEmergencyExitBody =>
      'This immediately ends the session and removes blocking.';

  @override
  String get detoxEmergencyExitConfirm => 'End now';

  @override
  String get detoxSessionComplete => 'Detox session complete.';

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
  String get jailBreakActiveDialogTitle => 'End Detox and leave Phone Detox?';

  @override
  String get jailBreakActiveDialogBody =>
      'Jail Break will immediately end the active Detox session, remove app blocking, and open Android\'s Home app settings.';

  @override
  String get jailBreakActiveConfirmAction => 'End session and Jail Break';

  @override
  String get jailBreakEndingSession => 'Ending the active Detox session…';

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
      'Phone Detox could not fully remove the active blocking session.';

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
      'The active blocking session will end. Phone Detox Accessibility access may remain enabled, but it will not block applications without an active Detox session.';

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
  String get mindfulSettingsTitle => 'Mindful opening';

  @override
  String get mindfulSettingsDescription =>
      'Pause before opening selected apps.';

  @override
  String get mindfulEnabledTitle => 'Mindful opening enabled';

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
}
