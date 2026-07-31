abstract interface class StartupPreferencesRepository {
  Future<bool> hasSeenLauncherExplanation();
  Future<void> setHasSeenLauncherExplanation(bool value);
  Future<bool> hasCompletedLauncherActivation();
  Future<void> setHasCompletedLauncherActivation(bool value);
}
