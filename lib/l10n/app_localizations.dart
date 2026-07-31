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

  /// Button label for retrying installed app discovery.
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
