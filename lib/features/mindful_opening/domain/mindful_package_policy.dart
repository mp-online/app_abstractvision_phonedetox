abstract final class MindfulPackagePolicy {
  static bool isConfigurable(String packageName) {
    final value = packageName.toLowerCase();
    if (value.trim().isEmpty || value == 'com.abstractvision.phonedetox') {
      return false;
    }
    return !const <String>{
      'systemui',
      'settings',
      'permissioncontroller',
      'packageinstaller',
      'incallui',
      'telecom',
      'emergency',
      'setupwizard',
      'recovery',
    }.any(value.contains);
  }
}
