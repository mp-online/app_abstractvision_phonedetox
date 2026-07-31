import 'package:flutter/foundation.dart';

import 'mindful_launch_source.dart';
import 'mindful_opening_mode.dart';

@immutable
class MindfulLaunchRequest {
  MindfulLaunchRequest({
    required this.id,
    required this.packageName,
    required this.source,
    required this.mode,
    required DateTime createdAt,
    required DateTime availableAt,
    required DateTime expiresAt,
  }) : createdAt = createdAt.toUtc(),
       availableAt = availableAt.toUtc(),
       expiresAt = expiresAt.toUtc() {
    if (id.trim().isEmpty || packageName.trim().isEmpty) {
      throw ArgumentError('Request identity and package must not be blank.');
    }
    if (this.availableAt.isBefore(this.createdAt) ||
        !this.expiresAt.isAfter(this.availableAt)) {
      throw ArgumentError('Invalid Mindful request timeline.');
    }
  }

  final String id;
  final String packageName;
  final MindfulLaunchSource source;
  final MindfulOpeningMode mode;
  final DateTime createdAt;
  final DateTime availableAt;
  final DateTime expiresAt;

  bool get isAvailable => isAvailableAt(DateTime.now());
  bool get isExpired => isExpiredAt(DateTime.now());
  Duration get remainingDelay => remainingDelayAt(DateTime.now());
  bool isAvailableAt(DateTime now) => !now.toUtc().isBefore(availableAt);
  bool isExpiredAt(DateTime now) => !now.toUtc().isBefore(expiresAt);
  Duration remainingDelayAt(DateTime now) {
    final remaining = availableAt.difference(now.toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  factory MindfulLaunchRequest.fromNative(Object? value) {
    if (value is! Map) throw const FormatException('Invalid Mindful request.');
    final map = Map<Object?, Object?>.from(value);
    int epoch(String key) {
      final raw = map[key];
      if (raw is! int) throw FormatException('Invalid $key.');
      return raw;
    }

    final id = map['requestId'];
    final packageName = map['packageName'];
    if (id is! String || packageName is! String) {
      throw const FormatException('Invalid request identity.');
    }
    return MindfulLaunchRequest(
      id: id,
      packageName: packageName,
      source: MindfulLaunchSource.fromWire(map['source']),
      mode: MindfulOpeningMode.fromWire(map['mode']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        epoch('createdAtEpochMs'),
        isUtc: true,
      ),
      availableAt: DateTime.fromMillisecondsSinceEpoch(
        epoch('availableAtEpochMs'),
        isUtc: true,
      ),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        epoch('expiresAtEpochMs'),
        isUtc: true,
      ),
    );
  }
}
