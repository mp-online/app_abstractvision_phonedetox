import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../launcher/presentation/launcher_controller.dart';
import '../domain/usage_limit_package_policy.dart';
import 'usage_limit_controller.dart';
import 'usage_limit_rule_editor_sheet.dart';

class UsageLimitsScreen extends ConsumerWidget {
  const UsageLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final usage = ref.watch(usageLimitControllerProvider);
    final apps = ref
        .watch(launcherControllerProvider)
        .apps
        .where((app) => UsageLimitPackagePolicy.isConfigurable(app.packageName))
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.usageLimitTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.usageLimitDescription),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.usageLimitEnabledTitle),
            subtitle: Text(
              usage.enabled
                  ? l10n.usageLimitEnabledStatus
                  : l10n.usageLimitDisabledStatus,
            ),
            value: usage.enabled,
            onChanged: (value) async {
              try {
                await ref
                    .read(usageLimitControllerProvider.notifier)
                    .setGlobalEnabled(value);
              } on UsageLimitDisclosureRequired {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.usageLimitDisclosureRequired)),
                  );
                }
              }
            },
          ),
          const Divider(),
          if (apps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(l10n.usageLimitEmpty),
            )
          else
            for (final app in apps)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(app.label),
                subtitle: Text(
                  usage.rules[app.packageName] == null
                      ? l10n.usageLimitOff
                      : l10n.usageLimitMinutes(
                          usage.rules[app.packageName]!.limitMinutes,
                        ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showUsageLimitRuleEditor(context, ref, app),
              ),
        ],
      ),
    );
  }
}
