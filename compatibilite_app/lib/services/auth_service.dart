import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
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

  static const _tableUsers = 'users';
  static const _tableSubscriptions = 'subscriptions';
  final Uuid _uuid = const Uuid();

  SupabaseClient? get _client => SupabaseManager.isReady ? SupabaseManager.client : null;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

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
      final passwordHash = _hashPassword(password);
      final userId = _uuid.v4();

      final result = await _client!.from(_tableUsers).insert({
        'id': userId,
        'email': email.toLowerCase().trim(),
        'password_hash': passwordHash,
        'name': name,
      }).select().single();

      _currentUser = AppUser.fromJson(result);
      return _currentUser;
    } catch (e) {
      debugPrint('AuthService signUp error: $e');
      // If user already exists, try to sign in
      if (e.toString().contains('duplicate') || e.toString().contains('unique')) {
        return signIn(email: email, password: password);
      }
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
      final passwordHash = _hashPassword(password);
      final result = await _client!
          .from(_tableUsers)
          .select()
          .eq('email', email.toLowerCase().trim())
          .eq('password_hash', passwordHash)
          .maybeSingle();

      if (result == null) {
        throw Exception('Email ou mot de passe incorrect');
      }

      // Update last login
      await _client!.from(_tableUsers).update({
        'last_login': DateTime.now().toIso8601String(),
      }).eq('id', result['id']);

      _currentUser = AppUser.fromJson(result);
      return await _checkAndUpdateSubscription(_currentUser!);
    } catch (e) {
      debugPrint('AuthService signIn error: $e');
      rethrow;
    }
  }

  /// Check if user has active subscription
  Future<AppUser> _checkAndUpdateSubscription(AppUser user) async {
    if (_client == null) return user;

    try {
      final now = DateTime.now().toIso8601String();
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
  Future<bool> emailExists(String email) async {
    if (_client == null) return false;

    try {
      final result = await _client!
          .from(_tableUsers)
          .select('id')
          .eq('email', email.toLowerCase().trim())
          .maybeSingle();
      return result != null;
    } catch (e) {
      debugPrint('AuthService emailExists error: $e');
      return false;
    }
  }

  /// Check if email has active subscription (without full login)
  Future<bool> hasActiveSubscription(String email) async {
    if (_client == null) return false;

    try {
      final user = await _client!
          .from(_tableUsers)
          .select('id')
          .eq('email', email.toLowerCase().trim())
          .maybeSingle();

      if (user == null) return false;

      final now = DateTime.now().toIso8601String();
      final subscription = await _client!
          .from(_tableSubscriptions)
          .select()
          .eq('user_id', user['id'])
          .eq('is_active', true)
          .gte('expires_at', now)
          .maybeSingle();

      return subscription != null;
    } catch (e) {
      debugPrint('AuthService hasActiveSubscription error: $e');
      return false;
    }
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

      // Update current user
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
  void signOut() {
    _currentUser = null;
  }
}
