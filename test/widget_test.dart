import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/app/phone_detox_app.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';

class WidgetLauncherRepository implements LauncherRepository {
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [
    LaunchableApp(
      label: 'Camera',
      packageName: 'system.camera',
      activityName: 'CameraActivity',
    ),
  ];

  @override
  Future<bool> isDefaultLauncher() async => true;

  @override
  Future<void> launchApp(LaunchableApp app) async {}

  @override
  Future<void> openAppDetails(String packageName) async {}

  @override
  Future<void> requestDefaultLauncher() async {}
}

class WidgetPreferencesRepository implements LauncherPreferencesRepository {
  @override
  Future<Set<String>> getFavouriteIds() async => {};

  @override
  Future<Set<String>> getHiddenIds() async => {};

  @override
  Future<void> setFavouriteIds(Set<String> ids) async {}

  @override
  Future<void> setHiddenIds(Set<String> ids) async {}
}

class WidgetDetoxRepository implements DetoxRepository {
  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async =>
      AccessibilityStatus.disabled;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => null;
  @override
  Future<void> openAccessibilitySettings() async {}
  @override
  Future<void> startSession(DetoxSession session) async {}
  @override
  Future<void> stopSession() async {}
}

class WidgetDetoxPreferences implements DetoxPreferencesRepository {
  @override
  Future<void> clearActiveSession() async {}
  @override
  Future<int?> getAccessibilityDisclosureVersion() async => null;
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

void main() {
  testWidgets('shows discovered apps and filters search results', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          launcherRepositoryProvider.overrideWithValue(
            WidgetLauncherRepository(),
          ),
          launcherPreferencesRepositoryProvider.overrideWithValue(
            WidgetPreferencesRepository(),
          ),
          detoxRepositoryProvider.overrideWithValue(WidgetDetoxRepository()),
          detoxPreferencesRepositoryProvider.overrideWithValue(
            WidgetDetoxPreferences(),
          ),
        ],
        child: const PhoneDetoxApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Camera'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'missing');
    await tester.pump();
    expect(find.text('No apps match your search.'), findsOneWidget);
  });
}
