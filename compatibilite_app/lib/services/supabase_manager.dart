import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles Supabase initialization and exposes the shared client.
class SupabaseManager {
  static bool _initialized = false;

  static bool get isReady => _initialized;

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError('Supabase has not been initialized. Check env variables.');
    }
    return Supabase.instance.client;
  }

  static Future<void> init({String? url, String? anonKey}) async {
    if (_initialized) return;
    if (url == null || anonKey == null || url.isEmpty || anonKey.isEmpty) {
      debugPrint('Supabase not configured: missing SUPABASE_URL or SUPABASE_ANON_KEY');
      return;
    }
    try {
      await Supabase.initialize(url: url, anonKey: anonKey);
      _initialized = true;
      debugPrint('Supabase initialized');
    } catch (e) {
      debugPrint('Supabase init failed: $e');
    }
  }
}
