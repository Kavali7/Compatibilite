import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'supabase_manager.dart';
import 'auth_service.dart';
import 'pricing_service.dart';

/// Payment status constants
class PaymentStatus {
  static const String pending = 'pending';
  static const String success = 'success';
  static const String failed = 'failed';
  static const String cancelled = 'cancelled';
}

/// Represents a payment record
class PaymentRecord {
  PaymentRecord({
    required this.id,
    required this.userId,
    this.sessionId,
    required this.transactionId,
    required this.amountFcfa,
    this.paymentMethod,
    required this.status,
    required this.planType,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? sessionId;
  final String transactionId;
  final int amountFcfa;
  final String? paymentMethod;
  final String status;
  final String planType;
  final DateTime createdAt;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sessionId: json['session_id'] as String?,
      transactionId: json['transaction_id'] as String,
      amountFcfa: json['amount_fcfa'] as int,
      paymentMethod: json['payment_method'] as String?,
      status: json['status'] as String,
      planType: json['plan_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Callback type for payment events
typedef PaymentCallback = void Function(bool success, String? transactionId, String? error);

/// Service to handle Kkiapay payments
class KkiapayService {
  KkiapayService._();
  static final KkiapayService instance = KkiapayService._();

  static const _tablePayments = 'payments';
  static const _tableUserReports = 'user_reports';
  final Uuid _uuid = const Uuid();

  SupabaseClient? get _client =>
      SupabaseManager.isReady ? SupabaseManager.client : null;

  /// Get the Kkiapay public API key from environment
  String get _apiKey {
    final key = dotenv.env['KKIAPAY_PUBLIC_KEY'];
    if (key == null || key.isEmpty) {
      debugPrint('WARNING: KKIAPAY_PUBLIC_KEY not set in .env');
      return '';
    }
    return key;
  }

  /// Check if Kkiapay is configured
  bool get isConfigured => _apiKey.isNotEmpty;

  /// Check if running in sandbox mode
  bool get isSandbox {
    final sandbox = dotenv.env['KKIAPAY_SANDBOX'];
    return sandbox?.toLowerCase() == 'true';
  }

  /// Create Kkiapay payment widget
  KKiaPay createPaymentWidget({
    required int amount,
    required String reason,
    required PaymentCallback callback,
    String? phone,
    String? email,
    String? name,
  }) {
    return KKiaPay(
      amount: amount,
      apikey: _apiKey,
      sandbox: isSandbox,
      phone: phone ?? '',
      name: name ?? '',
      email: email ?? '',
      reason: reason,
      theme: '#9C27B0', // Purple theme matching the app
      countries: ['BJ', 'CI', 'SN', 'TG', 'BF', 'ML', 'NE'],
      paymentMethods: ['momo', 'card'],
      callback: (response, context) {
        _handlePaymentCallback(response, context, callback);
      },
    );
  }

  /// Handle payment callback from Kkiapay
  void _handlePaymentCallback(
    Map<String, dynamic> response,
    BuildContext context,
    PaymentCallback callback,
  ) {
    debugPrint('Kkiapay callback: $response');

    final status = response['status'] as String?;

    switch (status) {
      case PAYMENT_SUCCESS:
        final transactionId = response['transactionId'] as String?;
        Navigator.of(context).pop();
        callback(true, transactionId, null);
        break;

      case PAYMENT_CANCELLED:
        Navigator.of(context).pop();
        callback(false, null, 'Paiement annulé');
        break;

      case PENDING_PAYMENT:
        debugPrint('Payment pending...');
        break;

      case PAYMENT_INIT:
        debugPrint('Payment initialized');
        break;

      default:
        debugPrint('Unknown payment status: $status');
        break;
    }
  }

  /// Start payment flow for mobile
  void startPaymentMobile({
    required BuildContext context,
    required int amount,
    required String reason,
    required PaymentCallback callback,
    String? phone,
    String? email,
    String? name,
  }) {
    if (!isConfigured) {
      callback(false, null, 'Configuration Kkiapay manquante');
      return;
    }

    final widget = createPaymentWidget(
      amount: amount,
      reason: reason,
      callback: callback,
      phone: phone,
      email: email,
      name: name,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  /// Start payment flow for web
  void startPaymentWeb({
    required BuildContext context,
    required int amount,
    required String reason,
    required PaymentCallback callback,
    String? phone,
    String? email,
    String? name,
  }) {
    if (!isConfigured) {
      callback(false, null, 'Configuration Kkiapay manquante');
      return;
    }

    final widget = createPaymentWidget(
      amount: amount,
      reason: reason,
      callback: callback,
      phone: phone,
      email: email,
      name: name,
    );

    KkiapayFlutterSdkPlatform.instance.pay(
      widget,
      context,
      (response, ctx) {
        _handlePaymentCallback(response, ctx, callback);
      },
    );
  }

  /// Start payment (auto-detect platform)
  void startPayment({
    required BuildContext context,
    required int amount,
    required String reason,
    required PaymentCallback callback,
    String? phone,
    String? email,
    String? name,
  }) {
    if (kIsWeb) {
      startPaymentWeb(
        context: context,
        amount: amount,
        reason: reason,
        callback: callback,
        phone: phone,
        email: email,
        name: name,
      );
    } else {
      startPaymentMobile(
        context: context,
        amount: amount,
        reason: reason,
        callback: callback,
        phone: phone,
        email: email,
        name: name,
      );
    }
  }

  /// Record a payment in Supabase
  Future<PaymentRecord?> recordPayment({
    required String userId,
    String? sessionId,
    required String transactionId,
    required int amountFcfa,
    String? paymentMethod,
    required String status,
    required String planType,
  }) async {
    if (_client == null) {
      debugPrint('KkiapayService: Supabase not initialized');
      return null;
    }

    try {
      final paymentId = _uuid.v4();
      final result = await _client!.from(_tablePayments).insert({
        'id': paymentId,
        'user_id': userId,
        'session_id': sessionId,
        'transaction_id': transactionId,
        'amount_fcfa': amountFcfa,
        'payment_method': paymentMethod,
        'status': status,
        'plan_type': planType,
      }).select().single();

      return PaymentRecord.fromJson(result);
    } catch (e) {
      debugPrint('KkiapayService recordPayment error: $e');
      rethrow;
    }
  }

  /// Link a report to a user after payment
  Future<void> linkReportToUser({
    required String userId,
    required String sessionId,
  }) async {
    if (_client == null) return;

    try {
      await _client!.from(_tableUserReports).insert({
        'user_id': userId,
        'session_id': sessionId,
      });
    } catch (e) {
      // Ignore duplicate errors
      if (!e.toString().contains('duplicate') && 
          !e.toString().contains('unique')) {
        debugPrint('KkiapayService linkReportToUser error: $e');
        rethrow;
      }
    }
  }

  /// Get user's purchased reports
  Future<List<String>> getUserReportIds(String userId) async {
    if (_client == null) return [];

    try {
      final result = await _client!
          .from(_tableUserReports)
          .select('session_id')
          .eq('user_id', userId);

      return (result as List)
          .map((r) => r['session_id'] as String)
          .toList();
    } catch (e) {
      debugPrint('KkiapayService getUserReportIds error: $e');
      return [];
    }
  }

  /// Get recent payments (for admin)
  Future<List<PaymentRecord>> getRecentPayments({int limit = 50}) async {
    if (_client == null) return [];

    try {
      final result = await _client!
          .from(_tablePayments)
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (result as List)
          .map((json) => PaymentRecord.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('KkiapayService getRecentPayments error: $e');
      return [];
    }
  }

  /// Process full payment flow with account creation
  Future<bool> processPaymentFlow({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required PricingPlan plan,
    String? sessionId,
    String? phone,
  }) async {
    final completer = ValueNotifier<bool?>(null);

    startPayment(
      context: context,
      amount: plan.priceFcfa,
      reason: plan.isSubscription
          ? 'Abonnement mensuel Compatibilité'
          : 'Rapport de compatibilité',
      email: email,
      name: name,
      phone: phone,
      callback: (success, transactionId, error) async {
        if (!success || transactionId == null) {
          debugPrint('Payment failed: $error');
          completer.value = false;
          return;
        }

        try {
          // Create or sign in user
          final authService = AuthService.instance;
          AppUser? user;

          if (await authService.emailExists(email)) {
            user = await authService.signIn(email: email, password: password);
          } else {
            user = await authService.signUp(
              email: email,
              password: password,
              name: name,
            );
          }

          if (user == null) {
            debugPrint('Failed to create/sign in user');
            completer.value = false;
            return;
          }

          // Record payment
          final payment = await recordPayment(
            userId: user.id,
            sessionId: sessionId,
            transactionId: transactionId,
            amountFcfa: plan.priceFcfa,
            status: PaymentStatus.success,
            planType: plan.planType,
          );

          // If subscription, create subscription record
          if (plan.isSubscription && plan.durationDays != null) {
            await authService.createSubscription(
              userId: user.id,
              planId: plan.id,
              paymentId: payment?.id ?? transactionId,
              durationDays: plan.durationDays!,
            );
          }

          // Link report to user if session exists
          if (sessionId != null) {
            await linkReportToUser(userId: user.id, sessionId: sessionId);
          }

          completer.value = true;
        } catch (e) {
          debugPrint('Payment flow error: $e');
          completer.value = false;
        }
      },
    );

    // Wait for payment completion
    while (completer.value == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return completer.value!;
  }
}
