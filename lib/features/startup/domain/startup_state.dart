import 'package:flutter/foundation.dart';

import '../../launcher/domain/home_role_request_result.dart';
import '../../launcher/domain/home_role_status.dart';
import 'startup_status.dart';

@immutable
class StartupState {
  const StartupState({
    this.status = StartupStatus.loading,
    this.homeRoleStatus = HomeRoleStatus.notHeld,
    this.lastRequestResult,
    this.hasPreviouslyCompletedActivation = false,
    this.error,
  });

  final StartupStatus status;
  final HomeRoleStatus homeRoleStatus;
  final HomeRoleRequestResult? lastRequestResult;
  final bool hasPreviouslyCompletedActivation;
  final Object? error;

  StartupState copyWith({
    StartupStatus? status,
    HomeRoleStatus? homeRoleStatus,
    HomeRoleRequestResult? lastRequestResult,
    bool clearLastRequestResult = false,
    bool? hasPreviouslyCompletedActivation,
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
          error == other.error;

  @override
  int get hashCode => Object.hash(
    status,
    homeRoleStatus,
    lastRequestResult,
    hasPreviouslyCompletedActivation,
    error,
  );
}
