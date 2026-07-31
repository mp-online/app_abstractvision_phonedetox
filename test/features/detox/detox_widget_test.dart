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
    home: home,
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
    expect(find.text('Accessibility access disabled'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Start session'),
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
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Start session'),
    );
    expect(button.onPressed, isNotNull);
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
    await tester.tap(find.text('End session'));
    await tester.pump();
    expect(find.text('Hold to end'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.tap(find.text('Emergency exit'));
    await tester.pump();
    expect(find.text('End now'), findsOneWidget);
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
}
