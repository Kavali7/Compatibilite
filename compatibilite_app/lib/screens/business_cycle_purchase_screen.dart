import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../widgets/animated_background.dart';
import '../services/pricing_service.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../services/business_cycle_service.dart';
import '../services/payment/payment_manager.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import 'business_cycle_report_screen.dart';
import 'auth/login_page.dart';

class BusinessCyclePurchaseScreen extends StatefulWidget {
  final PricingPlan plan;

  const BusinessCyclePurchaseScreen({
    super.key,
    required this.plan,
  });

  @override
  State<BusinessCyclePurchaseScreen> createState() => _BusinessCyclePurchaseScreenState();
}

class _BusinessCyclePurchaseScreenState extends State<BusinessCyclePurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  
  PaymentProvider _selectedPaymentMethod = PaymentProvider.kkiapay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year - 5;
    _selectedMonth = now.month;
    _selectedDay = now.day;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  DateTime? get _selectedDate {
    if (_selectedYear != null && _selectedMonth != null && _selectedDay != null) {
      final maxDay = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
      final day = _selectedDay! > maxDay ? maxDay : _selectedDay!;
      return DateTime(_selectedYear!, _selectedMonth!, day);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond animé
          AnimatedBackground(
            starCount: 100,
            showOrbs: true,
            child: Container(),
          ),
          
          // Contenu
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildIntroCard(),
                          const SizedBox(height: 24),
                          _buildFeaturesCard(),
                          const SizedBox(height: 24),
                          _buildPlanSummary(),
                          const SizedBox(height: 24),
                          _buildFormSection(),
                          const SizedBox(height: 24),
                          _buildPaymentMethodSelection(),
                          const SizedBox(height: 32),
                          _buildPayButton(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Cycle Business',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_center,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Votre Cycle Business Annuel',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Découvrez les phases stratégiques de votre année d\'affaires pour optimiser vos décisions entrepreneuriales.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
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
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Text(
                'Inclus dans votre abonnement',
                style: GoogleFonts.philosopher(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(Icons.timeline, 'Calendrier de vos périodes stratégiques'),
          _buildFeatureItem(Icons.trending_up, 'Actions recommandées par période'),
          _buildFeatureItem(Icons.warning_amber, 'Risques à éviter'),
          _buildFeatureItem(Icons.analytics, 'Indicateurs clés à surveiller'),
          _buildFeatureItem(Icons.check_circle, 'Décisions favorables / défavorables'),
          _buildFeatureItem(Icons.lightbulb, 'Astuces stratégiques'),
          _buildFeatureItem(Icons.refresh, 'Accès illimité pendant 1 an'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.withValues(alpha: 0.8), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    final formattedPrice = CurrencyService.instance.formatAmount(widget.plan.priceFcfa);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Récapitulatif',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Abonnement', style: TextStyle(color: AppColors.textMuted)),
              Text('Cycle Business Annuel', style: TextStyle(color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Durée', style: TextStyle(color: AppColors.textMuted)),
              Text('365 jours', style: TextStyle(color: AppColors.textLight)),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                formattedPrice,
                style: GoogleFonts.philosopher(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
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
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de l\'entreprise',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Nom de l'entreprise
          TextFormField(
            controller: _companyNameController,
            style: const TextStyle(color: AppColors.textLight),
            decoration: InputDecoration(
              labelText: 'Nom de l\'entreprise',
              labelStyle: TextStyle(color: AppColors.textMuted),
              prefixIcon: Icon(Icons.business, color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green),
              ),
              filled: true,
              fillColor: AppColors.background.withValues(alpha: 0.5),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez entrer le nom de l\'entreprise';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Date de référence
          Text(
            'Date de création de l\'entreprise',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Text(
            '(ou anniversaire du dirigeant si entreprise unipersonnelle)',
            style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7), fontSize: 12),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              // Année
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  value: _selectedYear,
                  decoration: InputDecoration(
                    labelText: 'Année',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withValues(alpha: 0.5),
                  ),
                  dropdownColor: AppColors.block,
                  style: TextStyle(color: AppColors.textLight),
                  items: List.generate(50, (i) => DateTime.now().year - i)
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedYear = value),
                  validator: (value) => value == null ? 'Requis' : null,
                ),
              ),
              const SizedBox(width: 12),
              
              // Mois
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int>(
                  value: _selectedMonth,
                  decoration: InputDecoration(
                    labelText: 'Mois',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withValues(alpha: 0.5),
                  ),
                  dropdownColor: AppColors.block,
                  style: TextStyle(color: AppColors.textLight),
                  items: List.generate(12, (i) => i + 1)
                      .map((month) => DropdownMenuItem(
                            value: month,
                            child: Text(DateFormat.MMM('fr_FR').format(DateTime(2024, month))),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedMonth = value),
                  validator: (value) => value == null ? 'Requis' : null,
                ),
              ),
              const SizedBox(width: 12),
              
              // Jour
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  value: _selectedDay,
                  decoration: InputDecoration(
                    labelText: 'Jour',
                    labelStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withValues(alpha: 0.5),
                  ),
                  dropdownColor: AppColors.block,
                  style: TextStyle(color: AppColors.textLight),
                  items: List.generate(31, (i) => i + 1)
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text('$day'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedDay = value),
                  validator: (value) => value == null ? 'Requis' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mode de paiement',
            style: GoogleFonts.philosopher(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // KKiapay
          _buildPaymentOption(
            value: PaymentProvider.kkiapay,
            title: 'KKiapay',
            subtitle: 'Mobile Money, Carte bancaire',
            icon: Icons.account_balance_wallet,
          ),
          const SizedBox(height: 12),
          
          // FedaPay
          _buildPaymentOption(
            value: PaymentProvider.fedapay,
            title: 'FedaPay',
            subtitle: 'Mobile Money, Carte bancaire',
            icon: Icons.payment,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentProvider value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    // Afficher FCFA si le prix converti est trop petit
    final priceFcfa = widget.plan.priceFcfa;
    String formattedPrice;
    if (priceFcfa < 100 && !CurrencyService.instance.isFcfa) {
      // Pour les petits montants (test), afficher en FCFA
      formattedPrice = '$priceFcfa FCFA';
    } else {
      formattedPrice = CurrencyService.instance.formatAmount(priceFcfa);
    }
    
    return ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
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
    
    final authService = AuthService.instance;
    
    // Vérifier connexion
    if (!authService.isLoggedIn) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      if (result != true) return;
    }
    
    final userId = authService.currentUser?.id;
    if (userId == null) {
      _showError('Erreur d\'authentification');
      return;
    }
    
    final companyName = _companyNameController.text.trim();
    final referenceDate = _selectedDate;
    
    if (referenceDate == null) {
      _showError('Veuillez sélectionner une date valide');
      return;
    }
    
    setState(() => _isProcessing = true);
    
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        _showError('Veuillez vous connecter pour continuer');
        setState(() => _isProcessing = false);
        return;
      }

      // Créer le produit pour le paiement
      final product = Product(
        id: widget.plan.id,
        type: ProductType.cyclesVie,
        name: widget.plan.name,
        description: widget.plan.description ?? 'Abonnement Cycle Business 1 an',
        priceFcfa: widget.plan.priceFcfa,
      );

      // Lancer le paiement via PaymentManager
      PaymentManager.instance.processPurchaseWithCallback(
        context: context,
        userId: user.id,
        product: product,
        provider: _selectedPaymentMethod,
        customerEmail: user.email ?? '',
        customerName: companyName,
        callback: (success, purchase, error) async {
          debugPrint('>>> Business Cycle payment callback: success=$success, error=$error');
          
          if (!mounted) return;
          
          if (success && purchase != null) {
            debugPrint('>>> Payment success, creating subscription...');
            
            try {
              // Créer l'abonnement
              await BusinessCycleService.instance.createSubscription(
                userId: user.id,
                companyName: companyName,
                referenceDate: referenceDate,
                paymentId: purchase.id,
              );
              
              if (!mounted) return;
              setState(() => _isProcessing = false);
              
              // Naviguer vers le rapport
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BusinessCycleReportScreen(
                    companyName: companyName,
                    referenceDate: referenceDate,
                  ),
                ),
              );
            } catch (e) {
              debugPrint('>>> Subscription creation error: $e');
              if (mounted) {
                // Paiement réussi mais erreur de création d'abonnement
                // On navigue quand même vers le rapport car le paiement est ok
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BusinessCycleReportScreen(
                      companyName: companyName,
                      referenceDate: referenceDate,
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
