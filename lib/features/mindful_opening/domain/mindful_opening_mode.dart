enum MindfulOpeningMode {
  disabled,
  pause,
  pauseAndIntention;

  String get wireValue => name;

  static MindfulOpeningMode fromWire(Object? value) => switch (value) {
    'disabled' => disabled,
    'pause' => pause,
    'pauseAndIntention' => pauseAndIntention,
    _ => throw FormatException('Unsupported Mindful Opening mode: $value'),
  };
}
