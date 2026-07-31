import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/jail_break_state.dart';
import 'jail_break_controller.dart';

Future<void> showJailBreakDialog(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(jailBreakControllerProvider.notifier);
  if (!controller.beginConfirmation()) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const JailBreakDialog(),
  );
}

class JailBreakDialog extends ConsumerWidget {
  const JailBreakDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jailBreakControllerProvider);
    final controller = ref.read(jailBreakControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final active = state.hadActiveSession;

    Future<void> runAndCloseWhenWaiting(Future<void> Function() action) async {
      await action();
      if (context.mounted &&
          ref.read(jailBreakControllerProvider).status ==
              JailBreakStatus.waitingForSelection) {
        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: Text(
        active ? l10n.jailBreakActiveDialogTitle : l10n.jailBreakDialogTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              active
                  ? l10n.jailBreakActiveDialogBody
                  : l10n.jailBreakDialogBody,
            ),
            if (!active) ...[
              const SizedBox(height: 12),
              Text(l10n.jailBreakPlatformExplanation),
            ],
            if (active) ...[
              const SizedBox(height: 12),
              Text(l10n.jailBreakAccessibilityStillEnabled),
            ],
            if (state.status == JailBreakStatus.endingDetox ||
                state.status == JailBreakStatus.openingHomeSettings) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  state.status == JailBreakStatus.endingDetox
                      ? l10n.jailBreakEndingSession
                      : l10n.jailBreakOpeningSettings,
                ),
              ),
            ],
            if (state.status == JailBreakStatus.error) ...[
              const SizedBox(height: 20),
              Text(
                l10n.jailBreakFailureTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.failureKind == JailBreakFailureKind.detoxCleanup
                    ? l10n.jailBreakActiveCleanupFailureBody
                    : l10n.jailBreakFailureBody,
              ),
            ],
          ],
        ),
      ),
      actions: switch (state.status) {
        JailBreakStatus.confirming => [
          TextButton(
            onPressed: () {
              controller.cancelConfirmation();
              Navigator.of(context).pop();
            },
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => runAndCloseWhenWaiting(controller.confirm),
            child: Text(
              active
                  ? l10n.jailBreakActiveConfirmAction
                  : l10n.jailBreakConfirmAction,
            ),
          ),
        ],
        JailBreakStatus.error => [
          TextButton(
            onPressed: () {
              controller.cancelConfirmation();
              Navigator.of(context).pop();
            },
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          if (state.failureKind == JailBreakFailureKind.detoxCleanup)
            TextButton(
              onPressed: controller.openAccessibilitySettings,
              child: Text(l10n.jailBreakOpenAccessibilityAction),
            ),
          TextButton(
            onPressed: () => runAndCloseWhenWaiting(
              state.failureKind == JailBreakFailureKind.detoxCleanup
                  ? controller.openHomeSettingsAnyway
                  : controller.retryHomeSettings,
            ),
            child: Text(
              state.failureKind == JailBreakFailureKind.detoxCleanup
                  ? l10n.jailBreakOpenSettingsAnywayAction
                  : l10n.jailBreakOpenHomeSettingsAction,
            ),
          ),
          FilledButton(
            onPressed: () => runAndCloseWhenWaiting(
              state.failureKind == JailBreakFailureKind.detoxCleanup
                  ? controller.retryDetoxCleanup
                  : controller.retryHomeSettings,
            ),
            child: Text(l10n.jailBreakRetryAction),
          ),
        ],
        _ => [
          TextButton(onPressed: null, child: Text(l10n.jailBreakConfirmAction)),
        ],
      },
    );
  }
}
