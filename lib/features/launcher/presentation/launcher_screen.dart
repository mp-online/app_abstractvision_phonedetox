import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/clock_header.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../detox/domain/accessibility_status.dart';
import '../../detox/presentation/detox_controller.dart';
import '../../detox/presentation/detox_screen.dart';
import '../domain/launch_decision.dart';
import '../domain/launchable_app.dart';
import 'launcher_controller.dart';
import 'launcher_state.dart';

class LauncherScreen extends ConsumerStatefulWidget {
  const LauncherScreen({super.key});

  @override
  ConsumerState<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends ConsumerState<LauncherScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(launcherControllerProvider);
    final detox = ref.watch(detoxControllerProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: ClockHeader()),
                  IconButton(
                    tooltip: l10n.detoxTooltip,
                    icon: const Icon(Icons.timer_outlined),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DetoxScreen(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.settingsTooltip,
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (detox.accessibilityStatus != AccessibilityStatus.enabled) ...[
                _StrictBlockingCard(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DetoxScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.searchLabel,
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                onChanged: ref
                    .read(launcherControllerProvider.notifier)
                    .setSearchQuery,
              ),
              const SizedBox(height: 12),
              Expanded(child: _LauncherBody(state: state)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrictBlockingCard extends StatelessWidget {
  const _StrictBlockingCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.startupStrictBlockingTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(l10n.startupStrictBlockingExplanation),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton(
                onPressed: onPressed,
                child: Text(l10n.startupStrictBlockingAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LauncherBody extends ConsumerWidget {
  const _LauncherBody({required this.state});

  final LauncherState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    switch (state.status) {
      case LauncherStatus.loading:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(l10n.loadingApps),
            ],
          ),
        );
      case LauncherStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.loadAppsError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: ref
                    .read(launcherControllerProvider.notifier)
                    .refresh,
                child: Text(l10n.retryAction),
              ),
            ],
          ),
        );
      case LauncherStatus.success:
        final apps = state.visibleApps;
        if (apps.isEmpty) {
          return Center(
            child: Text(
              state.apps.isEmpty ? l10n.noApps : l10n.noSearchResults,
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.separated(
          itemCount: apps.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) => _AppTile(app: apps[index]),
        );
    }
  }
}

class _AppTile extends ConsumerWidget {
  const _AppTile({required this.app});

  final LaunchableApp app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(launcherControllerProvider);
    final detox = ref.watch(detoxControllerProvider);
    final isBlocked = detox.blockedPackageNames.contains(app.packageName);
    return ListTile(
      title: Text(app.label, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        app.packageName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isBlocked
          ? const Icon(Icons.block, size: 18)
          : state.favouriteIds.contains(app.id)
          ? const Icon(Icons.star, size: 18)
          : null,
      onTap: () async {
        try {
          final decision = await ref
              .read(launcherControllerProvider.notifier)
              .launch(app);
          if (decision is LaunchBlocked && context.mounted) {
            final endTime = MaterialLocalizations.of(context).formatTimeOfDay(
              TimeOfDay.fromDateTime(decision.blockedUntil.toLocal()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).detoxBlockedUntil(endTime),
                ),
              ),
            );
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).launchFailed),
              ),
            );
          }
        }
      },
      onLongPress: () => _showActions(context, ref),
    );
  }

  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final isFavourite = ref
        .read(launcherControllerProvider)
        .favouriteIds
        .contains(app.id);
    final isBlocked = ref
        .read(detoxControllerProvider)
        .blockedPackageNames
        .contains(app.packageName);
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.appActionsTitle(app.label))),
            ListTile(
              leading: Icon(isFavourite ? Icons.star_border : Icons.star),
              title: Text(
                isFavourite ? l10n.unfavouriteAction : l10n.favouriteAction,
              ),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(launcherControllerProvider.notifier)
                    .toggleFavourite(app);
              },
            ),
            ListTile(
              leading: Icon(
                isBlocked ? Icons.remove_circle_outline : Icons.block,
              ),
              title: Text(
                isBlocked ? l10n.detoxRemoveAction : l10n.detoxAddAction,
              ),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(detoxControllerProvider.notifier)
                    .toggleBlockedPackage(app.packageName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(l10n.hideAction),
              onTap: () {
                Navigator.pop(context);
                ref.read(launcherControllerProvider.notifier).hide(app);
              },
            ),
          ],
        ),
      ),
    );
  }
}
