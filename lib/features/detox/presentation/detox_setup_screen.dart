import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../domain/accessibility_status.dart';
import 'accessibility_disclosure_screen.dart';
import 'detox_app_selection_screen.dart';
import 'detox_controller.dart';
import 'detox_state.dart';

class DetoxSetupScreen extends ConsumerWidget {
  const DetoxSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(detoxControllerProvider);
    final launcher = ref.watch(launcherControllerProvider);
    final selectedApps =
        launcher.apps
            .where((app) => state.blockedPackageNames.contains(app.packageName))
            .toList()
          ..sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
          );
    final l10n = AppLocalizations.of(context);
    final duration = _durationText(l10n, state.selectedDurationMinutes);
    final blockerText = _blockerText(l10n, state.startBlocker);
    final singleAppName = selectedApps.length == 1
        ? selectedApps.single.label
        : state.blockedPackageNames.firstOrNull ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detoxTitle)),
      body: switch (state.status) {
        DetoxStatus.loading => Center(child: Text(l10n.detoxLoading)),
        DetoxStatus.error => _ErrorBody(
          onRetry: ref.read(detoxControllerProvider.notifier).refresh,
        ),
        _ => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _StepHeader(
              title: l10n.detoxChooseAppsStepTitle,
              description: l10n.detoxChooseAppsStepDescription,
            ),
            const SizedBox(height: 12),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.detoxSelectedApps(state.blockedPackageNames.length),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (state.blockedPackageNames.isEmpty) ...[
                      const SizedBox(height: 4),
                      Text(l10n.detoxNoAppsSelectedDescription),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetoxAppSelectionScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.apps_outlined),
                      label: Text(
                        state.blockedPackageNames.isEmpty
                            ? l10n.detoxChooseAppsAction
                            : l10n.detoxChangeSelectionAction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _StepHeader(
              title: l10n.detoxDurationStepTitle,
              description: l10n.detoxDurationStepDescription,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in DetoxController.presetDurationMinutes)
                  ChoiceChip(
                    label: Text(_durationText(l10n, minutes)),
                    selected:
                        !state.usesCustomDuration &&
                        state.selectedDurationMinutes == minutes,
                    onSelected: (_) => ref
                        .read(detoxControllerProvider.notifier)
                        .setPresetDurationMinutes(minutes),
                  ),
                ChoiceChip(
                  label: Text(l10n.detoxCustomDurationOption),
                  selected: state.usesCustomDuration,
                  onSelected: (_) => ref
                      .read(detoxControllerProvider.notifier)
                      .selectCustomDuration(),
                ),
              ],
            ),
            if (state.usesCustomDuration) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('detox_custom_duration_field'),
                initialValue: state.hasValidDuration
                    ? state.selectedDurationMinutes.toString()
                    : '',
                decoration: InputDecoration(
                  labelText: l10n.detoxCustomDurationLabel,
                  helperText: l10n.detoxCustomDurationSupportingText,
                  errorText: state.hasValidDuration
                      ? null
                      : l10n.detoxCustomDurationError,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => ref
                    .read(detoxControllerProvider.notifier)
                    .setCustomDurationMinutes(int.tryParse(value) ?? 0),
              ),
            ],
            const SizedBox(height: 32),
            _StepHeader(
              title: l10n.detoxBlockingAccessStepTitle,
              description:
                  state.accessibilityStatus == AccessibilityStatus.enabled
                  ? l10n.detoxBlockingAccessReadyDescription
                  : l10n.detoxBlockingAccessDisabledDescription,
            ),
            const SizedBox(height: 12),
            Semantics(
              label: state.accessibilityStatus == AccessibilityStatus.enabled
                  ? l10n.detoxBlockingAccessReady
                  : l10n.detoxBlockingAccessDisabled,
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.accessibilityStatus ==
                                    AccessibilityStatus.enabled
                                ? Icons.verified_user_outlined
                                : Icons.warning_amber_outlined,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.accessibilityStatus ==
                                      AccessibilityStatus.enabled
                                  ? l10n.detoxBlockingAccessReady
                                  : l10n.detoxBlockingAccessDisabled,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      if (state.accessibilityStatus !=
                          AccessibilityStatus.enabled) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AccessibilityDisclosureScreen(),
                            ),
                          ),
                          child: Text(l10n.detoxReviewBlockingAccessAction),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.detoxWhatWillHappenTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (state.blockedPackageNames.isEmpty)
                      Text(l10n.detoxWhatWillHappenEmpty)
                    else ...[
                      Text(
                        l10n.detoxWhatWillHappenSummary(
                          state.blockedPackageNames.length,
                          singleAppName,
                          duration,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.detoxWhatWillHappenAvailability),
                      const SizedBox(height: 8),
                      Text(l10n.detoxNotUsageAllowance(duration)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: !state.canStart
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(detoxControllerProvider.notifier)
                            .startSession();
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.detoxStartError)),
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.block),
              label: Text(
                state.blockedPackageNames.isEmpty
                    ? l10n.detoxChooseAppsToContinue
                    : l10n.detoxDynamicStartAction(
                        state.blockedPackageNames.length,
                        singleAppName,
                        duration,
                      ),
              ),
            ),
            if (blockerText != null) ...[
              const SizedBox(height: 8),
              Semantics(
                liveRegion: true,
                label: blockerText,
                child: Text(
                  blockerText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      },
    );
  }

  String _durationText(AppLocalizations l10n, int minutes) =>
      minutes >= 60 && minutes % 60 == 0
      ? l10n.detoxDurationHours(minutes ~/ 60)
      : l10n.detoxDurationMinutes(minutes);

  String? _blockerText(AppLocalizations l10n, DetoxStartBlocker? blocker) =>
      switch (blocker) {
        DetoxStartBlocker.noAppsSelected => l10n.detoxBlockerNoApps,
        DetoxStartBlocker.invalidDuration => l10n.detoxBlockerInvalidDuration,
        DetoxStartBlocker.disclosureRequired => l10n.detoxBlockerDisclosure,
        DetoxStartBlocker.accessibilityDisabled =>
          l10n.detoxBlockerAccessibility,
        DetoxStartBlocker.alreadyActive => l10n.detoxBlockerAlreadyActive,
        DetoxStartBlocker.controllerError => l10n.detoxBlockerControllerError,
        null => null,
      };
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 4),
      Text(description),
    ],
  );
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.detoxLoadError, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.retryAction)),
          ],
        ),
      ),
    );
  }
}
