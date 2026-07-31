import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../domain/accessibility_status.dart';
import '../domain/detox_session.dart';

enum DetoxStatus {
  loading,
  ready,
  activeAndEnforced,
  activeButNotEnforced,
  error,
}

@immutable
class DetoxState {
  DetoxState({
    this.status = DetoxStatus.loading,
    Set<String> blockedPackageNames = const {},
    this.selectedDurationMinutes = 30,
    this.accessibilityStatus = AccessibilityStatus.disabled,
    this.acceptedDisclosureVersion,
    this.activeSession,
    this.error,
  }) : blockedPackageNames = UnmodifiableSetView(Set.from(blockedPackageNames));

  final DetoxStatus status;
  final Set<String> blockedPackageNames;
  final int selectedDurationMinutes;
  final AccessibilityStatus accessibilityStatus;
  final int? acceptedDisclosureVersion;
  final DetoxSession? activeSession;
  final Object? error;

  bool get hasValidDuration =>
      selectedDurationMinutes >= 5 && selectedDurationMinutes <= 480;
  bool get hasAcceptedDisclosure => acceptedDisclosureVersion == 1;
  bool get canStart =>
      status == DetoxStatus.ready &&
      blockedPackageNames.isNotEmpty &&
      hasValidDuration &&
      hasAcceptedDisclosure &&
      accessibilityStatus == AccessibilityStatus.enabled &&
      activeSession == null;

  DetoxState copyWith({
    DetoxStatus? status,
    Set<String>? blockedPackageNames,
    int? selectedDurationMinutes,
    AccessibilityStatus? accessibilityStatus,
    int? acceptedDisclosureVersion,
    DetoxSession? activeSession,
    bool clearActiveSession = false,
    Object? error,
    bool clearError = false,
  }) => DetoxState(
    status: status ?? this.status,
    blockedPackageNames: blockedPackageNames ?? this.blockedPackageNames,
    selectedDurationMinutes:
        selectedDurationMinutes ?? this.selectedDurationMinutes,
    accessibilityStatus: accessibilityStatus ?? this.accessibilityStatus,
    acceptedDisclosureVersion:
        acceptedDisclosureVersion ?? this.acceptedDisclosureVersion,
    activeSession: clearActiveSession
        ? null
        : activeSession ?? this.activeSession,
    error: clearError ? null : error ?? this.error,
  );
}
