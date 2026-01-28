/// Kkiapay JavaScript SDK Interop for Web
/// This file provides the interface to call Kkiapay's JavaScript SDK directly
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';

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

/// Check if Kkiapay SDK is loaded
bool _isKkiapayLoaded() {
  try {
    final global = globalContext;
    final openWidget = global['openKkiapayWidget'];
    final addListener = global['addSuccessListener'];
    return openWidget != null && addListener != null;
  } catch (e) {
    debugPrint('🔴 Error checking Kkiapay SDK: $e');
    return false;
  }
}

/// Dart-friendly wrapper for Kkiapay JavaScript SDK
class KkiapayJsInterop {
  KkiapayJsInterop._();
  static final KkiapayJsInterop instance = KkiapayJsInterop._();
  
  /// Current callback for payment result
  void Function(bool success, String? transactionId, String? error)? _currentCallback;
  
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
    // Check if SDK is loaded
    if (!_isKkiapayLoaded()) {
      debugPrint('🔴 Kkiapay SDK not loaded yet!');
      callback(false, null, 'Le SDK Kkiapay n\'est pas chargé. Veuillez rafraîchir la page.');
      return;
    }
    
    _currentCallback = callback;
    
    // Create success handler - called only when Kkiapay confirms payment success
    final successHandler = ((KkiapayResponse response) {
      debugPrint('✅ Kkiapay success callback received');
      final transactionId = response.transactionId;
      if (transactionId != null && transactionId.isNotEmpty) {
        _currentCallback?.call(true, transactionId, null);
      } else {
        _currentCallback?.call(false, null, 'Transaction ID manquant');
      }
      _currentCallback = null; // Cleanup
    }).toJS;
    
    // Register success listener only (the only reliable event from Kkiapay)
    try {
      _addSuccessListener(successHandler);
      debugPrint('✅ Kkiapay success listener registered');
    } catch (e) {
      debugPrint('🔴 Error adding success listener: $e');
      callback(false, null, 'Erreur SDK Kkiapay: $e');
      return;
    }
    
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
    try {
      _openKkiapayWidget(config.jsify() as JSObject);
      debugPrint('✅ Kkiapay widget opened');
    } catch (e) {
      debugPrint('🔴 Error opening Kkiapay widget: $e');
      callback(false, null, 'Erreur ouverture widget: $e');
    }
  }
}

