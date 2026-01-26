/// Kkiapay JavaScript SDK Interop for Web
/// This file provides the interface to call Kkiapay's JavaScript SDK directly
library;

import 'dart:js_interop';

/// JavaScript interop for Kkiapay SDK (k.js)
/// Uses the global openKkiapayWidget() and addSuccessListener() functions

/// Payment response from Kkiapay
extension type KkiapayResponse._(JSObject _) implements JSObject {
  external String? get transactionId;
}

/// Open Kkiapay widget with parameters
@JS('openKkiapayWidget')
external void _openKkiapayWidget(JSObject config);

/// Add success listener for payment completion
@JS('addSuccessListener')
external void _addSuccessListener(JSFunction callback);

/// Remove success listener
@JS('removeSuccessListener')
external void _removeSuccessListener(JSFunction callback);

/// Dart-friendly wrapper for Kkiapay JavaScript SDK
class KkiapayJsInterop {
  KkiapayJsInterop._();
  static final KkiapayJsInterop instance = KkiapayJsInterop._();
  
  /// Current callback for payment result
  void Function(bool success, String? transactionId, String? error)? _currentCallback;
  JSFunction? _successHandler;
  
  /// Open Kkiapay payment widget
  /// [apiKey] - Your Kkiapay public API key
  /// [amount] - Amount in FCFA
  /// [sandbox] - Use sandbox mode
  /// [reason] - Payment reason/description
  /// [callback] - Called with (success, transactionId, error)
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
    _currentCallback = callback;
    
    // Create success handler - called only when Kkiapay confirms payment success
    _successHandler = ((KkiapayResponse response) {
      final transactionId = response.transactionId;
      if (transactionId != null && transactionId.isNotEmpty) {
        _currentCallback?.call(true, transactionId, null);
      } else {
        _currentCallback?.call(false, null, 'Transaction ID manquant');
      }
      _cleanup();
    }).toJS;
    
    // Register success listener only (the only reliable event from Kkiapay)
    _addSuccessListener(_successHandler!);
    
    // Build config object
    final config = <String, dynamic>{
      'amount': amount,
      'key': apiKey,
      'sandbox': sandbox,
      'reason': reason,
      'theme': '#9C27B0',
      'countries': ['BJ', 'CI', 'SN', 'TG', 'BF', 'ML', 'NE'],
    };
    
    if (phone != null && phone.isNotEmpty) {
      config['phone'] = phone;
    }
    if (email != null && email.isNotEmpty) {
      config['email'] = email;
    }
    if (name != null && name.isNotEmpty) {
      config['name'] = name;
    }
    
    // Convert to JSObject and open widget
    _openKkiapayWidget(config.jsify() as JSObject);
  }
  
  void _cleanup() {
    // Clean up listeners
    if (_successHandler != null) {
      _removeSuccessListener(_successHandler!);
      _successHandler = null;
    }
    _currentCallback = null;
  }
}
