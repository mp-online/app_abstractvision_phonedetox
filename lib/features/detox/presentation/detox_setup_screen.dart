import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.block),
              title: Text(
                l10n.detoxSelectedApps(state.blockedPackageNames.length),
              ),
              subtitle: Text(
                state.blockedPackageNames.isEmpty
                    ? l10n.detoxEmptyList
                    : l10n.detoxManageAppsDescription,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetoxAppSelectionScreen(),
                ),
              ),
            ),
            const Divider(),
            Text(
              l10n.detoxDurationTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 60, 120]
                  .map(
                    (minutes) => ChoiceChip(
                      label: Text(l10n.detoxMinutes(minutes)),
                      selected: state.selectedDurationMinutes == minutes,
                      onSelected: (_) => ref
                          .read(detoxControllerProvider.notifier)
                          .setDurationMinutes(minutes),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: ValueKey(state.selectedDurationMinutes),
              initialValue: state.selectedDurationMinutes.toString(),
              decoration: InputDecoration(
                labelText: l10n.detoxCustomDurationLabel,
                errorText: state.hasValidDuration
                    ? null
                    : l10n.detoxCustomDurationError,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => ref
                  .read(detoxControllerProvider.notifier)
                  .setDurationMinutes(int.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 24),
            Card.outlined(
              child: ListTile(
                leading: Icon(
                  state.accessibilityStatus == AccessibilityStatus.enabled
                      ? Icons.verified_user_outlined
                      : Icons.warning_amber_outlined,
                ),
                title: Text(
                  _accessibilityLabel(l10n, state.accessibilityStatus),
                ),
                subtitle: Text(l10n.detoxAccessibilityExplanation),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccessibilityDisclosureScreen(),
                  ),
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
              icon: const Icon(Icons.timer_outlined),
              label: Text(l10n.detoxStartAction),
            ),
          ],
        ),
      },
    );
  }

  String _accessibilityLabel(
    AppLocalizations l10n,
    AccessibilityStatus status,
  ) => switch (status) {
    AccessibilityStatus.enabled => l10n.detoxAccessibilityEnabled,
    AccessibilityStatus.disabled => l10n.detoxAccessibilityDisabled,
    AccessibilityStatus.unavailable => l10n.detoxAccessibilityUnavailable,
  };
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
