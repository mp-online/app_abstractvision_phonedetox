abstract interface class LauncherPreferencesRepository {
  Future<Set<String>> getFavouriteIds();
  Future<Set<String>> getHiddenIds();
  Future<void> setFavouriteIds(Set<String> ids);
  Future<void> setHiddenIds(Set<String> ids);
}
