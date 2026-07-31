import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_mode.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_preferences_repository.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_rule.dart';
import 'package:phone_detox/features/mindful_opening/presentation/mindful_opening_controller.dart';
import 'package:phone_detox/features/settings/presentation/settings_screen.dart';
import 'package:phone_detox/l10n/app_localizations.dart';

import '../../support/fake_mindful_repository.dart';

class _LauncherRepository implements LauncherRepository {
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [];
  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;
  @override
  Future<void> launchApp(LaunchableApp app) async {}
  @override
  Future<void> openAppDetails(String packageName) async {}
  @override
  Future<void> openCurrentHome() async {}
  @override
  Future<void> openHomeSettings() async {}
  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.alreadyHeld;
}

class _LauncherPreferences implements LauncherPreferencesRepository {
  @override
  Future<Set<String>> getFavouriteIds() async => {};
  @override
  Future<Set<String>> getHiddenIds() async => {};
  @override
  Future<void> setFavouriteIds(Set<String> ids) async {}
  @override
  Future<void> setHiddenIds(Set<String> ids) async {}
}

class _DetoxRepository implements DetoxRepository {
  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async =>
      AccessibilityStatus.enabled;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => null;
  @override
  Future<void> openAccessibilitySettings() async {}
  @override
  Future<void> startSession(DetoxSession session) async {}
  @override
  Future<void> stopSession() async {}
}

class _DetoxPreferences implements DetoxPreferencesRepository {
  @override
  Future<void> clearActiveSession() async {}
  @override
  Future<int?> getAccessibilityDisclosureVersion() async => 2;
  @override
  Future<DetoxSession?> getActiveSession() async => null;
  @override
  Future<Set<String>> getBlockedPackageNames() async => {};
  @override
  Future<int> getDefaultDurationMinutes() async => 30;
  @override
  Future<void> setAccessibilityDisclosureVersion(int version) async {}
  @override
  Future<void> setActiveSession(DetoxSession session) async {}
  @override
  Future<void> setBlockedPackageNames(Set<String> packageNames) async {}
  @override
  Future<void> setDefaultDurationMinutes(int minutes) async {}
}

class _Preferences implements MindfulOpeningPreferencesRepository {
  Map<String, MindfulOpeningRule> rules = {};

  @override
  Future<bool> getMindfulOpeningEnabled() async => true;

  @override
  Future<Map<String, MindfulOpeningRule>> getRules() async => Map.of(rules);

  @override
  Future<void> setMindfulOpeningEnabled(bool enabled) async {}

  @override
  Future<void> setRules(Map<String, MindfulOpeningRule> value) async =>
      rules = Map.of(value);
}

class _Host extends ConsumerStatefulWidget {
  const _Host({required this.configured});
  final bool configured;

  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host> {
  @override
  void initState() {
    super.initState();
    if (widget.configured) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(mindfulOpeningControllerProvider.notifier)
            .setRule(
              MindfulOpeningRule(
                packageName: 'com.android.chrome',
                mode: MindfulOpeningMode.pause,
                delaySeconds: 10,
              ),
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) => const SettingsScreen();
}

Widget testApp({
  required Locale locale,
  bool configured = false,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    launcherRepositoryProvider.overrideWithValue(_LauncherRepository()),
    launcherPreferencesRepositoryProvider.overrideWithValue(
      _LauncherPreferences(),
    ),
    detoxRepositoryProvider.overrideWithValue(_DetoxRepository()),
    detoxPreferencesRepositoryProvider.overrideWithValue(_DetoxPreferences()),
    mindfulOpeningRepositoryProvider.overrideWithValue(FakeMindfulRepository()),
    mindfulOpeningPreferencesRepositoryProvider.overrideWithValue(
      _Preferences(),
    ),
  ],
  child: MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: _Host(configured: configured),
  ),
);

void main() {
  testWidgets(
    'English settings distinguish app entry from duration reminders',
    (tester) async {
      await tester.pumpWidget(testApp(locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Mindful Opening adds a pause before selected apps open.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'does not currently limit how long you remain in an app',
        ),
        findsOneWidget,
      );
      expect(find.text('Mindful Opening: Enabled'), findsOneWidget);
      expect(find.text('No apps configured'), findsOneWidget);
    },
  );

  testWidgets('configured application count is visible', (tester) async {
    await tester.pumpWidget(
      testApp(locale: const Locale('en'), configured: true),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 app configured'), findsOneWidget);
    expect(find.text('No apps configured'), findsNothing);
  });

  testWidgets('German copy and empty state support large text scaling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(testApp(locale: const Locale('de'), textScale: 2));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        '„Bewusstes Öffnen“ fügt vor dem Start ausgewählter Apps eine Pause ein.',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining('Es begrenzt derzeit nicht die Nutzungsdauer'),
      findsOneWidget,
    );
    expect(find.text('Bewusstes Öffnen: Aktiviert'), findsOneWidget);
    expect(find.text('Keine Apps konfiguriert'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
