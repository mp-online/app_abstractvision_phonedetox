import 'home_role_request_result.dart';
import 'home_role_status.dart';
import 'launchable_app.dart';

abstract interface class LauncherRepository {
  Future<List<LaunchableApp>> getLaunchableApps();
  Future<HomeRoleStatus> getHomeRoleStatus();
  Future<HomeRoleRequestResult> requestHomeRole();
  Future<void> openHomeSettings();
  Future<void> openCurrentHome();
  Future<void> launchApp(LaunchableApp app);
  Future<void> openAppDetails(String packageName);
}
