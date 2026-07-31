import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'detox_active_screen.dart';
import 'detox_controller.dart';
import 'detox_setup_screen.dart';
import 'detox_state.dart';

class DetoxScreen extends ConsumerStatefulWidget {
  const DetoxScreen({super.key});

  @override
  ConsumerState<DetoxScreen> createState() => _DetoxScreenState();
}

class _DetoxScreenState extends ConsumerState<DetoxScreen>
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
      ref.read(detoxControllerProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detoxControllerProvider);
    if (state.status == DetoxStatus.activeAndEnforced ||
        state.status == DetoxStatus.activeButNotEnforced) {
      return const DetoxActiveScreen();
    }
    return const DetoxSetupScreen();
  }
}
