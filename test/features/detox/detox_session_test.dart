import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/detox_session.dart';

void main() {
  final start = DateTime.utc(2026, 7, 31, 10);

  test('calculates active, expired, and remaining state from end time', () {
    final session = DetoxSession(
      id: 'one',
      startedAt: start,
      endsAt: start.add(const Duration(minutes: 30)),
      blockedPackageNames: {'example.app'},
    );
    expect(session.isActiveAt(start.add(const Duration(minutes: 5))), isTrue);
    expect(session.isActiveAt(start.add(const Duration(minutes: 30))), isFalse);
    expect(
      session.remainingAt(start.add(const Duration(minutes: 10))),
      const Duration(minutes: 20),
    );
    expect(
      session.remainingAt(start.add(const Duration(hours: 1))),
      Duration.zero,
    );
  });

  test('serializes with UTC epoch milliseconds and round trips', () {
    final session = DetoxSession(
      id: 'one',
      startedAt: start.toLocal(),
      endsAt: start.add(const Duration(minutes: 30)).toLocal(),
      blockedPackageNames: {'b.app', 'a.app'},
    );
    expect(session.toMap()['startedAtEpochMs'], start.millisecondsSinceEpoch);
    expect(DetoxSession.fromMap(session.toMap()), session);
  });

  test('rejects end-before-start input', () {
    expect(
      () => DetoxSession(
        id: 'one',
        startedAt: start,
        endsAt: start,
        blockedPackageNames: {'example.app'},
      ),
      throwsArgumentError,
    );
  });

  test('copies and exposes an immutable package set', () {
    final packages = {'example.app'};
    final session = DetoxSession(
      id: 'one',
      startedAt: start,
      endsAt: start.add(const Duration(minutes: 5)),
      blockedPackageNames: packages,
    );
    packages.add('later.app');
    expect(session.blockedPackageNames, {'example.app'});
    expect(
      () => session.blockedPackageNames.add('nope'),
      throwsUnsupportedError,
    );
  });
}
