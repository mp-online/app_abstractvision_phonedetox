sealed class JailBreakResult {
  const JailBreakResult();
}

final class JailBreakCompleted extends JailBreakResult {
  const JailBreakCompleted();
}

final class JailBreakCancelled extends JailBreakResult {
  const JailBreakCancelled();
}

final class JailBreakFailed extends JailBreakResult {
  const JailBreakFailed(this.error);

  final Object error;
}
