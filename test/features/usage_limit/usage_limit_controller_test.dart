import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_detox/features/detox/domain/accessibility_status.dart';
import 'package:phone_detox/features/detox/presentation/detox_controller.dart';
import 'package:phone_detox/features/detox/presentation/detox_state.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_preferences_repository.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_reached.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_repository.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_rule.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_runtime.dart';
import 'package:phone_detox/features/usage_limit/domain/usage_limit_status.dart';
import 'package:phone_detox/features/usage_limit/presentation/usage_limit_controller.dart';

class _Preferences implements UsageLimitPreferencesRepository {
  bool enabled = false;
  Map<String, UsageLimitRule> rules = {};
  @override
  Future<bool> getEnabled() async => enabled;
  @override
  Future<Map<String, UsageLimitRule>> getRules() async => Map.of(rules);
  @override
  Future<void> setEnabled(bool value) async => enabled = value;
  @override
  Future<void> setRules(Map<String, UsageLimitRule> value) async {
    rules = Map.of(value);
  }
}

class _Repository implements UsageLimitRepository {
  bool? synchronizedEnabled;
  int clearAllCount = 0;
  @override
  Future<void> synchronizeRules({
    required bool enabled,
    required int disclosureVersion,
    required Iterable<UsageLimitRule> rules,
  }) async {
    synchronizedEnabled = enabled;
  }

  @override
  Future<UsageLimitRuntime?> getRuntime() async => null;
  @override
  Future<UsageLimitReached?> getReachedLimit() async => null;
  @override
  Future<void> clearAllEnforcement() async => clearAllCount++;
  @override
  Future<void> clearReachedLimit() async {}
  @override
  Future<void> clearRuntime() async {}
  @override
  Future<void> continueUsage(String packageName) async {}
  @override
  Future<void> restoreReachedLimit(UsageLimitReached reached) async {}
}

class _DisclosureThreeDetoxController extends DetoxController {
  @override
  DetoxState build() => DetoxState(
    status: DetoxStatus.ready,
    accessibilityStatus: AccessibilityStatus.enabled,
    acceptedDisclosureVersion: 3,
  );
}

void main() {
  late _Preferences preferences;
  late _Repository repository;
  late ProviderContainer container;

  setUp(() async {
    preferences = _Preferences();
    repository = _Repository();
    container = ProviderContainer(
      overrides: [
        usageLimitPreferencesRepositoryProvider.overrideWithValue(preferences),
        usageLimitRepositoryProvider.overrideWithValue(repository),
        detoxControllerProvider.overrideWith(
          _DisclosureThreeDetoxController.new,
        ),
      ],
    );
    await container.read(usageLimitControllerProvider.notifier).refresh();
  });

  tearDown(() => container.dispose());

  test(
    'defaults off and requires explicit global enablement for a rule',
    () async {
      expect(
        container.read(usageLimitControllerProvider).status,
        UsageLimitStatus.disabled,
      );
      final rule = UsageLimitRule(packageName: 'social.app', limitMinutes: 15);
      expect(
        () =>
            container.read(usageLimitControllerProvider.notifier).setRule(rule),
        throwsA(isA<UsageLimitEnablementRequired>()),
      );
      await container
          .read(usageLimitControllerProvider.notifier)
          .setRule(rule, enableGloballyIfNeeded: true);
      expect(preferences.enabled, isTrue);
      expect(preferences.rules['social.app'], rule);
      expect(repository.synchronizedEnabled, isTrue);
    },
  );

  test(
    'Jail Break preserves rules while clearing active enforcement',
    () async {
      final rule = UsageLimitRule(packageName: 'social.app', limitMinutes: 10);
      await container
          .read(usageLimitControllerProvider.notifier)
          .setRule(rule, enableGloballyIfNeeded: true);
      await container
          .read(usageLimitControllerProvider.notifier)
          .clearForJailBreak();
      expect(repository.clearAllCount, 1);
      expect(
        container.read(usageLimitControllerProvider).rules,
        contains('social.app'),
      );
    },
  );
}
