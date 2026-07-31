import 'accessibility_status.dart';
import 'detox_session.dart';

abstract interface class DetoxRepository {
  Future<AccessibilityStatus> getAccessibilityStatus();
  Future<void> openAccessibilitySettings();
  Future<void> startSession(DetoxSession session);
  Future<void> stopSession();
  Future<DetoxSession?> getNativeActiveSession();
}
