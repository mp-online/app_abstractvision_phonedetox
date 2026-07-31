import 'package:flutter/foundation.dart';

import 'jail_break_result.dart';

enum JailBreakStatus {
  idle,
  confirming,
  endingDetox,
  openingHomeSettings,
  waitingForSelection,
  completed,
  cancelled,
  error,
}

enum JailBreakFailureKind {
  detoxCleanup,
  homeSettings,
  homeRoleUnavailable,
  homeRoleCheck,
}

@immutable
class JailBreakState {
  const JailBreakState({
    this.status = JailBreakStatus.idle,
    this.hadActiveSession = false,
    this.failureKind,
    this.result,
    this.error,
  });

  final JailBreakStatus status;
  final bool hadActiveSession;
  final JailBreakFailureKind? failureKind;
  final JailBreakResult? result;
  final Object? error;

  bool get isProcessing => switch (status) {
    JailBreakStatus.confirming ||
    JailBreakStatus.endingDetox ||
    JailBreakStatus.openingHomeSettings ||
    JailBreakStatus.waitingForSelection => true,
    _ => false,
  };

  JailBreakState copyWith({
    JailBreakStatus? status,
    bool? hadActiveSession,
    JailBreakFailureKind? failureKind,
    bool clearFailureKind = false,
    JailBreakResult? result,
    bool clearResult = false,
    Object? error,
    bool clearError = false,
  }) => JailBreakState(
    status: status ?? this.status,
    hadActiveSession: hadActiveSession ?? this.hadActiveSession,
    failureKind: clearFailureKind ? null : failureKind ?? this.failureKind,
    result: clearResult ? null : result ?? this.result,
    error: clearError ? null : error ?? this.error,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JailBreakState &&
          status == other.status &&
          hadActiveSession == other.hadActiveSession &&
          failureKind == other.failureKind &&
          result.runtimeType == other.result.runtimeType &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    status,
    hadActiveSession,
    failureKind,
    result.runtimeType,
    error,
  );
}
