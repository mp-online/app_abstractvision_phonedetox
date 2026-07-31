import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/presentation/launcher_controller.dart';
import 'mindful_opening_controller.dart';
import 'mindful_rule_editor_sheet.dart';

class MindfulAppsScreen extends ConsumerWidget {
  const MindfulAppsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mindful = ref.watch(mindfulOpeningControllerProvider);
    final apps = ref.watch(launcherControllerProvider).apps;
    final configured = apps
        .where((app) => mindful.rules.containsKey(app.packageName))
        .toList();
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mindfulManageApps)),
      body: configured.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.mindfulNoConfiguredApps),
              ),
            )
          : ListView(
              children: [
                for (final app in configured)
                  ListTile(
                    title: Text(app.label),
                    subtitle: Text(
                      '${app.packageName}\n${l10n.mindfulRuleSummary(mindful.rules[app.packageName]!.delaySeconds)}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => showMindfulRuleEditor(context, ref, app),
                  ),
              ],
            ),
    );
  }
}
