import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usage_limit_preferences_repository.dart';
import '../domain/usage_limit_rule.dart';

class SharedPreferencesUsageLimitRepository
    implements UsageLimitPreferencesRepository {
  SharedPreferencesUsageLimitRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences;

  static const enabledKey = 'usage_limits.enabled';
  static const rulesKey = 'usage_limits.rules';
  SharedPreferencesAsync? _preferences;
  SharedPreferencesAsync get _store =>
      _preferences ??= SharedPreferencesAsync();

  @override
  Future<bool> getEnabled() async => await _store.getBool(enabledKey) ?? false;

  @override
  Future<void> setEnabled(bool enabled) => _store.setBool(enabledKey, enabled);

  @override
  Future<Map<String, UsageLimitRule>> getRules() async {
    final raw = await _store.getString(rulesKey);
    if (raw == null) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const {};
      final rules = <String, UsageLimitRule>{};
      for (final value in decoded) {
        if (value is! Map) continue;
        try {
          final rule = UsageLimitRule.fromMap(Map<String, Object?>.from(value));
          rules[rule.packageName] = rule;
        } on Object {
          // Corrupt rules are discarded without reconstructing usage history.
        }
      }
      return Map.unmodifiable(rules);
    } on FormatException {
      return const {};
    }
  }

  @override
  Future<void> setRules(Map<String, UsageLimitRule> rules) {
    final normalized = rules.values.toList()
      ..sort((a, b) => a.packageName.compareTo(b.packageName));
    return _store.setString(
      rulesKey,
      jsonEncode(normalized.map((rule) => rule.toMap()).toList()),
    );
  }
}
