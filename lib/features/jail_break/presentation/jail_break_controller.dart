import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detox/presentation/detox_controller.dart';
import '../../launcher/domain/home_role_status.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../../mindful_opening/presentation/mindful_opening_controller.dart';
import '../../usage_limit/presentation/usage_limit_controller.dart';
import '../domain/jail_break_result.dart';
import '../domain/jail_break_state.dart';

final jailBreakControllerProvider =
    NotifierProvider<JailBreakController, JailBreakState>(
      JailBreakController.new,
    );

class JailBreakController extends Notifier<JailBreakState> {
  @override
  JailBreakState build() => const JailBreakState();
  bool beginConfirmation() {
    if (state.isProcessing) return false;
    final session = ref.read(detoxControllerProvider).activeSession;
    state = JailBreakState(
      status: JailBreakStatus.confirming,
      hadActiveSession: session != null && session.isActive,
    );
    return true;
  }

  void cancelConfirmation() {
    if (state.status == JailBreakStatus.confirming ||
        state.status == JailBreakStatus.error) {
      state = const JailBreakState();
    }
  }

  Future<void> confirm() async {
    if (state.status != JailBreakStatus.confirming) return;
    if (state.hadActiveSession) {
      state = state.copyWith(
        status: JailBreakStatus.endingDetox,
        clearFailureKind: true,
        clearError: true,
        clearResult: true,
      );
      try {
        await ref.read(detoxControllerProvider.notifier).stopSession();
      } catch (error) {
        _fail(JailBreakFailureKind.detoxCleanup, error);
        return;
      }
    }
    state = state.copyWith(
      status: JailBreakStatus.endingDetox,
      clearFailureKind: true,
      clearError: true,
      clearResult: true,
    );
    try {
      await ref
          .read(mindfulOpeningControllerProvider.notifier)
          .clearForJailBreak();
      await ref.read(usageLimitControllerProvider.notifier).clearForJailBreak();
    } catch (error) {
      _fail(JailBreakFailureKind.detoxCleanup, error);
      return;
    }
    await _openHomeSettings();
  }

  Future<void> retryDetoxCleanup() async {
    if (state.status != JailBreakStatus.error ||
        state.failureKind != JailBreakFailureKind.detoxCleanup) {
      return;
    }
    state = state.copyWith(
      status: JailBreakStatus.endingDetox,
      clearFailureKind: true,
      clearError: true,
      clearResult: true,
    );
    try {
      await ref.read(detoxControllerProvider.notifier).stopSession();
      await ref
          .read(mindfulOpeningControllerProvider.notifier)
          .clearForJailBreak();
      await ref.read(usageLimitControllerProvider.notifier).clearForJailBreak();
      await _openHomeSettings();
    } catch (error) {
      _fail(JailBreakFailureKind.detoxCleanup, error);
    }
  }

  Future<void> openHomeSettingsAnyway() async {
    if (state.status == JailBreakStatus.error) await _openHomeSettings();
  }

  Future<void> retryHomeSettings() async {
    if (state.status == JailBreakStatus.error) await _openHomeSettings();
  }

  Future<void> _openHomeSettings() async {
    state = state.copyWith(
      status: JailBreakStatus.openingHomeSettings,
      clearFailureKind: true,
      clearError: true,
      clearResult: true,
    );
    try {
      await ref.read(launcherRepositoryProvider).openHomeSettings();
      state = state.copyWith(status: JailBreakStatus.waitingForSelection);
    } catch (error) {
      _fail(JailBreakFailureKind.homeSettings, error);
    }
  }

  Future<void> openAccessibilitySettings() =>
      ref.read(detoxControllerProvider.notifier).openAccessibilitySettings();
  Future<void> openCurrentHome() =>
      ref.read(launcherRepositoryProvider).openCurrentHome();
  void handleHomeRoleStatus(HomeRoleStatus role) {
    if (state.status != JailBreakStatus.waitingForSelection) return;
    switch (role) {
      case HomeRoleStatus.notHeld:
        state = state.copyWith(
          status: JailBreakStatus.completed,
          result: const JailBreakCompleted(),
          clearFailureKind: true,
          clearError: true,
        );
      case HomeRoleStatus.held:
        state = state.copyWith(
          status: JailBreakStatus.cancelled,
          result: const JailBreakCancelled(),
          clearFailureKind: true,
          clearError: true,
        );
      case HomeRoleStatus.unavailable:
        _fail(
          JailBreakFailureKind.homeRoleUnavailable,
          StateError('Android Home-role status is unavailable.'),
        );
    }
  }

  void handleHomeRoleCheckFailure(Object error) {
    if (state.status == JailBreakStatus.waitingForSelection) {
      _fail(JailBreakFailureKind.homeRoleCheck, error);
    }
  }

  void prepareRoleCheckRetry() {
    if (state.status == JailBreakStatus.error) {
      state = state.copyWith(
        status: JailBreakStatus.waitingForSelection,
        clearFailureKind: true,
        clearError: true,
        clearResult: true,
      );
    }
  }

  void reset() => state = const JailBreakState();
  void _fail(JailBreakFailureKind kind, Object error) => state = state.copyWith(
    status: JailBreakStatus.error,
    failureKind: kind,
    error: error,
    result: JailBreakFailed(error),
  );
}
