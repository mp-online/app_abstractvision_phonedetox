import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detox/presentation/detox_controller.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../mindful_opening/presentation/mindful_opening_controller.dart';
import '../data/platform_usage_limit_repository.dart';
import '../data/shared_preferences_usage_limit_repository.dart';
import '../domain/usage_limit_preferences_repository.dart';
import '../domain/usage_limit_reached.dart';
import '../domain/usage_limit_repository.dart';
import '../domain/usage_limit_rule.dart';
import '../domain/usage_limit_runtime.dart';
import '../domain/usage_limit_status.dart';
import 'usage_limit_state.dart';

final usageLimitRepositoryProvider = Provider<UsageLimitRepository>(
  (ref) => PlatformUsageLimitRepository(),
);
final usageLimitPreferencesRepositoryProvider =
    Provider<UsageLimitPreferencesRepository>(
      (ref) => SharedPreferencesUsageLimitRepository(),
    );
final usageLimitControllerProvider =
    NotifierProvider<UsageLimitController, UsageLimitState>(
      UsageLimitController.new,
    );

class UsageLimitEnablementRequired implements Exception {
  const UsageLimitEnablementRequired();
}

class UsageLimitDisclosureRequired implements Exception {
  const UsageLimitDisclosureRequired();
}

class UsageLimitController extends Notifier<UsageLimitState> {
  late final UsageLimitRepository _repository;
  late final UsageLimitPreferencesRepository _preferences;
  Future<void>? _refreshInFlight;

  @override
  UsageLimitState build() {
    _repository = ref.watch(usageLimitRepositoryProvider);
    _preferences = ref.watch(usageLimitPreferencesRepositoryProvider);
    return UsageLimitState();
  }

  Future<void> refresh({Set<String>? availablePackages}) {
    if (_refreshInFlight case final current?) return current;
    final operation = _performRefresh(availablePackages);
    _refreshInFlight = operation;
    return operation.whenComplete(() {
      if (identical(_refreshInFlight, operation)) _refreshInFlight = null;
    });
  }

  Future<void> _performRefresh(Set<String>? availablePackages) async {
    state = state.copyWith(status: UsageLimitStatus.loading, clearError: true);
    try {
      final values = await Future.wait<Object?>([
        _preferences.getEnabled(),
        _preferences.getRules(),
        _repository.getRuntime(),
        _repository.getReachedLimit(),
      ]);
      final enabled = values[0] as bool;
      var rules = values[1] as Map<String, UsageLimitRule>;
      if (availablePackages != null) {
        rules = Map.of(rules)
          ..removeWhere(
            (packageName, _) => !availablePackages.contains(packageName),
          );
        if (rules.length != (values[1] as Map).length) {
          await _preferences.setRules(rules);
        }
      }
      final runtime = values[2] as UsageLimitRuntime?;
      final reached = values[3] as UsageLimitReached?;
      state = UsageLimitState(
        status: !enabled
            ? UsageLimitStatus.disabled
            : reached != null
            ? UsageLimitStatus.reached
            : runtime != null
            ? UsageLimitStatus.active
            : UsageLimitStatus.ready,
        enabled: enabled,
        rules: rules,
        runtime: runtime,
        reached: reached,
        showReachedGate: reached != null,
      );
      await _synchronize(allowDisclosureDisabled: true);
    } catch (error) {
      state = state.copyWith(status: UsageLimitStatus.error, error: error);
    }
  }

  Future<void> setGlobalEnabled(bool enabled) async {
    if (enabled && _acceptedDisclosureVersion < 3) {
      throw const UsageLimitDisclosureRequired();
    }
    await _preferences.setEnabled(enabled);
    if (!enabled) {
      await _repository.synchronizeRules(
        enabled: false,
        disclosureVersion: _acceptedDisclosureVersion,
        rules: state.rules.values,
      );
      state = state.copyWith(
        status: UsageLimitStatus.disabled,
        enabled: false,
        clearRuntime: true,
        clearReached: true,
        showReachedGate: false,
        clearError: true,
      );
      return;
    }
    state = state.copyWith(
      status: UsageLimitStatus.ready,
      enabled: true,
      clearError: true,
    );
    await _synchronize();
  }

  Future<void> setRule(
    UsageLimitRule rule, {
    bool enableGloballyIfNeeded = false,
  }) async {
    if (!state.enabled && !enableGloballyIfNeeded) {
      throw const UsageLimitEnablementRequired();
    }
    if (!state.enabled && _acceptedDisclosureVersion < 3) {
      throw const UsageLimitDisclosureRequired();
    }
    final updated = Map<String, UsageLimitRule>.of(state.rules)
      ..[rule.packageName] = rule;
    await _preferences.setRules(updated);
    if (!state.enabled) await _preferences.setEnabled(true);
    state = state.copyWith(
      status: UsageLimitStatus.ready,
      enabled: true,
      rules: updated,
      clearError: true,
    );
    await _synchronize();
  }

  Future<void> removeRule(String packageName) async {
    final updated = Map<String, UsageLimitRule>.of(state.rules)
      ..remove(packageName);
    await _preferences.setRules(updated);
    if (state.runtime?.packageName == packageName) {
      await _repository.clearRuntime();
    }
    if (state.reached?.packageName == packageName) {
      await _repository.clearReachedLimit();
    }
    state = state.copyWith(
      status: state.enabled
          ? UsageLimitStatus.ready
          : UsageLimitStatus.disabled,
      rules: updated,
      clearRuntime: state.runtime?.packageName == packageName,
      clearReached: state.reached?.packageName == packageName,
      showReachedGate: state.reached?.packageName == packageName
          ? false
          : state.showReachedGate,
      clearError: true,
    );
    await _synchronize(allowDisclosureDisabled: true);
  }

  void showReachedLimit(String packageName) {
    if (state.reached?.packageName != packageName) return;
    state = state.copyWith(
      status: UsageLimitStatus.reached,
      showReachedGate: true,
    );
  }

  void stayOut() {
    if (state.reached == null) return;
    state = state.copyWith(
      status: state.enabled
          ? UsageLimitStatus.ready
          : UsageLimitStatus.disabled,
      showReachedGate: false,
    );
  }

  Future<void> continueUsage(LaunchableApp app) async {
    final reached = state.reached;
    if (reached == null || reached.packageName != app.packageName) {
      throw StateError('Usage limit is not reached for this package.');
    }
    try {
      await ref
          .read(mindfulOpeningControllerProvider.notifier)
          .launchWithOneTimeAdmission(
            app,
            beforeLaunch: () => _repository.continueUsage(app.packageName),
          );
      state = state.copyWith(
        status: UsageLimitStatus.ready,
        clearReached: true,
        showReachedGate: false,
        clearError: true,
      );
    } catch (error) {
      await _repository.restoreReachedLimit(reached);
      state = state.copyWith(
        status: UsageLimitStatus.reached,
        reached: reached,
        showReachedGate: true,
        error: error,
      );
      rethrow;
    }
  }

  Future<void> reconcileAvailablePackages(Set<String> availablePackages) async {
    final removed = state.rules.keys
        .where((key) => !availablePackages.contains(key))
        .toSet();
    if (removed.isEmpty) return;
    final updated = Map<String, UsageLimitRule>.of(state.rules)
      ..removeWhere((key, _) => removed.contains(key));
    await _preferences.setRules(updated);
    if (state.runtime != null && removed.contains(state.runtime!.packageName)) {
      await _repository.clearRuntime();
    }
    if (state.reached != null && removed.contains(state.reached!.packageName)) {
      await _repository.clearReachedLimit();
    }
    state = state.copyWith(
      rules: updated,
      clearRuntime:
          state.runtime != null && removed.contains(state.runtime!.packageName),
      clearReached:
          state.reached != null && removed.contains(state.reached!.packageName),
      showReachedGate:
          state.reached != null && removed.contains(state.reached!.packageName)
          ? false
          : state.showReachedGate,
    );
    await _synchronize(allowDisclosureDisabled: true);
  }

  Future<void> clearRuntimeForBlockedPackages(Set<String> packages) async {
    if (state.runtime case final runtime?
        when packages.contains(runtime.packageName)) {
      await _repository.clearRuntime();
      state = state.copyWith(clearRuntime: true);
    }
  }

  Future<void> clearForJailBreak() async {
    if (state.enabled || state.runtime != null || state.reached != null) {
      await _repository.clearAllEnforcement();
    }
    state = state.copyWith(
      status: state.enabled
          ? UsageLimitStatus.ready
          : UsageLimitStatus.disabled,
      clearRuntime: true,
      clearReached: true,
      showReachedGate: false,
      clearError: true,
    );
  }

  Future<void> clearForRoleLoss() => clearForJailBreak();

  Future<void> synchronize() => _synchronize();

  int get _acceptedDisclosureVersion =>
      ref.read(detoxControllerProvider).acceptedDisclosureVersion ?? 0;

  Future<void> _synchronize({bool allowDisclosureDisabled = false}) async {
    final disclosure = _acceptedDisclosureVersion;
    if (state.enabled && disclosure < 3 && !allowDisclosureDisabled) {
      throw const UsageLimitDisclosureRequired();
    }
    await _repository.synchronizeRules(
      enabled: state.enabled && disclosure >= 3,
      disclosureVersion: disclosure,
      rules: state.rules.values,
    );
  }
}
