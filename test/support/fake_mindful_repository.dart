import 'package:phone_detox/features/mindful_opening/domain/mindful_launch_request.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_repository.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_rule.dart';

class FakeMindfulRepository implements MindfulOpeningRepository {
  MindfulLaunchRequest? pending;
  String? admittedPackage;
  bool? synchronizedEnabled;

  @override
  Future<void> clearAdmission() async => admittedPackage = null;
  @override
  Future<void> clearPendingLaunch() async => pending = null;
  @override
  Future<MindfulLaunchRequest?> getPendingLaunch() async => pending;
  @override
  Future<void> grantAdmission(String packageName) async =>
      admittedPackage = packageName;
  @override
  Future<MindfulLaunchRequest?> requestDirectLaunch(String packageName) async =>
      pending;
  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<MindfulOpeningRule> rules,
  }) async {
    synchronizedEnabled = enabled && disclosureVersion >= 2;
  }
}
