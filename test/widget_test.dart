import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/app/phone_detox_app.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/startup/domain/startup_preferences_repository.dart';
import 'package:phone_detox/features/startup/presentation/startup_controller.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;

  @override
  Future<void> launchApp(LaunchableApp app) async {}

  @override
  Future<void> openAppDetails(String packageName) async {}

  @override
  Future<void> openHomeSettings() async {}
  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.alreadyHeld;
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

class WidgetStartupPreferences implements StartupPreferencesRepository {
  @override
  Future<bool> hasCompletedLauncherActivation() async => true;
  @override
  Future<bool> hasSeenLauncherExplanation() async => true;
  @override
  Future<void> setHasCompletedLauncherActivation(bool value) async {}
  @override
  Future<void> setHasSeenLauncherExplanation(bool value) async {}
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

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
          startupPreferencesRepositoryProvider.overrideWithValue(
            WidgetStartupPreferences(),
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
