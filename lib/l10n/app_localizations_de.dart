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
      'Wähle Phone Detox aus, wenn Android nach der Start-App fragt. Dies lässt sich jederzeit in den Systemeinstellungen ändern.';

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

  @override
  String get detoxTooltip => 'Detox öffnen';

  @override
  String get detoxTitle => 'Detox';

  @override
  String get detoxLoading => 'Detox-Einstellungen werden geladen…';

  @override
  String get detoxLoadError =>
      'Detox-Einstellungen konnten nicht geladen werden. Versuche es erneut.';

  @override
  String get detoxManageAppsTitle => 'Zu blockierende Apps';

  @override
  String get detoxManageAppsDescription =>
      'Diese Pakete werden während einer Sitzung blockiert.';

  @override
  String get detoxNoAppsAvailable => 'Keine startbaren Apps verfügbar.';

  @override
  String detoxSelectedApps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps ausgewählt',
      one: '1 App ausgewählt',
      zero: 'Keine Apps ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get detoxEmptyList => 'Wähle mindestens eine ablenkende App.';

  @override
  String get detoxDurationTitle => 'Sitzungsdauer';

  @override
  String detoxMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get detoxCustomDurationLabel => 'Eigene Dauer (5–480 Minuten)';

  @override
  String get detoxCustomDurationError =>
      'Gib einen Wert zwischen 5 und 480 ein.';

  @override
  String get detoxAccessibilityExplanation =>
      'Strikte Blockierung benötigt Bedienungshilfenzugriff. Er wird nur verwendet, um während einer aktiven Sitzung das sichtbare App-Paket zu erkennen.';

  @override
  String get detoxAccessibilityEnabled => 'Bedienungshilfenzugriff aktiviert';

  @override
  String get detoxAccessibilityDisabled =>
      'Bedienungshilfenzugriff deaktiviert';

  @override
  String get detoxAccessibilityUnavailable =>
      'Bedienungshilfenzugriff nicht verfügbar';

  @override
  String get detoxStartAction => 'Sitzung starten';

  @override
  String get detoxStartError =>
      'Die Sitzung konnte nicht gestartet werden. Prüfe den Bedienungshilfenzugriff und versuche es erneut.';

  @override
  String get detoxAddAction => 'Zur Detox-Liste hinzufügen';

  @override
  String get detoxRemoveAction => 'Aus Detox-Liste entfernen';

  @override
  String detoxBlockedUntil(String endTime) {
    return 'Diese App ist bis $endTime blockiert.';
  }

  @override
  String get detoxDisclosureTitle => 'Verwendung des Bedienungshilfenzugriffs';

  @override
  String get detoxDisclosureWhatTitle => 'Welcher Zugriff verwendet wird';

  @override
  String get detoxDisclosureWhatBody =>
      'Phone Detox erkennt, welches Anwendungspaket gerade sichtbar ist, solange sein Bedienungshilfendienst aktiviert ist.';

  @override
  String get detoxDisclosureWhyTitle => 'Warum er verwendet wird';

  @override
  String get detoxDisclosureWhyBody =>
      'Während einer aktiven Sitzung wird damit eine ausgewählte blockierte App erkannt und du wirst sofort zum Startbildschirm zurückgebracht.';

  @override
  String get detoxDisclosureNotAccessedTitle => 'Worauf nicht zugegriffen wird';

  @override
  String get detoxDisclosureNotAccessedBody =>
      'Phone Detox liest keine Passwörter, Eingaben, Nachrichten, Bildschirm- oder Browserinhalte, Benachrichtigungen, Bilder, Kontakte, Dateien oder Bedienungshilfen-Knotenbäume.';

  @override
  String get detoxDisclosureDataTitle => 'Datenverarbeitung';

  @override
  String get detoxDisclosureDataBody =>
      'Die Verarbeitung erfolgt nur auf diesem Gerät. Sichtbare Pakete und installierte Apps werden nie übertragen. Es gibt keine Analyse oder Verfolgung.';

  @override
  String get detoxDisclosureControlTitle => 'Du behältst die Kontrolle';

  @override
  String get detoxDisclosureControlBody =>
      'Du kannst jederzeit eine Sitzung beenden, den Zugriff deaktivieren, eine andere Start-App wählen oder Phone Detox deinstallieren.';

  @override
  String get detoxDisclosureConsent =>
      'Ich verstehe, wie der Bedienungshilfenzugriff verwendet wird.';

  @override
  String get continueAction => 'Weiter';

  @override
  String get detoxActiveTitle => 'Detox-Sitzung aktiv';

  @override
  String detoxEndsAt(String endTime) {
    return 'Endet um $endTime';
  }

  @override
  String detoxBlockedAppsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blockierte Apps',
      one: '1 blockierte App',
    );
    return '$_temp0';
  }

  @override
  String get detoxEnforcementDisabledWarning =>
      'Die Sitzung ist noch aktiv, aber die Blockierung greift nicht, weil der Bedienungshilfenzugriff deaktiviert ist.';

  @override
  String get detoxOpenAccessibilitySettings =>
      'Bedienungshilfen-Einstellungen öffnen';

  @override
  String get detoxEndSessionAction => 'Sitzung beenden';

  @override
  String get detoxEndSessionTitle => 'Diese Sitzung beenden?';

  @override
  String get detoxEndSessionBody =>
      'Halte die Schaltfläche 3 Sekunden lang gedrückt, um die Sitzung zu beenden.';

  @override
  String get detoxHoldToEnd => 'Zum Beenden halten';

  @override
  String get detoxEmergencyExitAction => 'Notausstieg';

  @override
  String get detoxEmergencyExitTitle => 'Notausstieg verwenden?';

  @override
  String get detoxEmergencyExitBody =>
      'Dadurch wird die Sitzung sofort beendet und die Blockierung aufgehoben.';

  @override
  String get detoxEmergencyExitConfirm => 'Jetzt beenden';

  @override
  String get detoxSessionComplete => 'Detox-Sitzung abgeschlossen.';

  @override
  String get startupLoading => 'Dein Startbildschirm wird vorbereitet…';

  @override
  String get startupActivationTitle =>
      'Phone Detox als Startbildschirm festlegen';

  @override
  String get startupActivationExplanation =>
      'Phone Detox ersetzt deinen normalen Launcher und wird geöffnet, wenn du die Home-Taste verwendest.';

  @override
  String get startupAndroidConfirmationExplanation =>
      'Android benötigt deine Bestätigung. Wähle Phone Detox auf dem folgenden Systembildschirm aus.';

  @override
  String get startupReversibleChoiceExplanation =>
      'Deine Auswahl bleibt bestehen, bis du eine andere Start-App wählst. Du kannst sie jederzeit in den Android-Einstellungen ändern.';

  @override
  String get startupChooseHomeAction => 'Phone Detox als Start-App wählen';

  @override
  String get startupOpenHomeSettingsAction => 'Start-App-Einstellungen öffnen';

  @override
  String get startupWaitingForAndroid => 'Warten auf die Android-Bestätigung…';

  @override
  String get startupAccessGranted =>
      'Phone Detox ist jetzt dein Startbildschirm.';

  @override
  String get startupSelectionCancelled =>
      'Auswahl abgebrochen. Phone Detox kann erst nach deiner Bestätigung zum Startbildschirm werden.';

  @override
  String get startupAnotherLauncherSelected =>
      'Eine andere Start-App ist weiterhin ausgewählt. Versuche es erneut, wenn du bereit bist.';

  @override
  String get startupSettingsOpened =>
      'Wähle Phone Detox in den Android-Start-App-Einstellungen und kehre dann hierher zurück.';

  @override
  String get startupHomeRoleUnavailableTitle =>
      'Startbildschirm-Einrichtung nicht verfügbar';

  @override
  String get startupHomeRoleUnavailable =>
      'Android stellt keinen unterstützten Auswahlbildschirm bereit. Öffne die Einstellungen und wähle die Standard-Start-App manuell.';

  @override
  String get startupRoleLostTitle =>
      'Phone Detox ist nicht mehr deine Start-App';

  @override
  String get startupRoleLostExplanation =>
      'Android verwendet derzeit eine andere Start-App. Stelle Phone Detox wieder her, um Home-Taste und Launcher weiter zu verwenden.';

  @override
  String get startupRestoreHomeAction =>
      'Phone Detox als Start-App wiederherstellen';

  @override
  String get startupFailureTitle => 'Phone Detox konnte nicht gestartet werden';

  @override
  String get startupFailureMessage =>
      'Der Start-App-Status konnte nicht geprüft werden. Versuche es erneut oder bestätige die Start-App in den Android-Einstellungen.';

  @override
  String get startupStrictBlockingTitle => 'Strikte App-Blockierung aktivieren';

  @override
  String get startupStrictBlockingExplanation =>
      'Optionaler Bedienungshilfenzugriff kann dich während einer Detox-Sitzung zurück zum Startbildschirm bringen, wenn eine ausgewählte blockierte App geöffnet wird.';

  @override
  String get startupStrictBlockingAction => 'Strikte Blockierung einrichten';
}
