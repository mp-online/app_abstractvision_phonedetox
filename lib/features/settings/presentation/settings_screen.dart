import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/presentation/launcher_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hiddenApps = ref.watch(launcherControllerProvider).hiddenApps;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
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
        ],
      ),
    );
  }
}
