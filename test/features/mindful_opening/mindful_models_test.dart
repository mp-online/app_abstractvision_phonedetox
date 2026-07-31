import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_launch_request.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_launch_source.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_mode.dart';
import 'package:phone_detox/features/mindful_opening/domain/mindful_opening_rule.dart';

void main() {
  test('rules validate package, mode, and supported delays', () {
    expect(
      () => MindfulOpeningRule(
        packageName: ' ',
        mode: MindfulOpeningMode.pause,
        delaySeconds: 10,
      ),
      throwsArgumentError,
    );
    expect(
      () => MindfulOpeningRule(
        packageName: 'app',
        mode: MindfulOpeningMode.disabled,
        delaySeconds: 10,
      ),
      throwsArgumentError,
    );
    expect(
      () => MindfulOpeningRule(
        packageName: 'app',
        mode: MindfulOpeningMode.pause,
        delaySeconds: 60,
      ),
      throwsArgumentError,
    );
    expect(
      MindfulOpeningRule(
        packageName: 'app',
        mode: MindfulOpeningMode.pauseAndIntention,
        delaySeconds: 15,
      ).delaySeconds,
      15,
    );
  });

  test('native request uses UTC deadlines and does not reset countdown', () {
    final request = MindfulLaunchRequest.fromNative({
      'requestId': 'one',
      'packageName': 'app',
      'source': 'external',
      'mode': 'pause',
      'createdAtEpochMs': 1000,
      'availableAtEpochMs': 11000,
      'expiresAtEpochMs': 301000,
    });
    expect(request.source, MindfulLaunchSource.external);
    expect(request.createdAt.isUtc, isTrue);
    expect(
      request.remainingDelayAt(
        DateTime.fromMillisecondsSinceEpoch(6000, isUtc: true),
      ),
      const Duration(seconds: 5),
    );
    expect(
      request.isExpiredAt(
        DateTime.fromMillisecondsSinceEpoch(301000, isUtc: true),
      ),
      isTrue,
    );
  });

  test('unknown native values are rejected', () {
    expect(() => MindfulLaunchSource.fromWire('other'), throwsFormatException);
    expect(() => MindfulOpeningMode.fromWire('unknown'), throwsFormatException);
  });
}
