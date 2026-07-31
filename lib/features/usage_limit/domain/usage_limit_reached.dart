import 'package:flutter/foundation.dart';

@immutable
class UsageLimitReached {
  const UsageLimitReached({
    required this.packageName,
    required this.configuredLimitMs,
    required this.reachedAt,
  });

  final String packageName;
  final int configuredLimitMs;
  final DateTime reachedAt;
  Duration get configuredLimit => Duration(milliseconds: configuredLimitMs);

  Map<String, Object> toMap() => {
    'packageName': packageName,
    'configuredLimitMs': configuredLimitMs,
    'reachedAtEpochMs': reachedAt.millisecondsSinceEpoch,
  };

  factory UsageLimitReached.fromNative(Object? value) {
    if (value is! Map) {
      throw const FormatException('Reached limit must be a map.');
    }
    final map = Map<Object?, Object?>.from(value);
    final packageName = map['packageName'];
    final configured = map['configuredLimitMs'];
    final reached = map['reachedAtEpochMs'];
    if (packageName is! String ||
        packageName.trim().isEmpty ||
        configured is! num ||
        configured.toInt() <= 0 ||
        reached is! num) {
      throw const FormatException('Malformed reached limit.');
    }
    return UsageLimitReached(
      packageName: packageName,
      configuredLimitMs: configured.toInt(),
      reachedAt: DateTime.fromMillisecondsSinceEpoch(
        reached.toInt(),
        isUtc: true,
      ),
    );
  }
}
