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
  String get detoxTooltip => '„Apps jetzt blockieren“ öffnen';

  @override
  String get detoxTitle => 'Apps jetzt blockieren';

  @override
  String get detoxLoading => 'Blockierungseinstellungen werden geladen…';

  @override
  String get detoxLoadError =>
      'Blockierungseinstellungen konnten nicht geladen werden. Versuche es erneut.';

  @override
  String get detoxManageAppsTitle => 'Zu blockierende Apps';

  @override
  String get detoxManageAppsDescription =>
      'Diese Apps sind während einer aktiven Blockierung nicht verfügbar.';

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
  String get detoxEmptyList => 'Wähle mindestens eine zu blockierende App aus.';

  @override
  String get detoxDurationTitle => 'Ausgewählte Apps blockieren für';

  @override
  String detoxMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get detoxCustomDurationLabel => 'Eigene Blockierungsdauer';

  @override
  String get detoxCustomDurationError =>
      'Gib eine Dauer zwischen 5 Minuten und 8 Stunden ein.';

  @override
  String get detoxAccessibilityExplanation =>
      'Phone Detox kann Versuche erkennen, ausgewählte Apps zu öffnen, und dich zum Startbildschirm zurückbringen.';

  @override
  String get detoxAccessibilityEnabled => 'Strikte Blockierung ist bereit';

  @override
  String get detoxAccessibilityDisabled =>
      'Strikte Blockierung ist nicht aktiviert';

  @override
  String get detoxAccessibilityUnavailable =>
      'Strikte Blockierung ist nicht verfügbar';

  @override
  String get detoxStartAction => 'Blockierung starten';

  @override
  String get detoxStartError =>
      'Die Blockierung konnte nicht gestartet werden. Prüfe den Blockierungszugriff und versuche es erneut.';

  @override
  String get detoxAddAction => 'Zu den zu blockierenden Apps hinzufügen';

  @override
  String get detoxRemoveAction => 'Aus den zu blockierenden Apps entfernen';

  @override
  String detoxBlockedUntil(String appName, String endTime) {
    return '$appName ist bis $endTime nicht verfügbar.';
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
      'Während einer aktiven Detox-Sitzung werden blockierte Apps erkannt. Phone Detox kann dich außerdem für Bewusstes Öffnen zum Startbildschirm zurückbringen und bei einer ausdrücklichen Aktivierung pro App einen zusammenhängenden Vordergrundaufenthalt bis zum Nutzungslimit zählen.';

  @override
  String get detoxDisclosureNotAccessedTitle => 'Worauf nicht zugegriffen wird';

  @override
  String get detoxDisclosureNotAccessedBody =>
      'Phone Detox liest keine Passwörter, Eingaben, Nachrichten, Bildschirm- oder Browserinhalte, Benachrichtigungen, Bilder, Kontakte, Dateien oder Bedienungshilfen-Knotenbäume.';

  @override
  String get detoxDisclosureDataTitle => 'Datenverarbeitung';

  @override
  String get detoxDisclosureDataBody =>
      'Die Verarbeitung erfolgt nur auf diesem Gerät. Nutzungslimits speichern nur konfigurierte Regeln, ein aktuelles Intervall mit Restzeit und Zeitstempeln sowie eine erreichte Sperre. Es wird kein Nutzungsverlauf gespeichert. Sichtbare Pakete und installierte Apps werden nie übertragen. Es gibt keine Analyse oder Verfolgung.';

  @override
  String get detoxDisclosureControlTitle => 'Du behältst die Kontrolle';

  @override
  String get detoxDisclosureControlBody =>
      'Du kannst jederzeit eine Blockierung beenden, den Zugriff deaktivieren, eine andere Start-App wählen oder Phone Detox deinstallieren.';

  @override
  String get detoxDisclosureConsent =>
      'Ich verstehe, wie der Bedienungshilfenzugriff verwendet wird.';

  @override
  String get continueAction => 'Weiter';

  @override
  String get detoxActiveTitle => 'Apps blockiert';

  @override
  String detoxEndsAt(String endTime) {
    return 'Bis $endTime';
  }

  @override
  String detoxBlockedAppsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps sind derzeit blockiert',
      one: '1 App ist derzeit blockiert',
    );
    return '$_temp0';
  }

  @override
  String get detoxEnforcementDisabledWarning =>
      'Die Blockierung ist noch aktiv, wird aber nicht durchgesetzt, weil der Bedienungshilfenzugriff deaktiviert ist.';

  @override
  String get detoxOpenAccessibilitySettings =>
      'Bedienungshilfen-Einstellungen öffnen';

  @override
  String get detoxEndSessionAction => 'Blockierung vorzeitig beenden';

  @override
  String get detoxEndSessionTitle => 'Blockierung vorzeitig beenden?';

  @override
  String get detoxEndSessionBody =>
      'Die ausgewählten Apps sind sofort wieder verfügbar. Halte die Schaltfläche 3 Sekunden lang gedrückt, um zu bestätigen.';

  @override
  String get detoxHoldToEnd => 'Zum Beenden der Blockierung halten';

  @override
  String get detoxEmergencyExitAction => 'Notausstieg';

  @override
  String get detoxEmergencyExitTitle => 'Notausstieg verwenden?';

  @override
  String get detoxEmergencyExitBody =>
      'Mache die ausgewählten Apps sofort wieder verfügbar.';

  @override
  String get detoxEmergencyExitConfirm => 'Apps verfügbar machen';

  @override
  String get detoxSessionComplete => 'Die Blockierung ist beendet.';

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

  @override
  String get jailBreakTooltip => 'Aus Phone Detox ausbrechen';

  @override
  String get jailBreakDialogTitle => 'Phone Detox verlassen?';

  @override
  String get jailBreakDialogBody =>
      'Android öffnet die Einstellungen für die Start-App. Wähle deinen vorherigen Launcher, etwa Pixel Launcher oder One UI Home, um Phone Detox nicht mehr als Startbildschirm zu verwenden.';

  @override
  String get jailBreakPlatformExplanation =>
      'Phone Detox kann die Standard-Start-App nicht ohne deine Bestätigung ändern.';

  @override
  String get jailBreakConfirmAction => 'Ausbrechen';

  @override
  String get jailBreakActiveDialogTitle =>
      'Blockierung beenden und Phone Detox verlassen?';

  @override
  String get jailBreakActiveDialogBody =>
      'Der Notausstieg beendet die aktive Blockierung sofort, macht die ausgewählten Apps verfügbar und öffnet die Android-Einstellungen für Start-Apps.';

  @override
  String get jailBreakActiveConfirmAction =>
      'Blockierung beenden und ausbrechen';

  @override
  String get jailBreakEndingSession => 'Aktive Blockierung wird beendet…';

  @override
  String get jailBreakOpeningSettings =>
      'Android-Einstellungen für Start-Apps werden geöffnet…';

  @override
  String get jailBreakWaitingForSelection =>
      'Warten auf deine Auswahl der Start-App…';

  @override
  String get jailBreakCompletedTitle => 'Ausbruch abgeschlossen';

  @override
  String get jailBreakCompletedBody =>
      'Phone Detox ist nicht mehr deine Start-App. Drücke Home, um den ausgewählten Launcher zu öffnen.';

  @override
  String get jailBreakOpenHomeAction => 'Startbildschirm öffnen';

  @override
  String get jailBreakUseAgainAction => 'Phone Detox wieder verwenden';

  @override
  String get jailBreakCancelledMessage =>
      'Phone Detox ist weiterhin deine Start-App.';

  @override
  String get jailBreakFailureTitle =>
      'Ausbruch konnte nicht abgeschlossen werden';

  @override
  String get jailBreakFailureBody =>
      'Der Status der Android-Start-App konnte nicht bestätigt werden. Öffne die Standard-App-Einstellungen oder versuche es erneut.';

  @override
  String get jailBreakActiveCleanupFailureBody =>
      'Phone Detox konnte die aktive Blockierung nicht vollständig entfernen.';

  @override
  String get jailBreakRetryAction => 'Erneut versuchen';

  @override
  String get jailBreakOpenSettingsAnywayAction =>
      'Start-App-Einstellungen trotzdem öffnen';

  @override
  String get jailBreakOpenHomeSettingsAction =>
      'Standard-App-Einstellungen öffnen';

  @override
  String get jailBreakOpenAccessibilityAction =>
      'Bedienungshilfen-Einstellungen öffnen';

  @override
  String get jailBreakAccessibilityStillEnabled =>
      'Die aktive Blockierung wird beendet. Der Bedienungshilfenzugriff von Phone Detox kann aktiviert bleiben, blockiert ohne aktive Blockierung aber keine Apps.';

  @override
  String get jailBreakSettingsSectionTitle => 'Wiederherstellung';

  @override
  String get jailBreakSettingsDescription =>
      'Wähle eine andere Android-Start-App und verwende Phone Detox nicht mehr als Launcher.';

  @override
  String get jailBreakOpenHomeFailed =>
      'Drücke die Android-Home-Taste, um den ausgewählten Launcher zu öffnen.';

  @override
  String get mindfulTakeBreath => 'Atme kurz durch, bevor du fortfährst.';

  @override
  String get mindfulExternalExplanation =>
      'Diese App wurde außerhalb von Phone Detox geöffnet. Beim Fortfahren wird ihr Hauptbildschirm geöffnet; das ursprüngliche Ziel einer Benachrichtigung oder eines Links kann nicht wiederhergestellt werden.';

  @override
  String get mindfulDirectExplanation =>
      'Halte kurz inne und entscheide dann, ob das Öffnen dieser App noch zu deiner Absicht passt.';

  @override
  String get mindfulWhyQuestion => 'Warum öffnest du diese App?';

  @override
  String get mindfulIntentionReply => 'Jemandem antworten';

  @override
  String get mindfulIntentionTask => 'Eine bestimmte Aufgabe erledigen';

  @override
  String get mindfulIntentionSearch => 'Nach etwas suchen';

  @override
  String get mindfulIntentionCreate => 'Etwas erstellen oder veröffentlichen';

  @override
  String get mindfulIntentionOther => 'Andere';

  @override
  String get mindfulOtherLabel => 'Schreibe deine Absicht';

  @override
  String get mindfulGoBack => 'Zurück';

  @override
  String get mindfulOpenIntentionally => 'Bewusst öffnen';

  @override
  String get mindfulAppUnavailable =>
      'Diese App ist nicht mehr verfügbar. Gehe zurück, um fortzufahren.';

  @override
  String get mindfulModeOff => 'Aus';

  @override
  String get mindfulModePause => 'Pause';

  @override
  String get mindfulModePauseIntention => 'Pause + Absicht';

  @override
  String get mindfulDelayTitle => 'Verzögerung';

  @override
  String get mindfulManageApps => 'Apps verwalten';

  @override
  String get mindfulNoConfiguredApps =>
      'Noch keine Apps konfiguriert. Halte eine App im Launcher gedrückt, um Mindful Opening hinzuzufügen.';

  @override
  String get mindfulOpeningAction => 'Bewusstes Öffnen';

  @override
  String get mindfulConfiguredSemantics => 'Bewusstes Öffnen konfiguriert';

  @override
  String get mindfulSettingsTitle => 'Bewusstes Öffnen';

  @override
  String get mindfulSettingsDescription =>
      'Pausiere, bevor sich eine App öffnet.\n\nBewusstes Öffnen begrenzt nicht die Zeit innerhalb der App.';

  @override
  String get mindfulEnabledTitle => 'Bewusstes Öffnen aktivieren';

  @override
  String get mindfulEnabledStatus => 'Bewusstes Öffnen: Aktiviert';

  @override
  String get mindfulDisabledStatus => 'Bewusstes Öffnen: Deaktiviert';

  @override
  String get mindfulPartialCoverageWarning =>
      'Bewusstes Öffnen funktioniert in Phone Detox. Aktiviere den Bedienungshilfenzugriff und akzeptiere die aktualisierte Erklärung, um auch Apps aus Benachrichtigungen, Links, der Übersicht und anderen Apps zu erfassen.';

  @override
  String get saveAction => 'Speichern';

  @override
  String mindfulSecondsRemaining(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Noch $seconds Sekunden',
      one: 'Noch 1 Sekunde',
      zero: 'Bereit zum Fortfahren',
    );
    return '$_temp0';
  }

  @override
  String mindfulRuleTitle(String appName) {
    return 'Bewusstes Öffnen für $appName';
  }

  @override
  String mindfulDelaySeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String mindfulRuleSummary(int seconds) {
    return '$seconds Sekunden Pause';
  }

  @override
  String mindfulConfiguredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps konfiguriert',
      one: '1 App konfiguriert',
      zero: 'Keine Apps konfiguriert',
    );
    return '$_temp0';
  }

  @override
  String get detoxChooseAppsStepTitle => '1. Apps auswählen';

  @override
  String get detoxChooseAppsStepDescription =>
      'Ausgewählte Apps sind vollständig nicht verfügbar, solange die Blockierung aktiv ist.';

  @override
  String get detoxNoAppsSelectedDescription =>
      'Wähle mindestens eine zu blockierende App aus.';

  @override
  String get detoxChooseAppsAction => 'Apps auswählen';

  @override
  String get detoxChangeSelectionAction => 'Auswahl ändern';

  @override
  String get detoxDurationStepTitle => '2. Blockieren für';

  @override
  String get detoxDurationStepDescription =>
      'Der Countdown beginnt, wenn du „Blockierung starten“ drückst.';

  @override
  String detoxDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String detoxDurationHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String get detoxCustomDurationOption => 'Eigene Dauer';

  @override
  String get detoxCustomDurationSupportingText =>
      'Zwischen 5 Minuten und 8 Stunden';

  @override
  String get detoxBlockingAccessStepTitle => '3. Blockierungszugriff';

  @override
  String get detoxBlockingAccessReady => 'Strikte Blockierung ist bereit';

  @override
  String get detoxBlockingAccessReadyDescription =>
      'Phone Detox kann Versuche erkennen, ausgewählte Apps zu öffnen, und dich zum Startbildschirm zurückbringen.';

  @override
  String get detoxBlockingAccessDisabled =>
      'Strikte Blockierung ist nicht aktiviert';

  @override
  String get detoxBlockingAccessDisabledDescription =>
      'Aktiviere den Bedienungshilfenzugriff, damit Phone Detox die Blockierung außerhalb des Launchers durchsetzen kann.';

  @override
  String get detoxReviewBlockingAccessAction => 'Zugriff prüfen und aktivieren';

  @override
  String get detoxWhatWillHappenTitle => 'Was wird passieren?';

  @override
  String get detoxWhatWillHappenEmpty =>
      'Wähle mindestens eine App aus, um genau zu sehen, was blockiert wird.';

  @override
  String detoxWhatWillHappenSummary(
    int count,
    String appName,
    String duration,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählte Apps werden für $duration blockiert.',
      one: '$appName wird für $duration blockiert.',
    );
    return '$_temp0';
  }

  @override
  String get detoxWhatWillHappenAvailability =>
      'Du kannst sie nicht öffnen, bis die Blockierung endet oder du sie bewusst beendest.';

  @override
  String detoxNotUsageAllowance(String duration) {
    return 'Dies gibt dir nicht $duration Nutzungszeit innerhalb einer App.';
  }

  @override
  String get detoxChooseAppsToContinue => 'Apps auswählen, um fortzufahren';

  @override
  String detoxDynamicStartAction(int count, String appName, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps für $duration blockieren',
      one: '$appName für $duration blockieren',
    );
    return '$_temp0';
  }

  @override
  String get detoxBlockerNoApps =>
      'Wähle mindestens eine zu blockierende App aus.';

  @override
  String get detoxBlockerInvalidDuration =>
      'Gib eine gültige Blockierungsdauer ein.';

  @override
  String get detoxBlockerDisclosure =>
      'Prüfe, wie der Blockierungszugriff verwendet wird.';

  @override
  String get detoxBlockerAccessibility =>
      'Aktiviere den Zugriff für strikte Blockierung.';

  @override
  String get detoxBlockerAlreadyActive => 'Eine Blockierung ist bereits aktiv.';

  @override
  String get detoxBlockerControllerError =>
      'Blockierungseinstellungen konnten nicht geladen werden. Versuche es erneut.';

  @override
  String detoxSelectionDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fertig — $count ausgewählt',
      one: 'Fertig — 1 ausgewählt',
      zero: 'Fertig — keine Apps ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get detoxMindfulOpeningConfigured => 'Bewusstes Öffnen konfiguriert';

  @override
  String get detoxBlockEndsIn => 'Blockierung endet in';

  @override
  String detoxCountdownSemantics(String remainingTime) {
    return 'Blockierung endet in $remainingTime';
  }

  @override
  String get detoxBlockedAppsHeading => 'Blockierte Apps';

  @override
  String get detoxBlockedAppExplanation =>
      'Sie ist Teil deiner aktiven Blockierung.';

  @override
  String get detoxViewActiveBlock => 'Aktive Blockierung anzeigen';

  @override
  String get settingsHowItWorksTitle => 'So funktioniert Phone Detox';

  @override
  String get settingsMindfulDefinition =>
      'Pausiere, bevor ausgewählte Apps geöffnet werden.';

  @override
  String get settingsMindfulDisabled => 'Deaktiviert';

  @override
  String get settingsMindfulNoApps => 'Keine Apps konfiguriert';

  @override
  String settingsMindfulEnabledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Für $count Apps aktiviert',
      one: 'Für 1 App aktiviert',
    );
    return '$_temp0';
  }

  @override
  String get settingsTemporaryBlockDefinition =>
      'Mache ausgewählte Apps für einen gewählten Zeitraum vollständig nicht verfügbar.';

  @override
  String get settingsTemporaryBlockInactive => 'Keine aktive Blockierung';

  @override
  String settingsTemporaryBlockActive(int count, String endTime) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps bis $endTime blockiert',
      one: '1 App bis $endTime blockiert',
    );
    return '$_temp0';
  }

  @override
  String get usageLimitTitle => 'Nutzungslimits';

  @override
  String get usageLimitDescription =>
      'Optionale Limits pro App für einen zusammenhängenden Aufenthalt im Vordergrund. Es werden keine Tagessummen oder Nutzungsverläufe gespeichert.';

  @override
  String get usageLimitEnabledTitle => 'Nutzungslimits aktivieren';

  @override
  String get usageLimitEnabledStatus => 'Aktiviert';

  @override
  String get usageLimitDisabledStatus => 'Standardmäßig aus';

  @override
  String get usageLimitManageApps => 'App-Limits verwalten';

  @override
  String usageLimitConfiguredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Apps eingerichtet',
      one: '1 App eingerichtet',
      zero: 'Keine Apps eingerichtet',
    );
    return '$_temp0';
  }

  @override
  String get usageLimitAppAction => 'Nutzungslimit';

  @override
  String usageLimitEditorTitle(String appName) {
    return 'Nutzungslimit für $appName';
  }

  @override
  String get usageLimitWarning =>
      'Wenn die Zeit abgelaufen ist, kehrt Phone Detox zum Startbildschirm zurück und verhindert ein erneutes Öffnen, bis du dich entscheidest. Android erzwingt kein Beenden der App.';

  @override
  String get usageLimitAcknowledge =>
      'Ich verstehe, was passiert, wenn die Zeit abgelaufen ist.';

  @override
  String get usageLimitOff => 'Aus';

  @override
  String usageLimitMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get usageLimitEnableAndSave => 'Aktivieren und speichern';

  @override
  String get usageLimitNotNow => 'Nicht jetzt';

  @override
  String get usageLimitSave => 'Limit speichern';

  @override
  String get usageLimitTimeUpTitle => 'Zeit abgelaufen';

  @override
  String usageLimitTimeUpBody(String appName) {
    return 'Dein zusammenhängender Aufenthalt in $appName hat das Limit erreicht.';
  }

  @override
  String get usageLimitStayOut => 'Draußen bleiben';

  @override
  String get usageLimitContinue => 'Weiter';

  @override
  String get usageLimitChange => 'Limit ändern';

  @override
  String get usageLimitReachedSemantics => 'Nutzungslimit erreicht';

  @override
  String get usageLimitConfiguredSemantics => 'Nutzungslimit eingerichtet';

  @override
  String get usageLimitDisclosureRequired =>
      'Prüfe und akzeptiere die aktualisierte Erklärung zur Bedienungshilfe, bevor du Nutzungslimits aktivierst.';

  @override
  String get usageLimitEnablePrompt =>
      'Nutzungslimits sind aus. Global aktivieren und den 15-Minuten-Vorschlag für diese App speichern?';

  @override
  String get usageLimitEmpty =>
      'Keine konfigurierbaren startbaren Apps verfügbar.';
}
