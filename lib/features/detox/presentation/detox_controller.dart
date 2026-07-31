import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/platform_detox_repository.dart';
import '../data/shared_preferences_detox_repository.dart';
import '../domain/accessibility_status.dart';
import '../domain/detox_preferences_repository.dart';
import '../domain/detox_repository.dart';
import '../domain/detox_session.dart';
import 'detox_state.dart';

final detoxRepositoryProvider = Provider<DetoxRepository>(
  (ref) => PlatformDetoxRepository(),
);
final detoxPreferencesRepositoryProvider = Provider<DetoxPreferencesRepository>(
  (ref) => SharedPreferencesDetoxRepository(),
);
final detoxControllerProvider = NotifierProvider<DetoxController, DetoxState>(
  DetoxController.new,
);

class DetoxController extends Notifier<DetoxState> {
  late final DetoxRepository _repository;
  late final DetoxPreferencesRepository _preferences;
  int _refreshVersion = 0;

  @override
  DetoxState build() {
    _repository = ref.watch(detoxRepositoryProvider);
    _preferences = ref.watch(detoxPreferencesRepositoryProvider);
    unawaited(Future<void>.delayed(Duration.zero, refresh));
    return DetoxState();
  }

  Future<void> refresh() async {
    final version = ++_refreshVersion;
    state = state.copyWith(status: DetoxStatus.loading, clearError: true);
    try {
      final values = await Future.wait<Object?>([
        _preferences.getBlockedPackageNames(),
        _preferences.getDefaultDurationMinutes(),
        _preferences.getAccessibilityDisclosureVersion(),
        _preferences.getActiveSession(),
        _repository.getNativeActiveSession(),
        _repository.getAccessibilityStatus(),
      ]);
      if (version != _refreshVersion) return;
      final nativeSession = values[4] as DetoxSession?;
      final persistedSession = values[3] as DetoxSession?;
      DetoxSession? activeSession;
      if (nativeSession != null && nativeSession.isActiveAt(DateTime.now())) {
        activeSession = nativeSession;
        if (persistedSession != nativeSession) {
          await _preferences.setActiveSession(nativeSession);
        }
      } else {
        if (nativeSession != null) await _repository.stopSession();
        if (persistedSession != null) await _preferences.clearActiveSession();
      }
      if (version != _refreshVersion) return;
      final accessibility = values[5] as AccessibilityStatus;
      state = DetoxState(
        status: activeSession == null
            ? DetoxStatus.ready
            : accessibility == AccessibilityStatus.enabled
            ? DetoxStatus.activeAndEnforced
            : DetoxStatus.activeButNotEnforced,
        blockedPackageNames: values[0] as Set<String>,
        selectedDurationMinutes: values[1] as int,
        acceptedDisclosureVersion: values[2] as int?,
        activeSession: activeSession,
        accessibilityStatus: accessibility,
      );
    } catch (error) {
      if (version == _refreshVersion) {
        state = state.copyWith(status: DetoxStatus.error, error: error);
      }
    }
  }

  Future<void> toggleBlockedPackage(String packageName) async {
    if (packageName.trim().isEmpty) return;
    final updated = state.blockedPackageNames.toSet();
    updated.contains(packageName)
        ? updated.remove(packageName)
        : updated.add(packageName);
    state = state.copyWith(blockedPackageNames: updated);
    await _preferences.setBlockedPackageNames(updated);
  }

  Future<void> reconcileAvailablePackages(Set<String> available) async {
    final updated = state.blockedPackageNames.intersection(available);
    if (updated.length == state.blockedPackageNames.length) return;
    state = state.copyWith(blockedPackageNames: updated);
    await _preferences.setBlockedPackageNames(updated);
  }

  Future<void> setDurationMinutes(int minutes) async {
    state = state.copyWith(selectedDurationMinutes: minutes);
    if (minutes >= 5 && minutes <= 480) {
      await _preferences.setDefaultDurationMinutes(minutes);
    }
  }

  Future<void> acceptDisclosureAndOpenSettings() async {
    await _preferences.setAccessibilityDisclosureVersion(1);
    state = state.copyWith(acceptedDisclosureVersion: 1);
    await _repository.openAccessibilitySettings();
  }

  Future<void> openAccessibilitySettings() =>
      _repository.openAccessibilitySettings();

  Future<void> startSession() async {
    if (!state.canStart) {
      throw StateError('Detox session prerequisites are not satisfied.');
    }
    final now = DateTime.now().toUtc();
    final session = DetoxSession(
      id: '${now.microsecondsSinceEpoch}',
      startedAt: now,
      endsAt: now.add(Duration(minutes: state.selectedDurationMinutes)),
      blockedPackageNames: state.blockedPackageNames,
    );
    await _preferences.setActiveSession(session);
    try {
      await _repository.startSession(session);
    } catch (_) {
      await _preferences.clearActiveSession();
      rethrow;
    }
    state = state.copyWith(
      status: DetoxStatus.activeAndEnforced,
      activeSession: session,
      clearError: true,
    );
  }

  Future<void> stopSession() async {
    await _repository.stopSession();
    await _preferences.clearActiveSession();
    state = state.copyWith(
      status: DetoxStatus.ready,
      clearActiveSession: true,
      clearError: true,
    );
  }
}
