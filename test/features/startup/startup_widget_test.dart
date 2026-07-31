import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/startup/presentation/launcher_activation_screen.dart';
import 'package:phone_detox/features/startup/presentation/launcher_role_lost_screen.dart';
import 'package:phone_detox/l10n/app_localizations.dart';

Widget localized(Widget home, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  testWidgets('activation explains confirmation and exposes both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        LauncherActivationScreen(
          requesting: false,
          onRequest: () {},
          onOpenSettings: () {},
        ),
      ),
    );
    expect(find.text('Make Phone Detox your Home screen'), findsOneWidget);
    expect(find.text('Choose Phone Detox as Home'), findsOneWidget);
    expect(find.text('Open Home settings'), findsOneWidget);
  });

  testWidgets('waiting disables actions and cancelled remains recoverable', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        LauncherActivationScreen(
          requesting: true,
          onRequest: () {},
          onOpenSettings: () {},
        ),
      ),
    );
    expect(find.text('Waiting for Android confirmation…'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.pumpWidget(
      localized(
        LauncherActivationScreen(
          requesting: false,
          lastResult: HomeRoleRequestResult.cancelled,
          onRequest: () {},
          onOpenSettings: () {},
        ),
      ),
    );
    expect(find.textContaining('Selection cancelled'), findsOneWidget);
  });

  testWidgets('role-lost recovery renders in German at large text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: localized(
          LauncherRoleLostScreen(
            requesting: false,
            onRestore: () {},
            onOpenSettings: () {},
          ),
          locale: const Locale('de'),
        ),
      ),
    );
    expect(
      find.text('Phone Detox ist nicht mehr deine Start-App'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
