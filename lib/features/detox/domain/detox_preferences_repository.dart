import 'detox_session.dart';

abstract interface class DetoxPreferencesRepository {
  Future<Set<String>> getBlockedPackageNames();
  Future<void> setBlockedPackageNames(Set<String> packageNames);
  Future<int> getDefaultDurationMinutes();
  Future<void> setDefaultDurationMinutes(int minutes);
  Future<int?> getAccessibilityDisclosureVersion();
  Future<void> setAccessibilityDisclosureVersion(int version);
  Future<DetoxSession?> getActiveSession();
  Future<void> setActiveSession(DetoxSession session);
  Future<void> clearActiveSession();
}
