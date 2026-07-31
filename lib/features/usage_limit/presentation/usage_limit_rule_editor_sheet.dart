import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../detox/presentation/accessibility_disclosure_screen.dart';
import '../../launcher/domain/launchable_app.dart';
import '../../detox/presentation/detox_controller.dart';
import '../domain/usage_limit_rule.dart';
import 'usage_limit_controller.dart';

Future<void> showUsageLimitRuleEditor(
  BuildContext context,
  WidgetRef ref,
  LaunchableApp app,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _UsageLimitRuleEditor(app: app),
);

class _UsageLimitRuleEditor extends ConsumerStatefulWidget {
  const _UsageLimitRuleEditor({required this.app});
  final LaunchableApp app;

  @override
  ConsumerState<_UsageLimitRuleEditor> createState() =>
      _UsageLimitRuleEditorState();
}

class _UsageLimitRuleEditorState extends ConsumerState<_UsageLimitRuleEditor> {
  late int _minutes;
  late bool _enabled;
  bool _acknowledged = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = ref
        .read(usageLimitControllerProvider)
        .rules[widget.app.packageName];
    _enabled = existing != null;
    _minutes = existing?.limitMinutes ?? UsageLimitRule.defaultMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.usageLimitEditorTitle(widget.app.label),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(l10n.usageLimitWarning),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.usageLimitAcknowledge),
              value: _acknowledged,
              onChanged: (value) => setState(() {
                _acknowledged = value ?? false;
              }),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.usageLimitEnabledTitle),
              value: _enabled,
              onChanged: _acknowledged
                  ? (value) => setState(() => _enabled = value)
                  : null,
            ),
            if (_enabled)
              Wrap(
                spacing: 8,
                children: UsageLimitRule.supportedMinutes
                    .map(
                      (minutes) => ChoiceChip(
                        label: Text(l10n.usageLimitMinutes(minutes)),
                        selected: _minutes == minutes,
                        onSelected: (_) => setState(() => _minutes = minutes),
                      ),
                    )
                    .toList(growable: false),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: !_acknowledged || _saving ? null : _save,
              child: Text(l10n.usageLimitSave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final controller = ref.read(usageLimitControllerProvider.notifier);
    try {
      if (!_enabled) {
        await controller.removeRule(widget.app.packageName);
      } else {
        final state = ref.read(usageLimitControllerProvider);
        var enableGlobally = false;
        if (!state.enabled) {
          if ((ref.read(detoxControllerProvider).acceptedDisclosureVersion ??
                  0) <
              3) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).usageLimitDisclosureRequired,
                  ),
                  action: SnackBarAction(
                    label: AppLocalizations.of(
                      context,
                    ).detoxReviewBlockingAccessAction,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AccessibilityDisclosureScreen(),
                      ),
                    ),
                  ),
                ),
              );
            }
            return;
          }
          if (!mounted) return;
          enableGlobally =
              await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(AppLocalizations.of(context).usageLimitTitle),
                  content: Text(
                    AppLocalizations.of(context).usageLimitEnablePrompt,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text(
                        AppLocalizations.of(context).usageLimitNotNow,
                      ),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(
                        AppLocalizations.of(context).usageLimitEnableAndSave,
                      ),
                    ),
                  ],
                ),
              ) ??
              false;
          if (!enableGlobally) return;
        }
        await controller.setRule(
          UsageLimitRule(
            packageName: widget.app.packageName,
            limitMinutes: _minutes,
          ),
          enableGloballyIfNeeded: enableGlobally,
        );
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
