import 'package:flutter/foundation.dart';

import '../../launcher/domain/home_role_request_result.dart';
import '../../launcher/domain/home_role_status.dart';
import 'home_role_loss_reason.dart';
import 'startup_status.dart';

@immutable
class StartupState {
  const StartupState({
    this.status = StartupStatus.loading,
    this.homeRoleStatus = HomeRoleStatus.notHeld,
    this.lastRequestResult,
    this.hasPreviouslyCompletedActivation = false,
    this.homeRoleLossReason = HomeRoleLossReason.unknown,
    this.error,
  });

  final StartupStatus status;
  final HomeRoleStatus homeRoleStatus;
  final HomeRoleRequestResult? lastRequestResult;
  final bool hasPreviouslyCompletedActivation;
  final HomeRoleLossReason homeRoleLossReason;
  final Object? error;

  StartupState copyWith({
    StartupStatus? status,
    HomeRoleStatus? homeRoleStatus,
    HomeRoleRequestResult? lastRequestResult,
    bool clearLastRequestResult = false,
    bool? hasPreviouslyCompletedActivation,
    HomeRoleLossReason? homeRoleLossReason,
    Object? error,
    bool clearError = false,
  }) => StartupState(
    status: status ?? this.status,
    homeRoleStatus: homeRoleStatus ?? this.homeRoleStatus,
    lastRequestResult: clearLastRequestResult
        ? null
        : lastRequestResult ?? this.lastRequestResult,
    hasPreviouslyCompletedActivation:
        hasPreviouslyCompletedActivation ??
        this.hasPreviouslyCompletedActivation,
    homeRoleLossReason: homeRoleLossReason ?? this.homeRoleLossReason,
    error: clearError ? null : error ?? this.error,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartupState &&
          status == other.status &&
          homeRoleStatus == other.homeRoleStatus &&
          lastRequestResult == other.lastRequestResult &&
          hasPreviouslyCompletedActivation ==
              other.hasPreviouslyCompletedActivation &&
          homeRoleLossReason == other.homeRoleLossReason &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    status,
    homeRoleStatus,
    lastRequestResult,
    hasPreviouslyCompletedActivation,
    homeRoleLossReason,
    error,
  );
}
