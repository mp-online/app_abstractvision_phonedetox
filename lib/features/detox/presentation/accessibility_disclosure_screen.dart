import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'detox_controller.dart';

class AccessibilityDisclosureScreen extends ConsumerStatefulWidget {
  const AccessibilityDisclosureScreen({super.key});

  @override
  ConsumerState<AccessibilityDisclosureScreen> createState() =>
      _AccessibilityDisclosureScreenState();
}

class _AccessibilityDisclosureScreenState
    extends ConsumerState<AccessibilityDisclosureScreen> {
  bool _understood = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detoxDisclosureTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.detoxDisclosureWhatTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxDisclosureWhatBody),
          const SizedBox(height: 20),
          Text(
            l10n.detoxDisclosureWhyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxDisclosureWhyBody),
          const SizedBox(height: 20),
          Text(
            l10n.detoxDisclosureNotAccessedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxDisclosureNotAccessedBody),
          const SizedBox(height: 20),
          Text(
            l10n.detoxDisclosureDataTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxDisclosureDataBody),
          const SizedBox(height: 20),
          Text(
            l10n.detoxDisclosureControlTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.detoxDisclosureControlBody),
          const SizedBox(height: 20),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _understood,
            title: Text(l10n.detoxDisclosureConsent),
            onChanged: (value) => setState(() => _understood = value ?? false),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: !_understood
                ? null
                : () async {
                    await ref
                        .read(detoxControllerProvider.notifier)
                        .acceptDisclosureAndOpenSettings();
                    if (context.mounted) Navigator.pop(context);
                  },
            child: Text(l10n.continueAction),
          ),
        ],
      ),
    );
  }
}
