import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';

/// Model representing a service item in the catalog
class ServiceCatalogItem {
  final String id;
  final String name;
  final String emoji;
  final List<String> advantages;
  final String? priceLabel;
  final Widget Function(BuildContext context) screenBuilder;
  final bool requiresAuth;
  final String planType;

  const ServiceCatalogItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.advantages,
    this.priceLabel,
    required this.screenBuilder,
    this.requiresAuth = true,
    required this.planType,
  });
}

/// Service to fetch and cache catalog data from Supabase
class ServiceCatalogData {
  static List<Map<String, dynamic>>? _cachedServices;
  static bool _isLoading = false;
  static DateTime? _lastFetch;
  static const Duration _cacheExpiry = Duration(minutes: 30);

  /// Load services from Supabase with caching
  static Future<List<Map<String, dynamic>>> loadServices() async {
    // Return cache if valid
    if (_cachedServices != null && 
        _lastFetch != null && 
        DateTime.now().difference(_lastFetch!) < _cacheExpiry) {
      return _cachedServices!;
    }

    // Prevent multiple simultaneous loads
    if (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      return _cachedServices ?? _fallbackServices;
    }

    _isLoading = true;
    try {
      final response = await SupabaseManager.client
          .from('service_catalog')
          .select()
          .eq('enabled', true)
          .order('display_order', ascending: true);

      if (response != null && response is List && response.isNotEmpty) {
        _cachedServices = response.map((item) => {
          'id': item['id'] as String,
          'name': item['name'] as String,
          'emoji': item['emoji'] as String,
          'planType': item['plan_type'] as String? ?? 'consultation',
          'requiresAuth': true, // All services require auth
          'advantages': (item['advantages'] as List?)?.cast<String>() ?? <String>[],
        }).toList();
        _lastFetch = DateTime.now();
        debugPrint('ServiceCatalogData: Loaded ${_cachedServices!.length} services from Supabase');
        return _cachedServices!;
      }
    } catch (e) {
      debugPrint('ServiceCatalogData: Error loading from Supabase: $e');
    } finally {
      _isLoading = false;
    }

    // Fallback to static data
    debugPrint('ServiceCatalogData: Using fallback static services');
    return _fallbackServices;
  }

  /// Synchronous getter for cached services (with fallback)
  static List<Map<String, dynamic>> get services => _cachedServices ?? _fallbackServices;

  /// Force refresh from Supabase
  static Future<void> refresh() async {
    _cachedServices = null;
    _lastFetch = null;
    await loadServices();
  }

  /// Fallback static data (used if Supabase is unavailable)
  static const List<Map<String, dynamic>> _fallbackServices = [
    {
      'id': 'compatibilite_couple',
      'name': 'Compatibilité Couple',
      'emoji': '❤️',
      'planType': 'consultation',
      'requiresAuth': true,
      'advantages': [
        'Fini les doutes sur votre relation',
        'Comprenez pourquoi certains moments sont difficiles',
        'Révélez les forces cachées de votre union',
        'Un rapport clair basé sur vos dates de naissance',
        'Des milliers de couples ont déjà testé',
      ],
    },
    {
      'id': 'previsions_temporelles',
      'name': 'Ce Que l\'Avenir Réserve À Votre Couple',
      'emoji': '🔮',
      'planType': 'temporal_year',
      'requiresAuth': true,
      'advantages': [
        'Anticipez les moments clés avant qu\'ils n\'arrivent',
        'Transformez l\'incertitude en clarté',
        'Évitez les erreurs de timing qui fragilisent les couples',
        'Conseils personnalisés selon votre période',
        'Plus de mauvaises surprises',
      ],
    },
    {
      'id': 'guidance_quotidienne',
      'name': 'Guidance Quotidienne de Couple',
      'emoji': '☀️',
      'planType': 'temporel_jour',
      'requiresAuth': true,
      'advantages': [
        'Un conseil précis pour chaque journée',
        'Anticipez les tensions avant qu\'elles n\'éclatent',
        'Sachez exactement quand planifier les conversations importantes',
        'Basé sur vos données personnelles',
        'Résultats immédiats',
      ],
    },
    {
      'id': 'mois_decrypte',
      'name': 'Votre Mois de Couple Décrypté',
      'emoji': '📅',
      'planType': 'temporel_mois',
      'requiresAuth': true,
      'advantages': [
        'Vue d\'ensemble sur les 30 prochains jours',
        'Identifiez les semaines à risque et les meilleures périodes',
        'Planifiez les moments importants au bon timing',
        'Conseils ciblés pour chaque phase du mois',
        'Investissement rentable pour l\'harmonie du couple',
      ],
    },
    {
      'id': 'avenir_annee',
      'name': 'L\'Avenir de Votre Couple Cette Année',
      'emoji': '🔮',
      'planType': 'temporel_annee',
      'requiresAuth': true,
      'advantages': [
        'Vision stratégique sur les 12 prochains mois',
        'Les grandes phases de votre couple révélées',
        'Évitez les erreurs de timing qui fragilisent les couples',
        'Inclut le mois en cours et la journée en bonus',
        'L\'investissement le plus complet pour votre couple',
      ],
    },
    {
      'id': 'portrait_ame',
      'name': 'Qui Êtes-Vous Vraiment',
      'emoji': '✨',
      'planType': 'portrait_ame',
      'requiresAuth': true,
      'advantages': [
        'Comprenez enfin pourquoi vous réagissez ainsi',
        'Identifiez les obstacles qui vous freinent sans le savoir',
        'Comprenez vos affinités relationnelles profondes',
        'Un rapport de plus de 1 000 mots sur vous seul',
        'Basé sur votre date de naissance uniquement',
      ],
    },
    {
      'id': 'cycle_personnel',
      'name': 'Calendrier de Votre Destinée',
      'emoji': '📅',
      'planType': 'personal_cycle_annual',
      'requiresAuth': true,
      'advantages': [
        'Comprenez pourquoi certaines périodes sont plus dures',
        'Évitez l\'épuisement en respectant vos rythmes naturels',
        'Conseils pratiques adaptés à chaque phase',
        '7 000 mots de guidance experte',
        'Abonnement annuel avec accès complet',
      ],
    },
    {
      'id': 'cycle_business',
      'name': 'L\'Année Business Idéale',
      'emoji': '💼',
      'planType': 'business_cycle_annual',
      'requiresAuth': true,
      'advantages': [
        'Anticipez les meilleures périodes pour investir',
        'Identifiez les risques avant qu\'ils ne surviennent',
        'KPIs à surveiller selon votre cycle',
        'Contenu professionnel adapté aux entrepreneurs',
        'Passez de l\'intuition à la stratégie',
      ],
    },
    {
      'id': 'cycle_sante',
      'name': 'Cycle Santé',
      'emoji': '💚',
      'planType': 'health_cycle_annual',
      'requiresAuth': true,
      'advantages': [
        'Respectez les rythmes naturels de votre corps',
        'Sachez quand pousser et quand ralentir',
        'Activités physiques recommandées',
        'Notifications de changement de phase',
        'Abonnement annuel accessible',
      ],
    },
    {
      'id': 'guide_horaire',
      'name': 'Horloge de Productivité',
      'emoji': '⏰',
      'planType': 'daily_guide_day',
      'requiresAuth': true,
      'advantages': [
        'Organisez vos tâches selon votre énergie réelle',
        'Évitez les créneaux où votre concentration chute',
        'Personnalisé selon votre profil et le jour de la semaine',
        'Format clair et pratique',
        'La productivité devient naturelle',
      ],
    },
    {
      'id': 'eclairage_decision',
      'name': 'Guide des Grandes Décisions',
      'emoji': '💡',
      'planType': 'decision_credit',
      'requiresAuth': true,
      'advantages': [
        'Des alternatives proposées si le timing n\'est pas idéal',
        'Avertissements clairs si la période est défavorable',
        '20 catégories de décisions couvertes',
        'Système de crédits flexible',
        'Décidez avec sérénité',
      ],
    },
    {
      'id': 'phases_vie',
      'name': 'D\'où Venez-Vous, Où Allez-Vous',
      'emoji': '🛤️',
      'planType': 'life_phase_report',
      'requiresAuth': true,
      'advantages': [
        'Découvrez où vous en êtes vraiment',
        'Ce que les années à venir vous réservent',
        'Vision claire de votre chemin',
        'Partageable avec vos proches',
        'Enfin des réponses sur votre parcours',
      ],
    },
    {
      'id': 'timing_lunaire',
      'name': 'Calendrier Lunaire Personnel',
      'emoji': '🌙',
      'planType': 'lunar_timing_monthly',
      'requiresAuth': true,
      'advantages': [
        'La Lune influence votre énergie, utilisez-la',
        'Activités favorables et défavorables identifiées',
        'Notifications à chaque changement de phase',
        'Accès illimité pendant votre abonnement',
        'Simplicité et efficacité au quotidien',
      ],
    },
  ];
}
