import 'package:flutter/foundation.dart';

enum UsageLimitRuntimePhase {
  running('running'),
  paused('paused');

  const UsageLimitRuntimePhase(this.wireValue);
  final String wireValue;

  static UsageLimitRuntimePhase fromWire(Object? value) => switch (value) {
    'running' => running,
    'paused' => paused,
    _ => throw FormatException('Unsupported usage interval phase: $value'),
  };
}

@immutable
class UsageLimitRuntime {
  const UsageLimitRuntime({
    required this.packageName,
    required this.configuredLimitMs,
    required this.remainingMs,
    required this.phase,
    required this.startedAt,
    required this.updatedAt,
  });

  final String packageName;
  final int configuredLimitMs;
  final int remainingMs;
  final UsageLimitRuntimePhase phase;
  final DateTime startedAt;
  final DateTime updatedAt;

  Duration get configuredLimit => Duration(milliseconds: configuredLimitMs);
  Duration get remaining => Duration(milliseconds: remainingMs);

  factory UsageLimitRuntime.fromNative(Object? value) {
    if (value is! Map) throw const FormatException('Runtime must be a map.');
    final map = Map<Object?, Object?>.from(value);
    final packageName = map['packageName'];
    final configured = map['configuredLimitMs'];
    final remaining = map['remainingMs'];
    final started = map['startedAtEpochMs'];
    final updated = map['updatedAtEpochMs'];
    if (packageName is! String ||
        packageName.trim().isEmpty ||
        configured is! num ||
        remaining is! num ||
        started is! num ||
        updated is! num) {
      throw const FormatException('Malformed usage runtime.');
    }
    final configuredMs = configured.toInt();
    final remainingMs = remaining.toInt();
    if (configuredMs <= 0 || remainingMs <= 0 || remainingMs > configuredMs) {
      throw const FormatException('Invalid usage runtime duration.');
    }
    return UsageLimitRuntime(
      packageName: packageName,
      configuredLimitMs: configuredMs,
      remainingMs: remainingMs,
      phase: UsageLimitRuntimePhase.fromWire(map['phase']),
      startedAt: DateTime.fromMillisecondsSinceEpoch(
        started.toInt(),
        isUtc: true,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        updated.toInt(),
        isUtc: true,
      ),
    );
  }
}
