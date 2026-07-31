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
}
