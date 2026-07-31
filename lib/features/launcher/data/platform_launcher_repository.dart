import 'package:flutter/services.dart';

import '../domain/home_role_request_result.dart';
import '../domain/home_role_status.dart';
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
  Future<HomeRoleStatus> getHomeRoleStatus() async => HomeRoleStatus.fromNative(
    await _channel.invokeMethod<Object?>('getHomeRoleStatus'),
  );

  @override
  Future<HomeRoleRequestResult> requestHomeRole() async =>
      HomeRoleRequestResult.fromNative(
        await _channel.invokeMethod<Object?>('requestHomeRole'),
      );

  @override
  Future<void> openHomeSettings() =>
      _channel.invokeMethod<void>('openHomeSettings');

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
