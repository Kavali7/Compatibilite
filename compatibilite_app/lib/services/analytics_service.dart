import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';
import 'tracking_js_interop_stub.dart' if (dart.library.html) 'tracking_js_interop.dart';

/// Service de tracking analytics — fire-and-forget.
/// Envoie des événements à Supabase via rpc_log_event sans jamais bloquer l'UI.
/// Pont vers les pixels web (Meta, TikTok, GA4) via TrackingJsInterop.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  /// Tracking pixel bridge (web-only, no-op on mobile)
  final _tracking = TrackingJsInterop.instance;

  /// Log générique — ne lance jamais d'exception.
  Future<void> logEvent(String eventType, {Map<String, dynamic>? metadata}) async {
    try {
      if (!SupabaseManager.isReady) return;
      await SupabaseManager.client.rpc('rpc_log_event', params: {
        'p_event_type': eventType,
        'p_metadata': metadata ?? {},
      });
      debugPrint('Analytics: $eventType logged');
    } catch (e) {
      // Silencieux — ne doit jamais bloquer l'app
      debugPrint('Analytics: failed to log $eventType — $e');
    }
  }

  // ─── Méthodes spécialisées ──────────────────────────────────

  /// Ouverture de l'application
  /// PageView is already sent by the pixel script in index.html on load
  void logAppOpen() {
    logEvent('app_open');
  }

  /// Consultation d'un service
  void logServiceView(String serviceName) {
    logEvent('service_view', metadata: {'service': serviceName});
    // Pixel: ViewContent
    _tracking.trackEvent('ViewContent', params: {
      'content_name': serviceName,
      'content_type': 'service',
    });
  }

  /// Paiement réussi
  void logPaymentSuccess({
    required String transactionId,
    required int amount,
    required String planType,
  }) {
    logEvent('payment_success', metadata: {
      'transaction_id': transactionId,
      'amount': amount,
      'plan_type': planType,
    });
    // Pixel: Purchase
    _tracking.trackEvent('Purchase', params: {
      'value': amount,
      'currency': 'XOF',
      'content_name': planType,
      'transaction_id': transactionId,
    });
  }

  /// Paiement annulé par l'utilisateur
  void logPaymentCancel({String? email, String? phone}) {
    logEvent('payment_cancel', metadata: {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    });
  }

  /// Échec de paiement
  void logPaymentFailure(String error, {String? email, String? phone}) {
    logEvent('payment_failure', metadata: {
      'error': error,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    });
  }

  /// Début de processus de paiement (InitiateCheckout)
  void logPaymentInitiate({required String planType, required int amount}) {
    logEvent('payment_initiate', metadata: {
      'plan_type': planType,
      'amount': amount,
    });
    // Pixel: InitiateCheckout
    _tracking.trackEvent('InitiateCheckout', params: {
      'value': amount,
      'currency': 'XOF',
      'content_name': planType,
    });
  }

  /// Inscription réussie
  void logSignupSuccess(String email) {
    logEvent('signup_success', metadata: {'email': email});
    // Pixel: CompleteRegistration
    _tracking.trackEvent('CompleteRegistration', params: {
      'content_name': 'signup',
    });
  }

  /// Erreur d'inscription
  void logSignupError(String email, String error) {
    logEvent('signup_error', metadata: {
      'email': email,
      'error': error,
    });
  }

  /// Connexion réussie
  void logLoginSuccess(String email) {
    logEvent('login_success', metadata: {'email': email});
  }

  /// Erreur de connexion
  void logLoginError(String email, String error) {
    logEvent('login_error', metadata: {
      'email': email,
      'error': error,
    });
  }
}
