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

enum DetoxStartBlocker {
  noAppsSelected,
  invalidDuration,
  disclosureRequired,
  accessibilityDisabled,
  alreadyActive,
  controllerError,
}

@immutable
class DetoxState {
  DetoxState({
    this.status = DetoxStatus.loading,
    Set<String> blockedPackageNames = const {},
    this.selectedDurationMinutes = 30,
    this.usesCustomDuration = false,
    this.accessibilityStatus = AccessibilityStatus.disabled,
    this.acceptedDisclosureVersion,
    this.activeSession,
    this.error,
  }) : blockedPackageNames = UnmodifiableSetView(Set.from(blockedPackageNames));

  final DetoxStatus status;
  final Set<String> blockedPackageNames;
  final int selectedDurationMinutes;
  final bool usesCustomDuration;
  final AccessibilityStatus accessibilityStatus;
  final int? acceptedDisclosureVersion;
  final DetoxSession? activeSession;
  final Object? error;

  bool get hasValidDuration =>
      selectedDurationMinutes >= 5 && selectedDurationMinutes <= 480;
  bool get hasAcceptedDisclosure => (acceptedDisclosureVersion ?? 0) >= 1;
  DetoxStartBlocker? get startBlocker {
    if (blockedPackageNames.isEmpty) return DetoxStartBlocker.noAppsSelected;
    if (!hasValidDuration) return DetoxStartBlocker.invalidDuration;
    if (!hasAcceptedDisclosure) {
      return DetoxStartBlocker.disclosureRequired;
    }
    if (accessibilityStatus != AccessibilityStatus.enabled) {
      return DetoxStartBlocker.accessibilityDisabled;
    }
    if (activeSession != null ||
        status == DetoxStatus.activeAndEnforced ||
        status == DetoxStatus.activeButNotEnforced) {
      return DetoxStartBlocker.alreadyActive;
    }
    if (status == DetoxStatus.error) return DetoxStartBlocker.controllerError;
    return null;
  }

  bool get canStart => status == DetoxStatus.ready && startBlocker == null;

  DetoxState copyWith({
    DetoxStatus? status,
    Set<String>? blockedPackageNames,
    int? selectedDurationMinutes,
    bool? usesCustomDuration,
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
    usesCustomDuration: usesCustomDuration ?? this.usesCustomDuration,
    accessibilityStatus: accessibilityStatus ?? this.accessibilityStatus,
    acceptedDisclosureVersion:
        acceptedDisclosureVersion ?? this.acceptedDisclosureVersion,
    activeSession: clearActiveSession
        ? null
        : activeSession ?? this.activeSession,
    error: clearError ? null : error ?? this.error,
  );
}
