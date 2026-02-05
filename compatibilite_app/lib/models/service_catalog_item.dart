import 'package:flutter/material.dart';

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

/// Static catalog data with new marketing names and descriptions
class ServiceCatalogData {
  static const List<Map<String, dynamic>> services = [
    {
      'id': 'compatibilite_couple',
      'name': 'Compatibilité Couple',
      'emoji': '❤️',
      'planType': 'consultation',
      'requiresAuth': false,
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
