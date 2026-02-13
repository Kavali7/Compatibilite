/// Tracking Pixels JavaScript Interop for Web
/// Calls window.trackEvent() to send events to Meta Pixel, TikTok Pixel, and GA4
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';

/// Bridge to the global trackEvent() function injected in index.html
class TrackingJsInterop {
  TrackingJsInterop._();
  static final TrackingJsInterop instance = TrackingJsInterop._();

  /// Send a tracking event to all active pixels (Meta, TikTok, GA4)
  /// [eventName] — standardized event name (e.g. 'Purchase', 'ViewContent')
  /// [params] — optional event parameters (e.g. {'value': 500, 'currency': 'XOF'})
  void trackEvent(String eventName, {Map<String, dynamic>? params}) {
    try {
      final global = globalContext;
      final fn = global['trackEvent'];
      if (fn == null) {
        debugPrint('[Tracking] trackEvent not available yet');
        return;
      }

      if (params != null && params.isNotEmpty) {
        (fn as JSFunction).callAsFunction(
          null,
          eventName.toJS,
          params.jsify(),
        );
      } else {
        (fn as JSFunction).callAsFunction(
          null,
          eventName.toJS,
        );
      }

      debugPrint('[Tracking] Event sent: $eventName');
    } catch (e) {
      // Silent — tracking must never crash the app
      debugPrint('[Tracking] Error sending $eventName: $e');
    }
  }
}
