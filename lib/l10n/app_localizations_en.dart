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
      'During an active session, this detects an app you selected for blocking and immediately returns you to the Home screen.';

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
}
