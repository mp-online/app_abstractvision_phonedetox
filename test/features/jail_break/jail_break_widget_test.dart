import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/core/widgets/clock_header.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/jail_break/presentation/jail_break_completed_screen.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/mindful_opening/presentation/mindful_opening_controller.dart';

import '../../support/fake_mindful_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_screen.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';
import 'package:phone_detox/features/settings/presentation/settings_screen.dart';
import 'package:phone_detox/l10n/app_localizations.dart';

class _LauncherRepository implements LauncherRepository {
  int settingsCount = 0;
  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [];
  @override
  Future<void> launchApp(LaunchableApp app) async {}
  @override
  Future<void> openAppDetails(String packageName) async {}
  @override
  Future<void> openCurrentHome() async {}
  @override
  Future<void> openHomeSettings() async => settingsCount++;
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
  _DetoxRepository({this.session, this.stopError});
  DetoxSession? session;
  Object? stopError;
  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async =>
      AccessibilityStatus.enabled;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => session;
  @override
  Future<void> openAccessibilitySettings() async {}
  @override
  Future<void> startSession(DetoxSession value) async => session = value;
  @override
  Future<void> stopSession() async {
    if (stopError case final error?) throw error;
    session = null;
  }
}

class _DetoxPreferences implements DetoxPreferencesRepository {
  _DetoxPreferences({this.session});
  DetoxSession? session;
  @override
  Future<void> clearActiveSession() async => session = null;
  @override
  Future<int?> getAccessibilityDisclosureVersion() async => 1;
  @override
  Future<DetoxSession?> getActiveSession() async => session;
  @override
  Future<Set<String>> getBlockedPackageNames() async => {'blocked.app'};
  @override
  Future<int> getDefaultDurationMinutes() async => 30;
  @override
  Future<void> setAccessibilityDisclosureVersion(int version) async {}
  @override
  Future<void> setActiveSession(DetoxSession value) async => session = value;
  @override
  Future<void> setBlockedPackageNames(Set<String> packageNames) async {}
  @override
  Future<void> setDefaultDurationMinutes(int minutes) async {}
}

class _Host extends ConsumerStatefulWidget {
  const _Host({required this.child});
  final Widget child;
  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(detoxControllerProvider.notifier).refresh();
      await ref.read(launcherControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Widget _testApp({
  required Widget home,
  required _LauncherRepository launcher,
  required _DetoxRepository detox,
  required _DetoxPreferences preferences,
  Locale locale = const Locale('en'),
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    launcherRepositoryProvider.overrideWithValue(launcher),
    mindfulOpeningRepositoryProvider.overrideWithValue(FakeMindfulRepository()),
    launcherPreferencesRepositoryProvider.overrideWithValue(
      _LauncherPreferences(),
    ),
    detoxRepositoryProvider.overrideWithValue(detox),
    detoxPreferencesRepositoryProvider.overrideWithValue(preferences),
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
    home: _Host(child: home),
  ),
);

DetoxSession activeSession() {
  final now = DateTime.now().toUtc();
  return DetoxSession(
    id: 'active',
    startedAt: now,
    endsAt: now.add(const Duration(minutes: 5)),
    blockedPackageNames: {'blocked.app'},
  );
}

void main() {
  testWidgets('header orders Jail Break between clock and Detox', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        home: const LauncherScreen(),
        launcher: _LauncherRepository(),
        detox: _DetoxRepository(),
        preferences: _DetoxPreferences(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ClockHeader), findsOneWidget);
    final jailBreak = find.byKey(const Key('launcher_jail_break_button'));
    expect(jailBreak, findsOneWidget);
    expect(
      find.descendant(
        of: jailBreak,
        matching: find.byIcon(Icons.lock_open_rounded),
      ),
      findsOneWidget,
    );
    expect(
      tester.getCenter(jailBreak).dx,
      lessThan(tester.getCenter(find.byIcon(Icons.timer_outlined)).dx),
    );
    expect(
      tester.getCenter(find.byIcon(Icons.timer_outlined)).dx,
      lessThan(tester.getCenter(find.byIcon(Icons.settings_outlined)).dx),
    );
    await tester.longPress(jailBreak);
    await tester.pumpAndSettle();
    expect(find.text('Leave Phone Detox Home mode'), findsOneWidget);
  });

  testWidgets('inactive confirmation explains Android selection and cancels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        home: const LauncherScreen(),
        launcher: _LauncherRepository(),
        detox: _DetoxRepository(),
        preferences: _DetoxPreferences(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('launcher_jail_break_button')));
    await tester.pumpAndSettle();
    expect(find.text('Leave Phone Detox?'), findsOneWidget);
    expect(find.textContaining('Pixel Launcher'), findsOneWidget);
    expect(
      find.textContaining('cannot change the default Home app'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Leave Phone Detox?'), findsNothing);
  });

  testWidgets('active confirmation states cleanup and failure keeps recovery', (
    tester,
  ) async {
    final session = activeSession();
    final launcher = _LauncherRepository();
    await tester.pumpWidget(
      _testApp(
        home: const LauncherScreen(),
        launcher: launcher,
        detox: _DetoxRepository(
          session: session,
          stopError: StateError('failed'),
        ),
        preferences: _DetoxPreferences(session: session),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('launcher_jail_break_button')));
    await tester.pumpAndSettle();
    expect(find.text('End Detox and leave Phone Detox?'), findsOneWidget);
    expect(
      find.textContaining('immediately end the active Detox session'),
      findsOneWidget,
    );
    await tester.tap(find.text('End session and Jail Break'));
    await tester.pumpAndSettle();
    expect(find.textContaining('could not fully remove'), findsOneWidget);
    expect(find.text('Open Home settings anyway'), findsOneWidget);
    expect(find.text('Open Accessibility settings'), findsOneWidget);
    await tester.tap(find.text('Open Home settings anyway'));
    await tester.pumpAndSettle();
    expect(launcher.settingsCount, 1);
  });

  testWidgets('settings exposes the same localized recovery flow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        home: const SettingsScreen(),
        launcher: _LauncherRepository(),
        detox: _DetoxRepository(),
        preferences: _DetoxPreferences(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recovery'), findsOneWidget);
    expect(find.byKey(const Key('settings_jail_break_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings_jail_break_button')));
    await tester.pumpAndSettle();
    expect(find.text('Leave Phone Detox?'), findsOneWidget);
  });

  testWidgets('German large text keeps Jail Break reachable', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _testApp(
        home: const LauncherScreen(),
        launcher: _LauncherRepository(),
        detox: _DetoxRepository(),
        preferences: _DetoxPreferences(),
        locale: const Locale('de'),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('launcher_jail_break_button'));
    expect(button, findsOneWidget);
    await tester.longPress(button);
    await tester.pumpAndSettle();
    expect(find.text('Aus Phone Detox ausbrechen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completion messaging is neutral and exposes both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        home: JailBreakCompletedScreen(
          onOpenHome: () async {},
          onUseAgain: () {},
        ),
        launcher: _LauncherRepository(),
        detox: _DetoxRepository(),
        preferences: _DetoxPreferences(),
      ),
    );
    expect(find.text('Jail Break complete'), findsOneWidget);
    expect(find.textContaining('no longer your Home app'), findsOneWidget);
    expect(find.text('Open Home screen'), findsOneWidget);
    expect(find.text('Use Phone Detox again'), findsOneWidget);
    expect(find.textContaining('unexpectedly'), findsNothing);
  });
}
