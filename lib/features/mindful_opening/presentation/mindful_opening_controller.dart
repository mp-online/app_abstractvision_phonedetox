import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detox/presentation/detox_controller.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../data/platform_mindful_opening_repository.dart';
import '../data/shared_preferences_mindful_opening_repository.dart';
import '../domain/mindful_launch_request.dart';
import '../domain/mindful_opening_preferences_repository.dart';
import '../domain/mindful_opening_repository.dart';
import '../domain/mindful_opening_rule.dart';
import '../domain/mindful_package_policy.dart';
import 'mindful_opening_state.dart';

final mindfulOpeningRepositoryProvider = Provider<MindfulOpeningRepository>(
  (ref) => PlatformMindfulOpeningRepository(),
);
final mindfulOpeningPreferencesRepositoryProvider =
    Provider<MindfulOpeningPreferencesRepository>(
      (ref) => SharedPreferencesMindfulOpeningRepository(),
    );
final mindfulOpeningControllerProvider =
    NotifierProvider<MindfulOpeningController, MindfulOpeningState>(
      MindfulOpeningController.new,
    );

class MindfulOpeningController extends Notifier<MindfulOpeningState> {
  late final MindfulOpeningRepository _repository;
  late final MindfulOpeningPreferencesRepository _preferences;
  Future<void>? _refreshInFlight;

  @override
  MindfulOpeningState build() {
    _repository = ref.watch(mindfulOpeningRepositoryProvider);
    _preferences = ref.watch(mindfulOpeningPreferencesRepositoryProvider);
    return MindfulOpeningState();
  }

  Future<void> refresh({Set<String>? availablePackages}) {
    if (_refreshInFlight case final operation?) return operation;
    final operation = _performRefresh(availablePackages);
    _refreshInFlight = operation;
    return operation.whenComplete(() {
      if (identical(_refreshInFlight, operation)) _refreshInFlight = null;
    });
  }

  Future<void> _performRefresh(Set<String>? availablePackages) async {
    state = state.copyWith(
      status: MindfulOpeningStatus.loading,
      clearError: true,
    );
    try {
      var rules = await _preferences.getRules();
      if (availablePackages != null) {
        rules = Map.fromEntries(
          rules.entries.where(
            (entry) =>
                availablePackages.contains(entry.key) &&
                MindfulPackagePolicy.isConfigurable(entry.key),
          ),
        );
        await _preferences.setRules(rules);
      }
      final enabled = await _preferences.getMindfulOpeningEnabled();
      final disclosure =
          ref.read(detoxControllerProvider).acceptedDisclosureVersion ?? 0;
      await _repository.synchronizeRules(
        enabled: enabled,
        disclosureVersion: disclosure,
        rules: rules.values,
      );
      var pending = await _repository.getPendingLaunch();
      if (pending?.isExpired ?? false) {
        await _repository.clearPendingLaunch();
        pending = null;
      }
      state = MindfulOpeningState(
        status: pending == null
            ? MindfulOpeningStatus.idle
            : MindfulOpeningStatus.pending,
        enabled: enabled,
        rules: rules,
        pendingRequest: pending,
      );
    } catch (error) {
      state = state.copyWith(status: MindfulOpeningStatus.error, error: error);
    }
  }

  Future<void> setRule(MindfulOpeningRule rule) async {
    if (!MindfulPackagePolicy.isConfigurable(rule.packageName)) {
      throw ArgumentError('This package is a critical Android surface.');
    }
    final rules = Map<String, MindfulOpeningRule>.of(state.rules)
      ..[rule.packageName] = rule;
    await _preferences.setRules(rules);
    state = state.copyWith(rules: rules);
    await _synchronize();
  }

  Future<void> removeRule(String packageName) async {
    final rules = Map<String, MindfulOpeningRule>.of(state.rules)
      ..remove(packageName);
    await _preferences.setRules(rules);
    await _repository.clearPendingLaunch();
    await _repository.clearAdmission();
    state = state.copyWith(
      rules: rules,
      clearPendingRequest: true,
      clearSelectedIntention: true,
      customIntention: '',
    );
    await _synchronize();
  }

  Future<void> setEnabled(bool enabled) async {
    await _preferences.setMindfulOpeningEnabled(enabled);
    if (!enabled) {
      await _repository.clearPendingLaunch();
      await _repository.clearAdmission();
    }
    state = state.copyWith(
      enabled: enabled,
      clearPendingRequest: !enabled,
      clearSelectedIntention: !enabled,
      customIntention: '',
    );
    await _synchronize();
  }

  Future<MindfulLaunchRequest?> requestDirectLaunch(String packageName) async {
    if (!state.enabled || !state.rules.containsKey(packageName)) return null;
    final request = await _repository.requestDirectLaunch(packageName);
    if (request != null) {
      state = state.copyWith(
        status: MindfulOpeningStatus.pending,
        pendingRequest: request,
        clearSelectedIntention: true,
        customIntention: '',
      );
    }
    return request;
  }

  void selectIntention(String value) => state = state.copyWith(
    selectedIntention: value,
    customIntention: value == 'other' ? state.customIntention : '',
  );
  void setCustomIntention(String value) =>
      state = state.copyWith(customIntention: value);

  Future<void> goBack() async {
    await _repository.clearPendingLaunch();
    await _repository.clearAdmission();
    state = state.copyWith(
      status: MindfulOpeningStatus.idle,
      clearPendingRequest: true,
      clearSelectedIntention: true,
      customIntention: '',
    );
  }

  Future<void> openIntentionally(LaunchableApp app, {DateTime? now}) async {
    final request = state.pendingRequest;
    final instant = now ?? DateTime.now();
    if (request == null ||
        request.packageName != app.packageName ||
        !state.canContinueAt(instant)) {
      throw StateError('Mindful Opening requirements are not satisfied.');
    }
    await _repository.clearPendingLaunch();
    try {
      await _repository.grantAdmission(app.packageName);
      await ref.read(launcherRepositoryProvider).launchApp(app);
      state = state.copyWith(
        status: MindfulOpeningStatus.admitted,
        clearPendingRequest: true,
        clearSelectedIntention: true,
        customIntention: '',
      );
    } catch (_) {
      await _repository.clearAdmission();
      state = state.copyWith(
        status: MindfulOpeningStatus.error,
        clearPendingRequest: true,
        clearSelectedIntention: true,
        customIntention: '',
      );
      rethrow;
    }
  }

  Future<void> clearForJailBreak() async {
    await _repository.clearPendingLaunch();
    await _repository.clearAdmission();
    state = state.copyWith(
      status: MindfulOpeningStatus.idle,
      clearPendingRequest: true,
      clearSelectedIntention: true,
      customIntention: '',
    );
  }

  Future<void> _synchronize() async {
    final disclosure =
        ref.read(detoxControllerProvider).acceptedDisclosureVersion ?? 0;
    await _repository.synchronizeRules(
      enabled: state.enabled,
      disclosureVersion: disclosure,
      rules: state.rules.values,
    );
  }
}
