import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../jail_break/domain/jail_break_state.dart';
import '../../jail_break/presentation/jail_break_completed_screen.dart';
import '../../jail_break/presentation/jail_break_controller.dart';
import '../../launcher/presentation/launcher_screen.dart';
import '../domain/startup_status.dart';
import 'launcher_activation_screen.dart';
import 'launcher_role_lost_screen.dart';
import 'startup_controller.dart';

class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({super.key});

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(startupControllerProvider.notifier).refreshOnResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(jailBreakControllerProvider, (previous, next) {
      if (previous?.status != JailBreakStatus.cancelled &&
          next.status == JailBreakStatus.cancelled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).jailBreakCancelledMessage,
              ),
            ),
          );
          ref.read(jailBreakControllerProvider.notifier).reset();
        });
      }
    });

    final state = ref.watch(startupControllerProvider);
    final controller = ref.read(startupControllerProvider.notifier);
    final jailBreakController = ref.read(jailBreakControllerProvider.notifier);
    return switch (state.status) {
      StartupStatus.loading => const _LoadingScreen(),
      StartupStatus.activationRequired => LauncherActivationScreen(
        requesting: false,
        lastResult: state.lastRequestResult,
        onRequest: controller.requestHomeRole,
        onOpenSettings: controller.openHomeSettings,
      ),
      StartupStatus.requestingHomeRole =>
        state.hasPreviouslyCompletedActivation
            ? LauncherRoleLostScreen(
                requesting: true,
                onRestore: controller.requestHomeRole,
                onOpenSettings: controller.openHomeSettings,
              )
            : LauncherActivationScreen(
                requesting: true,
                onRequest: controller.requestHomeRole,
                onOpenSettings: controller.openHomeSettings,
              ),
      StartupStatus.ready => const LauncherScreen(),
      StartupStatus.roleLost => LauncherRoleLostScreen(
        requesting: false,
        onRestore: controller.requestHomeRole,
        onOpenSettings: controller.openHomeSettings,
      ),
      StartupStatus.jailBreakCompleted => JailBreakCompletedScreen(
        onOpenHome: jailBreakController.openCurrentHome,
        onUseAgain: controller.usePhoneDetoxAgain,
      ),
      StartupStatus.jailBreakFailure => _JailBreakFailureScreen(
        onRetry: controller.retryJailBreakRoleCheck,
        onOpenSettings: jailBreakController.openHomeSettingsAnyway,
      ),
      StartupStatus.unavailable => _MessageScreen(
        icon: Icons.phonelink_erase_outlined,
        title: AppLocalizations.of(context).startupHomeRoleUnavailableTitle,
        body: AppLocalizations.of(context).startupHomeRoleUnavailable,
        action: AppLocalizations.of(context).startupOpenHomeSettingsAction,
        onAction: controller.openHomeSettings,
      ),
      StartupStatus.error => _MessageScreen(
        icon: Icons.error_outline,
        title: AppLocalizations.of(context).startupFailureTitle,
        body: AppLocalizations.of(context).startupFailureMessage,
        action: AppLocalizations.of(context).retryAction,
        onAction: controller.initialize,
      ),
    };
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).startupLoading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _JailBreakFailureScreen extends StatelessWidget {
  const _JailBreakFailureScreen({
    required this.onRetry,
    required this.onOpenSettings,
  });

  final VoidCallback onRetry;
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
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 24),
                  Text(
                    l10n.jailBreakFailureTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.jailBreakFailureBody, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onOpenSettings,
                    child: Text(l10n.jailBreakOpenHomeSettingsAction),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onRetry,
                    child: Text(l10n.jailBreakRetryAction),
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

class _MessageScreen extends StatelessWidget {
  const _MessageScreen({
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(icon, size: 64),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(body, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(onPressed: onAction, child: Text(action)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
