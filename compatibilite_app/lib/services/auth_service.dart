import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'analytics_service.dart';
import 'supabase_manager.dart';

/// User model for local use
class AppUser {
  AppUser({
    required this.id,
    required this.email,
    this.name,
    this.hasActiveSubscription = false,
  });

  final String id;
  final String email;
  final String? name;
  final bool hasActiveSubscription;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }
}

/// Handles user authentication with email/password
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _tableSubscriptions = 'subscriptions';

  SupabaseClient? get _client => SupabaseManager.isReady ? SupabaseManager.client : null;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Sign up a new user with email and password
  Future<AppUser?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    if (_client == null) {
      debugPrint('AuthService: Supabase not initialized');
      return null;
    }

    try {
      final response = await _client!.auth.signUp(
        email: email.trim(),
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user == null) {
        throw Exception('Échec de l\'inscription');
      }

      final userId = response.user!.id;
      final userEmail = response.user!.email!;

      // Note: With Supabase Auth, user is in auth.users
      // Foreign keys now reference auth.users(id) directly

      // Sync with local model
      _currentUser = AppUser(
        id: userId,
        email: userEmail,
        name: name,
      );
      
      return _currentUser;
    } catch (e) {
      debugPrint('AuthService signUp error: $e');
      AnalyticsService.instance.logSignupError(email, e.toString());
      rethrow;
    }
  }

  /// Sign in an existing user
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      debugPrint('AuthService: Supabase not initialized');
      return null;
    }

    try {
      final response = await _client!.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw Exception('Email ou mot de passe incorrect');
      }

      final userId = response.user!.id;
      final userEmail = response.user!.email!;
      final userName = response.user!.userMetadata?['name'] as String?;

      // Note: With Supabase Auth, user is in auth.users
      // Foreign keys now reference auth.users(id) directly

      _currentUser = AppUser(
        id: userId,
        email: userEmail,
        name: userName,
      );

      return await _checkAndUpdateSubscription(_currentUser!);
    } catch (e) {
      debugPrint('AuthService signIn error: $e');
      AnalyticsService.instance.logLoginError(email, e.toString());
      rethrow;
    }
  }

  /// Check if user has active subscription
  Future<AppUser> _checkAndUpdateSubscription(AppUser user) async {
    if (_client == null) return user;

    try {
      final now = DateTime.now().toIso8601String();
      // NOTE: RLS might block this if policies aren't set yet.
      // But we are migrating to Supabase Auth to ENABLE RLS.
      final subscription = await _client!
          .from(_tableSubscriptions)
          .select()
          .eq('user_id', user.id)
          .eq('is_active', true)
          .gte('expires_at', now)
          .maybeSingle();

      _currentUser = AppUser(
        id: user.id,
        email: user.email,
        name: user.name,
        hasActiveSubscription: subscription != null,
      );
      return _currentUser!;
    } catch (e) {
      debugPrint('AuthService subscription check error: $e');
      return user;
    }
  }

  /// Check if email exists
  /// Note: Supabase Admin API is needed to check existence reliably without login.
  /// For client side, we can only try to sign up or sign in.
  Future<bool> emailExists(String email) async {
    // Client-side existence check is discouraged for security (enumeration attacks).
    // Returning false by default to prompt sign-up or let sign-in fail naturally.
    return false; 
  }

  /// Check if email has active subscription (without full login)
  /// This legacy check is tricky with RLS. We'll simplify.
  Future<bool> hasActiveSubscription(String email) async {
    // Cannot check subscription of another user securely.
    // Assuming false until logged in.
    return false;
  }

  /// Create or update subscription after payment
  Future<void> createSubscription({
    required String userId,
    required String planId,
    required String paymentId,
    required int durationDays,
  }) async {
    if (_client == null) return;

    try {
      final now = DateTime.now();
      final expiresAt = now.add(Duration(days: durationDays));

      await _client!.from(_tableSubscriptions).insert({
        'user_id': userId,
        'plan_id': planId,
        'payment_id': paymentId,
        'starts_at': now.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
        'is_active': true,
      });

      // Update current user state if it matches
      if (_currentUser?.id == userId) {
        _currentUser = AppUser(
          id: _currentUser!.id,
          email: _currentUser!.email,
          name: _currentUser!.name,
          hasActiveSubscription: true,
        );
      }
    } catch (e) {
      debugPrint('AuthService createSubscription error: $e');
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _client?.auth.signOut();
    _currentUser = null;
  }
}
