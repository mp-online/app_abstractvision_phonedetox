import 'launchable_app.dart';

abstract interface class LauncherRepository {
  Future<List<LaunchableApp>> getLaunchableApps();
  Future<bool> isDefaultLauncher();
  Future<void> requestDefaultLauncher();
  Future<void> launchApp(LaunchableApp app);
  Future<void> openAppDetails(String packageName);
}
