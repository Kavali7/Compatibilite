# Guide d'Implémentation Flutter

## Service 01 : Portrait de l'Âme

Ce guide explique comment implémenter le service "Portrait de l'Âme" dans l'application Flutter.

---

## 1. Structure des Fichiers à Créer

```
lib/
├── models/
│   └── soul_profile.dart
├── services/
│   └── soul_profile_service.dart
└── screens/
    └── soul_profile/
        ├── soul_profile_input_screen.dart
        ├── soul_profile_report_screen.dart
        └── widgets/
            └── soul_profile_card.dart
```

---

## 2. Modèle de Données

### `lib/models/soul_profile.dart`

```dart
class SoulProfile {
  final String id;
  final int periodNumber;
  final String polarity;
  final String profileCode;
  final String cosmicIdentity;
  final String fullContent;
  final List<String> affinitesGeo;
  final List<String> vigilanceSante;
  final List<String> conseils;

  SoulProfile({
    required this.id,
    required this.periodNumber,
    required this.polarity,
    required this.profileCode,
    required this.cosmicIdentity,
    required this.fullContent,
    required this.affinitesGeo,
    required this.vigilanceSante,
    required this.conseils,
  });

  factory SoulProfile.fromJson(Map<String, dynamic> json) {
    return SoulProfile(
      id: json['id'] ?? '',
      periodNumber: json['period'] ?? json['period_number'] ?? 0,
      polarity: json['polarity'] ?? '',
      profileCode: json['profile_code'] ?? '',
      cosmicIdentity: json['cosmic_identity'] ?? '',
      fullContent: json['full_content'] ?? '',
      affinitesGeo: List<String>.from(json['affinites_geo'] ?? []),
      vigilanceSante: List<String>.from(json['vigilance_sante'] ?? []),
      conseils: List<String>.from(json['conseils'] ?? []),
    );
  }
}

class SoulProfilePurchase {
  final String id;
  final String userId;
  final DateTime userBirthdate;
  final String userFirstname;
  final SoulProfile profile;
  final DateTime createdAt;

  SoulProfilePurchase({
    required this.id,
    required this.userId,
    required this.userBirthdate,
    required this.userFirstname,
    required this.profile,
    required this.createdAt,
  });

  factory SoulProfilePurchase.fromJson(Map<String, dynamic> json) {
    return SoulProfilePurchase(
      id: json['purchase_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userBirthdate: DateTime.parse(json['user_birthdate']),
      userFirstname: json['user_firstname'] ?? '',
      profile: SoulProfile.fromJson(json['profile'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
```

---

## 3. Service Supabase

### `lib/services/soul_profile_service.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/soul_profile.dart';

class SoulProfileService {
  final SupabaseClient _client;

  SoulProfileService(this._client);

  /// Calcule et retourne le profil Soul pour une date de naissance
  Future<SoulProfile?> getProfileForBirthdate(DateTime birthdate) async {
    try {
      final response = await _client.rpc(
        'fn_get_soul_profile',
        params: {'p_birthdate': birthdate.toIso8601String().split('T')[0]},
      );

      if (response == null || response['error'] != null) {
        return null;
      }

      return SoulProfile.fromJson(response);
    } catch (e) {
      print('Erreur lors de la récupération du profil: $e');
      return null;
    }
  }

  /// Calcule la période et polarité sans récupérer le contenu complet
  Future<Map<String, dynamic>?> calculateProfile(DateTime birthdate) async {
    try {
      final response = await _client.rpc(
        'fn_calculate_soul_profile',
        params: {'p_birthdate': birthdate.toIso8601String().split('T')[0]},
      );

      if (response == null || (response is List && response.isEmpty)) {
        return null;
      }

      return response is List ? response.first : response;
    } catch (e) {
      print('Erreur lors du calcul du profil: $e');
      return null;
    }
  }

  /// Crée un achat après paiement réussi
  Future<SoulProfilePurchase?> createPurchase({
    required String userId,
    required String paymentId,
    required DateTime birthdate,
    required String firstname,
  }) async {
    try {
      final response = await _client.rpc(
        'fn_create_soul_purchase',
        params: {
          'p_user_id': userId,
          'p_payment_id': paymentId,
          'p_birthdate': birthdate.toIso8601String().split('T')[0],
          'p_firstname': firstname,
        },
      );

      if (response == null || response['error'] != null) {
        return null;
      }

      return SoulProfilePurchase.fromJson(response);
    } catch (e) {
      print('Erreur lors de la création de l\'achat: $e');
      return null;
    }
  }

  /// Récupère les achats précédents de l'utilisateur
  Future<List<SoulProfilePurchase>> getUserPurchases(String userId) async {
    try {
      final response = await _client
          .from('soul_profile_purchases')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => SoulProfilePurchase.fromJson(json))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des achats: $e');
      return [];
    }
  }
}
```

---

## 4. Écran de Saisie

### `lib/screens/soul_profile/soul_profile_input_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../services/soul_profile_service.dart';
// Import your payment service

class SoulProfileInputScreen extends StatefulWidget {
  const SoulProfileInputScreen({Key? key}) : super(key: key);

  @override
  State<SoulProfileInputScreen> createState() => _SoulProfileInputScreenState();
}

class _SoulProfileInputScreenState extends State<SoulProfileInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portrait de l\'Âme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête mystique
              _buildHeader(),
              const SizedBox(height: 32),
              
              // Champ prénom
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  labelText: 'Votre prénom',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              
              // Sélecteur de date
              _buildDateSelector(),
              const SizedBox(height: 32),
              
              // Bouton d'achat
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePurchase,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Découvrir mon Portrait (2 500 FCFA)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.auto_awesome, size: 64, color: Theme.of(context).primaryColor),
        const SizedBox(height: 16),
        Text(
          'Découvrez votre essence cosmique',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Un portrait personnalisé de votre âme révélant votre véritable essence',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date de naissance',
          border: OutlineInputBorder(),
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Sélectionner...',
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Intégrer le flux de paiement existant
    // Après paiement réussi, appeler SoulProfileService.createPurchase()
    // puis naviguer vers SoulProfileReportScreen

    setState(() => _isLoading = false);
  }
}
```

---

## 5. Écran du Rapport

### `lib/screens/soul_profile/soul_profile_report_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/soul_profile.dart';

class SoulProfileReportScreen extends StatelessWidget {
  final SoulProfilePurchase purchase;

  const SoulProfileReportScreen({
    Key? key,
    required this.purchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Portrait de l\'Âme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implémenter le partage
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec identité cosmique
            _buildCosmicHeader(context),
            const SizedBox(height: 24),
            
            // Contenu Markdown
            MarkdownBody(
              data: purchase.profile.fullContent,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium,
                h2: Theme.of(context).textTheme.titleLarge,
                h3: Theme.of(context).textTheme.titleMedium,
                p: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Pied de page
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCosmicHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            purchase.profile.cosmicIdentity,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Portrait de ${purchase.userFirstname}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Né(e) le ${_formatDate(purchase.userBirthdate)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Portrait généré le ${_formatDate(purchase.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

---

## 6. Intégration avec le Système de Paiement Existant

Le service "Portrait de l'Âme" doit s'intégrer au flux de paiement existant (Kkiapay/FedaPay).

### Modifications dans `PaymentManager`

```dart
// Ajouter un nouveau type de service
enum ServiceType {
  compatibility,
  soulProfile,  // NOUVEAU
  decisionAdvice,
  // ...
}

// Dans la callback de paiement réussi
void _onPaymentSuccess(String paymentId) async {
  if (currentServiceType == ServiceType.soulProfile) {
    final purchase = await soulProfileService.createPurchase(
      userId: currentUserId,
      paymentId: paymentId,
      birthdate: selectedBirthdate,
      firstname: enteredFirstname,
    );
    
    if (purchase != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SoulProfileReportScreen(purchase: purchase),
        ),
      );
    }
  }
}
```

---

## 7. Points d'Attention

1. **Styling** : Adapter les styles au thème "Mystical Dark" existant
2. **Internationalisation** : Le contenu est en français uniquement pour l'instant
3. **Offline** : Considérer le cache des profils achetés
4. **Partage** : Implémenter le partage du rapport (PDF ou image)
5. **Tests** : Tester avec différentes dates de naissance pour couvrir les 14 profils

---

## 8. Checklist d'Implémentation

- [ ] Créer `soul_profile.dart` (modèle)
- [ ] Créer `soul_profile_service.dart` (service)
- [ ] Créer `soul_profile_input_screen.dart` (saisie)
- [ ] Créer `soul_profile_report_screen.dart` (affichage)
- [ ] Intégrer au menu de navigation
- [ ] Intégrer au flux de paiement
- [ ] Tester les 14 profils
- [ ] Implémenter le partage
