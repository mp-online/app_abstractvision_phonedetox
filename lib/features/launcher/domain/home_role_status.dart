enum HomeRoleStatus {
  held,
  notHeld,
  unavailable;

  static HomeRoleStatus fromNative(Object? value) => switch (value) {
    'held' => HomeRoleStatus.held,
    'notHeld' => HomeRoleStatus.notHeld,
    'unavailable' => HomeRoleStatus.unavailable,
    _ => throw FormatException('Unknown native Home-role status: $value'),
  };
}
