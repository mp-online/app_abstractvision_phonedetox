import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/domain/home_role_request_result.dart';

class LauncherActivationScreen extends StatelessWidget {
  const LauncherActivationScreen({
    required this.requesting,
    required this.onRequest,
    required this.onOpenSettings,
    this.lastResult,
    super.key,
  });

  final bool requesting;
  final HomeRoleRequestResult? lastResult;
  final VoidCallback onRequest;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.home_outlined, size: 64),
                  const SizedBox(height: 24),
                  Text(
                    l10n.startupActivationTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.startupActivationExplanation),
                  const SizedBox(height: 12),
                  Text(l10n.startupAndroidConfirmationExplanation),
                  const SizedBox(height: 12),
                  Text(l10n.startupReversibleChoiceExplanation),
                  if (requesting) ...[
                    const SizedBox(height: 24),
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 12),
                    Text(
                      l10n.startupWaitingForAndroid,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (lastResult != null) ...[
                    const SizedBox(height: 20),
                    _StatusMessage(result: lastResult!),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: requesting ? null : onRequest,
                    child: Text(l10n.startupChooseHomeAction),
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

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.result});

  final HomeRoleRequestResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (result) {
      HomeRoleRequestResult.cancelled => l10n.startupSelectionCancelled,
      HomeRoleRequestResult.denied => l10n.startupAnotherLauncherSelected,
      HomeRoleRequestResult.openedSettings => l10n.startupSettingsOpened,
      HomeRoleRequestResult.unavailable => l10n.startupHomeRoleUnavailable,
      HomeRoleRequestResult.granted ||
      HomeRoleRequestResult.alreadyHeld => l10n.startupAccessGranted,
    };
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
