import 'usage_limit_rule.dart';

abstract interface class UsageLimitPreferencesRepository {
  Future<bool> getEnabled();
  Future<void> setEnabled(bool enabled);
  Future<Map<String, UsageLimitRule>> getRules();
  Future<void> setRules(Map<String, UsageLimitRule> rules);
}
