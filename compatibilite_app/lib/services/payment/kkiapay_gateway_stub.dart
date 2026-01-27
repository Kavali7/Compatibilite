/// Stub for kkiapay_flutter_sdk on web
/// This file is imported conditionally on web to avoid importing the WebView-based SDK
library;

// Stub constants matching the real SDK
const String PAYMENT_SUCCESS = 'SUCCESS';
const String PAYMENT_CANCELLED = 'CANCELLED';
const String PENDING_PAYMENT = 'PENDING';
const String PAYMENT_INIT = 'INIT';
const String PAYMENT_FAILED = 'FAILED';

/// Stub widget - never actually used on web since we use JS SDK
class KKiaPay {
  KKiaPay({
    required int amount,
    required List<String> countries,
    required String phone,
    required String name,
    required String email,
    required String reason,
    required bool sandbox,
    required String apikey,
    required void Function(Map<String, dynamic>, Object?) callback,
    String? theme,
    List<String>? paymentMethods,
  });
}
