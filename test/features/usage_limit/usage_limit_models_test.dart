import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_reached.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_rule.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_runtime.dart';

void main() {
  test('rules are opt-in with a 15-minute suggestion and fixed presets', () {
    expect(UsageLimitRule.defaultMinutes, 15);
    expect(UsageLimitRule.supportedMinutes, [5, 10, 15, 30, 60]);
    expect(
      () => UsageLimitRule(packageName: 'social.app', limitMinutes: 20),
      throwsArgumentError,
    );
    expect(
      () =>
          UsageLimitRule(packageName: 'com.android.settings', limitMinutes: 15),
      throwsArgumentError,
    );
  });

  test('native runtime and reached snapshots validate primitive payloads', () {
    final runtime = UsageLimitRuntime.fromNative({
      'schemaVersion': 1,
      'packageName': 'social.app',
      'configuredLimitMs': 900000,
      'remainingMs': 450000,
      'phase': 'paused',
      'startedAtEpochMs': 1000,
      'updatedAtEpochMs': 2000,
    });
    expect(runtime.remaining, const Duration(minutes: 7, seconds: 30));
    expect(runtime.phase, UsageLimitRuntimePhase.paused);

    final reached = UsageLimitReached.fromNative({
      'packageName': 'social.app',
      'configuredLimitMs': 900000,
      'reachedAtEpochMs': 3000,
    });
    expect(reached.configuredLimit, const Duration(minutes: 15));
    expect(
      () => UsageLimitRuntime.fromNative({'phase': 'other'}),
      throwsFormatException,
    );
  });
}
