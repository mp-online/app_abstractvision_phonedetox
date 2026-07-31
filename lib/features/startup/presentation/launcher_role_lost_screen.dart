import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class LauncherRoleLostScreen extends StatelessWidget {
  const LauncherRoleLostScreen({
    required this.requesting,
    required this.onRestore,
    required this.onOpenSettings,
    super.key,
  });

  final bool requesting;
  final VoidCallback onRestore;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.home_work_outlined, size: 64),
                  const SizedBox(height: 24),
                  Text(
                    l10n.startupRoleLostTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.startupRoleLostExplanation),
                  if (requesting) ...[
                    const SizedBox(height: 24),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: requesting ? null : onRestore,
                    child: Text(l10n.startupRestoreHomeAction),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: requesting ? null : onOpenSettings,
                    child: Text(l10n.startupOpenHomeSettingsAction),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
