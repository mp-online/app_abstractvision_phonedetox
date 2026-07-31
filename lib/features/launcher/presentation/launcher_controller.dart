import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/data/shared_preferences_launcher_repository.dart';
import '../../settings/domain/launcher_preferences_repository.dart';
import '../../detox/presentation/detox_controller.dart';
import '../../detox/presentation/detox_state.dart';
import '../data/platform_launcher_repository.dart';
import '../domain/launch_decision.dart';
import '../domain/launchable_app.dart';
import '../domain/launcher_repository.dart';
import 'launcher_state.dart';

final launcherRepositoryProvider = Provider<LauncherRepository>(
  (ref) => PlatformLauncherRepository(),
);

final launcherPreferencesRepositoryProvider =
    Provider<LauncherPreferencesRepository>(
      (ref) => SharedPreferencesLauncherRepository(),
    );

final launcherControllerProvider =
    NotifierProvider<LauncherController, LauncherState>(LauncherController.new);

class LauncherController extends Notifier<LauncherState> {
  late final LauncherRepository _launcherRepository;
  late final LauncherPreferencesRepository _preferencesRepository;
  int _refreshVersion = 0;

  @override
  LauncherState build() {
    _launcherRepository = ref.watch(launcherRepositoryProvider);
    _preferencesRepository = ref.watch(launcherPreferencesRepositoryProvider);
    unawaited(Future<void>.delayed(Duration.zero, refresh));
    return const LauncherState();
  }

  Future<void> refresh() async {
    final version = ++_refreshVersion;
    state = state.copyWith(status: LauncherStatus.loading, clearError: true);
    try {
      final results = await Future.wait<Object>([
        _launcherRepository.getLaunchableApps(),
        _launcherRepository.isDefaultLauncher(),
        _preferencesRepository.getFavouriteIds(),
        _preferencesRepository.getHiddenIds(),
      ]);
      if (version != _refreshVersion) return;
      final apps = results[0] as List<LaunchableApp>;
      final knownIds = apps.map((app) => app.id).toSet();
      final favourites = (results[2] as Set<String>).intersection(knownIds);
      final hidden = (results[3] as Set<String>).intersection(knownIds);
      await Future.wait([
        _preferencesRepository.setFavouriteIds(favourites),
        _preferencesRepository.setHiddenIds(hidden),
      ]);
      if (version != _refreshVersion) return;
      state = state.copyWith(
        status: LauncherStatus.success,
        apps: List.unmodifiable(apps),
        favouriteIds: Set.unmodifiable(favourites),
        hiddenIds: Set.unmodifiable(hidden),
        isDefaultLauncher: results[1] as bool,
        clearError: true,
      );
    } catch (error) {
      if (version != _refreshVersion) return;
      state = state.copyWith(status: LauncherStatus.error, error: error);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> toggleFavourite(LaunchableApp app) async {
    final updated = state.favouriteIds.toSet();
    updated.contains(app.id) ? updated.remove(app.id) : updated.add(app.id);
    state = state.copyWith(favouriteIds: Set.unmodifiable(updated));
    await _preferencesRepository.setFavouriteIds(updated);
  }

  Future<void> hide(LaunchableApp app) async {
    final hidden = state.hiddenIds.toSet()..add(app.id);
    final favourites = state.favouriteIds.toSet()..remove(app.id);
    state = state.copyWith(
      hiddenIds: Set.unmodifiable(hidden),
      favouriteIds: Set.unmodifiable(favourites),
    );
    await Future.wait([
      _preferencesRepository.setHiddenIds(hidden),
      _preferencesRepository.setFavouriteIds(favourites),
    ]);
  }

  Future<void> restore(LaunchableApp app) async {
    final hidden = state.hiddenIds.toSet()..remove(app.id);
    state = state.copyWith(hiddenIds: Set.unmodifiable(hidden));
    await _preferencesRepository.setHiddenIds(hidden);
  }

  Future<LaunchDecision> launch(LaunchableApp app) async {
    final detox = ref.read(detoxControllerProvider);
    final session = detox.activeSession;
    if (detox.status == DetoxStatus.activeAndEnforced &&
        session != null &&
        session.isActive &&
        session.blockedPackageNames.contains(app.packageName)) {
      return LaunchBlocked(blockedUntil: session.endsAt);
    }
    await _launcherRepository.launchApp(app);
    return const LaunchAllowed();
  }

  Future<void> requestDefaultLauncher() async {
    await _launcherRepository.requestDefaultLauncher();
    await refresh();
  }
}
