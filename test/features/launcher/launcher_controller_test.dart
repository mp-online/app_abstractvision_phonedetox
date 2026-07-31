import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/launcher/domain/launchable_app.dart';
import 'package:phone_detox/features/launcher/domain/launcher_repository.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_controller.dart';
import 'package:phone_detox/features/launcher/presentation/launcher_state.dart';
import 'package:phone_detox/features/settings/domain/launcher_preferences_repository.dart';

const app = LaunchableApp(
  label: 'Alpha',
  packageName: 'example.alpha',
  activityName: 'AlphaActivity',
);

class FakeLauncherRepository implements LauncherRepository {
  List<LaunchableApp> apps = const [app];
  bool defaultLauncher = false;
  int launchCount = 0;

  @override
  Future<List<LaunchableApp>> getLaunchableApps() async => apps;

  @override
  Future<bool> isDefaultLauncher() async => defaultLauncher;

  @override
  Future<void> launchApp(LaunchableApp app) async => launchCount++;

  @override
  Future<void> openAppDetails(String packageName) async {}

  @override
  Future<void> requestDefaultLauncher() async => defaultLauncher = true;
}

class FakePreferencesRepository implements LauncherPreferencesRepository {
  Set<String> favourites = {};
  Set<String> hidden = {};

  @override
  Future<Set<String>> getFavouriteIds() async => favourites.toSet();

  @override
  Future<Set<String>> getHiddenIds() async => hidden.toSet();

  @override
  Future<void> setFavouriteIds(Set<String> ids) async {
    favourites = ids.toSet();
  }

  @override
  Future<void> setHiddenIds(Set<String> ids) async {
    hidden = ids.toSet();
  }
}

void main() {
  late FakeLauncherRepository launcher;
  late FakePreferencesRepository preferences;
  late ProviderContainer container;

  setUp(() async {
    launcher = FakeLauncherRepository();
    preferences = FakePreferencesRepository();
    container = ProviderContainer(
      overrides: [
        launcherRepositoryProvider.overrideWithValue(launcher),
        launcherPreferencesRepositoryProvider.overrideWithValue(preferences),
      ],
    );
    container.read(launcherControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(launcherControllerProvider.notifier).refresh();
  });

  tearDown(() => container.dispose());

  test('loads repository and persisted selections', () {
    final state = container.read(launcherControllerProvider);
    expect(state.status, LauncherStatus.success);
    expect(state.apps, const [app]);
  });

  test(
    'favourite, hide, and restore transitions persist component IDs',
    () async {
      final controller = container.read(launcherControllerProvider.notifier);

      await controller.toggleFavourite(app);
      expect(preferences.favourites, {app.id});

      await controller.hide(app);
      expect(preferences.hidden, {app.id});
      expect(preferences.favourites, isEmpty);
      expect(container.read(launcherControllerProvider).visibleApps, isEmpty);

      await controller.restore(app);
      expect(preferences.hidden, isEmpty);
      expect(container.read(launcherControllerProvider).visibleApps, const [
        app,
      ]);
    },
  );

  test('requesting Home role refreshes default-launcher state', () async {
    await container
        .read(launcherControllerProvider.notifier)
        .requestDefaultLauncher();

    expect(
      container.read(launcherControllerProvider).isDefaultLauncher,
      isTrue,
    );
  });
}
