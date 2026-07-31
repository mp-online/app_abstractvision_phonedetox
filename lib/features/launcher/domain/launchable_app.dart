import 'package:flutter/foundation.dart';

@immutable
class LaunchableApp {
  const LaunchableApp({
    required this.label,
    required this.packageName,
    required this.activityName,
  });

  final String label;
  final String packageName;
  final String activityName;

  String get id => '$packageName/$activityName';

  @override
  bool operator ==(Object other) =>
      other is LaunchableApp &&
      label == other.label &&
      packageName == other.packageName &&
      activityName == other.activityName;

  @override
  int get hashCode => Object.hash(label, packageName, activityName);
}
