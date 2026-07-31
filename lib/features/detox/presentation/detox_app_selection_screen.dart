import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../launcher/presentation/launcher_controller.dart';
import 'detox_controller.dart';

class DetoxAppSelectionScreen extends ConsumerStatefulWidget {
  const DetoxAppSelectionScreen({super.key});

  @override
  ConsumerState<DetoxAppSelectionScreen> createState() =>
      _DetoxAppSelectionScreenState();
}

class _DetoxAppSelectionScreenState
    extends ConsumerState<DetoxAppSelectionScreen> {
  bool _reconciled = false;

  @override
  Widget build(BuildContext context) {
    final launcher = ref.watch(launcherControllerProvider);
    final detox = ref.watch(detoxControllerProvider);
    final appsByPackage = <String, LaunchableApp>{};
    for (final app in launcher.apps) {
      appsByPackage.putIfAbsent(app.packageName, () => app);
    }
    final apps = appsByPackage.values.toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    if (!_reconciled && launcher.apps.isNotEmpty) {
      _reconciled = true;
      unawaited(
        Future<void>.delayed(
          Duration.zero,
          () => ref
              .read(detoxControllerProvider.notifier)
              .reconcileAvailablePackages(appsByPackage.keys.toSet()),
        ),
      );
    }
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detoxManageAppsTitle)),
      body: apps.isEmpty
          ? Center(child: Text(l10n.detoxNoAppsAvailable))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                final selected = detox.blockedPackageNames.contains(
                  app.packageName,
                );
                return CheckboxListTile(
                  value: selected,
                  title: Text(app.label),
                  subtitle: Text(app.packageName),
                  secondary: Icon(selected ? Icons.block : Icons.apps),
                  onChanged: (_) => ref
                      .read(detoxControllerProvider.notifier)
                      .toggleBlockedPackage(app.packageName),
                );
              },
            ),
    );
  }
}
