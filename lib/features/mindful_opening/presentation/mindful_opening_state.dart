import 'dart:collection';

import '../domain/mindful_launch_request.dart';
import '../domain/mindful_opening_mode.dart';
import '../domain/mindful_opening_rule.dart';

enum MindfulOpeningStatus {
  loading,
  idle,
  synchronizing,
  pending,
  admitted,
  error,
}

class MindfulOpeningState {
  MindfulOpeningState({
    this.status = MindfulOpeningStatus.idle,
    this.enabled = true,
    Map<String, MindfulOpeningRule> rules = const {},
    this.pendingRequest,
    this.selectedIntention,
    this.customIntention = '',
    this.error,
  }) : rules = UnmodifiableMapView(Map.of(rules));

  final MindfulOpeningStatus status;
  final bool enabled;
  final Map<String, MindfulOpeningRule> rules;
  final MindfulLaunchRequest? pendingRequest;
  final String? selectedIntention;
  final String customIntention;
  final Object? error;

  bool canContinueAt(DateTime now) {
    final request = pendingRequest;
    if (request == null ||
        request.isExpiredAt(now) ||
        !request.isAvailableAt(now)) {
      return false;
    }
    if (request.mode != MindfulOpeningMode.pauseAndIntention) return true;
    if (selectedIntention == null) return false;
    return selectedIntention != 'other' || customIntention.trim().isNotEmpty;
  }

  MindfulOpeningState copyWith({
    MindfulOpeningStatus? status,
    bool? enabled,
    Map<String, MindfulOpeningRule>? rules,
    MindfulLaunchRequest? pendingRequest,
    bool clearPendingRequest = false,
    String? selectedIntention,
    bool clearSelectedIntention = false,
    String? customIntention,
    Object? error,
    bool clearError = false,
  }) => MindfulOpeningState(
    status: status ?? this.status,
    enabled: enabled ?? this.enabled,
    rules: rules ?? this.rules,
    pendingRequest: clearPendingRequest
        ? null
        : pendingRequest ?? this.pendingRequest,
    selectedIntention: clearSelectedIntention
        ? null
        : selectedIntention ?? this.selectedIntention,
    customIntention: customIntention ?? this.customIntention,
    error: clearError ? null : error ?? this.error,
  );
}
