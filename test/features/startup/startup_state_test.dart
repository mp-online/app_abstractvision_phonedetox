import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/launcher/domain/home_role_request_result.dart';
import 'package:phone_detox/features/launcher/domain/home_role_status.dart';
import 'package:phone_detox/features/startup/domain/startup_state.dart';
import 'package:phone_detox/features/startup/domain/startup_status.dart';

void main() {
  test('supports value equality and immutable transitions', () {
    const initial = StartupState();
    const same = StartupState();
    expect(initial, same);

    final ready = initial.copyWith(
      status: StartupStatus.ready,
      homeRoleStatus: HomeRoleStatus.held,
      lastRequestResult: HomeRoleRequestResult.granted,
      hasPreviouslyCompletedActivation: true,
    );
    expect(initial.status, StartupStatus.loading);
    expect(ready.status, StartupStatus.ready);
    expect(ready.homeRoleStatus, HomeRoleStatus.held);
    expect(ready.lastRequestResult, HomeRoleRequestResult.granted);
    expect(ready.hasPreviouslyCompletedActivation, isTrue);
  });
}
