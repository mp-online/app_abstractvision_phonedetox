import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class JailBreakCompletedScreen extends StatelessWidget {
  const JailBreakCompletedScreen({
    required this.onOpenHome,
    required this.onUseAgain,
    super.key,
  });

  final Future<void> Function() onOpenHome;
  final VoidCallback onUseAgain;

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
                  const Icon(Icons.lock_open_rounded, size: 64),
                  const SizedBox(height: 24),
                  Text(
                    l10n.jailBreakCompletedTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.jailBreakCompletedBody,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await onOpenHome();
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.jailBreakOpenHomeFailed),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(l10n.jailBreakOpenHomeAction),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onUseAgain,
                    child: Text(l10n.jailBreakUseAgainAction),
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
