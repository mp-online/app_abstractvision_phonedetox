import 'package:shared_preferences/shared_preferences.dart';

import '../domain/launcher_preferences_repository.dart';

class SharedPreferencesLauncherRepository
    implements LauncherPreferencesRepository {
  SharedPreferencesLauncherRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _favouriteIdsKey = 'launcher.favouriteComponentIds';
  static const _hiddenIdsKey = 'launcher.hiddenComponentIds';
  final SharedPreferencesAsync _preferences;

  @override
  Future<Set<String>> getFavouriteIds() => _readIds(_favouriteIdsKey);

  @override
  Future<Set<String>> getHiddenIds() => _readIds(_hiddenIdsKey);

  Future<Set<String>> _readIds(String key) async =>
      (await _preferences.getStringList(key) ?? const <String>[]).toSet();

  @override
  Future<void> setFavouriteIds(Set<String> ids) =>
      _preferences.setStringList(_favouriteIdsKey, _sorted(ids));

  @override
  Future<void> setHiddenIds(Set<String> ids) =>
      _preferences.setStringList(_hiddenIdsKey, _sorted(ids));

  List<String> _sorted(Set<String> ids) => ids.toList()..sort();
}
