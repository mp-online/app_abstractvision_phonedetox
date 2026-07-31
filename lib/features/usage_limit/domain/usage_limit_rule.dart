import 'package:flutter/foundation.dart';

import '../../../core/domain/intervention_package_policy.dart';

@immutable
class UsageLimitRule {
  UsageLimitRule({required String packageName, required this.limitMinutes})
    : packageName = packageName.trim() {
    if (!InterventionPackagePolicy.isConfigurable(this.packageName)) {
      throw ArgumentError.value(
        packageName,
        'packageName',
        'Package is not configurable.',
      );
    }
    if (!supportedMinutes.contains(limitMinutes)) {
      throw ArgumentError.value(
        limitMinutes,
        'limitMinutes',
        'Unsupported usage limit.',
      );
    }
  }

  static const defaultMinutes = 15;
  static const supportedMinutes = <int>[5, 10, 15, 30, 60];
  final String packageName;
  final int limitMinutes;

  Map<String, Object> toMap() => {
    'packageName': packageName,
    'limitMinutes': limitMinutes,
  };

  factory UsageLimitRule.fromMap(Map<String, Object?> map) => UsageLimitRule(
    packageName: map['packageName'] as String? ?? '',
    limitMinutes: (map['limitMinutes'] as num?)?.toInt() ?? -1,
  );

  @override
  bool operator ==(Object other) =>
      other is UsageLimitRule &&
      packageName == other.packageName &&
      limitMinutes == other.limitMinutes;

  @override
  int get hashCode => Object.hash(packageName, limitMinutes);
}
