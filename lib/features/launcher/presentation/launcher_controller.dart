import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detox/presentation/detox_controller.dart';
import '../../detox/presentation/detox_state.dart';
import '../../mindful_opening/presentation/mindful_opening_controller.dart';
import '../../settings/data/shared_preferences_launcher_repository.dart';
import '../../settings/domain/launcher_preferences_repository.dart';
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
  Future<void>? _refreshInFlight;
  int _refreshVersion = 0;

  @override
  LauncherState build() {
    _launcherRepository = ref.watch(launcherRepositoryProvider);
    _preferencesRepository = ref.watch(launcherPreferencesRepositoryProvider);
    return const LauncherState();
  }

  Future<void> refresh() {
    final current = _refreshInFlight;
    if (current != null) return current;
    final operation = _performRefresh();
    _refreshInFlight = operation;
    return operation.whenComplete(() {
      if (identical(_refreshInFlight, operation)) _refreshInFlight = null;
    });
  }

  Future<void> _performRefresh() async {
    final version = ++_refreshVersion;
    state = state.copyWith(status: LauncherStatus.loading, clearError: true);
    try {
      final results = await Future.wait<Object>([
        _launcherRepository.getLaunchableApps(),
        _preferencesRepository.getFavouriteIds(),
        _preferencesRepository.getHiddenIds(),
      ]);
      if (version != _refreshVersion) return;
      final apps = results[0] as List<LaunchableApp>;
      final knownIds = apps.map((app) => app.id).toSet();
      final favourites = (results[1] as Set<String>).intersection(knownIds);
      final hidden = (results[2] as Set<String>).intersection(knownIds);
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
        clearError: true,
      );
    } catch (error) {
      if (version == _refreshVersion) {
        state = state.copyWith(status: LauncherStatus.error, error: error);
      }
    }
  }

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);
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
    final request = await ref
        .read(mindfulOpeningControllerProvider.notifier)
        .requestDirectLaunch(app.packageName);
    if (request != null) return LaunchRequiresMindfulOpening(request);
    await _launcherRepository.launchApp(app);
    return const LaunchAllowed();
  }
}
