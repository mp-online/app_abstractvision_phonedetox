import 'dart:async';

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
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';
import 'package:phone_detox/features/startup/domain/startup_preferences_repository.dart';
import 'package:phone_detox/features/startup/domain/startup_status.dart';
import 'package:phone_detox/features/startup/presentation/startup_controller.dart';

class FakeHomeRepository implements LauncherRepository {
  HomeRoleStatus status = HomeRoleStatus.notHeld;
  HomeRoleRequestResult requestResult = HomeRoleRequestResult.cancelled;
  Completer<HomeRoleRequestResult>? pendingRequest;
  int requestCount = 0;

  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => status;
  @override
  Future<HomeRoleRequestResult> requestHomeRole() {
    requestCount++;
    return pendingRequest?.future ?? Future.value(requestResult);
  }

  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [];
  @override
  Future<void> launchApp(LaunchableApp app) async {}
  @override
  Future<void> openAppDetails(String packageName) async {}
  @override
  Future<void> openHomeSettings() async {}
}

class FakeStartupPreferences implements StartupPreferencesRepository {
  bool seen = false;
  bool completed = false;
  @override
  Future<bool> hasSeenLauncherExplanation() async => seen;
  @override
  Future<bool> hasCompletedLauncherActivation() async => completed;
  @override
  Future<void> setHasSeenLauncherExplanation(bool value) async => seen = value;
  @override
  Future<void> setHasCompletedLauncherActivation(bool value) async =>
      completed = value;
}

class EmptyLauncherPreferences implements LauncherPreferencesRepository {
  @override
  Future<Set<String>> getFavouriteIds() async => {};
  @override
  Future<Set<String>> getHiddenIds() async => {};
  @override
  Future<void> setFavouriteIds(Set<String> ids) async {}
  @override
  Future<void> setHiddenIds(Set<String> ids) async {}
}

class EmptyDetoxRepository implements DetoxRepository {
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

class EmptyDetoxPreferences implements DetoxPreferencesRepository {
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
  late FakeHomeRepository home;
  late FakeStartupPreferences preferences;
  late ProviderContainer container;

  setUp(() {
    home = FakeHomeRepository();
    preferences = FakeStartupPreferences();
    container = ProviderContainer(
      overrides: [
        launcherRepositoryProvider.overrideWithValue(home),
        launcherPreferencesRepositoryProvider.overrideWithValue(
          EmptyLauncherPreferences(),
        ),
        startupPreferencesRepositoryProvider.overrideWithValue(preferences),
        detoxRepositoryProvider.overrideWithValue(EmptyDetoxRepository()),
        detoxPreferencesRepositoryProvider.overrideWithValue(
          EmptyDetoxPreferences(),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> initialize() async {
    container.read(startupControllerProvider);
    for (var attempt = 0; attempt < 20; attempt++) {
      await Future<void>.delayed(Duration.zero);
      if (container.read(startupControllerProvider).status !=
          StartupStatus.loading) {
        return;
      }
    }
    fail('Startup initialization did not complete.');
  }

  test(
    'held role becomes ready and records informational completion',
    () async {
      home.status = HomeRoleStatus.held;
      await initialize();
      expect(
        container.read(startupControllerProvider).status,
        StartupStatus.ready,
      );
      expect(preferences.completed, isTrue);
    },
  );

  test('not-held role requires activation', () async {
    await initialize();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.activationRequired,
    );
  });

  test('unavailable role remains an expected unavailable state', () async {
    home.status = HomeRoleStatus.unavailable;
    await initialize();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.unavailable,
    );
  });

  test('missing previously completed role becomes role-lost', () async {
    preferences.completed = true;
    await initialize();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.roleLost,
    );
  });

  test('granted request rechecks OS state before becoming ready', () async {
    await initialize();
    home.requestResult = HomeRoleRequestResult.granted;
    home.status = HomeRoleStatus.notHeld;
    await container.read(startupControllerProvider.notifier).requestHomeRole();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.activationRequired,
    );

    home.status = HomeRoleStatus.held;
    await container.read(startupControllerProvider.notifier).requestHomeRole();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.ready,
    );
  });

  test('cancelled and denied requests remain recoverable', () async {
    await initialize();
    for (final result in [
      HomeRoleRequestResult.cancelled,
      HomeRoleRequestResult.denied,
    ]) {
      home.requestResult = result;
      await container
          .read(startupControllerProvider.notifier)
          .requestHomeRole();
      final state = container.read(startupControllerProvider);
      expect(state.status, StartupStatus.activationRequired);
      expect(state.lastRequestResult, result);
    }
  });

  test('opened settings waits for resume and then detects grant', () async {
    await initialize();
    home.requestResult = HomeRoleRequestResult.openedSettings;
    await container.read(startupControllerProvider.notifier).requestHomeRole();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.activationRequired,
    );
    home.status = HomeRoleStatus.held;
    await container.read(startupControllerProvider.notifier).refreshOnResume();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.ready,
    );
  });

  test('repeated request taps do not call repository concurrently', () async {
    await initialize();
    home.pendingRequest = Completer<HomeRoleRequestResult>();
    final first = container
        .read(startupControllerProvider.notifier)
        .requestHomeRole();
    final second = container
        .read(startupControllerProvider.notifier)
        .requestHomeRole();
    expect(home.requestCount, 1);
    home.pendingRequest!.complete(HomeRoleRequestResult.cancelled);
    await Future.wait([first, second]);
  });

  test('resume detects role revocation regardless of preferences', () async {
    home.status = HomeRoleStatus.held;
    await initialize();
    home.status = HomeRoleStatus.notHeld;
    await container.read(startupControllerProvider.notifier).refreshOnResume();
    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.roleLost,
    );
  });
}
