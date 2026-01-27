/// Product model for the flexible product catalog
library;

/// Types of products available for purchase
enum ProductType {
  basicReport,
  yearPrediction,
  monthPrediction,
  dayPrediction,
  fullBundle,
  subscription30,
  cyclesVie,
}

/// Extension to get human-readable info from ProductType
extension ProductTypeExtension on ProductType {
  String get displayName {
    switch (this) {
      case ProductType.basicReport:
        return 'Rapport de Compatibilité';
      case ProductType.yearPrediction:
        return 'Prévision Annuelle';
      case ProductType.monthPrediction:
        return 'Prévision Mensuelle';
      case ProductType.dayPrediction:
        return 'Prévision du Jour';
      case ProductType.fullBundle:
        return 'Pack Complet';
      case ProductType.subscription30:
        return 'Abonnement 30 Jours';
      case ProductType.cyclesVie:
        return 'Cycles de Vie';
    }
  }
  
  String get icon {
    switch (this) {
      case ProductType.basicReport:
        return '💑';
      case ProductType.yearPrediction:
        return '📅';
      case ProductType.monthPrediction:
        return '🗓️';
      case ProductType.dayPrediction:
        return '☀️';
      case ProductType.fullBundle:
        return '✨';
      case ProductType.subscription30:
        return '⭐';
      case ProductType.cyclesVie:
        return '🌀';
    }
  }
  
  String get periodType {
    switch (this) {
      case ProductType.basicReport:
        return 'base';
      case ProductType.yearPrediction:
        return 'annee';
      case ProductType.monthPrediction:
        return 'mois';
      case ProductType.dayPrediction:
        return 'jour';
      case ProductType.fullBundle:
        return 'bundle';
      case ProductType.subscription30:
        return 'subscription';
      case ProductType.cyclesVie:
        return 'cycles_vie';
    }
  }
  
  bool get isTemporal {
    return this == ProductType.yearPrediction ||
           this == ProductType.monthPrediction ||
           this == ProductType.dayPrediction;
  }
  
  bool get isBundle => this == ProductType.fullBundle;
  bool get isSubscription => this == ProductType.subscription30;
}

/// Product model representing a purchasable item
class Product {
  final String id;
  final ProductType type;
  final String name;
  final String description;
  final int priceFcfa;
  final List<String> features;
  final bool isActive;
  final bool isPopular;
  final int? durationDays; // For subscriptions
  
  const Product({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.priceFcfa,
    this.features = const [],
    this.isActive = true,
    this.isPopular = false,
    this.durationDays,
  });
  
  /// Create from Supabase JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      type: _parseProductType(json['product_type'] as String? ?? json['plan_type'] as String?),
      name: json['name'] as String? ?? json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priceFcfa: json['price_fcfa'] as int? ?? json['amount'] as int? ?? 0,
      features: (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isActive: json['is_active'] as bool? ?? true,
      isPopular: json['is_popular'] as bool? ?? false,
      durationDays: json['duration_days'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_type': type.periodType,
      'name': name,
      'description': description,
      'price_fcfa': priceFcfa,
      'features': features,
      'is_active': isActive,
      'is_popular': isPopular,
      'duration_days': durationDays,
    };
  }
  
  static ProductType _parseProductType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'basic_report':
      case 'consultation':
      case 'base':
        return ProductType.basicReport;
      case 'year_prediction':
      case 'annee':
        return ProductType.yearPrediction;
      case 'month_prediction':
      case 'mois':
        return ProductType.monthPrediction;
      case 'day_prediction':
      case 'jour':
        return ProductType.dayPrediction;
      case 'full_bundle':
      case 'bundle':
        return ProductType.fullBundle;
      case 'subscription_30':
      case 'subscription':
        return ProductType.subscription30;
      case 'cycle_vie':
      case 'cycles_vie':
      case 'cycle_vie_express':
      case 'cycle_vie_strategique':
      case 'cycle_vie_consultation':
      case 'cycle_vie_abonnement':
        return ProductType.cyclesVie;
      default:
        return ProductType.basicReport;
    }
  }
  
  @override
  String toString() => 'Product($name, $priceFcfa FCFA)';
}
