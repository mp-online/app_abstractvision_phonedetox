import 'usage_limit_reached.dart';
import 'usage_limit_rule.dart';
import 'usage_limit_runtime.dart';

abstract interface class UsageLimitRepository {
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<UsageLimitRule> rules,
  });
  Future<UsageLimitRuntime?> getRuntime();
  Future<UsageLimitReached?> getReachedLimit();
  Future<void> clearReachedLimit();
  Future<void> continueUsage(String packageName);
  Future<void> restoreReachedLimit(UsageLimitReached reached);
  Future<void> clearRuntime();
  Future<void> clearAllEnforcement();
}
