import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_state.dart';

const alpha = LaunchableApp(
  label: 'Alpha',
  packageName: 'example.alpha',
  activityName: 'AlphaActivity',
);
const beta = LaunchableApp(
  label: 'Beta',
  packageName: 'example.beta',
  activityName: 'BetaActivity',
);
const camera = LaunchableApp(
  label: 'Camera',
  packageName: 'system.camera',
  activityName: 'CameraActivity',
);

void main() {
  test('sorts favourites first and remaining apps alphabetically', () {
    final state = LauncherState(
      status: LauncherStatus.success,
      apps: const [camera, beta, alpha],
      favouriteIds: {beta.id},
    );

    expect(state.visibleApps, const [beta, alpha, camera]);
  });

  test('filters by label or package without case sensitivity', () {
    final state = LauncherState(
      status: LauncherStatus.success,
      apps: const [alpha, camera],
      searchQuery: 'SYSTEM.CAM',
    );

    expect(state.visibleApps, const [camera]);
  });

  test('excludes hidden apps and exposes them for settings', () {
    final state = LauncherState(
      status: LauncherStatus.success,
      apps: const [beta, alpha],
      hiddenIds: {beta.id},
    );

    expect(state.visibleApps, const [alpha]);
    expect(state.hiddenApps, const [beta]);
  });
}
