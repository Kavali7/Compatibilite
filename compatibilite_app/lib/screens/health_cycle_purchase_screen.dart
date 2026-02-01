/// Health Cycle Purchase Screen (Service 04)
/// Écran d'achat du service Cycle Santé
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../services/health_cycle_service.dart';
import '../services/pricing_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../widgets/animated_background.dart';
import 'health_cycle_report_screen.dart';

/// Écran d'achat du Cycle Santé
class HealthCyclePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const HealthCyclePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<HealthCyclePurchaseScreen> createState() => _HealthCyclePurchaseScreenState();
}

class _HealthCyclePurchaseScreenState extends State<HealthCyclePurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  DateTime? _birthdate;
  
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Valeurs par défaut
    final now = DateTime.now();
    _birthYear = now.year - 25;
    _birthMonth = now.month;
    _birthDay = now.day;
    _updateBirthdate();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  void _updateBirthdate() {
    if (_birthYear != null && _birthMonth != null && _birthDay != null) {
      final maxDay = _daysInMonth(_birthYear, _birthMonth);
      if (_birthDay! > maxDay) {
        _birthDay = maxDay;
      }
      _birthdate = DateTime(_birthYear!, _birthMonth!, _birthDay!);
    } else {
      _birthdate = null;
    }
  }

  int _daysInMonth(int? year, int? month) {
    if (year == null || month == null) return 31;
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '🏥 Cycle Santé',
          style: GoogleFonts.philosopher(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        showStars: true,
        showOrbs: true,
        starCount: 35,
        gradientColors: const [Color(0xFF1B5E20), Color(0xFF0E2E15)], // Vert santé
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80), // Espace pour l'app bar
            
            // Introduction
            _buildIntroCard(),
            const SizedBox(height: 28),

            // Caractéristiques
            _buildFeaturesCard(),
            const SizedBox(height: 28),

            // Récapitulatif du plan
            _buildPlanSummary(),
            const SizedBox(height: 28),

            // Formulaire
            _buildFormSection(),
            const SizedBox(height: 28),
            
            // Avertissement médical
            _buildMedicalDisclaimer(),
            const SizedBox(height: 28),

            // Bouton de paiement
            _buildPayButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32).withValues(alpha: 0.2),
            const Color(0xFF1B5E20).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite, color: Color(0xFF66BB6A), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Votre Guide Bien-Être',
                      style: GoogleFonts.philosopher(
                        color: AppColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Abonnement annuel',
                      style: TextStyle(
                        color: const Color(0xFF66BB6A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Découvrez vos 7 périodes de bien-être personnalisées basées sur les cycles ancestraux. '
            'Optimisez votre alimentation, vos activités et votre repos selon les rythmes naturels de votre corps.',
            style: TextStyle(
              color: AppColors.textLight.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Ce que vous obtenez',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(Icons.calendar_month, '7 périodes de bien-être personnalisées'),
          _buildFeatureRow(Icons.restaurant, 'Conseils alimentation par période'),
          _buildFeatureRow(Icons.fitness_center, 'Activités physiques recommandées'),
          _buildFeatureRow(Icons.bed, 'Optimisation du repos et sommeil'),
          _buildFeatureRow(Icons.lightbulb, 'Conseils pratiques quotidiens'),
          _buildFeatureRow(Icons.self_improvement, 'Affirmations de bien-être'),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF66BB6A), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    final price = CurrencyService.instance.formatAmount(widget.plan.priceFcfa);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32).withValues(alpha: 0.15),
            const Color(0xFF1B5E20).withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Color(0xFF66BB6A), size: 24),
              const SizedBox(width: 12),
              Text(
                'Votre commande',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.plan.name,
                style: TextStyle(color: AppColors.textLight, fontSize: 15),
              ),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF66BB6A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Accès pendant 365 jours',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vos informations',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Prénom
          TextFormField(
            controller: _firstNameController,
            style: TextStyle(color: AppColors.textLight),
            decoration: InputDecoration(
              labelText: 'Votre prénom',
              labelStyle: TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.person, color: Color(0xFF66BB6A)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF66BB6A)),
              ),
              filled: true,
              fillColor: AppColors.background.withValues(alpha: 0.5),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre prénom';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Date de naissance
          _buildDateDropdowns(),
        ],
      ),
    );
  }

  Widget _buildDateDropdowns() {
    final now = DateTime.now();
    final years = List<int>.generate(now.year - 1919, (i) => 1920 + i).reversed.toList();
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    final maxDay = _daysInMonth(_birthYear, _birthMonth);
    final days = List<int>.generate(maxDay, (i) => i + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cake, color: Color(0xFF66BB6A), size: 20),
              const SizedBox(width: 10),
              Text(
                'Date de naissance',
                style: GoogleFonts.philosopher(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Important pour calculer vos périodes de santé',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Année
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int>(
                  value: _birthYear,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Année',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppColors.block,
                  items: years.map((y) {
                    return DropdownMenuItem(value: y, child: Text('$y', style: TextStyle(color: AppColors.textLight)));
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _birthYear = v;
                      _updateBirthdate();
                    });
                  },
                  validator: (v) => v == null ? 'Requis' : null,
                ),
              ),
              const SizedBox(width: 8),
              // Mois
              Expanded(
                flex: 4,
                child: DropdownButtonFormField<int>(
                  value: _birthMonth,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Mois',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppColors.block,
                  items: List.generate(12, (i) {
                    return DropdownMenuItem(
                      value: i + 1,
                      child: Text(months[i], style: TextStyle(color: AppColors.textLight)),
                    );
                  }),
                  onChanged: (v) {
                    setState(() {
                      _birthMonth = v;
                      _updateBirthdate();
                    });
                  },
                  validator: (v) => v == null ? 'Requis' : null,
                ),
              ),
              const SizedBox(width: 8),
              // Jour
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  value: (_birthDay != null && _birthDay! <= maxDay) ? _birthDay : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Jour',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppColors.block,
                  items: days.map((d) {
                    return DropdownMenuItem(value: d, child: Text('$d', style: TextStyle(color: AppColors.textLight)));
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _birthDay = v;
                      _updateBirthdate();
                    });
                  },
                  validator: (v) => v == null ? 'Requis' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '⚕️ Ce service fournit des conseils généraux de bien-être basés sur des cycles ancestraux. '
              'Il ne remplace en aucun cas un avis médical professionnel. Consultez votre médecin avant tout changement significatif.',
              style: TextStyle(
                color: Colors.amber.shade100,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    // Afficher FCFA si le prix converti est trop petit
    final priceFcfa = widget.plan.priceFcfa;
    String formattedPrice;
    if (priceFcfa < 100 && !CurrencyService.instance.isFcfa) {
      formattedPrice = '$priceFcfa FCFA';
    } else {
      formattedPrice = CurrencyService.instance.formatAmount(priceFcfa);
    }
    
    return ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
      child: _isProcessing
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Payer $formattedPrice',
                  style: GoogleFonts.philosopher(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_birthdate == null) {
      _showError('Veuillez sélectionner une date de naissance complète');
      return;
    }
    
    final authService = AuthService.instance;
    
    // Vérifier connexion
    if (!authService.isLoggedIn) {
      _showError('Veuillez vous connecter pour continuer');
      return;
    }
    
    final user = authService.currentUser;
    if (user == null) {
      _showError('Erreur d\'authentification');
      return;
    }
    
    final firstName = _firstNameController.text.trim();
    
    setState(() => _isProcessing = true);
    
    try {
      // Créer le produit pour le paiement
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? 'Abonnement Cycle Santé 1 an',
        priceFcfa: widget.plan.priceFcfa,
      );

      final birthDate = _birthdate!;
      
      // Lancer le paiement via PaymentManager
      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: PaymentProvider.kkiapay,
        customerEmail: user.email,
        customerName: firstName,
        callback: (success, purchase, error) async {
          debugPrint('>>> Health Cycle payment callback: success=$success, error=$error');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            debugPrint('>>> Payment success, creating subscription...');
            
            try {
              // Créer l'abonnement
              await HealthCycleService.instance.createSubscription(
                userId: user.id,
                userName: firstName,
                birthDate: birthDate,
                paymentId: purchase.id,
              );
              
              if (!mounted) return;
              setState(() => _isProcessing = false);
              
              // Naviguer vers le rapport
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HealthCycleReportScreen(
                      userName: firstName,
                      birthDate: birthDate,
                    ),
                  ),
                );
              }
            } catch (e) {
              debugPrint('>>> Subscription creation error: $e');
              if (mounted && context.mounted) {
                // Paiement réussi mais erreur de création d'abonnement - naviguer quand même
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HealthCycleReportScreen(
                      userName: firstName,
                      birthDate: birthDate,
                    ),
                  ),
                );
              }
            }
          } else {
            if (mounted) {
              setState(() => _isProcessing = false);
              _showError(error ?? 'Paiement échoué');
            }
          }
        },
      );
    } catch (e) {
      _showError('Erreur: $e');
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
