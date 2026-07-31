import 'mindful_launch_request.dart';
import 'mindful_opening_rule.dart';

abstract interface class MindfulOpeningRepository {
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<MindfulOpeningRule> rules,
  });
  Future<MindfulLaunchRequest?> requestDirectLaunch(String packageName);
  Future<MindfulLaunchRequest?> getPendingLaunch();
  Future<void> clearPendingLaunch();
  Future<void> grantAdmission(String packageName);
  Future<void> clearAdmission();
}
