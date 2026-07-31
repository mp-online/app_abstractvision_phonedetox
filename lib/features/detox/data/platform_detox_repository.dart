import 'package:flutter/services.dart';

import '../domain/accessibility_status.dart';
import '../domain/detox_repository.dart';
import '../domain/detox_session.dart';

class PlatformDetoxRepository implements DetoxRepository {
  PlatformDetoxRepository({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'com.abstractvision.phonedetox/detox';
  final MethodChannel _channel;

  @override
  Future<AccessibilityStatus> getAccessibilityStatus() async {
    final value = await _channel.invokeMethod<Object?>(
      'getAccessibilityStatus',
    );
    return switch (value) {
      'enabled' => AccessibilityStatus.enabled,
      'disabled' => AccessibilityStatus.disabled,
      'unavailable' => AccessibilityStatus.unavailable,
      _ => throw const FormatException('Invalid Accessibility status.'),
    };
  }

  @override
  Future<void> openAccessibilitySettings() =>
      _channel.invokeMethod<void>('openAccessibilitySettings');

  @override
  Future<void> startSession(DetoxSession session) =>
      _channel.invokeMethod<void>('startDetoxSession', session.toMap());

  @override
  Future<void> stopSession() => _channel.invokeMethod<void>('stopDetoxSession');

  @override
  Future<DetoxSession?> getNativeActiveSession() async {
    final value = await _channel.invokeMethod<Object?>('getActiveDetoxSession');
    if (value == null) return null;
    if (value is! Map<Object?, Object?>) {
      throw const FormatException('Invalid native detox session.');
    }
    return DetoxSession.fromMap(value);
  }
}
