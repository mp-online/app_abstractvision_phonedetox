import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/jail_break/domain/jail_break_result.dart';
import 'package:phone_detox/features/jail_break/domain/jail_break_state.dart';
import 'package:phone_detox/features/jail_break/presentation/jail_break_controller.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';

class _LauncherRepository implements LauncherRepository {
  int settingsCount = 0;
  Object? settingsError;
  Completer<void>? pendingSettings;

  @override
  Future<void> openHomeSettings() async {
    settingsCount++;
    if (settingsError case final error?) throw error;
    await pendingSettings?.future;
  }

  @override
  Future<void> openCurrentHome() async {}
  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [];
  @override
  Future<void> launchApp(LaunchableApp app) async {}
  @override
  Future<void> openAppDetails(String packageName) async {}
  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.alreadyHeld;
}

class _DetoxRepository implements DetoxRepository {
  DetoxSession? session;
  int stopCount = 0;
  int accessibilitySettingsCount = 0;
  Object? stopError;

  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async =>
      AccessibilityStatus.enabled;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => session;
  @override
  Future<void> openAccessibilitySettings() async {
    accessibilitySettingsCount++;
  }

  @override
  Future<void> startSession(DetoxSession value) async => session = value;
  @override
  Future<void> stopSession() async {
    stopCount++;
    if (stopError case final error?) throw error;
    session = null;
  }
}

class _DetoxPreferences implements DetoxPreferencesRepository {
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

void main() {
  late _LauncherRepository launcher;
  late _DetoxRepository detox;
  late _DetoxPreferences preferences;
  late ProviderContainer container;
  late JailBreakController controller;

  setUp(() async {
    launcher = _LauncherRepository();
    detox = _DetoxRepository();
    preferences = _DetoxPreferences();
    container = ProviderContainer(
      overrides: [
        launcherRepositoryProvider.overrideWithValue(launcher),
        detoxRepositoryProvider.overrideWithValue(detox),
        detoxPreferencesRepositoryProvider.overrideWithValue(preferences),
      ],
    );
    await container.read(detoxControllerProvider.notifier).refresh();
    controller = container.read(jailBreakControllerProvider.notifier);
  });

  tearDown(() => container.dispose());

  JailBreakState currentState() => container.read(jailBreakControllerProvider);

  test(
    'no active session opens Home settings without stopping Detox',
    () async {
      expect(controller.beginConfirmation(), isTrue);
      await controller.confirm();
      expect(detox.stopCount, 0);
      expect(launcher.settingsCount, 1);
      expect(currentState().status, JailBreakStatus.waitingForSelection);
    },
  );

  test('active session is cleared before Home settings opens', () async {
    final now = DateTime.now().toUtc();
    final session = DetoxSession(
      id: 'active',
      startedAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      blockedPackageNames: {'blocked.app'},
    );
    detox.session = session;
    preferences.session = session;
    await container.read(detoxControllerProvider.notifier).refresh();

    expect(controller.beginConfirmation(), isTrue);
    expect(currentState().hadActiveSession, isTrue);
    await controller.confirm();

    expect(detox.stopCount, 1);
    expect(detox.session, isNull);
    expect(preferences.session, isNull);
    expect(container.read(detoxControllerProvider).activeSession, isNull);
    expect(launcher.settingsCount, 1);
  });

  test('duplicate requests and confirmations are ignored', () async {
    launcher.pendingSettings = Completer<void>();
    expect(controller.beginConfirmation(), isTrue);
    expect(controller.beginConfirmation(), isFalse);
    final first = controller.confirm();
    final second = controller.confirm();
    expect(launcher.settingsCount, 1);
    launcher.pendingSettings!.complete();
    await Future.wait([first, second]);
    expect(launcher.settingsCount, 1);
  });

  test('resume role results complete, cancel, or fail recoverably', () async {
    for (final role in HomeRoleStatus.values) {
      controller.reset();
      controller.beginConfirmation();
      await controller.confirm();
      controller.handleHomeRoleStatus(role);
      switch (role) {
        case HomeRoleStatus.notHeld:
          expect(currentState().status, JailBreakStatus.completed);
          expect(currentState().result, isA<JailBreakCompleted>());
        case HomeRoleStatus.held:
          expect(currentState().status, JailBreakStatus.cancelled);
          expect(currentState().result, isA<JailBreakCancelled>());
        case HomeRoleStatus.unavailable:
          expect(currentState().status, JailBreakStatus.error);
          expect(
            currentState().failureKind,
            JailBreakFailureKind.homeRoleUnavailable,
          );
      }
    }
  });

  test('Home settings failure is typed and retryable', () async {
    launcher.settingsError = StateError('settings failed');
    controller.beginConfirmation();
    await controller.confirm();
    expect(currentState().status, JailBreakStatus.error);
    expect(currentState().failureKind, JailBreakFailureKind.homeSettings);
    launcher.settingsError = null;
    await controller.retryHomeSettings();
    expect(currentState().status, JailBreakStatus.waitingForSelection);
    expect(launcher.settingsCount, 2);
  });

  test('cleanup failure preserves Home and Accessibility recovery', () async {
    final now = DateTime.now().toUtc();
    final session = DetoxSession(
      id: 'active',
      startedAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      blockedPackageNames: {'blocked.app'},
    );
    detox.session = session;
    preferences.session = session;
    detox.stopError = StateError('cleanup failed');
    await container.read(detoxControllerProvider.notifier).refresh();

    controller.beginConfirmation();
    await controller.confirm();
    expect(currentState().failureKind, JailBreakFailureKind.detoxCleanup);
    expect(launcher.settingsCount, 0);

    await controller.openAccessibilitySettings();
    expect(detox.accessibilitySettingsCount, 1);
    expect(detox.stopCount, 1);

    await controller.openHomeSettingsAnyway();
    expect(launcher.settingsCount, 1);
    expect(currentState().status, JailBreakStatus.waitingForSelection);
  });

  test('state values are immutable snapshots', () {
    controller.beginConfirmation();
    final before = currentState();
    controller.cancelConfirmation();
    expect(before.status, JailBreakStatus.confirming);
    expect(currentState().status, JailBreakStatus.idle);
  });
}
