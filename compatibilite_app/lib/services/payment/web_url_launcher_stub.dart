/// Stub implementation for non-web platforms
/// This file is used when the app runs on iOS, Android, etc.

bool openUrlInPopup(String url, {String windowName = 'FedaPayPayment'}) {
  // On non-web platforms, we can't open popups
  // Return false to use fallback behavior
  return false;
}
