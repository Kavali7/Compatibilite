import 'package:flutter/foundation.dart';
import 'supabase_manager.dart';

/// Supported currencies for display
enum Currency { FCFA, EUR, USD }

/// Service to manage currency display and conversion
/// Note: All payments are processed in FCFA, this only affects display
class CurrencyService {
  static CurrencyService? _instance;
  static CurrencyService get instance => _instance ??= CurrencyService._();
  
  CurrencyService._();
  
  // Current active currency for display
  Currency _currency = Currency.FCFA;
  Currency get currency => _currency;
  
  // Conversion rates (1 FCFA = X other currency)
  // EUR: Fixed peg rate (1 EUR = 655.957 FCFA officially)
  // USD: Approximate market rate (1 USD ≈ 615 FCFA as of 2026)
  static const Map<Currency, double> _ratesFromFcfa = {
    Currency.FCFA: 1.0,
    Currency.EUR: 0.001524,  // 1 FCFA = 1/655.957 EUR (official fixed rate)
    Currency.USD: 0.001626,  // 1 FCFA ≈ 1/615 USD (market rate ~2026)
  };
  
  // Currency symbols
  static const Map<Currency, String> _symbols = {
    Currency.FCFA: 'FCFA',
    Currency.EUR: '€',
    Currency.USD: '\$',
  };
  
  // Currency names
  static const Map<Currency, String> _names = {
    Currency.FCFA: 'Franc CFA',
    Currency.EUR: 'Euro',
    Currency.USD: 'Dollar US',
  };
  
  /// Load currency setting from Supabase
  Future<void> loadCurrency() async {
    try {
      final response = await SupabaseManager.client
          .from('app_settings')
          .select('value')
          .eq('key', 'devise')
          .maybeSingle();
      
      if (response != null && response['value'] != null) {
        final deviseStr = response['value']['devise'] as String?;
        if (deviseStr != null) {
          switch (deviseStr.toUpperCase()) {
            case 'EUR':
              _currency = Currency.EUR;
              break;
            case 'USD':
              _currency = Currency.USD;
              break;
            default:
              _currency = Currency.FCFA;
          }
        }
      }
      debugPrint('CurrencyService: Loaded currency: $_currency');
    } catch (e) {
      debugPrint('CurrencyService: Error loading currency: $e');
      _currency = Currency.FCFA; // Default fallback
    }
  }
  
  /// Convert amount from FCFA to current display currency
  double convertFromFcfa(int amountFcfa) {
    return amountFcfa * (_ratesFromFcfa[_currency] ?? 1.0);
  }
  
  /// Format amount in current currency for display
  String formatAmount(int amountFcfa) {
    final converted = convertFromFcfa(amountFcfa);
    final symbol = _symbols[_currency] ?? 'FCFA';
    
    if (_currency == Currency.FCFA) {
      // FCFA: no decimals, format with spaces
      return '${_formatNumber(amountFcfa)} $symbol';
    } else {
      // EUR/USD: 2 decimals
      return '$symbol${converted.toStringAsFixed(2)}';
    }
  }
  
  /// Format number with thousand separators
  String _formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
  
  /// Get current currency symbol
  String get symbol => _symbols[_currency] ?? 'FCFA';
  
  /// Get current currency name
  String get name => _names[_currency] ?? 'Franc CFA';
  
  /// Check if current currency is FCFA
  bool get isFcfa => _currency == Currency.FCFA;
}
