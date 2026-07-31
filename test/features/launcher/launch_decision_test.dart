import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/launcher/domain/launch_decision.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';

const blockedApp = LaunchableApp(
  label: 'Blocked',
  packageName: 'blocked.app',
  activityName: 'Main',
);
const allowedApp = LaunchableApp(
  label: 'Allowed',
  packageName: 'allowed.app',
  activityName: 'Main',
);

class DecisionLauncherRepository implements LauncherRepository {
  int launches = 0;
  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [
    blockedApp,
    allowedApp,
  ];
  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;
  @override
  Future<void> launchApp(LaunchableApp app) async => launches++;
  @override
  Future<void> openAppDetails(String packageName) async {}
  @override
  Future<void> openHomeSettings() async {}
  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.alreadyHeld;
}

class DecisionLauncherPreferences implements LauncherPreferencesRepository {
  @override
  Future<Set<String>> getFavouriteIds() async => {};
  @override
  Future<Set<String>> getHiddenIds() async => {};
  @override
  Future<void> setFavouriteIds(Set<String> ids) async {}
  @override
  Future<void> setHiddenIds(Set<String> ids) async {}
}

class DecisionDetoxRepository implements DetoxRepository {
  DetoxSession? session;
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
  Future<void> stopSession() async => session = null;
}

class DecisionDetoxPreferences implements DetoxPreferencesRepository {
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
  late DecisionLauncherRepository launcher;
  late DecisionDetoxRepository detox;
  late DecisionDetoxPreferences detoxPreferences;
  late ProviderContainer container;

  setUp(() async {
    launcher = DecisionLauncherRepository();
    detox = DecisionDetoxRepository();
    detoxPreferences = DecisionDetoxPreferences();
    container = ProviderContainer(
      overrides: [
        launcherRepositoryProvider.overrideWithValue(launcher),
        launcherPreferencesRepositoryProvider.overrideWithValue(
          DecisionLauncherPreferences(),
        ),
        detoxRepositoryProvider.overrideWithValue(detox),
        detoxPreferencesRepositoryProvider.overrideWithValue(detoxPreferences),
      ],
    );
    container.read(launcherControllerProvider);
    container.read(detoxControllerProvider);
    await container.read(launcherControllerProvider.notifier).refresh();
    await container.read(detoxControllerProvider.notifier).refresh();
  });

  tearDown(() => container.dispose());

  Future<void> restore(DetoxSession? session) async {
    detox.session = session;
    detoxPreferences.session = session;
    await container.read(detoxControllerProvider.notifier).refresh();
  }

  test('blocked app is rejected during enforced active session', () async {
    final now = DateTime.now().toUtc();
    await restore(
      DetoxSession(
        id: 'active',
        startedAt: now,
        endsAt: now.add(const Duration(minutes: 5)),
        blockedPackageNames: {'blocked.app'},
      ),
    );
    final decision = await container
        .read(launcherControllerProvider.notifier)
        .launch(blockedApp);
    expect(decision, isA<LaunchBlocked>());
    expect(launcher.launches, 0);
  });

  test('unblocked app is allowed during active session', () async {
    final now = DateTime.now().toUtc();
    await restore(
      DetoxSession(
        id: 'active',
        startedAt: now,
        endsAt: now.add(const Duration(minutes: 5)),
        blockedPackageNames: {'blocked.app'},
      ),
    );
    expect(
      await container
          .read(launcherControllerProvider.notifier)
          .launch(allowedApp),
      isA<LaunchAllowed>(),
    );
    expect(launcher.launches, 1);
  });

  test('blocked app is allowed without a session', () async {
    await restore(null);
    expect(
      await container
          .read(launcherControllerProvider.notifier)
          .launch(blockedApp),
      isA<LaunchAllowed>(),
    );
  });

  test('blocked app is allowed after session expiry', () async {
    final now = DateTime.now().toUtc();
    await restore(
      DetoxSession(
        id: 'expired',
        startedAt: now.subtract(const Duration(minutes: 10)),
        endsAt: now.subtract(const Duration(minutes: 5)),
        blockedPackageNames: {'blocked.app'},
      ),
    );
    expect(
      await container
          .read(launcherControllerProvider.notifier)
          .launch(blockedApp),
      isA<LaunchAllowed>(),
    );
  });
}
