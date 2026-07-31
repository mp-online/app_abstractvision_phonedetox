import '../../../core/domain/intervention_package_policy.dart';

abstract final class UsageLimitPackagePolicy {
  static bool isConfigurable(String packageName) =>
      InterventionPackagePolicy.isConfigurable(packageName);
}
