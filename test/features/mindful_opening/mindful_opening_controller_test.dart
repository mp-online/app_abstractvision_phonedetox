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
import 'package:phone_detox/features/mindful_opening/domain/mindful_launch_request.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_launch_source.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_mode.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_preferences_repository.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_repository.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_rule.dart';
import 'package:phone_detox/features/mindful_opening/presentation/mindful_opening_controller.dart';
import 'package:phone_detox/features/mindful_opening/presentation/mindful_opening_state.dart';

const app = LaunchableApp(
  label: 'Chrome',
  packageName: 'com.android.chrome',
  activityName: 'MainActivity',
);

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
  Future<int?> getAccessibilityDisclosureVersion() async => 2;
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

class _MindfulRepository implements MindfulOpeningRepository {
  _MindfulRepository(this.events, this.pending);
  final List<String> events;
  MindfulLaunchRequest? pending;
  String? admittedPackage;

  @override
  Future<void> clearAdmission() async {
    events.add('clearAdmission');
    admittedPackage = null;
  }

  @override
  Future<void> clearPendingLaunch() async {
    events.add('clearPending');
    pending = null;
  }

  @override
  Future<MindfulLaunchRequest?> getPendingLaunch() async => pending;

  @override
  Future<void> grantAdmission(String packageName) async {
    events.add('grantAdmission');
    admittedPackage = packageName;
  }

  @override
  Future<MindfulLaunchRequest?> requestDirectLaunch(String packageName) async =>
      pending;

  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<MindfulOpeningRule> rules,
  }) async {}
}

class _MindfulPreferences implements MindfulOpeningPreferencesRepository {
  final rule = MindfulOpeningRule(
    packageName: app.packageName,
    mode: MindfulOpeningMode.pauseAndIntention,
    delaySeconds: 10,
  );

  @override
  Future<bool> getMindfulOpeningEnabled() async => true;

  @override
  Future<Map<String, MindfulOpeningRule>> getRules() async => {
    rule.packageName: rule,
  };

  @override
  Future<void> setMindfulOpeningEnabled(bool enabled) async {}

  @override
  Future<void> setRules(Map<String, MindfulOpeningRule> rules) async {}
}

class _LauncherRepository implements LauncherRepository {
  _LauncherRepository(this.events);
  final List<String> events;
  Object? launchError;

  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => const [app];

  @override
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.held;

  @override
  Future<void> launchApp(LaunchableApp app) async {
    events.add('launch');
    if (launchError case final error?) throw error;
  }

  @override
  Future<void> openAppDetails(String packageName) async {}

  @override
  Future<void> openCurrentHome() async {}

  @override
  Future<void> openHomeSettings() async {}

  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.alreadyHeld;
}

MindfulLaunchRequest requestAt(DateTime now) => MindfulLaunchRequest(
  id: 'request',
  packageName: app.packageName,
  source: MindfulLaunchSource.launcher,
  mode: MindfulOpeningMode.pauseAndIntention,
  createdAt: now.subtract(const Duration(seconds: 11)),
  availableAt: now.subtract(const Duration(seconds: 1)),
  expiresAt: now.add(const Duration(minutes: 5)),
);

void main() {
  late List<String> events;
  late _MindfulRepository mindful;
  late _LauncherRepository launcher;
  late ProviderContainer container;
  late DateTime now;

  setUp(() async {
    now = DateTime.now().toUtc();
    events = [];
    mindful = _MindfulRepository(events, requestAt(now));
    launcher = _LauncherRepository(events);
    container = ProviderContainer(
      overrides: [
        detoxRepositoryProvider.overrideWithValue(_DetoxRepository()),
        detoxPreferencesRepositoryProvider.overrideWithValue(
          _DetoxPreferences(),
        ),
        mindfulOpeningRepositoryProvider.overrideWithValue(mindful),
        mindfulOpeningPreferencesRepositoryProvider.overrideWithValue(
          _MindfulPreferences(),
        ),
        launcherRepositoryProvider.overrideWithValue(launcher),
      ],
    );
    container.read(mindfulOpeningControllerProvider);
    await container.read(mindfulOpeningControllerProvider.notifier).refresh();
    container
        .read(mindfulOpeningControllerProvider.notifier)
        .selectIntention('task');
    final readyState = container.read(mindfulOpeningControllerProvider);
    expect(readyState.pendingRequest, isNotNull);
    expect(readyState.selectedIntention, 'task');
    expect(readyState.canContinueAt(now), isTrue);
    events.clear();
  });

  tearDown(() => container.dispose());

  test(
    'clears request, grants admission, then launches and clears intention',
    () async {
      await container
          .read(mindfulOpeningControllerProvider.notifier)
          .openIntentionally(app, now: now);

      expect(events, ['clearPending', 'grantAdmission', 'launch']);
      expect(mindful.pending, isNull);
      expect(mindful.admittedPackage, app.packageName);
      final state = container.read(mindfulOpeningControllerProvider);
      expect(state.status, MindfulOpeningStatus.admitted);
      expect(state.pendingRequest, isNull);
      expect(state.selectedIntention, isNull);
      expect(state.customIntention, isEmpty);
    },
  );

  test(
    'launch failure clears admission and leaves no pending request',
    () async {
      launcher.launchError = StateError('launch failed');

      await expectLater(
        container
            .read(mindfulOpeningControllerProvider.notifier)
            .openIntentionally(app, now: now),
        throwsStateError,
      );

      expect(events, [
        'clearPending',
        'grantAdmission',
        'launch',
        'clearAdmission',
      ]);
      expect(mindful.pending, isNull);
      expect(mindful.admittedPackage, isNull);
      final state = container.read(mindfulOpeningControllerProvider);
      expect(state.status, MindfulOpeningStatus.error);
      expect(state.pendingRequest, isNull);
      expect(state.selectedIntention, isNull);
    },
  );
}
