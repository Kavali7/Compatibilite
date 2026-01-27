/// Stub for kkiapay_flutter_sdk on web
/// This file is imported conditionally on web to avoid importing the WebView-based SDK
library;

import 'package:flutter/material.dart';

// Stub constants matching the real SDK
const String PAYMENT_SUCCESS = 'SUCCESS';
const String PAYMENT_CANCELLED = 'CANCELLED';
const String PENDING_PAYMENT = 'PENDING';
const String PAYMENT_INIT = 'INIT';
const String PAYMENT_FAILED = 'FAILED';

/// Stub widget - never actually used on web since we use JS SDK
/// But it needs to be a valid Widget for the compiler
class KKiaPay extends StatelessWidget {
  final int amount;
  final List<String> countries;
  final String phone;
  final String name;
  final String email;
  final String reason;
  final bool sandbox;
  final String apikey;
  final void Function(Map<String, dynamic>, Object?) callback;
  final String? theme;
  final List<String>? paymentMethods;

  const KKiaPay({
    super.key,
    required this.amount,
    required this.countries,
    required this.phone,
    required this.name,
    required this.email,
    required this.reason,
    required this.sandbox,
    required this.apikey,
    required this.callback,
    this.theme,
    this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
    // This should never be called on web - we use JS SDK instead
    return const Center(
      child: Text('Kkiapay non disponible sur cette plateforme'),
    );
  }
}

