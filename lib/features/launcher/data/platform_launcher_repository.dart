import 'package:flutter/services.dart';

import '../domain/launchable_app.dart';
import '../domain/launcher_repository.dart';

class PlatformLauncherRepository implements LauncherRepository {
  PlatformLauncherRepository({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'com.abstractvision.phonedetox/launcher';
  final MethodChannel _channel;

  @override
  Future<List<LaunchableApp>> getLaunchableApps() async {
    final payload = await _channel.invokeListMethod<Object?>(
      'getLaunchableApps',
    );
    if (payload == null) {
      throw const FormatException('Native app inventory was null.');
    }

    return payload.map(_parseApp).toList(growable: false);
  }

  LaunchableApp _parseApp(Object? value) {
    if (value is! Map<Object?, Object?>) {
      throw const FormatException('Native app entry was not a map.');
    }
    final label = value['label'];
    final packageName = value['packageName'];
    final activityName = value['activityName'];
    if (label is! String ||
        label.isEmpty ||
        packageName is! String ||
        packageName.isEmpty ||
        activityName is! String ||
        activityName.isEmpty) {
      throw const FormatException('Native app entry had invalid fields.');
    }
    return LaunchableApp(
      label: label,
      packageName: packageName,
      activityName: activityName,
    );
  }

  @override
  Future<bool> isDefaultLauncher() async =>
      await _channel.invokeMethod<bool>('isDefaultLauncher') ?? false;

  @override
  Future<void> requestDefaultLauncher() =>
      _channel.invokeMethod<void>('requestDefaultLauncher');

  @override
  Future<void> launchApp(LaunchableApp app) =>
      _channel.invokeMethod<void>('launchApp', <String, String>{
        'packageName': app.packageName,
        'activityName': app.activityName,
      });

  @override
  Future<void> openAppDetails(String packageName) =>
      _channel.invokeMethod<void>('openAppDetails', <String, String>{
        'packageName': packageName,
      });
}
