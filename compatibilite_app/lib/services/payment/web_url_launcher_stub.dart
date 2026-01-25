/// Stub implementation for non-web platforms
/// This file is used when the app runs on iOS, Android, etc.

bool openUrlInPopup(String url, {String windowName = 'FedaPayPayment'}) {
  // On non-web platforms, we can't open popups
  // Return false to use fallback behavior
  return false;
}

/// Stub for closing popup - does nothing on non-web
void closePaymentPopup() {
  // No-op on non-web platforms
}

/// Stub for checking popup status
bool isPopupOpen() {
  return false;
}
