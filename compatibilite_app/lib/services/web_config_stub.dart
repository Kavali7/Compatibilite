/// Stub implementation for non-web platforms
/// This file is used when the app runs on iOS, Android, etc.

String getWebConfigValue(String key) {
  // On non-web platforms, we don't have window.flutterConfig
  // Return empty string to fallback to dotenv
  return '';
}
