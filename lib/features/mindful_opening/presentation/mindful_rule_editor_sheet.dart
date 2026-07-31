import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/domain/launchable_app.dart';
import '../domain/mindful_opening_mode.dart';
import '../domain/mindful_opening_rule.dart';
import 'mindful_opening_controller.dart';

Future<void> showMindfulRuleEditor(
  BuildContext context,
  WidgetRef ref,
  LaunchableApp app,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => MindfulRuleEditorSheet(app: app),
);

class MindfulRuleEditorSheet extends ConsumerStatefulWidget {
  const MindfulRuleEditorSheet({required this.app, super.key});
  final LaunchableApp app;
  @override
  ConsumerState<MindfulRuleEditorSheet> createState() =>
      _MindfulRuleEditorSheetState();
}

class _MindfulRuleEditorSheetState
    extends ConsumerState<MindfulRuleEditorSheet> {
  MindfulOpeningMode _mode = MindfulOpeningMode.disabled;
  int _delay = 10;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_initialized) {
      final rule = ref
          .read(mindfulOpeningControllerProvider)
          .rules[widget.app.packageName];
      _mode = rule?.mode ?? MindfulOpeningMode.disabled;
      _delay = rule?.delaySeconds ?? 10;
      _initialized = true;
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.mindfulRuleTitle(widget.app.label),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SegmentedButton<MindfulOpeningMode>(
                segments: [
                  ButtonSegment(
                    value: MindfulOpeningMode.disabled,
                    label: Text(l10n.mindfulModeOff),
                  ),
                  ButtonSegment(
                    value: MindfulOpeningMode.pause,
                    label: Text(l10n.mindfulModePause),
                  ),
                  ButtonSegment(
                    value: MindfulOpeningMode.pauseAndIntention,
                    label: Text(l10n.mindfulModePauseIntention),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (value) =>
                    setState(() => _mode = value.single),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.mindfulDelayTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (final seconds in MindfulOpeningRule.supportedDelays)
                    ChoiceChip(
                      label: Text(l10n.mindfulDelaySeconds(seconds)),
                      selected: _delay == seconds,
                      onSelected: _mode == MindfulOpeningMode.disabled
                          ? null
                          : (_) => setState(() => _delay = seconds),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  final controller = ref.read(
                    mindfulOpeningControllerProvider.notifier,
                  );
                  if (_mode == MindfulOpeningMode.disabled) {
                    await controller.removeRule(widget.app.packageName);
                  } else {
                    await controller.setRule(
                      MindfulOpeningRule(
                        packageName: widget.app.packageName,
                        mode: _mode,
                        delaySeconds: _delay,
                      ),
                    );
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(l10n.saveAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
