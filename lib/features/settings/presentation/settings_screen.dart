import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../detox/domain/accessibility_status.dart';
import '../../detox/presentation/detox_controller.dart';
import '../../jail_break/presentation/jail_break_controller.dart';
import '../../jail_break/presentation/jail_break_dialog.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../../mindful_opening/presentation/mindful_apps_screen.dart';
import '../../mindful_opening/presentation/mindful_opening_controller.dart';
import '../../usage_limit/presentation/usage_limit_controller.dart';
import '../../usage_limit/presentation/usage_limits_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hiddenApps = ref.watch(launcherControllerProvider).hiddenApps;
    final jailBreak = ref.watch(jailBreakControllerProvider);
    final mindful = ref.watch(mindfulOpeningControllerProvider);
    final usage = ref.watch(usageLimitControllerProvider);
    final detox = ref.watch(detoxControllerProvider);
    final activeBlock = detox.activeSession;
    final mindfulModeStatus = !mindful.enabled
        ? l10n.settingsMindfulDisabled
        : mindful.rules.isEmpty
        ? l10n.settingsMindfulNoApps
        : l10n.settingsMindfulEnabledCount(mindful.rules.length);
    final temporaryBlockStatus = activeBlock == null || !activeBlock.isActive
        ? l10n.settingsTemporaryBlockInactive
        : l10n.settingsTemporaryBlockActive(
            activeBlock.blockedPackageNames.length,
            MaterialLocalizations.of(context).formatTimeOfDay(
              TimeOfDay.fromDateTime(activeBlock.endsAt.toLocal()),
            ),
          );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.settingsHowItWorksTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _ModeExplanationCard(
            icon: Icons.hourglass_bottom_rounded,
            title: l10n.mindfulSettingsTitle,
            description: l10n.settingsMindfulDefinition,
            status: mindfulModeStatus,
          ),
          const SizedBox(height: 8),
          _ModeExplanationCard(
            icon: Icons.block,
            title: l10n.detoxTitle,
            description: l10n.settingsTemporaryBlockDefinition,
            status: temporaryBlockStatus,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.mindfulSettingsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.mindfulSettingsDescription),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.mindfulEnabledTitle),
            value: mindful.enabled,
            onChanged: ref
                .read(mindfulOpeningControllerProvider.notifier)
                .setEnabled,
          ),
          Text(
            mindful.enabled
                ? l10n.mindfulEnabledStatus
                : l10n.mindfulDisabledStatus,
          ),
          Text(l10n.mindfulConfiguredCount(mindful.rules.length)),
          if (detox.accessibilityStatus != AccessibilityStatus.enabled ||
              (detox.acceptedDisclosureVersion ?? 0) < 2) ...[
            const SizedBox(height: 8),
            Text(l10n.mindfulPartialCoverageWarning),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MindfulAppsScreen(),
                ),
              ),
              child: Text(l10n.mindfulManageApps),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.usageLimitTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.usageLimitDescription),
          Text(
            usage.enabled
                ? l10n.usageLimitConfiguredCount(usage.rules.length)
                : l10n.usageLimitDisabledStatus,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const UsageLimitsScreen(),
                ),
              ),
              child: Text(l10n.usageLimitManageApps),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.hiddenAppsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.hiddenAppsDescription),
          const SizedBox(height: 16),
          if (hiddenApps.isEmpty)
            Text(l10n.hiddenAppsEmpty)
          else
            for (final app in hiddenApps)
              ListTile(
                title: Text(app.label),
                subtitle: Text(app.packageName),
                trailing: TextButton(
                  onPressed: () => ref
                      .read(launcherControllerProvider.notifier)
                      .restore(app),
                  child: Text(l10n.restoreAction),
                ),
              ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          GestureDetector(
            key: const Key('settings_jail_break_button'),
            onTap: jailBreak.isProcessing
                ? null
                : () => showJailBreakDialog(context, ref),
            child: Text(
              l10n.jailBreakSettingsSectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.jailBreakSettingsDescription),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: jailBreak.isProcessing
                  ? null
                  : () => showJailBreakDialog(context, ref),
              icon: const Icon(Icons.lock_open_rounded),
              label: Text(l10n.jailBreakTooltip),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeExplanationCard extends StatelessWidget {
  const _ModeExplanationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String description;
  final String status;

  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(description),
                const SizedBox(height: 8),
                Text(status, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
