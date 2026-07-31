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
