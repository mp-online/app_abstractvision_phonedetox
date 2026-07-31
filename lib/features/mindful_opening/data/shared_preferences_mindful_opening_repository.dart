import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/mindful_opening_preferences_repository.dart';
import '../domain/mindful_opening_rule.dart';

class SharedPreferencesMindfulOpeningRepository
    implements MindfulOpeningPreferencesRepository {
  SharedPreferencesMindfulOpeningRepository({
    SharedPreferencesAsync? preferences,
  }) : _preferences = preferences;
  static const _enabledKey = 'mindful.enabled';
  static const _rulesKey = 'mindful.rules';
  SharedPreferencesAsync? _preferences;
  SharedPreferencesAsync get _store =>
      _preferences ??= SharedPreferencesAsync();

  @override
  Future<bool> getMindfulOpeningEnabled() async =>
      await _store.getBool(_enabledKey) ?? true;
  @override
  Future<void> setMindfulOpeningEnabled(bool enabled) =>
      _store.setBool(_enabledKey, enabled);
  @override
  Future<Map<String, MindfulOpeningRule>> getRules() async {
    final raw = await _store.getString(_rulesKey);
    if (raw == null) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const {};
      final rules = <String, MindfulOpeningRule>{};
      for (final item in decoded) {
        if (item is! Map) continue;
        try {
          final rule = MindfulOpeningRule.fromMap(
            Map<String, Object?>.from(item),
          );
          rules[rule.packageName] = rule;
        } on Object {
          // Corrupted entries are discarded independently; no history is reconstructed.
        }
      }
      return Map.unmodifiable(rules);
    } on FormatException {
      return const {};
    }
  }

  @override
  Future<void> setRules(Map<String, MindfulOpeningRule> rules) {
    final normalized = rules.values.toList()
      ..sort((a, b) => a.packageName.compareTo(b.packageName));
    return _store.setString(
      _rulesKey,
      jsonEncode(normalized.map((rule) => rule.toMap()).toList()),
    );
  }
}
