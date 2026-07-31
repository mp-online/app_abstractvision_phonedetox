import 'mindful_opening_rule.dart';

abstract interface class MindfulOpeningPreferencesRepository {
  Future<Map<String, MindfulOpeningRule>> getRules();
  Future<void> setRules(Map<String, MindfulOpeningRule> rules);
  Future<bool> getMindfulOpeningEnabled();
  Future<void> setMindfulOpeningEnabled(bool enabled);
}
