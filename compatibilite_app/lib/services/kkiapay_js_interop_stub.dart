/// Stub file for non-web platforms
/// This file is used when not running on web

class KkiapayJsInterop {
  KkiapayJsInterop._();
  static final KkiapayJsInterop instance = KkiapayJsInterop._();
  
  void openPaymentWidget({
    required String apiKey,
    required int amount,
    required bool sandbox,
    required String reason,
    String? phone,
    String? email,
    String? name,
    required void Function(bool success, String? transactionId, String? error) callback,
  }) {
    // This should never be called on non-web platforms
    callback(false, null, 'JavaScript SDK not available on this platform');
  }
}
