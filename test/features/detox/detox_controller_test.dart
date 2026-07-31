import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/domain/detox_preferences_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_repository.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/detox/presentation/detox_state.dart';

class FakeDetoxRepository implements DetoxRepository {
  AccessibilityStatus accessibility = AccessibilityStatus.enabled;
  DetoxSession? nativeSession;
  Object? startError;
  int stopCount = 0;

  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async => accessibility;
  @override
  Future<DetoxSession?> getNativeActiveSession() async => nativeSession;
  @override
  Future<void> openAccessibilitySettings() async {}
  @override
  Future<void> startSession(DetoxSession session) async {
    if (startError case final error?) throw error;
    nativeSession = session;
  }

  @override
  Future<void> stopSession() async {
    stopCount++;
    nativeSession = null;
  }
}

class FakeDetoxPreferences implements DetoxPreferencesRepository {
  Set<String> packages = {};
  int duration = 30;
  int? disclosure;
  DetoxSession? session;
  @override
  Future<void> clearActiveSession() async => session = null;
  @override
  Future<int?> getAccessibilityDisclosureVersion() async => disclosure;
  @override
  Future<DetoxSession?> getActiveSession() async => session;
  @override
  Future<Set<String>> getBlockedPackageNames() async => packages.toSet();
  @override
  Future<int> getDefaultDurationMinutes() async => duration;
  @override
  Future<void> setAccessibilityDisclosureVersion(int version) async =>
      disclosure = version;
  @override
  Future<void> setActiveSession(DetoxSession value) async => session = value;
  @override
  Future<void> setBlockedPackageNames(Set<String> value) async =>
      packages = value.toSet();
  @override
  Future<void> setDefaultDurationMinutes(int value) async => duration = value;
}

void main() {
  late FakeDetoxRepository repository;
  late FakeDetoxPreferences preferences;
  late ProviderContainer container;

  setUp(() async {
    repository = FakeDetoxRepository();
    preferences = FakeDetoxPreferences();
    container = ProviderContainer(
      overrides: [
        detoxRepositoryProvider.overrideWithValue(repository),
        detoxPreferencesRepositoryProvider.overrideWithValue(preferences),
      ],
    );
    container.read(detoxControllerProvider);
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => container.dispose());

  Future<void> refresh() =>
      container.read(detoxControllerProvider.notifier).refresh();

  test('loads persisted configuration', () async {
    preferences
      ..packages = {'example.app'}
      ..duration = 60
      ..disclosure = 1;
    await refresh();
    final state = container.read(detoxControllerProvider);
    expect(state.status, DetoxStatus.ready);
    expect(state.blockedPackageNames, {'example.app'});
    expect(state.selectedDurationMinutes, 60);
    expect(state.hasAcceptedDisclosure, isTrue);
  });

  test('valid start persists Flutter and native session', () async {
    preferences
      ..packages = {'example.app'}
      ..disclosure = 1;
    await refresh();
    await container.read(detoxControllerProvider.notifier).startSession();
    expect(repository.nativeSession, isNotNull);
    expect(preferences.session, repository.nativeSession);
    expect(
      container.read(detoxControllerProvider).status,
      DetoxStatus.activeAndEnforced,
    );
  });

  test(
    'empty list, disabled access, and missing disclosure reject start',
    () async {
      await refresh();
      expect(container.read(detoxControllerProvider).canStart, isFalse);
      preferences
        ..packages = {'example.app'}
        ..disclosure = 1;
      repository.accessibility = AccessibilityStatus.disabled;
      await refresh();
      expect(container.read(detoxControllerProvider).canStart, isFalse);
      repository.accessibility = AccessibilityStatus.enabled;
      preferences.disclosure = null;
      await refresh();
      expect(container.read(detoxControllerProvider).canStart, isFalse);
    },
  );

  test('native start failure rolls back Flutter session', () async {
    preferences
      ..packages = {'example.app'}
      ..disclosure = 1;
    repository.startError = StateError('failed');
    await refresh();
    await expectLater(
      container.read(detoxControllerProvider.notifier).startSession(),
      throwsStateError,
    );
    expect(preferences.session, isNull);
  });

  test(
    'native state restores Flutter state and reports disabled enforcement',
    () async {
      final now = DateTime.now().toUtc();
      repository
        ..accessibility = AccessibilityStatus.disabled
        ..nativeSession = DetoxSession(
          id: 'native',
          startedAt: now,
          endsAt: now.add(const Duration(minutes: 5)),
          blockedPackageNames: {'example.app'},
        );
      await refresh();
      expect(preferences.session, repository.nativeSession);
      expect(
        container.read(detoxControllerProvider).status,
        DetoxStatus.activeButNotEnforced,
      );
    },
  );

  test('expired native state clears both sides', () async {
    final now = DateTime.now().toUtc();
    final expired = DetoxSession(
      id: 'expired',
      startedAt: now.subtract(const Duration(minutes: 10)),
      endsAt: now.subtract(const Duration(minutes: 5)),
      blockedPackageNames: {'example.app'},
    );
    repository.nativeSession = expired;
    preferences.session = expired;
    await refresh();
    expect(repository.nativeSession, isNull);
    expect(preferences.session, isNull);
  });

  test('stopping clears native and Flutter state', () async {
    final now = DateTime.now().toUtc();
    repository.nativeSession = DetoxSession(
      id: 'active',
      startedAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      blockedPackageNames: {'example.app'},
    );
    await refresh();
    await container.read(detoxControllerProvider.notifier).stopSession();
    expect(repository.nativeSession, isNull);
    expect(preferences.session, isNull);
    expect(container.read(detoxControllerProvider).status, DetoxStatus.ready);
  });

  test(
    'selection deduplicates packages and removes unknown packages',
    () async {
      preferences.packages = {'one.app', 'unknown.app'};
      await refresh();
      final controller = container.read(detoxControllerProvider.notifier);
      await controller.toggleBlockedPackage('one.app');
      await controller.toggleBlockedPackage('one.app');
      expect(preferences.packages, {'one.app', 'unknown.app'});
      await controller.reconcileAvailablePackages({'one.app'});
      expect(preferences.packages, {'one.app'});
    },
  );
}
