import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';

void main() {
  test('parses every native Home-role status', () {
    expect(HomeRoleStatus.fromNative('held'), HomeRoleStatus.held);
    expect(HomeRoleStatus.fromNative('notHeld'), HomeRoleStatus.notHeld);
    expect(
      HomeRoleStatus.fromNative('unavailable'),
      HomeRoleStatus.unavailable,
    );
  });

  test('rejects unknown native Home-role status', () {
    expect(() => HomeRoleStatus.fromNative('unknown'), throwsFormatException);
    expect(() => HomeRoleStatus.fromNative(null), throwsFormatException);
  });

  test('parses every native Home-role request result', () {
    const expected = <String, HomeRoleRequestResult>{
      'granted': HomeRoleRequestResult.granted,
      'denied': HomeRoleRequestResult.denied,
      'cancelled': HomeRoleRequestResult.cancelled,
      'alreadyHeld': HomeRoleRequestResult.alreadyHeld,
      'openedSettings': HomeRoleRequestResult.openedSettings,
      'unavailable': HomeRoleRequestResult.unavailable,
    };
    for (final entry in expected.entries) {
      expect(HomeRoleRequestResult.fromNative(entry.key), entry.value);
    }
  });

  test('rejects unknown native Home-role request result', () {
    expect(
      () => HomeRoleRequestResult.fromNative('unknown'),
      throwsFormatException,
    );
  });
}
