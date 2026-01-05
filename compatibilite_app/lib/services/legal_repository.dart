import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/legal_models.dart';

class LegalRepository {
  static final LegalRepository instance = LegalRepository._();
  LegalRepository._();

  final _supabase = Supabase.instance.client;
  
  // Simple in-memory cache
  List<LegalPage>? _cachedPages;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 5);

  Future<List<LegalPage>> getActivePages({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedPages != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return _cachedPages!;
      }
    }

    try {
      final response = await _supabase
          .from('legal_pages')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      _cachedPages = data.map((json) => LegalPage.fromJson(json)).toList();
      _lastFetchTime = DateTime.now();
      
      return _cachedPages!;
    } catch (e) {
      // Return cached pages if fetch fails, or empty list
      return _cachedPages ?? [];
    }
  }

  Future<LegalPage?> getPageBySlug(String slug) async {
    try {
      final response = await _supabase
          .from('legal_pages')
          .select()
          .eq('slug', slug)
          .maybeSingle();

      if (response == null) return null;
      return LegalPage.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
