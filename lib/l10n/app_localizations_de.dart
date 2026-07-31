// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Phone Detox';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsTooltip => 'Einstellungen öffnen';

  @override
  String get searchLabel => 'Apps suchen';

  @override
  String get searchHint => 'Name oder Paket';

  @override
  String get makeDefaultTitle => 'Phone Detox als Start-App festlegen';

  @override
  String get makeDefaultBody =>
      'Wähle Phone Detox aus, wenn Android nach der zu verwendenden Start-App fragt. Dies lässt sich jederzeit in den Systemeinstellungen ändern.';

  @override
  String get makeDefaultAction => 'Start-App auswählen';

  @override
  String get loadingApps => 'Apps werden geladen…';

  @override
  String get loadAppsError =>
      'Apps konnten nicht geladen werden. Android-Einstellungen und Navigation bleiben verfügbar.';

  @override
  String get retryAction => 'Erneut versuchen';

  @override
  String get noApps => 'Keine startbaren Apps gefunden.';

  @override
  String get noSearchResults => 'Keine Apps entsprechen der Suche.';

  @override
  String appActionsTitle(String appName) {
    return 'Aktionen für $appName';
  }

  @override
  String get favouriteAction => 'Zu Favoriten hinzufügen';

  @override
  String get unfavouriteAction => 'Aus Favoriten entfernen';

  @override
  String get hideAction => 'Im Launcher ausblenden';

  @override
  String get launchFailed => 'Diese App konnte nicht geöffnet werden.';

  @override
  String get hiddenAppsTitle => 'Ausgeblendete Apps';

  @override
  String get hiddenAppsDescription =>
      'Ausgeblendete Apps bleiben installiert und können hier jederzeit wiederhergestellt werden.';

  @override
  String get hiddenAppsEmpty => 'Keine Apps sind ausgeblendet.';

  @override
  String get restoreAction => 'Wiederherstellen';
}
