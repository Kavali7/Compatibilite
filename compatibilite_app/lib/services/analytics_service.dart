import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Service de tracking analytics — fire-and-forget.
/// Envoie des événements à Supabase via rpc_log_event sans jamais bloquer l'UI.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

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
  void logAppOpen() {
    logEvent('app_open');
  }

  /// Consultation d'un service
  void logServiceView(String serviceName) {
    logEvent('service_view', metadata: {'service': serviceName});
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

  /// Erreur d'inscription
  void logSignupError(String email, String error) {
    logEvent('signup_error', metadata: {
      'email': email,
      'error': error,
    });
  }

  /// Erreur de connexion
  void logLoginError(String email, String error) {
    logEvent('login_error', metadata: {
      'email': email,
      'error': error,
    });
  }
}
