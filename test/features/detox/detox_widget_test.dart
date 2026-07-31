import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/accessibility_disclosure_screen.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/detox/presentation/detox_screen.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_state.dart';
import 'package:phone_detox/l10n/app_localizations.dart';

class WidgetDetoxRepository implements DetoxRepository {
  WidgetDetoxRepository({
    this.accessibility = AccessibilityStatus.disabled,
    this.nativeSession,
  });
  AccessibilityStatus accessibility;
  DetoxSession? nativeSession;
  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async => accessibility;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => nativeSession;
  @override
  Future<void> openAccessibilitySettings() async {}
  @override
  Future<void> startSession(DetoxSession session) async =>
      nativeSession = session;
  @override
  Future<void> stopSession() async => nativeSession = null;
}

class WidgetDetoxPreferences implements DetoxPreferencesRepository {
  WidgetDetoxPreferences({
    this.packages = const {},
    this.disclosure,
    this.session,
  });
  Set<String> packages;
  int? disclosure;
  DetoxSession? session;
  @override
  Future<void> clearActiveSession() async => session = null;
  @override
  Future<int?> getAccessibilityDisclosureVersion() async => disclosure;
  @override
  Future<DetoxSession?> getActiveSession() async => session;
  @override
  Future<Set<String>> getBlockedPackageNames() async => packages;
  @override
  Future<int> getDefaultDurationMinutes() async => 30;
  @override
  Future<void> setAccessibilityDisclosureVersion(int value) async =>
      disclosure = value;
  @override
  Future<void> setActiveSession(DetoxSession value) async => session = value;
  @override
  Future<void> setBlockedPackageNames(Set<String> value) async =>
      packages = value;
  @override
  Future<void> setDefaultDurationMinutes(int minutes) async {}
}

class _StaticLauncherController extends LauncherController {
  @override
  LauncherState build() => const LauncherState(
    status: LauncherStatus.success,
    apps: [
      LaunchableApp(
        label: 'Chrome',
        packageName: 'example.app',
        activityName: 'MainActivity',
      ),
    ],
  );
}

class _DetoxTestHost extends ConsumerStatefulWidget {
  const _DetoxTestHost({required this.child});

  final Widget child;

  @override
  ConsumerState<_DetoxTestHost> createState() => _DetoxTestHostState();
}

class _DetoxTestHostState extends ConsumerState<_DetoxTestHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(detoxControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Widget app({
  required Widget home,
  required WidgetDetoxRepository repository,
  required WidgetDetoxPreferences preferences,
  Locale locale = const Locale('en'),
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    detoxRepositoryProvider.overrideWithValue(repository),
    detoxPreferencesRepositoryProvider.overrideWithValue(preferences),
    launcherControllerProvider.overrideWith(_StaticLauncherController.new),
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
    home: _DetoxTestHost(child: home),
  ),
);

void main() {
  testWidgets('setup disables start with empty list and disabled access', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(),
        preferences: WidgetDetoxPreferences(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No apps selected'), findsOneWidget);
    expect(find.text('1. Choose apps'), findsOneWidget);
    expect(find.text('2. Block them for'), findsOneWidget);
    expect(find.text('Choose at least one app to block.'), findsOneWidget);
    expect(find.byKey(const Key('detox_custom_duration_field')), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(find.text('3. Blocking access'), findsOneWidget);
    expect(find.text('Strict blocking is not enabled'), findsOneWidget);
    expect(find.text('Choose at least one app to block.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Choose apps to continue'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('disclosure checkbox gates Continue', (tester) async {
    await tester.pumpWidget(
      app(
        home: const AccessibilityDisclosureScreen(),
        repository: WidgetDetoxRepository(),
        preferences: WidgetDetoxPreferences(),
      ),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pump();
    var button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continue'),
    );
    expect(button.onPressed, isNull);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continue'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('valid configuration enables Start', (tester) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(
          accessibility: AccessibilityStatus.enabled,
        ),
        preferences: WidgetDetoxPreferences(
          packages: {'example.app'},
          disclosure: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Block Chrome for 30 minutes'),
    );
    expect(button.onPressed, isNotNull);
    expect(find.text('Chrome will be blocked for 30 minutes.'), findsOneWidget);
  });

  testWidgets('active countdown warns when unenforced and exposes both exits', (
    tester,
  ) async {
    final now = DateTime.now().toUtc();
    final session = DetoxSession(
      id: 'active',
      startedAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      blockedPackageNames: {'example.app'},
    );
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(nativeSession: session),
        preferences: WidgetDetoxPreferences(session: session),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('blocking is not enforced'), findsOneWidget);
    expect(find.textContaining('00:04:'), findsOneWidget);
    await tester.tap(find.text('End block early'));
    await tester.pump();
    expect(find.text('Hold to end block'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    await tester.tap(find.text('Emergency exit'));
    await tester.pump();
    expect(find.text('Make apps available'), findsOneWidget);
  });

  testWidgets('German disclosure renders at large text scale', (tester) async {
    await tester.pumpWidget(
      app(
        home: const AccessibilityDisclosureScreen(),
        repository: WidgetDetoxRepository(),
        preferences: WidgetDetoxPreferences(),
        locale: const Locale('de'),
        textScale: 2,
      ),
    );
    expect(
      find.text('Verwendung des Bedienungshilfenzugriffs'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('custom duration is deliberate and validates input', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(
          accessibility: AccessibilityStatus.enabled,
        ),
        preferences: WidgetDetoxPreferences(
          packages: {'example.app'},
          disclosure: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detox_custom_duration_field')), findsNothing);

    await tester.ensureVisible(find.text('Custom'));
    await tester.tap(find.text('Custom'));
    await tester.pump();
    expect(
      find.byKey(const Key('detox_custom_duration_field')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('detox_custom_duration_field')),
      '2',
    );
    await tester.pump();
    expect(
      find.text('Enter a duration between 5 minutes and 8 hours.'),
      findsOneWidget,
    );
    tester.testTextInput.hide();
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid blocking duration.'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('1 hour'));
    await tester.tap(find.text('1 hour'));
    await tester.pump();
    expect(find.byKey(const Key('detox_custom_duration_field')), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(find.text('Block Chrome for 1 hour'), findsOneWidget);
  });

  testWidgets('multiple selected apps use plural dynamic copy', (tester) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(
          accessibility: AccessibilityStatus.enabled,
        ),
        preferences: WidgetDetoxPreferences(
          packages: {'one.app', 'two.app', 'three.app'},
          disclosure: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(
      find.text('3 selected apps will be blocked for 30 minutes.'),
      findsOneWidget,
    );
    expect(find.text('Block 3 apps for 30 minutes'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('2 hours'));
    await tester.tap(find.text('2 hours'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(find.text('Block 3 apps for 2 hours'), findsOneWidget);
  });

  testWidgets('German setup supports narrow large-text layout', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(),
        preferences: WidgetDetoxPreferences(),
        locale: const Locale('de'),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Apps jetzt blockieren'), findsOneWidget);
    expect(find.text('1. Apps auswählen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('app selection explains blocking and has explicit Done action', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(),
        preferences: WidgetDetoxPreferences(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose apps'));
    await tester.pumpAndSettle();

    expect(find.text('Apps to block'), findsOneWidget);
    expect(
      find.text('These apps will be unavailable during an active block.'),
      findsOneWidget,
    );
    expect(find.text('Chrome'), findsOneWidget);
    expect(find.text('example.app'), findsOneWidget);
    expect(find.text('Done — no apps selected'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('Done — 1 selected'), findsOneWidget);
  });

  testWidgets('German dynamic copy uses plural apps and hours', (tester) async {
    await tester.pumpWidget(
      app(
        home: const DetoxScreen(),
        repository: WidgetDetoxRepository(
          accessibility: AccessibilityStatus.enabled,
        ),
        preferences: WidgetDetoxPreferences(
          packages: {'one.app', 'two.app', 'three.app'},
          disclosure: 1,
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 Stunden'));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(
      find.text('3 ausgewählte Apps werden für 2 Stunden blockiert.'),
      findsOneWidget,
    );
    expect(find.text('3 Apps für 2 Stunden blockieren'), findsOneWidget);
  });
}
