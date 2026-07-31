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
import 'package:phone_detox/features/usage_limit/domain/usage_limit_preferences_repository.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_reached.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_repository.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_rule.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_runtime.dart';
import 'package:phone_detox/features/usage_limit/presentation/usage_limit_controller.dart';

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
  Future<void> openCurrentHome() async {}
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

class ActiveWidgetDetoxRepository extends WidgetDetoxRepository {
  ActiveWidgetDetoxRepository(this.session);
  final DetoxSession session;

  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async =>
      AccessibilityStatus.enabled;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => session;
}

class ActiveWidgetDetoxPreferences extends WidgetDetoxPreferences {
  ActiveWidgetDetoxPreferences(this.session);
  final DetoxSession session;

  @override
  Future<int?> getAccessibilityDisclosureVersion() async => 1;
  @override
  Future<DetoxSession?> getActiveSession() async => session;
  @override
  Future<Set<String>> getBlockedPackageNames() async => {'system.camera'};
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

class WidgetUsagePreferences implements UsageLimitPreferencesRepository {
  @override
  Future<bool> getEnabled() async => false;
  @override
  Future<Map<String, UsageLimitRule>> getRules() async => const {};
  @override
  Future<void> setEnabled(bool enabled) async {}
  @override
  Future<void> setRules(Map<String, UsageLimitRule> rules) async {}
}

class WidgetUsageRepository implements UsageLimitRepository {
  @override
  Future<void> clearAllEnforcement() async {}
  @override
  Future<void> clearReachedLimit() async {}
  @override
  Future<void> clearRuntime() async {}
  @override
  Future<void> continueUsage(String packageName) async {}
  @override
  Future<UsageLimitReached?> getReachedLimit() async => null;
  @override
  Future<UsageLimitRuntime?> getRuntime() async => null;
  @override
  Future<void> restoreReachedLimit(UsageLimitReached reached) async {}
  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<UsageLimitRule> rules,
  }) async {}
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
          usageLimitPreferencesRepositoryProvider.overrideWithValue(
            WidgetUsagePreferences(),
          ),
          usageLimitRepositoryProvider.overrideWithValue(
            WidgetUsageRepository(),
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

  testWidgets('blocked launcher feedback names the app and active block', (
    tester,
  ) async {
    final now = DateTime.now().toUtc();
    final session = DetoxSession(
      id: 'active',
      startedAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      blockedPackageNames: const {'system.camera'},
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          launcherRepositoryProvider.overrideWithValue(
            WidgetLauncherRepository(),
          ),
          launcherPreferencesRepositoryProvider.overrideWithValue(
            WidgetPreferencesRepository(),
          ),
          detoxRepositoryProvider.overrideWithValue(
            ActiveWidgetDetoxRepository(session),
          ),
          detoxPreferencesRepositoryProvider.overrideWithValue(
            ActiveWidgetDetoxPreferences(session),
          ),
          startupPreferencesRepositoryProvider.overrideWithValue(
            WidgetStartupPreferences(),
          ),
          usageLimitPreferencesRepositoryProvider.overrideWithValue(
            WidgetUsagePreferences(),
          ),
          usageLimitRepositoryProvider.overrideWithValue(
            WidgetUsageRepository(),
          ),
        ],
        child: const PhoneDetoxApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pump();

    expect(find.textContaining('Camera is unavailable until'), findsOneWidget);
    expect(find.text('It is included in your active block.'), findsOneWidget);
    expect(find.text('View active block'), findsOneWidget);
  });
}
