import 'package:flutter/foundation.dart';

import 'mindful_opening_mode.dart';

@immutable
class MindfulOpeningRule {
  MindfulOpeningRule({
    required String packageName,
    required this.mode,
    required this.delaySeconds,
  }) : packageName = packageName.trim() {
    if (this.packageName.isEmpty) {
      throw ArgumentError.value(
        packageName,
        'packageName',
        'Must not be blank.',
      );
    }
    if (mode == MindfulOpeningMode.disabled) {
      throw ArgumentError.value(
        mode,
        'mode',
        'Disabled rules are not persisted.',
      );
    }
    if (!supportedDelays.contains(delaySeconds)) {
      throw ArgumentError.value(
        delaySeconds,
        'delaySeconds',
        'Unsupported delay.',
      );
    }
  }

  static const supportedDelays = <int>{5, 10, 15, 30};
  final String packageName;
  final MindfulOpeningMode mode;
  final int delaySeconds;

  Map<String, Object> toMap() => {
    'packageName': packageName,
    'mode': mode.wireValue,
    'delaySeconds': delaySeconds,
  };

  factory MindfulOpeningRule.fromMap(Map<String, Object?> map) =>
      MindfulOpeningRule(
        packageName: map['packageName'] as String? ?? '',
        mode: MindfulOpeningMode.fromWire(map['mode']),
        delaySeconds: map['delaySeconds'] as int? ?? -1,
      );

  @override
  bool operator ==(Object other) =>
      other is MindfulOpeningRule &&
      packageName == other.packageName &&
      mode == other.mode &&
      delaySeconds == other.delaySeconds;
  @override
  int get hashCode => Object.hash(packageName, mode, delaySeconds);
}
