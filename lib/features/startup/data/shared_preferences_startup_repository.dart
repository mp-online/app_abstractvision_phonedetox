import 'package:shared_preferences/shared_preferences.dart';

import '../domain/startup_preferences_repository.dart';

class SharedPreferencesStartupRepository
    implements StartupPreferencesRepository {
  SharedPreferencesStartupRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _seenExplanationKey = 'startup.hasSeenLauncherExplanation';
  static const _completedActivationKey =
      'startup.hasCompletedLauncherActivation';
  final SharedPreferencesAsync _preferences;

  @override
  Future<bool> hasSeenLauncherExplanation() async =>
      await _preferences.getBool(_seenExplanationKey) ?? false;

  @override
  Future<void> setHasSeenLauncherExplanation(bool value) =>
      _preferences.setBool(_seenExplanationKey, value);

  @override
  Future<bool> hasCompletedLauncherActivation() async =>
      await _preferences.getBool(_completedActivationKey) ?? false;

  @override
  Future<void> setHasCompletedLauncherActivation(bool value) =>
      _preferences.setBool(_completedActivationKey, value);
}
