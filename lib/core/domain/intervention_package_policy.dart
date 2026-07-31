abstract final class InterventionPackagePolicy {
  static bool isConfigurable(String packageName) {
    final value = packageName.trim().toLowerCase();
    if (value.isEmpty || value == 'com.abstractvision.phonedetox') return false;
    return !_excludedParts.any(value.contains);
  }

  static const _excludedParts = <String>{
    'systemui',
    'settings',
    'permissioncontroller',
    'packageinstaller',
    'incallui',
    'telecom',
    'emergency',
    'setupwizard',
    'recovery',
  };
}
