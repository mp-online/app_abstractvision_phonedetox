import 'dart:collection';

import 'package:flutter/foundation.dart';

@immutable
class DetoxSession {
  DetoxSession({
    required this.id,
    required this.startedAt,
    required this.endsAt,
    required Set<String> blockedPackageNames,
  }) : blockedPackageNames = UnmodifiableSetView(
         Set.from(blockedPackageNames),
       ) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Session ID must not be blank.');
    }
    if (!endsAt.isAfter(startedAt)) {
      throw ArgumentError('Session end must be after its start.');
    }
    if (this.blockedPackageNames.isEmpty ||
        this.blockedPackageNames.any((name) => name.trim().isEmpty)) {
      throw ArgumentError('Blocked package names must be non-empty.');
    }
    if (endsAt.difference(startedAt) > const Duration(minutes: 480)) {
      throw ArgumentError('Session duration must not exceed 480 minutes.');
    }
  }

  final String id;
  final DateTime startedAt;
  final DateTime endsAt;
  final Set<String> blockedPackageNames;

  bool get isActive => isActiveAt(DateTime.now());
  bool get isExpired => !isActive;
  Duration get remaining => remainingAt(DateTime.now());

  bool isActiveAt(DateTime now) => endsAt.isAfter(now);

  Duration remainingAt(DateTime now) {
    final value = endsAt.difference(now);
    return value.isNegative ? Duration.zero : value;
  }

  Map<String, Object> toMap() => <String, Object>{
    'id': id,
    'startedAtEpochMs': startedAt.toUtc().millisecondsSinceEpoch,
    'endsAtEpochMs': endsAt.toUtc().millisecondsSinceEpoch,
    'blockedPackageNames': blockedPackageNames.toList()..sort(),
  };

  static DetoxSession fromMap(Map<Object?, Object?> map) {
    final id = map['id'];
    final startedAt = map['startedAtEpochMs'];
    final endsAt = map['endsAtEpochMs'];
    final packages = map['blockedPackageNames'];
    if (id is! String ||
        startedAt is! int ||
        endsAt is! int ||
        packages is! List<Object?> ||
        packages.any((value) => value is! String)) {
      throw const FormatException('Invalid detox session payload.');
    }
    return DetoxSession(
      id: id,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedAt, isUtc: true),
      endsAt: DateTime.fromMillisecondsSinceEpoch(endsAt, isUtc: true),
      blockedPackageNames: packages.cast<String>().toSet(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DetoxSession &&
      id == other.id &&
      startedAt.toUtc() == other.startedAt.toUtc() &&
      endsAt.toUtc() == other.endsAt.toUtc() &&
      setEquals(blockedPackageNames, other.blockedPackageNames);

  @override
  int get hashCode => Object.hash(
    id,
    startedAt.toUtc(),
    endsAt.toUtc(),
    Object.hashAll(blockedPackageNames.toList()..sort()),
  );
}
