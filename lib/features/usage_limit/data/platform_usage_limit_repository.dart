import 'package:flutter/services.dart';

import '../domain/usage_limit_reached.dart';
import '../domain/usage_limit_repository.dart';
import '../domain/usage_limit_rule.dart';
import '../domain/usage_limit_runtime.dart';

class PlatformUsageLimitRepository implements UsageLimitRepository {
  PlatformUsageLimitRepository({MethodChannel? channel})
    : _channel =
          channel ??
          const MethodChannel('com.abstractvision.phonedetox/usage_limit');

  final MethodChannel _channel;

  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<UsageLimitRule> rules,
  }) => _channel.invokeMethod<void>('synchronizeUsageLimitRules', {
    'schemaVersion': 1,
    'enabled': enabled,
    'disclosureVersion': disclosureVersion,
    'rules': rules.map((rule) => rule.toMap()).toList(growable: false),
  });

  @override
  Future<UsageLimitRuntime?> getRuntime() async {
    final value = await _channel.invokeMethod<Object?>('getUsageLimitRuntime');
    return value == null ? null : UsageLimitRuntime.fromNative(value);
  }

  @override
  Future<UsageLimitReached?> getReachedLimit() async {
    final value = await _channel.invokeMethod<Object?>('getUsageLimitReached');
    return value == null ? null : UsageLimitReached.fromNative(value);
  }

  @override
  Future<void> clearReachedLimit() =>
      _channel.invokeMethod<void>('clearUsageLimitReached');

  @override
  Future<void> continueUsage(String packageName) => _channel.invokeMethod<void>(
    'continueUsageLimit',
    {'packageName': packageName},
  );

  @override
  Future<void> restoreReachedLimit(UsageLimitReached reached) =>
      _channel.invokeMethod<void>('restoreUsageLimitReached', reached.toMap());

  @override
  Future<void> clearRuntime() =>
      _channel.invokeMethod<void>('clearUsageLimitRuntime');

  @override
  Future<void> clearAllEnforcement() =>
      _channel.invokeMethod<void>('clearAllUsageLimitEnforcement');
}
