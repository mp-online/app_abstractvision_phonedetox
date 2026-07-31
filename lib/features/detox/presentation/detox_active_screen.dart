import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import 'detox_controller.dart';
import 'detox_state.dart';

class DetoxActiveScreen extends ConsumerStatefulWidget {
  const DetoxActiveScreen({super.key});

  @override
  ConsumerState<DetoxActiveScreen> createState() => _DetoxActiveScreenState();
}

class _DetoxActiveScreenState extends ConsumerState<DetoxActiveScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _tick() async {
    final session = ref.read(detoxControllerProvider).activeSession;
    if (session == null) return;
    if (!session.isActive) {
      _timer?.cancel();
      await ref.read(detoxControllerProvider.notifier).stopSession();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).detoxSessionComplete),
          ),
        );
      }
    } else if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detoxControllerProvider);
    final session = state.activeSession;
    final l10n = AppLocalizations.of(context);
    if (session == null) return const SizedBox.shrink();
    final remaining = session.remaining;
    final remainingText = _formatRemaining(remaining);
    final endTime = DateFormat.jm(
      Localizations.localeOf(context).toString(),
    ).format(session.endsAt.toLocal());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detoxActiveTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              remainingText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxEndsAt(endTime), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (state.status == DetoxStatus.activeButNotEnforced)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.detoxEnforcementDisabledWarning),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: ref
                          .read(detoxControllerProvider.notifier)
                          .openAccessibilitySettings,
                      child: Text(l10n.detoxOpenAccessibilitySettings),
                    ),
                  ],
                ),
              ),
            ),
          Text(
            l10n.detoxBlockedAppsCount(session.blockedPackageNames.length),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final packageName in session.blockedPackageNames)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.block),
              title: Text(packageName),
            ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _showEndDialog(context),
            child: Text(l10n.detoxEndSessionAction),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showEmergencyDialog(context),
            child: Text(l10n.detoxEmergencyExitAction),
          ),
        ],
      ),
    );
  }

  String _formatRemaining(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _showEndDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).detoxEndSessionTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).detoxEndSessionBody),
          const SizedBox(height: 16),
          HoldToEndButton(
            onComplete: () async {
              Navigator.pop(dialogContext);
              await ref.read(detoxControllerProvider.notifier).stopSession();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    ),
  );

  Future<void> _showEmergencyDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).detoxEmergencyExitTitle),
      content: Text(AppLocalizations.of(context).detoxEmergencyExitBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await ref.read(detoxControllerProvider.notifier).stopSession();
          },
          child: Text(AppLocalizations.of(context).detoxEmergencyExitConfirm),
        ),
      ],
    ),
  );
}

class HoldToEndButton extends StatefulWidget {
  const HoldToEndButton({required this.onComplete, super.key});
  final Future<void> Function() onComplete;

  @override
  State<HoldToEndButton> createState() => _HoldToEndButtonState();
}

class _HoldToEndButtonState extends State<HoldToEndButton> {
  Timer? _timer;
  double _progress = 0;

  void _start() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() => _progress = timer.tick / 30);
      if (timer.tick >= 30) {
        timer.cancel();
        widget.onComplete();
      }
    });
  }

  void _cancel() {
    _timer?.cancel();
    if (mounted) setState(() => _progress = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: AppLocalizations.of(context).detoxHoldToEnd,
    child: Listener(
      onPointerDown: (_) => _start(),
      onPointerUp: (_) => _cancel(),
      onPointerCancel: (_) => _cancel(),
      child: OutlinedButton(
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).detoxHoldToEnd),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: _progress),
          ],
        ),
      ),
    ),
  );
}
