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
  /// **'Open Block apps now'**
  String get detoxTooltip;

  /// Title of the Detox setup screen.
  ///
  /// In en, this message translates to:
  /// **'Block apps now'**
  String get detoxTitle;

  /// Message shown while Detox state is loading.
  ///
  /// In en, this message translates to:
  /// **'Loading blocking settings…'**
  String get detoxLoading;

  /// Recoverable Detox loading error.
  ///
  /// In en, this message translates to:
  /// **'Blocking settings could not be loaded. Try again.'**
  String get detoxLoadError;

  /// Title of the Detox app selection screen.
  ///
  /// In en, this message translates to:
  /// **'Apps to block'**
  String get detoxManageAppsTitle;

  /// Explanation of the selected Detox package list.
  ///
  /// In en, this message translates to:
  /// **'These apps will be unavailable during an active block.'**
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
  /// **'Choose at least one app to block.'**
  String get detoxEmptyList;

  /// Heading for Detox duration selection.
  ///
  /// In en, this message translates to:
  /// **'Block selected apps for'**
  String get detoxDurationTitle;

  /// A Detox duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String detoxMinutes(int minutes);

  /// Label for custom Detox duration input.
  ///
  /// In en, this message translates to:
  /// **'Custom block duration'**
  String get detoxCustomDurationLabel;

  /// Validation error for custom Detox duration.
  ///
  /// In en, this message translates to:
  /// **'Enter a duration between 5 minutes and 8 hours.'**
  String get detoxCustomDurationError;

  /// Explanation of why Detox needs Accessibility special access.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox can detect attempts to open selected apps and return you Home.'**
  String get detoxAccessibilityExplanation;

  /// Enabled Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking is ready'**
  String get detoxAccessibilityEnabled;

  /// Disabled Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking is not enabled'**
  String get detoxAccessibilityDisabled;

  /// Unavailable Accessibility status.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking is unavailable'**
  String get detoxAccessibilityUnavailable;

  /// Action that starts a Detox session.
  ///
  /// In en, this message translates to:
  /// **'Start blocking'**
  String get detoxStartAction;

  /// Recoverable error after Detox session start fails.
  ///
  /// In en, this message translates to:
  /// **'Blocking could not be started. Check blocking access and try again.'**
  String get detoxStartError;

  /// Action that adds an app package to the Detox list.
  ///
  /// In en, this message translates to:
  /// **'Add to apps to block'**
  String get detoxAddAction;

  /// Action that removes an app package from the Detox list.
  ///
  /// In en, this message translates to:
  /// **'Remove from apps to block'**
  String get detoxRemoveAction;

  /// Localized product copy for detoxBlockedUntil.
  ///
  /// In en, this message translates to:
  /// **'{appName} is unavailable until {endTime}.'**
  String detoxBlockedUntil(String appName, String endTime);

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
  /// **'During an active Detox session it detects selected blocked apps. For configured apps, Phone Detox may also return you Home for the Mindful Opening pause.'**
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
  /// **'You can end a block, disable Accessibility access, choose another Home app, or uninstall Phone Detox at any time.'**
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
  /// **'Apps blocked'**
  String get detoxActiveTitle;

  /// Local end time for the active session.
  ///
  /// In en, this message translates to:
  /// **'Until {endTime}'**
  String detoxEndsAt(String endTime);

  /// Count of apps blocked by the active session.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app is currently blocked} other{{count} apps are currently blocked}}'**
  String detoxBlockedAppsCount(int count);

  /// Warning when an active session is not enforced.
  ///
  /// In en, this message translates to:
  /// **'The block is still active, but blocking is not enforced because Accessibility access is disabled.'**
  String get detoxEnforcementDisabledWarning;

  /// Action opening Android Accessibility settings.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings'**
  String get detoxOpenAccessibilitySettings;

  /// Action opening the deliberate end-session flow.
  ///
  /// In en, this message translates to:
  /// **'End block early'**
  String get detoxEndSessionAction;

  /// Title of the deliberate end-session dialog.
  ///
  /// In en, this message translates to:
  /// **'End the block early?'**
  String get detoxEndSessionTitle;

  /// Instruction for deliberate session ending.
  ///
  /// In en, this message translates to:
  /// **'The selected apps will become available immediately. Hold the button for 3 seconds to confirm.'**
  String get detoxEndSessionBody;

  /// Label for the 3-second hold button.
  ///
  /// In en, this message translates to:
  /// **'Hold to end block'**
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
  /// **'Immediately make the selected apps available again.'**
  String get detoxEmergencyExitBody;

  /// Confirmation action for emergency exit.
  ///
  /// In en, this message translates to:
  /// **'Make apps available'**
  String get detoxEmergencyExitConfirm;

  /// Message shown after a session naturally expires.
  ///
  /// In en, this message translates to:
  /// **'The block has ended.'**
  String get detoxSessionComplete;

  /// Message shown while startup state is resolved.
  ///
  /// In en, this message translates to:
  /// **'Preparing your Home screen…'**
  String get startupLoading;

  /// Title of the first-run Home-role activation screen.
  ///
  /// In en, this message translates to:
  /// **'Make Phone Detox your Home screen'**
  String get startupActivationTitle;

  /// Explanation of Phone Detox acting as the Android Home launcher.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox replaces your normal launcher and becomes the screen Android opens when you press Home.'**
  String get startupActivationExplanation;

  /// Explanation that Android requires explicit Home-role confirmation.
  ///
  /// In en, this message translates to:
  /// **'Android requires you to approve this change. Choose Phone Detox on the system screen that opens.'**
  String get startupAndroidConfirmationExplanation;

  /// Explanation that the Home-app selection remains reversible.
  ///
  /// In en, this message translates to:
  /// **'Your choice remains until you select another Home app. You can reverse it at any time in Android Settings.'**
  String get startupReversibleChoiceExplanation;

  /// Primary action requesting the Android Home role.
  ///
  /// In en, this message translates to:
  /// **'Choose Phone Detox as Home'**
  String get startupChooseHomeAction;

  /// Action opening Android default Home-app settings.
  ///
  /// In en, this message translates to:
  /// **'Open Home settings'**
  String get startupOpenHomeSettingsAction;

  /// Status shown while the Android Home-role screen is open.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Android confirmation…'**
  String get startupWaitingForAndroid;

  /// Status shown after Home-role access is granted.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox is now your Home screen.'**
  String get startupAccessGranted;

  /// Non-error status shown when Home-role selection is cancelled.
  ///
  /// In en, this message translates to:
  /// **'Selection cancelled. Phone Detox cannot become your Home screen until you approve it.'**
  String get startupSelectionCancelled;

  /// Non-error status shown when another launcher remains selected.
  ///
  /// In en, this message translates to:
  /// **'Another launcher is still selected. Try again when you are ready.'**
  String get startupAnotherLauncherSelected;

  /// Guidance after the Home settings fallback was opened.
  ///
  /// In en, this message translates to:
  /// **'Choose Phone Detox in Android Home settings, then return here.'**
  String get startupSettingsOpened;

  /// Title for an unavailable Android Home-role capability.
  ///
  /// In en, this message translates to:
  /// **'Home screen setup unavailable'**
  String get startupHomeRoleUnavailableTitle;

  /// Recoverable explanation when Home-role selection is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Android did not provide a supported Home-app selection screen. Open Settings and choose the default Home app manually.'**
  String get startupHomeRoleUnavailable;

  /// Title shown when a previously held Home role has been revoked.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox is no longer your Home app'**
  String get startupRoleLostTitle;

  /// Explanation of Home-role revocation and recovery.
  ///
  /// In en, this message translates to:
  /// **'Android currently uses another Home app. Restore Phone Detox to resume Home-button and launcher behavior.'**
  String get startupRoleLostExplanation;

  /// Action requesting restoration of the Android Home role.
  ///
  /// In en, this message translates to:
  /// **'Restore Phone Detox as Home'**
  String get startupRestoreHomeAction;

  /// Title for a recoverable startup failure.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox could not start'**
  String get startupFailureTitle;

  /// Recoverable startup failure message.
  ///
  /// In en, this message translates to:
  /// **'The Home-screen status could not be checked. Try again or use Android Settings to confirm your Home app.'**
  String get startupFailureMessage;

  /// Title of the optional strict-blocking launcher card.
  ///
  /// In en, this message translates to:
  /// **'Enable strict app blocking'**
  String get startupStrictBlockingTitle;

  /// Explanation that strict blocking is optional and separate from Home activation.
  ///
  /// In en, this message translates to:
  /// **'Optional Accessibility access can return you Home when a selected blocked app opens during a Detox session.'**
  String get startupStrictBlockingExplanation;

  /// Action opening the existing Detox setup and disclosure flow.
  ///
  /// In en, this message translates to:
  /// **'Set up strict blocking'**
  String get startupStrictBlockingAction;

  /// Tooltip and settings action for leaving Phone Detox as the Android Home app.
  ///
  /// In en, this message translates to:
  /// **'Leave Phone Detox Home mode'**
  String get jailBreakTooltip;

  /// Confirmation title when leaving without an active Detox session.
  ///
  /// In en, this message translates to:
  /// **'Leave Phone Detox?'**
  String get jailBreakDialogTitle;

  /// Explanation of Android Home selection for an inactive session.
  ///
  /// In en, this message translates to:
  /// **'Android will open the Home app settings. Select your previous launcher, such as Pixel Launcher or One UI Home, to stop using Phone Detox as your Home screen.'**
  String get jailBreakDialogBody;

  /// Explanation that Android requires explicit user confirmation.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox cannot change the default Home app without your confirmation.'**
  String get jailBreakPlatformExplanation;

  /// Confirmation action for leaving Phone Detox Home mode.
  ///
  /// In en, this message translates to:
  /// **'Jail Break'**
  String get jailBreakConfirmAction;

  /// Confirmation title when Jail Break will end an active session.
  ///
  /// In en, this message translates to:
  /// **'End the block and leave Phone Detox?'**
  String get jailBreakActiveDialogTitle;

  /// Active-session Jail Break consequences.
  ///
  /// In en, this message translates to:
  /// **'Jail Break immediately ends the active block, makes the selected apps available, and opens Android Home-app settings.'**
  String get jailBreakActiveDialogBody;

  /// Confirmation action that ends a session and opens Home settings.
  ///
  /// In en, this message translates to:
  /// **'End block and Jail Break'**
  String get jailBreakActiveConfirmAction;

  /// Progress message during active-session cleanup.
  ///
  /// In en, this message translates to:
  /// **'Ending active block…'**
  String get jailBreakEndingSession;

  /// Progress message while Home settings opens.
  ///
  /// In en, this message translates to:
  /// **'Opening Android Home app settings…'**
  String get jailBreakOpeningSettings;

  /// Status while Android Home selection is pending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your Home app selection…'**
  String get jailBreakWaitingForSelection;

  /// Neutral completion title after intentional Home-role loss.
  ///
  /// In en, this message translates to:
  /// **'Jail Break complete'**
  String get jailBreakCompletedTitle;

  /// Neutral completion explanation after selecting another launcher.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox is no longer your Home app. Press Home to open the launcher you selected.'**
  String get jailBreakCompletedBody;

  /// Action opening the newly selected Android Home app.
  ///
  /// In en, this message translates to:
  /// **'Open Home screen'**
  String get jailBreakOpenHomeAction;

  /// Action requesting Phone Detox as Home again.
  ///
  /// In en, this message translates to:
  /// **'Use Phone Detox again'**
  String get jailBreakUseAgainAction;

  /// Non-error message after keeping Phone Detox selected.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox is still your Home app.'**
  String get jailBreakCancelledMessage;

  /// Title for a recoverable Jail Break failure.
  ///
  /// In en, this message translates to:
  /// **'Jail Break could not be completed'**
  String get jailBreakFailureTitle;

  /// Recoverable Home-role verification failure.
  ///
  /// In en, this message translates to:
  /// **'Android\'s Home app status could not be confirmed. Open default-app settings or try again.'**
  String get jailBreakFailureBody;

  /// Failure shown when active Detox cleanup fails.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox could not fully remove the active block.'**
  String get jailBreakActiveCleanupFailureBody;

  /// Action retrying a failed Jail Break step.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get jailBreakRetryAction;

  /// Recovery action that opens Home settings despite cleanup failure.
  ///
  /// In en, this message translates to:
  /// **'Open Home settings anyway'**
  String get jailBreakOpenSettingsAnywayAction;

  /// Recovery action opening Android default-app settings.
  ///
  /// In en, this message translates to:
  /// **'Open default-app settings'**
  String get jailBreakOpenHomeSettingsAction;

  /// Recovery action opening Accessibility settings for manual control.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings'**
  String get jailBreakOpenAccessibilityAction;

  /// Explanation that Accessibility access remains enabled without active blocking.
  ///
  /// In en, this message translates to:
  /// **'The active block is ended. Phone Detox Accessibility access may remain enabled, but it blocks no apps without an active block.'**
  String get jailBreakAccessibilityStillEnabled;

  /// Title of the settings recovery section.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get jailBreakSettingsSectionTitle;

  /// Description of the settings Jail Break recovery action.
  ///
  /// In en, this message translates to:
  /// **'Choose another Android Home application and stop using Phone Detox as your launcher.'**
  String get jailBreakSettingsDescription;

  /// Fallback when the selected Home app cannot be launched directly.
  ///
  /// In en, this message translates to:
  /// **'Press the Android Home button to open the launcher you selected.'**
  String get jailBreakOpenHomeFailed;

  /// mindfulTakeBreath.
  ///
  /// In en, this message translates to:
  /// **'Take a breath before continuing.'**
  String get mindfulTakeBreath;

  /// mindfulExternalExplanation.
  ///
  /// In en, this message translates to:
  /// **'This app was opened outside Phone Detox. Continuing opens its main launcher screen; the original notification or link destination cannot be restored.'**
  String get mindfulExternalExplanation;

  /// mindfulDirectExplanation.
  ///
  /// In en, this message translates to:
  /// **'Pause for a moment, then choose whether opening this app still supports what you meant to do.'**
  String get mindfulDirectExplanation;

  /// mindfulWhyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Why are you opening this app?'**
  String get mindfulWhyQuestion;

  /// mindfulIntentionReply.
  ///
  /// In en, this message translates to:
  /// **'Reply to someone'**
  String get mindfulIntentionReply;

  /// mindfulIntentionTask.
  ///
  /// In en, this message translates to:
  /// **'Complete a specific task'**
  String get mindfulIntentionTask;

  /// mindfulIntentionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search for something'**
  String get mindfulIntentionSearch;

  /// mindfulIntentionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create or publish something'**
  String get mindfulIntentionCreate;

  /// mindfulIntentionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get mindfulIntentionOther;

  /// mindfulOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Write your intention'**
  String get mindfulOtherLabel;

  /// mindfulGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get mindfulGoBack;

  /// mindfulOpenIntentionally.
  ///
  /// In en, this message translates to:
  /// **'Open intentionally'**
  String get mindfulOpenIntentionally;

  /// mindfulAppUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This app is no longer available. Go back to continue.'**
  String get mindfulAppUnavailable;

  /// mindfulModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get mindfulModeOff;

  /// mindfulModePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get mindfulModePause;

  /// mindfulModePauseIntention.
  ///
  /// In en, this message translates to:
  /// **'Pause + intention'**
  String get mindfulModePauseIntention;

  /// mindfulDelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get mindfulDelayTitle;

  /// mindfulManageApps.
  ///
  /// In en, this message translates to:
  /// **'Manage apps'**
  String get mindfulManageApps;

  /// mindfulNoConfiguredApps.
  ///
  /// In en, this message translates to:
  /// **'No apps are configured yet. Long-press an app in the launcher to add Mindful Opening.'**
  String get mindfulNoConfiguredApps;

  /// mindfulOpeningAction.
  ///
  /// In en, this message translates to:
  /// **'Mindful opening'**
  String get mindfulOpeningAction;

  /// mindfulConfiguredSemantics.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening configured'**
  String get mindfulConfiguredSemantics;

  /// mindfulSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening'**
  String get mindfulSettingsTitle;

  /// Explains that Mindful Opening adds app-entry friction and does not monitor in-app duration.
  ///
  /// In en, this message translates to:
  /// **'Pause before an app opens.\n\nMindful Opening does not limit time spent inside the app.'**
  String get mindfulSettingsDescription;

  /// Toggle label for globally enabling Mindful Opening.
  ///
  /// In en, this message translates to:
  /// **'Enable Mindful Opening'**
  String get mindfulEnabledTitle;

  /// Status shown when Mindful Opening is globally enabled.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening: Enabled'**
  String get mindfulEnabledStatus;

  /// Status shown when Mindful Opening is globally disabled.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening: Disabled'**
  String get mindfulDisabledStatus;

  /// mindfulPartialCoverageWarning.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening works from Phone Detox. Enable Accessibility access and accept the updated disclosure to also catch apps opened from notifications, links, Recents, and other apps.'**
  String get mindfulPartialCoverageWarning;

  /// saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// Countdown remaining before intentional opening.
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, =0{Ready to continue} =1{1 second remaining} other{{seconds} seconds remaining}}'**
  String mindfulSecondsRemaining(int seconds);

  /// Rule editor title for an app.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening for {appName}'**
  String mindfulRuleTitle(String appName);

  /// Delay option in seconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String mindfulDelaySeconds(int seconds);

  /// Configured Mindful delay summary.
  ///
  /// In en, this message translates to:
  /// **'{seconds}-second pause'**
  String mindfulRuleSummary(int seconds);

  /// Number of apps configured for Mindful Opening.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No apps configured} =1{1 app configured} other{{count} apps configured}}'**
  String mindfulConfiguredCount(int count);

  /// Localized product copy for detoxChooseAppsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Choose apps'**
  String get detoxChooseAppsStepTitle;

  /// Localized product copy for detoxChooseAppsStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Selected apps will be completely unavailable while the block is active.'**
  String get detoxChooseAppsStepDescription;

  /// Localized product copy for detoxNoAppsSelectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one app to block.'**
  String get detoxNoAppsSelectedDescription;

  /// Localized product copy for detoxChooseAppsAction.
  ///
  /// In en, this message translates to:
  /// **'Choose apps'**
  String get detoxChooseAppsAction;

  /// Localized product copy for detoxChangeSelectionAction.
  ///
  /// In en, this message translates to:
  /// **'Change selection'**
  String get detoxChangeSelectionAction;

  /// Localized product copy for detoxDurationStepTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Block them for'**
  String get detoxDurationStepTitle;

  /// Localized product copy for detoxDurationStepDescription.
  ///
  /// In en, this message translates to:
  /// **'The countdown starts when you press Start blocking.'**
  String get detoxDurationStepDescription;

  /// Localized product copy for detoxDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String detoxDurationMinutes(int minutes);

  /// Localized product copy for detoxDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour} other{{hours} hours}}'**
  String detoxDurationHours(int hours);

  /// Localized product copy for detoxCustomDurationOption.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get detoxCustomDurationOption;

  /// Localized product copy for detoxCustomDurationSupportingText.
  ///
  /// In en, this message translates to:
  /// **'Between 5 minutes and 8 hours'**
  String get detoxCustomDurationSupportingText;

  /// Localized product copy for detoxBlockingAccessStepTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Blocking access'**
  String get detoxBlockingAccessStepTitle;

  /// Localized product copy for detoxBlockingAccessReady.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking is ready'**
  String get detoxBlockingAccessReady;

  /// Localized product copy for detoxBlockingAccessReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox can detect attempts to open selected apps and return you Home.'**
  String get detoxBlockingAccessReadyDescription;

  /// Localized product copy for detoxBlockingAccessDisabled.
  ///
  /// In en, this message translates to:
  /// **'Strict blocking is not enabled'**
  String get detoxBlockingAccessDisabled;

  /// Localized product copy for detoxBlockingAccessDisabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable Accessibility access so Phone Detox can enforce the block outside the launcher.'**
  String get detoxBlockingAccessDisabledDescription;

  /// Localized product copy for detoxReviewBlockingAccessAction.
  ///
  /// In en, this message translates to:
  /// **'Review and enable access'**
  String get detoxReviewBlockingAccessAction;

  /// Localized product copy for detoxWhatWillHappenTitle.
  ///
  /// In en, this message translates to:
  /// **'What will happen?'**
  String get detoxWhatWillHappenTitle;

  /// Localized product copy for detoxWhatWillHappenEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one app to see exactly what will be blocked.'**
  String get detoxWhatWillHappenEmpty;

  /// Localized product copy for detoxWhatWillHappenSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{appName} will be blocked for {duration}.} other{{count} selected apps will be blocked for {duration}.}}'**
  String detoxWhatWillHappenSummary(int count, String appName, String duration);

  /// Localized product copy for detoxWhatWillHappenAvailability.
  ///
  /// In en, this message translates to:
  /// **'You will not be able to open them until the block ends or you deliberately end the block.'**
  String get detoxWhatWillHappenAvailability;

  /// Localized product copy for detoxNotUsageAllowance.
  ///
  /// In en, this message translates to:
  /// **'This does not give you {duration} of usage inside an app.'**
  String detoxNotUsageAllowance(String duration);

  /// Localized product copy for detoxChooseAppsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Choose apps to continue'**
  String get detoxChooseAppsToContinue;

  /// Localized product copy for detoxDynamicStartAction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Block {appName} for {duration}} other{Block {count} apps for {duration}}}'**
  String detoxDynamicStartAction(int count, String appName, String duration);

  /// Localized product copy for detoxBlockerNoApps.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one app to block.'**
  String get detoxBlockerNoApps;

  /// Localized product copy for detoxBlockerInvalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid blocking duration.'**
  String get detoxBlockerInvalidDuration;

  /// Localized product copy for detoxBlockerDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Review how blocking access is used.'**
  String get detoxBlockerDisclosure;

  /// Localized product copy for detoxBlockerAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Enable strict blocking access.'**
  String get detoxBlockerAccessibility;

  /// Localized product copy for detoxBlockerAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'A block is already active.'**
  String get detoxBlockerAlreadyActive;

  /// Localized product copy for detoxBlockerControllerError.
  ///
  /// In en, this message translates to:
  /// **'Blocking settings could not be loaded. Try again.'**
  String get detoxBlockerControllerError;

  /// Localized product copy for detoxSelectionDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Done — no apps selected} =1{Done — 1 selected} other{Done — {count} selected}}'**
  String detoxSelectionDone(int count);

  /// Localized product copy for detoxMindfulOpeningConfigured.
  ///
  /// In en, this message translates to:
  /// **'Mindful Opening configured'**
  String get detoxMindfulOpeningConfigured;

  /// Localized product copy for detoxBlockEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Block ends in'**
  String get detoxBlockEndsIn;

  /// Localized product copy for detoxCountdownSemantics.
  ///
  /// In en, this message translates to:
  /// **'Block ends in {remainingTime}'**
  String detoxCountdownSemantics(String remainingTime);

  /// Localized product copy for detoxBlockedAppsHeading.
  ///
  /// In en, this message translates to:
  /// **'Blocked apps'**
  String get detoxBlockedAppsHeading;

  /// Localized product copy for detoxBlockedAppExplanation.
  ///
  /// In en, this message translates to:
  /// **'It is included in your active block.'**
  String get detoxBlockedAppExplanation;

  /// Localized product copy for detoxViewActiveBlock.
  ///
  /// In en, this message translates to:
  /// **'View active block'**
  String get detoxViewActiveBlock;

  /// Localized product copy for settingsHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How Phone Detox works'**
  String get settingsHowItWorksTitle;

  /// Localized product copy for settingsMindfulDefinition.
  ///
  /// In en, this message translates to:
  /// **'Pause before selected apps open.'**
  String get settingsMindfulDefinition;

  /// Localized product copy for settingsMindfulDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsMindfulDisabled;

  /// Localized product copy for settingsMindfulNoApps.
  ///
  /// In en, this message translates to:
  /// **'No apps configured'**
  String get settingsMindfulNoApps;

  /// Localized product copy for settingsMindfulEnabledCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Enabled for 1 app} other{Enabled for {count} apps}}'**
  String settingsMindfulEnabledCount(int count);

  /// Localized product copy for settingsTemporaryBlockDefinition.
  ///
  /// In en, this message translates to:
  /// **'Make selected apps completely unavailable for a chosen period.'**
  String get settingsTemporaryBlockDefinition;

  /// Localized product copy for settingsTemporaryBlockInactive.
  ///
  /// In en, this message translates to:
  /// **'No active block'**
  String get settingsTemporaryBlockInactive;

  /// Localized product copy for settingsTemporaryBlockActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app blocked until {endTime}} other{{count} apps blocked until {endTime}}}'**
  String settingsTemporaryBlockActive(int count, String endTime);
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
