import 'package:flutter/services.dart';

import '../domain/mindful_launch_request.dart';
import '../domain/mindful_opening_repository.dart';
import '../domain/mindful_opening_rule.dart';

class PlatformMindfulOpeningRepository implements MindfulOpeningRepository {
  PlatformMindfulOpeningRepository({MethodChannel? channel})
    : _channel =
          channel ??
          const MethodChannel('com.abstractvision.phonedetox/mindful');
  final MethodChannel _channel;

  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<MindfulOpeningRule> rules,
  }) => _channel.invokeMethod<void>('synchronizeMindfulRules', {
    'schemaVersion': 1,
    'enabled': enabled,
    'disclosureVersion': disclosureVersion,
    'rules': rules.map((rule) => rule.toMap()).toList(growable: false),
  });
  @override
  Future<MindfulLaunchRequest?> requestDirectLaunch(String packageName) async =>
      _parse(
        await _channel.invokeMethod<Object?>('requestDirectMindfulLaunch', {
          'packageName': packageName,
        }),
      );
  @override
  Future<MindfulLaunchRequest?> getPendingLaunch() async =>
      _parse(await _channel.invokeMethod<Object?>('getPendingMindfulLaunch'));
  MindfulLaunchRequest? _parse(Object? value) =>
      value == null ? null : MindfulLaunchRequest.fromNative(value);
  @override
  Future<void> clearPendingLaunch() =>
      _channel.invokeMethod<void>('clearPendingMindfulLaunch');
  @override
  Future<void> grantAdmission(String packageName) =>
      _channel.invokeMethod<void>('grantMindfulAdmission', {
        'packageName': packageName,
      });
  @override
  Future<void> clearAdmission() =>
      _channel.invokeMethod<void>('clearMindfulAdmission');
}
