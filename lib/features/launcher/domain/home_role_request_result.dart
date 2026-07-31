enum HomeRoleRequestResult {
  granted,
  denied,
  cancelled,
  alreadyHeld,
  openedSettings,
  unavailable;

  static HomeRoleRequestResult fromNative(Object? value) => switch (value) {
    'granted' => HomeRoleRequestResult.granted,
    'denied' => HomeRoleRequestResult.denied,
    'cancelled' => HomeRoleRequestResult.cancelled,
    'alreadyHeld' => HomeRoleRequestResult.alreadyHeld,
    'openedSettings' => HomeRoleRequestResult.openedSettings,
    'unavailable' => HomeRoleRequestResult.unavailable,
    _ => throw FormatException(
      'Unknown native Home-role request result: $value',
    ),
  };
}
