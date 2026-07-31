import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../domain/mindful_launch_source.dart';
import '../domain/mindful_opening_mode.dart';
import 'mindful_opening_controller.dart';

class MindfulOpeningScreen extends ConsumerStatefulWidget {
  const MindfulOpeningScreen({super.key});
  @override
  ConsumerState<MindfulOpeningScreen> createState() =>
      _MindfulOpeningScreenState();
}

class _MindfulOpeningScreenState extends ConsumerState<MindfulOpeningScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mindfulOpeningControllerProvider);
    final request = state.pendingRequest;
    final l10n = AppLocalizations.of(context);
    if (request == null) return const SizedBox.shrink();
    if (request.isExpiredAt(_now)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mindfulOpeningControllerProvider.notifier).goBack();
      });
    }
    LaunchableApp? app;
    for (final candidate in ref.watch(launcherControllerProvider).apps) {
      if (candidate.packageName == request.packageName) {
        app = candidate;
        break;
      }
    }
    final remaining = request.remainingDelayAt(_now);
    final seconds = remaining.inMilliseconds == 0
        ? 0
        : (remaining.inMilliseconds / 1000).ceil();
    return Scaffold(
      appBar: AppBar(
        title: Text(app?.label ?? request.packageName),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.hourglass_bottom_rounded, size: 56),
            const SizedBox(height: 20),
            Text(
              l10n.mindfulTakeBreath,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              request.source == MindfulLaunchSource.external
                  ? l10n.mindfulExternalExplanation
                  : l10n.mindfulDirectExplanation,
              textAlign: TextAlign.center,
            ),
            if (request.mode == MindfulOpeningMode.pauseAndIntention) ...[
              const SizedBox(height: 24),
              Text(
                l10n.mindfulWhyQuestion,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in <(String, String)>[
                    ('reply', l10n.mindfulIntentionReply),
                    ('task', l10n.mindfulIntentionTask),
                    ('search', l10n.mindfulIntentionSearch),
                    ('create', l10n.mindfulIntentionCreate),
                    ('other', l10n.mindfulIntentionOther),
                  ])
                    ChoiceChip(
                      label: Text(option.$2),
                      selected: state.selectedIntention == option.$1,
                      onSelected: (_) => ref
                          .read(mindfulOpeningControllerProvider.notifier)
                          .selectIntention(option.$1),
                    ),
                ],
              ),
              if (state.selectedIntention == 'other')
                TextField(
                  key: const Key('mindful_other_text'),
                  decoration: InputDecoration(
                    labelText: l10n.mindfulOtherLabel,
                  ),
                  onChanged: ref
                      .read(mindfulOpeningControllerProvider.notifier)
                      .setCustomIntention,
                ),
            ],
            const SizedBox(height: 24),
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.mindfulSecondsRemaining(seconds),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              key: const Key('mindful_go_back'),
              onPressed: ref
                  .read(mindfulOpeningControllerProvider.notifier)
                  .goBack,
              child: Text(l10n.mindfulGoBack),
            ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('mindful_open_intentionally'),
              onPressed: app != null && state.canContinueAt(_now)
                  ? () async {
                      try {
                        await ref
                            .read(mindfulOpeningControllerProvider.notifier)
                            .openIntentionally(app!, now: _now);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.launchFailed)),
                          );
                        }
                      }
                    }
                  : null,
              child: Text(l10n.mindfulOpenIntentionally),
            ),
            if (app == null) ...[
              const SizedBox(height: 12),
              Text(l10n.mindfulAppUnavailable, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
