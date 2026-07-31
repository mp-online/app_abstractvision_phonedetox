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

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hiddenApps = ref.watch(launcherControllerProvider).hiddenApps;
    final jailBreak = ref.watch(jailBreakControllerProvider);
    final mindful = ref.watch(mindfulOpeningControllerProvider);
    final detox = ref.watch(detoxControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
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
              (detox.acceptedDisclosureVersion ?? 0) <
                  DetoxController.accessibilityDisclosureVersion) ...[
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
