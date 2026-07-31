enum MindfulLaunchSource {
  launcher,
  external;

  static MindfulLaunchSource fromWire(Object? value) => switch (value) {
    'launcher' => launcher,
    'external' => external,
    _ => throw FormatException('Unsupported Mindful launch source: $value'),
  };
}
