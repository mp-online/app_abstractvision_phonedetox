import '../../mindful_opening/domain/mindful_launch_request.dart';

sealed class LaunchDecision {
  const LaunchDecision();
}

final class LaunchAllowed extends LaunchDecision {
  const LaunchAllowed();
}

final class LaunchBlocked extends LaunchDecision {
  const LaunchBlocked({required this.blockedUntil});
  final DateTime blockedUntil;
}

final class LaunchRequiresMindfulOpening extends LaunchDecision {
  const LaunchRequiresMindfulOpening(this.request);
  final MindfulLaunchRequest request;
}
