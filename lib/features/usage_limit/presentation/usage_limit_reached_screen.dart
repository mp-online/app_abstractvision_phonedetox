import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../launcher/presentation/launcher_controller.dart';
import 'usage_limit_controller.dart';
import 'usage_limit_rule_editor_sheet.dart';

class UsageLimitReachedScreen extends ConsumerStatefulWidget {
  const UsageLimitReachedScreen({super.key});

  @override
  ConsumerState<UsageLimitReachedScreen> createState() =>
      _UsageLimitReachedScreenState();
}

class _UsageLimitReachedScreenState
    extends ConsumerState<UsageLimitReachedScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reached = ref.watch(usageLimitControllerProvider).reached;
    final apps = ref.watch(launcherControllerProvider).apps;
    LaunchableApp? app;
    if (reached != null) {
      for (final candidate in apps) {
        if (candidate.packageName == reached.packageName) app = candidate;
      }
    }
    final label = app?.label ?? reached?.packageName ?? '';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.timer_off_outlined, size: 72),
                  const SizedBox(height: 24),
                  Text(
                    l10n.usageLimitTimeUpTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.usageLimitTimeUpBody(label),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _busy
                        ? null
                        : ref
                              .read(usageLimitControllerProvider.notifier)
                              .stayOut,
                    child: Text(l10n.usageLimitStayOut),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _busy || app == null
                        ? null
                        : () => _continue(app!),
                    child: Text(l10n.usageLimitContinue),
                  ),
                  TextButton(
                    onPressed: _busy || app == null
                        ? null
                        : () => showUsageLimitRuleEditor(context, ref, app!),
                    child: Text(l10n.usageLimitChange),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _continue(LaunchableApp app) async {
    setState(() => _busy = true);
    try {
      await ref.read(usageLimitControllerProvider.notifier).continueUsage(app);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).launchFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
