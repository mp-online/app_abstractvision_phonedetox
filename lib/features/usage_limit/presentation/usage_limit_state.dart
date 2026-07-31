import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../domain/usage_limit_reached.dart';
import '../domain/usage_limit_rule.dart';
import '../domain/usage_limit_runtime.dart';
import '../domain/usage_limit_status.dart';

@immutable
class UsageLimitState {
  UsageLimitState({
    this.status = UsageLimitStatus.loading,
    this.enabled = false,
    Map<String, UsageLimitRule> rules = const {},
    this.runtime,
    this.reached,
    this.showReachedGate = false,
    this.error,
  }) : rules = UnmodifiableMapView(Map.of(rules));

  final UsageLimitStatus status;
  final bool enabled;
  final Map<String, UsageLimitRule> rules;
  final UsageLimitRuntime? runtime;
  final UsageLimitReached? reached;
  final bool showReachedGate;
  final Object? error;

  bool get hasReachedLimit => reached != null;

  UsageLimitState copyWith({
    UsageLimitStatus? status,
    bool? enabled,
    Map<String, UsageLimitRule>? rules,
    UsageLimitRuntime? runtime,
    bool clearRuntime = false,
    UsageLimitReached? reached,
    bool clearReached = false,
    bool? showReachedGate,
    Object? error,
    bool clearError = false,
  }) => UsageLimitState(
    status: status ?? this.status,
    enabled: enabled ?? this.enabled,
    rules: rules ?? this.rules,
    runtime: clearRuntime ? null : runtime ?? this.runtime,
    reached: clearReached ? null : reached ?? this.reached,
    showReachedGate: showReachedGate ?? this.showReachedGate,
    error: clearError ? null : error ?? this.error,
  );
}
