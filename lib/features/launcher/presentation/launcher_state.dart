import 'package:flutter/foundation.dart';

import '../domain/launchable_app.dart';

enum LauncherStatus { loading, success, error }

@immutable
class LauncherState {
  const LauncherState({
    this.status = LauncherStatus.loading,
    this.apps = const [],
    this.favouriteIds = const {},
    this.hiddenIds = const {},
    this.searchQuery = '',
    this.isDefaultLauncher = false,
    this.error,
  });

  final LauncherStatus status;
  final List<LaunchableApp> apps;
  final Set<String> favouriteIds;
  final Set<String> hiddenIds;
  final String searchQuery;
  final bool isDefaultLauncher;
  final Object? error;

  List<LaunchableApp> get visibleApps {
    final query = searchQuery.trim().toLowerCase();
    final result = apps.where((app) {
      if (hiddenIds.contains(app.id)) return false;
      if (query.isEmpty) return true;
      return app.label.toLowerCase().contains(query) ||
          app.packageName.toLowerCase().contains(query);
    }).toList();
    result.sort(_compareApps);
    return result;
  }

  List<LaunchableApp> get hiddenApps {
    final result = apps.where((app) => hiddenIds.contains(app.id)).toList();
    result.sort((a, b) => _compareLabels(a.label, b.label));
    return result;
  }

  int _compareApps(LaunchableApp a, LaunchableApp b) {
    final favouriteOrder =
        (favouriteIds.contains(b.id) ? 1 : 0) -
        (favouriteIds.contains(a.id) ? 1 : 0);
    return favouriteOrder != 0
        ? favouriteOrder
        : _compareLabels(a.label, b.label);
  }

  int _compareLabels(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  LauncherState copyWith({
    LauncherStatus? status,
    List<LaunchableApp>? apps,
    Set<String>? favouriteIds,
    Set<String>? hiddenIds,
    String? searchQuery,
    bool? isDefaultLauncher,
    Object? error,
    bool clearError = false,
  }) {
    return LauncherState(
      status: status ?? this.status,
      apps: apps ?? this.apps,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      hiddenIds: hiddenIds ?? this.hiddenIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isDefaultLauncher: isDefaultLauncher ?? this.isDefaultLauncher,
      error: clearError ? null : error ?? this.error,
    );
  }
}
