import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// The application name shown by the operating system and in the app.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox'**
  String get appName;

  /// Title of the launcher settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Tooltip for the button that opens launcher settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsTooltip;

  /// Accessible label for the app search field.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get searchLabel;

  /// Hint explaining what can be entered in the app search field.
  ///
  /// In en, this message translates to:
  /// **'Name or package'**
  String get searchHint;

  /// Heading prompting the user to select Phone Detox as the default Home app.
  ///
  /// In en, this message translates to:
  /// **'Make Phone Detox your Home app'**
  String get makeDefaultTitle;

  /// Explanation of the reversible Android default Home selection.
  ///
  /// In en, this message translates to:
  /// **'Choose Phone Detox when Android asks which Home app to use. You can change this at any time in system settings.'**
  String get makeDefaultBody;

  /// Button label that starts Android's default Home selection flow.
  ///
  /// In en, this message translates to:
  /// **'Choose Home app'**
  String get makeDefaultAction;

  /// Message displayed while installed launchable apps are loading.
  ///
  /// In en, this message translates to:
  /// **'Loading apps…'**
  String get loadingApps;

  /// Recoverable error shown when installed app discovery fails.
  ///
  /// In en, this message translates to:
  /// **'Apps could not be loaded. Android settings and navigation remain available.'**
  String get loadAppsError;

  /// Button label for retrying a failed operation.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;

  /// Empty state when Android returns no launchable applications.
  ///
  /// In en, this message translates to:
  /// **'No launchable apps were found.'**
  String get noApps;

  /// Empty state when no visible app matches the current search.
  ///
  /// In en, this message translates to:
  /// **'No apps match your search.'**
  String get noSearchResults;

  /// Heading for an app's action sheet.
  ///
  /// In en, this message translates to:
  /// **'Actions for {appName}'**
  String appActionsTitle(String appName);

  /// Action that pins an app above non-favourite apps.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get favouriteAction;

  /// Action that removes an app from launcher favourites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get unfavouriteAction;

  /// Action that hides an app from the primary launcher list.
  ///
  /// In en, this message translates to:
  /// **'Hide from launcher'**
  String get hideAction;

  /// Transient error shown when explicit Android app launching fails.
  ///
  /// In en, this message translates to:
  /// **'This app could not be opened.'**
  String get launchFailed;

  /// Heading for the hidden app management section.
  ///
  /// In en, this message translates to:
  /// **'Hidden apps'**
  String get hiddenAppsTitle;

  /// Explanation that hiding is local, reversible, and does not uninstall an app.
  ///
  /// In en, this message translates to:
  /// **'Hidden apps stay installed and can always be restored here.'**
  String get hiddenAppsDescription;

  /// Empty state for hidden app management.
  ///
  /// In en, this message translates to:
  /// **'No apps are hidden.'**
  String get hiddenAppsEmpty;

  /// Action that restores a hidden app to the launcher list.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreAction;

  /// Tooltip for the launcher button that opens Detox.
  ///
  /// In en, this message translates to:
  /// **'Open Detox'**
  String get detoxTooltip;

  /// Title of the Detox setup screen.
  ///
  /// In en, this message translates to:
  /// **'Detox'**
  String get detoxTitle;

  /// Message shown while Detox state is loading.
  ///
  /// In en, this message translates to:
  /// **'Loading Detox settings…'**
  String get detoxLoading;

  /// Recoverable Detox loading error.
  ///
  /// In en, this message translates to:
  /// **'Detox settings could not be loaded. Try again.'**
  String get detoxLoadError;

  /// Title of the Detox app selection screen.
  ///
  /// In en, this message translates to:
  /// **'Apps to block'**
  String get detoxManageAppsTitle;

  /// Explanation of the selected Detox package list.
  ///
  /// In en, this message translates to:
  /// **'These packages will be blocked during a session.'**
  String get detoxManageAppsDescription;

  /// Empty state for Detox app selection.
  ///
  /// In en, this message translates to:
  /// **'No launchable apps are available.'**
  String get detoxNoAppsAvailable;

  /// Count of packages selected for Detox.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No apps selected} =1{1 app selected} other{{count} apps selected}}'**
  String detoxSelectedApps(int count);

  /// Guidance when the Detox list is empty.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one distracting app.'**
  String get detoxEmptyList;

  /// Heading for Detox duration selection.
  ///
  /// In en, this message translates to:
  /// **'Session duration'**
  String get detoxDurationTitle;

  /// A Detox duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String detoxMinutes(int minutes);

  /// Label for custom Detox duration input.
  ///
  /// In en, this message translates to:
  /// **'Custom duration (5–480 minutes)'**
  String get detoxCustomDurationLabel;

  /// Validation error for custom Detox duration.
  ///
  /// In en, this message translates to:
  /// **'Enter a value from 5 to 480.'**
  String get detoxCustomDurationError;

  /// Explanation of why Detox needs Accessibility special access.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking requires Accessibility access. It is only used to observe the visible app package during an active session.'**
  String get detoxAccessibilityExplanation;

  /// Enabled Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Accessibility access enabled'**
  String get detoxAccessibilityEnabled;

  /// Disabled Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Accessibility access disabled'**
  String get detoxAccessibilityDisabled;

  /// Unavailable Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Accessibility access unavailable'**
  String get detoxAccessibilityUnavailable;

  /// Action that starts a Detox session.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get detoxStartAction;

  /// Recoverable error after Detox session start fails.
  ///
  /// In en, this message translates to:
  /// **'The session could not be started. Check Accessibility access and try again.'**
  String get detoxStartError;

  /// Action that adds an app package to the Detox list.
  ///
  /// In en, this message translates to:
  /// **'Add to detox list'**
  String get detoxAddAction;

  /// Action that removes an app package from the Detox list.
  ///
  /// In en, this message translates to:
  /// **'Remove from detox list'**
  String get detoxRemoveAction;

  /// Message shown when direct launching is blocked.
  ///
  /// In en, this message translates to:
  /// **'This app is blocked until {endTime}.'**
  String detoxBlockedUntil(String endTime);

  /// Title of the prominent Accessibility disclosure.
  ///
  /// In en, this message translates to:
  /// **'How Accessibility access is used'**
  String get detoxDisclosureTitle;

  /// Heading describing observed Accessibility information.
  ///
  /// In en, this message translates to:
  /// **'What access is used'**
  String get detoxDisclosureWhatTitle;

  /// Disclosure of the foreground package observation.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox observes which application package is currently visible while its Accessibility Service is enabled.'**
  String get detoxDisclosureWhatBody;

  /// Heading explaining the purpose of Accessibility access.
  ///
  /// In en, this message translates to:
  /// **'Why it is used'**
  String get detoxDisclosureWhyTitle;

  /// Disclosure of blocking behavior.
  ///
  /// In en, this message translates to:
  /// **'During an active session, this detects an app you selected for blocking and immediately returns you to the Home screen.'**
  String get detoxDisclosureWhyBody;

  /// Heading for information excluded from Accessibility processing.
  ///
  /// In en, this message translates to:
  /// **'What is not accessed'**
  String get detoxDisclosureNotAccessedTitle;

  /// Disclosure of data that is never accessed.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox does not read passwords, typed text, messages, screen or browser content, notifications, images, contacts, files, or Accessibility node trees.'**
  String get detoxDisclosureNotAccessedBody;

  /// Heading for local data handling disclosure.
  ///
  /// In en, this message translates to:
  /// **'Data handling'**
  String get detoxDisclosureDataTitle;

  /// Disclosure that processing stays local.
  ///
  /// In en, this message translates to:
  /// **'Processing happens only on this device. Foreground packages and installed-app information are never transmitted. There is no analytics or tracking.'**
  String get detoxDisclosureDataBody;

  /// Heading for reversible user controls.
  ///
  /// In en, this message translates to:
  /// **'You remain in control'**
  String get detoxDisclosureControlTitle;

  /// Disclosure of user recovery controls.
  ///
  /// In en, this message translates to:
  /// **'You can end a session, disable Accessibility access, choose another Home app, or uninstall Phone Detox at any time.'**
  String get detoxDisclosureControlBody;

  /// Affirmative consent checkbox for the Accessibility disclosure.
  ///
  /// In en, this message translates to:
  /// **'I understand how Accessibility access is used.'**
  String get detoxDisclosureConsent;

  /// Action that continues after affirmative disclosure consent.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Title of the active Detox session screen.
  ///
  /// In en, this message translates to:
  /// **'Detox session active'**
  String get detoxActiveTitle;

  /// Local end time for the active session.
  ///
  /// In en, this message translates to:
  /// **'Ends at {endTime}'**
  String detoxEndsAt(String endTime);

  /// Count of apps blocked by the active session.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 blocked app} other{{count} blocked apps}}'**
  String detoxBlockedAppsCount(int count);

  /// Warning when an active session is not enforced.
  ///
  /// In en, this message translates to:
  /// **'The session is still active, but blocking is not enforced because Accessibility access is disabled.'**
  String get detoxEnforcementDisabledWarning;

  /// Action opening Android Accessibility settings.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings'**
  String get detoxOpenAccessibilitySettings;

  /// Action opening the deliberate end-session flow.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get detoxEndSessionAction;

  /// Title of the deliberate end-session dialog.
  ///
  /// In en, this message translates to:
  /// **'End this session?'**
  String get detoxEndSessionTitle;

  /// Instruction for deliberate session ending.
  ///
  /// In en, this message translates to:
  /// **'Hold the button for 3 seconds to end the session.'**
  String get detoxEndSessionBody;

  /// Label for the 3-second hold button.
  ///
  /// In en, this message translates to:
  /// **'Hold to end'**
  String get detoxHoldToEnd;

  /// Accessible immediate session exit action.
  ///
  /// In en, this message translates to:
  /// **'Emergency exit'**
  String get detoxEmergencyExitAction;

  /// Title of the emergency exit confirmation.
  ///
  /// In en, this message translates to:
  /// **'Use emergency exit?'**
  String get detoxEmergencyExitTitle;

  /// Consequence explained by emergency exit confirmation.
  ///
  /// In en, this message translates to:
  /// **'This immediately ends the session and removes blocking.'**
  String get detoxEmergencyExitBody;

  /// Confirmation action for emergency exit.
  ///
  /// In en, this message translates to:
  /// **'End now'**
  String get detoxEmergencyExitConfirm;

  /// Message shown after a session naturally expires.
  ///
  /// In en, this message translates to:
  /// **'Detox session complete.'**
  String get detoxSessionComplete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
