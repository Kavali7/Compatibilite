/// Stub file for non-web platforms (iOS/Android).
/// On mobile, tracking pixels are not available (web-only feature).
class TrackingJsInterop {
  TrackingJsInterop._();
  static final TrackingJsInterop instance = TrackingJsInterop._();

  /// No-op on non-web platforms
  void trackEvent(String eventName, {Map<String, dynamic>? params}) {
    // Pixels are web-only — do nothing on mobile
  }
}
