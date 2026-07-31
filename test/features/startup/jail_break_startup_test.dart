import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/jail_break/domain/jail_break_state.dart';
import 'package:phone_detox/features/jail_break/presentation/jail_break_controller.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';
import 'package:phone_detox/features/startup/domain/home_role_loss_reason.dart';
import 'package:phone_detox/features/startup/domain/startup_preferences_repository.dart';
import 'package:phone_detox/features/startup/domain/startup_status.dart';
import 'package:phone_detox/features/startup/presentation/startup_controller.dart';

class _HomeRepository implements LauncherRepository {
  HomeRoleStatus role = HomeRoleStatus.held;
  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => role;
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [];
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
      HomeRoleRequestResult.granted;
}

class _StartupPreferences implements StartupPreferencesRepository {
  bool completed = true;
  @override
  Future<bool> hasCompletedLauncherActivation() async => completed;
  @override
  Future<bool> hasSeenLauncherExplanation() async => true;
  @override
  Future<void> setHasCompletedLauncherActivation(bool value) async =>
      completed = value;
  @override
  Future<void> setHasSeenLauncherExplanation(bool value) async {}
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
  Future<int?> getAccessibilityDisclosureVersion() async => 1;
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
  late _HomeRepository home;
  late ProviderContainer container;

  setUp(() async {
    home = _HomeRepository();
    container = ProviderContainer(
      overrides: [
        launcherRepositoryProvider.overrideWithValue(home),
        launcherPreferencesRepositoryProvider.overrideWithValue(
          _LauncherPreferences(),
        ),
        startupPreferencesRepositoryProvider.overrideWithValue(
          _StartupPreferences(),
        ),
        detoxRepositoryProvider.overrideWithValue(_DetoxRepository()),
        detoxPreferencesRepositoryProvider.overrideWithValue(
          _DetoxPreferences(),
        ),
      ],
    );
    container.read(startupControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => container.dispose());

  test('intentional role loss uses neutral completion state', () async {
    final jailBreak = container.read(jailBreakControllerProvider.notifier);
    jailBreak.beginConfirmation();
    await jailBreak.confirm();
    home.role = HomeRoleStatus.notHeld;

    await container.read(startupControllerProvider.notifier).refreshOnResume();

    final startup = container.read(startupControllerProvider);
    expect(startup.status, StartupStatus.jailBreakCompleted);
    expect(startup.homeRoleLossReason, HomeRoleLossReason.intentionalJailBreak);
    expect(
      container.read(jailBreakControllerProvider).status,
      JailBreakStatus.completed,
    );
  });

  test('returning with Phone Detox selected remains ready', () async {
    final jailBreak = container.read(jailBreakControllerProvider.notifier);
    jailBreak.beginConfirmation();
    await jailBreak.confirm();

    await container.read(startupControllerProvider.notifier).refreshOnResume();

    expect(
      container.read(startupControllerProvider).status,
      StartupStatus.ready,
    );
    expect(
      container.read(jailBreakControllerProvider).status,
      JailBreakStatus.cancelled,
    );
  });

  test('ordinary role loss remains unexpected recovery', () async {
    home.role = HomeRoleStatus.notHeld;
    await container.read(startupControllerProvider.notifier).refreshOnResume();
    final state = container.read(startupControllerProvider);
    expect(state.status, StartupStatus.roleLost);
    expect(state.homeRoleLossReason, HomeRoleLossReason.unknown);
  });
}
