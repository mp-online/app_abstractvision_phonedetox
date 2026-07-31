import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detox/presentation/detox_controller.dart';
import '../../jail_break/domain/jail_break_state.dart';
import '../../jail_break/presentation/jail_break_controller.dart';
import '../../launcher/domain/home_role_request_result.dart';
import '../../launcher/domain/home_role_status.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../../mindful_opening/presentation/mindful_opening_controller.dart';
import '../../usage_limit/presentation/usage_limit_controller.dart';
import '../data/shared_preferences_startup_repository.dart';
import '../domain/home_role_loss_reason.dart';
import '../domain/startup_preferences_repository.dart';
import '../domain/startup_state.dart';
import '../domain/startup_status.dart';

final startupPreferencesRepositoryProvider =
    Provider<StartupPreferencesRepository>(
      (ref) => SharedPreferencesStartupRepository(),
    );
final startupControllerProvider =
    NotifierProvider<StartupController, StartupState>(StartupController.new);

class StartupController extends Notifier<StartupState> {
  late final StartupPreferencesRepository _preferences;
  bool _requestInProgress = false;
  int _refreshGeneration = 0;
  @override
  StartupState build() {
    _preferences = ref.watch(startupPreferencesRepositoryProvider);
    unawaited(Future<void>.delayed(Duration.zero, initialize));
    return const StartupState();
  }

  Future<void> initialize() async {
    final generation = ++_refreshGeneration;
    state = state.copyWith(
      status: StartupStatus.loading,
      clearError: true,
      clearLastRequestResult: true,
    );
    try {
      final values = await Future.wait<Object>([
        _preferences.hasSeenLauncherExplanation(),
        _preferences.hasCompletedLauncherActivation(),
        ref.read(launcherRepositoryProvider).getHomeRoleStatus(),
      ]).timeout(const Duration(seconds: 10));
      if (generation != _refreshGeneration) return;
      if (!(values[0] as bool)) {
        await _preferences.setHasSeenLauncherExplanation(true);
      }
      await _applyRoleStatus(
        values[2] as HomeRoleStatus,
        previouslyCompleted: values[1] as bool,
        generation: generation,
      );
    } catch (error) {
      if (generation == _refreshGeneration) {
        state = state.copyWith(status: StartupStatus.error, error: error);
      }
    }
  }

  Future<void> refreshOnResume() async {
    if (_requestInProgress) return;
    final generation = ++_refreshGeneration;
    final wasWaiting =
        ref.read(jailBreakControllerProvider).status ==
        JailBreakStatus.waitingForSelection;
    try {
      final completed = await _preferences.hasCompletedLauncherActivation();
      final role = await ref
          .read(launcherRepositoryProvider)
          .getHomeRoleStatus();
      if (generation != _refreshGeneration) return;
      await ref.read(detoxControllerProvider.notifier).refresh();
      if (generation != _refreshGeneration) return;
      ref.read(jailBreakControllerProvider.notifier).handleHomeRoleStatus(role);
      await _applyRoleStatus(
        role,
        previouslyCompleted: completed,
        generation: generation,
        detoxAlreadyReconciled: true,
      );
    } catch (error) {
      if (generation == _refreshGeneration) {
        ref
            .read(jailBreakControllerProvider.notifier)
            .handleHomeRoleCheckFailure(error);
        state = state.copyWith(
          status: wasWaiting
              ? StartupStatus.jailBreakFailure
              : StartupStatus.error,
          error: error,
        );
      }
    }
  }

  Future<void> requestHomeRole() async {
    if (_requestInProgress) return;
    _requestInProgress = true;
    final generation = ++_refreshGeneration;
    state = state.copyWith(
      status: StartupStatus.requestingHomeRole,
      clearError: true,
      clearLastRequestResult: true,
    );
    try {
      final result = await ref
          .read(launcherRepositoryProvider)
          .requestHomeRole();
      if (generation != _refreshGeneration) return;
      if (result == HomeRoleRequestResult.granted ||
          result == HomeRoleRequestResult.alreadyHeld) {
        final role = await ref
            .read(launcherRepositoryProvider)
            .getHomeRoleStatus();
        if (generation != _refreshGeneration) return;
        if (role == HomeRoleStatus.held) {
          await _preferences.setHasCompletedLauncherActivation(true);
          await _applyRoleStatus(
            role,
            previouslyCompleted: true,
            generation: generation,
            requestResult: result,
          );
          return;
        }
      }
      final fallback = result == HomeRoleRequestResult.unavailable
          ? StartupStatus.unavailable
          : state.hasPreviouslyCompletedActivation
          ? StartupStatus.roleLost
          : StartupStatus.activationRequired;
      state = state.copyWith(
        status: fallback,
        homeRoleStatus: result == HomeRoleRequestResult.unavailable
            ? HomeRoleStatus.unavailable
            : HomeRoleStatus.notHeld,
        lastRequestResult: result,
      );
    } catch (error) {
      if (generation == _refreshGeneration) {
        state = state.copyWith(status: StartupStatus.error, error: error);
      }
    } finally {
      _requestInProgress = false;
    }
  }

  Future<void> openHomeSettings() async {
    try {
      await ref.read(launcherRepositoryProvider).openHomeSettings();
    } catch (error) {
      state = state.copyWith(status: StartupStatus.error, error: error);
    }
  }

  Future<void> usePhoneDetoxAgain() async {
    ref.read(jailBreakControllerProvider.notifier).reset();
    await requestHomeRole();
  }

  Future<void> retryJailBreakRoleCheck() async {
    ref.read(jailBreakControllerProvider.notifier).prepareRoleCheckRetry();
    state = state.copyWith(status: StartupStatus.loading, clearError: true);
    await refreshOnResume();
  }

  Future<void> _applyRoleStatus(
    HomeRoleStatus role, {
    required bool previouslyCompleted,
    required int generation,
    HomeRoleRequestResult? requestResult,
    bool detoxAlreadyReconciled = false,
  }) async {
    if (role == HomeRoleStatus.held) {
      await _preferences.setHasCompletedLauncherActivation(true);
      if (generation != _refreshGeneration) return;
      if (!detoxAlreadyReconciled) {
        await ref.read(detoxControllerProvider.notifier).refresh();
      }
      if (generation != _refreshGeneration) return;
      await ref.read(launcherControllerProvider.notifier).refresh();
      if (generation != _refreshGeneration) return;
      final packages = ref
          .read(launcherControllerProvider)
          .apps
          .map((app) => app.packageName)
          .toSet();
      await ref
          .read(mindfulOpeningControllerProvider.notifier)
          .refresh(availablePackages: packages);
      if (generation != _refreshGeneration) return;
      await ref
          .read(usageLimitControllerProvider.notifier)
          .refresh(availablePackages: packages);
      if (generation != _refreshGeneration) return;
      if (ref.read(usageLimitControllerProvider).reached != null &&
          ref.read(mindfulOpeningControllerProvider).pendingRequest != null) {
        await ref.read(mindfulOpeningControllerProvider.notifier).goBack();
      }
      if (generation != _refreshGeneration) return;
      state = StartupState(
        status: StartupStatus.ready,
        homeRoleStatus: role,
        lastRequestResult: requestResult,
        hasPreviouslyCompletedActivation: true,
      );
      return;
    }
    await ref.read(usageLimitControllerProvider.notifier).clearForRoleLoss();
    final jailBreak = ref.read(jailBreakControllerProvider);
    if (role == HomeRoleStatus.notHeld &&
        jailBreak.status == JailBreakStatus.completed) {
      state = StartupState(
        status: StartupStatus.jailBreakCompleted,
        homeRoleStatus: role,
        homeRoleLossReason: HomeRoleLossReason.intentionalJailBreak,
        hasPreviouslyCompletedActivation: previouslyCompleted,
      );
      return;
    }
    if (jailBreak.status == JailBreakStatus.error &&
        (jailBreak.failureKind == JailBreakFailureKind.homeRoleUnavailable ||
            jailBreak.failureKind == JailBreakFailureKind.homeRoleCheck)) {
      state = StartupState(
        status: StartupStatus.jailBreakFailure,
        homeRoleStatus: role,
        homeRoleLossReason: HomeRoleLossReason.intentionalJailBreak,
        hasPreviouslyCompletedActivation: previouslyCompleted,
        error: jailBreak.error,
      );
      return;
    }
    state = StartupState(
      status: role == HomeRoleStatus.unavailable
          ? StartupStatus.unavailable
          : previouslyCompleted
          ? StartupStatus.roleLost
          : StartupStatus.activationRequired,
      homeRoleStatus: role,
      hasPreviouslyCompletedActivation: previouslyCompleted,
      lastRequestResult: requestResult,
    );
  }
}
