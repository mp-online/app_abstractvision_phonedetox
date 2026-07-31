import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/detox_preferences_repository.dart';
import '../domain/detox_session.dart';

class SharedPreferencesDetoxRepository implements DetoxPreferencesRepository {
  SharedPreferencesDetoxRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _blockedKey = 'detox.blockedPackageNames';
  static const _durationKey = 'detox.defaultDurationMinutes';
  static const _disclosureKey = 'detox.accessibilityDisclosureVersion';
  static const _sessionKey = 'detox.activeSession';
  final SharedPreferencesAsync _preferences;

  @override
  Future<Set<String>> getBlockedPackageNames() async =>
      (await _preferences.getStringList(_blockedKey) ?? const <String>[])
          .where((value) => value.trim().isNotEmpty)
          .toSet();

  @override
  Future<void> setBlockedPackageNames(Set<String> packageNames) =>
      _preferences.setStringList(
        _blockedKey,
        packageNames.where((value) => value.trim().isNotEmpty).toList()..sort(),
      );

  @override
  Future<int> getDefaultDurationMinutes() async =>
      await _preferences.getInt(_durationKey) ?? 30;

  @override
  Future<void> setDefaultDurationMinutes(int minutes) =>
      _preferences.setInt(_durationKey, minutes);

  @override
  Future<int?> getAccessibilityDisclosureVersion() =>
      _preferences.getInt(_disclosureKey);

  @override
  Future<void> setAccessibilityDisclosureVersion(int version) =>
      _preferences.setInt(_disclosureKey, version);

  @override
  Future<DetoxSession?> getActiveSession() async {
    final value = await _preferences.getString(_sessionKey);
    if (value == null) return null;
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Invalid persisted detox session.');
    }
    return DetoxSession.fromMap(decoded);
  }

  @override
  Future<void> setActiveSession(DetoxSession session) =>
      _preferences.setString(_sessionKey, jsonEncode(session.toMap()));

  @override
  Future<void> clearActiveSession() => _preferences.remove(_sessionKey);
}
