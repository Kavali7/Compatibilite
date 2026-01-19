import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../services/temporal_report_service.dart';
import '../services/auth_service.dart';
import '../services/kkiapay_service.dart';
import '../services/pricing_service.dart';
import '../services/app_settings_service.dart';
import '../services/payment/fedapay_gateway.dart';
import '../services/payment/payment_gateway.dart';
import '../core/constants.dart';
import 'auth/login_page.dart';
import 'auth/simple_signup_screen.dart';
import 'purchase_history_screen.dart';
import '../widgets/animated_background.dart';
import '../widgets/hamburger_menu_overlay.dart';

/// Screen for purchasing temporal predictions (year, month, day)
class TemporalPurchaseScreen extends StatefulWidget {
  const TemporalPurchaseScreen({super.key});

  @override
  State<TemporalPurchaseScreen> createState() => _TemporalPurchaseScreenState();
}

class _TemporalPurchaseScreenState extends State<TemporalPurchaseScreen> {
  String _selectedPeriod = 'jour'; // 'jour', 'mois', 'annee'
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate; // For ranges
  bool _isRange = false;
  bool _isProcessingPayment = false;
  bool _isLoadingPrices = true;
  bool _isMenuOpen = false;
  
  // Couple profile state
  bool _hasCoupleProfile = false;
  bool _isCheckingProfile = true;
  bool _showCoupleForm = false;
  
  // Couple info form controllers
  final _userNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  DateTime? _userBirthdate;
  DateTime? _partnerBirthdate;
  String _userGender = 'Autre';
  String _partnerGender = 'Autre';

  // Pricing (in FCFA) - loaded from database, null if not configured
  int? _priceDayFcfa;
  int? _priceMonthFcfa;
  int? _priceYearFcfa;

  @override
  void initState() {
    super.initState();
    _loadPricesFromDatabase();
    _checkCoupleProfile();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _partnerNameController.dispose();
    super.dispose();
  }

  Future<void> _checkCoupleProfile() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() {
        _hasCoupleProfile = false;
        _isCheckingProfile = false;
      });
      return;
    }

    try {
      final hasProfile = await TemporalReportService.instance.hasCoupleProfile();
      if (mounted) {
        setState(() {
          _hasCoupleProfile = hasProfile;
          _isCheckingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking couple profile: $e');
      if (mounted) {
        setState(() => _isCheckingProfile = false);
      }
    }
  }

  Future<void> _loadPricesFromDatabase() async {
    try {
      final pricingService = PricingService.instance;
      await pricingService.fetchPlans();
      
      // Look for temporal pricing plans
      for (final plan in pricingService.plans) {
        final planType = plan.planType.toLowerCase();
        if (planType.contains('jour') && planType.contains('temporel')) {
          _priceDayFcfa = plan.priceFcfa;
        } else if (planType.contains('mois') && planType.contains('temporel')) {
          _priceMonthFcfa = plan.priceFcfa;
        } else if ((planType.contains('annee') || planType.contains('année')) && planType.contains('temporel')) {
          _priceYearFcfa = plan.priceFcfa;
        }
      }
      
      debugPrint('TemporalPurchaseScreen: Loaded prices - Day: $_priceDayFcfa, Month: $_priceMonthFcfa, Year: $_priceYearFcfa');
    } catch (e) {
      debugPrint('TemporalPurchaseScreen: Error loading prices: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPrices = false);
      }
    }
  }

  int? get _basePrice {
    switch (_selectedPeriod) {
      case 'annee':
        return _priceYearFcfa;
      case 'mois':
        return _priceMonthFcfa;
      case 'jour':
      default:
        return _priceDayFcfa;
    }
  }

  bool get _isPriceConfigured => _basePrice != null;

  int get _totalPrice {
    final base = _basePrice;
    if (base == null) return 0;
    if (!_isRange || _endDate == null) return base;
    
    // Calculate range price
    final days = _endDate!.difference(_selectedDate).inDays + 1;
    switch (_selectedPeriod) {
      case 'mois':
        // Count months in range
        final months = ((_endDate!.year - _selectedDate.year) * 12 + 
            _endDate!.month - _selectedDate.month) + 1;
        return (_priceMonthFcfa ?? 0) * months;
      case 'jour':
        return (_priceDayFcfa ?? 0) * days;
      default:
        return base;
    }
  }

  List<String> get _includedBonuses {
    final bonuses = <String>[];
    switch (_selectedPeriod) {
      case 'annee':
        bonuses.add('Prévision du mois en cours');
        bonuses.add('Prévision d\'aujourd\'hui');
        break;
      case 'mois':
        bonuses.add('Prévision d\'aujourd\'hui');
        break;
      case 'jour':
        if (_isRange && _endDate != null) {
          final days = _endDate!.difference(_selectedDate).inDays + 1;
          // Bonus: si 15+ jours achetés, le mois est offert
          if (days >= 15) {
            bonuses.add('Prévision du mois concerné (bonus 15+ jours)');
          }
        }
        break;
    }
    return bonuses;
  }

  String get _periodLabel {
    switch (_selectedPeriod) {
      case 'annee':
        return 'Année ${_selectedDate.year}';
      case 'mois':
        final months = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin',
            'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
        if (_isRange && _endDate != null) {
          return '${months[_selectedDate.month - 1]} - ${months[_endDate!.month - 1]} ${_selectedDate.year}';
        }
        return '${months[_selectedDate.month - 1]} ${_selectedDate.year}';
      case 'jour':
      default:
        if (_isRange && _endDate != null) {
          return '${_selectedDate.day}/${_selectedDate.month} - ${_endDate!.day}/${_endDate!.month}/${_selectedDate.year}';
        }
        return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 60, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Prévisions Temporelles',
                            style: GoogleFonts.philosopher(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: _showCoupleForm
                        ? _buildCoupleProfileForm()
                        : _buildMainContent(),
                  ),
                ],
              ),
            ),
            // Hamburger menu
            HamburgerMenuOverlay(
              isOpen: _isMenuOpen,
              onToggle: _toggleMenu,
              entries: _buildMenuEntries(),
              isDark: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Choisissez votre prévision',
            style: GoogleFonts.philosopher(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Anticipez les énergies de votre couple pour mieux naviguer ensemble.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          
          const SizedBox(height: 24),
          
          // Period selector
          _buildPeriodSelector(),
          
          const SizedBox(height: 20),
          
          // Date picker
          _buildDatePicker(),
          
          const SizedBox(height: 20),
          
          // Range toggle (for month/day)
          if (_selectedPeriod != 'annee') _buildRangeToggle(),
          
          const SizedBox(height: 24),
          
          // Summary card
          _buildSummaryCard(),
          
          const SizedBox(height: 24),
          
          // Purchase button
          _buildPurchaseButton(),
          
          const SizedBox(height: 16),
          
          // Payment info
          const Center(
            child: Text(
              'Paiement sécurisé par Kkiapay',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoupleProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.block.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Votre Profil',
                  style: GoogleFonts.philosopher(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pour générer votre prévision, nous avons besoin de vos informations personnelles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Your info section
          _buildSectionTitle('Vos informations'),
          const SizedBox(height: 12),
          _buildNameField(_userNameController, 'Votre prénom'),
          const SizedBox(height: 12),
          _buildDatePickerField(
            label: 'Votre date de naissance',
            value: _userBirthdate,
            onPicked: (date) => setState(() => _userBirthdate = date),
          ),
          const SizedBox(height: 12),
          _buildGenderSelector(
            value: _userGender,
            onChanged: (val) => setState(() => _userGender = val),
          ),

          const SizedBox(height: 24),

          // Section partenaire supprimée - Prévisions temporelles = 1 personne uniquement
          // Les prévisions sont personnelles et ne nécessitent que les infos du consultant

          const SizedBox(height: 32),

          // Submit buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _showCoupleForm = false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    side: const BorderSide(color: AppColors.textMuted),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _createCoupleProfileAndPay,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessingPayment
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Continuer vers le paiement',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
    );
  }

  Widget _buildNameField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppColors.textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.block.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? value,
    required Function(DateTime) onPicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime(1990, 1, 1),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  surface: AppColors.block,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.block.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value != null
                    ? '${value.day}/${value.month}/${value.year}'
                    : label,
                style: TextStyle(
                  color: value != null ? AppColors.textLight : AppColors.textMuted,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector({
    required String value,
    required Function(String) onChanged,
  }) {
    final options = ['Homme', 'Femme', 'Autre'];
    return Row(
      children: options.map((option) {
        final isSelected = value == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: EdgeInsets.only(right: option != options.last ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.block.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _buildPeriodTab('Jour', 'jour', Icons.today),
          _buildPeriodTab('Mois', 'mois', Icons.date_range),
          _buildPeriodTab('Année', 'annee', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, String value, IconData icon) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedPeriod = value;
          _isRange = false;
          _endDate = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isRange ? 'Date de début' : 'Date',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDate(isStart: true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _periodLabel,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          if (_isRange) ...[
            const SizedBox(height: 12),
            Text(
              'Date de fin',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(isStart: false),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _endDate != null 
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : 'Sélectionner...',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeToggle() {
    return GestureDetector(
      onTap: () => setState(() {
        _isRange = !_isRange;
        if (!_isRange) _endDate = null;
      }),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _isRange 
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.block.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isRange ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _isRange ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isRange ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPeriod == 'mois' 
                        ? 'Sélectionner plusieurs mois' 
                        : 'Sélectionner plusieurs jours',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _isRange ? AppColors.primary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Activez pour choisir une plage',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final bonuses = _includedBonuses;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Récapitulatif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Selected period
          _buildSummaryRow(
            icon: Icons.event,
            label: 'Période sélectionnée',
            value: _periodLabel,
          ),
          
          const SizedBox(height: 12),
          
          // Bonuses
          if (bonuses.isNotEmpty) ...[
            const Divider(color: AppColors.textMuted),
            const SizedBox(height: 8),
            const Text(
              '🎁 Bonus inclus',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...bonuses.map((bonus) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bonus, style: const TextStyle(fontSize: 13))),
                ],
              ),
            )),
            const SizedBox(height: 8),
            const Divider(color: AppColors.textMuted),
          ],
          
          const SizedBox(height: 12),
          
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_totalPrice FCFA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    if (_isProcessingPayment) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              'Traitement en cours...',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: _initiatePurchase,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Acheter pour $_totalPrice FCFA',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    DateTime firstDate;
    DateTime initialDate;
    
    if (_selectedPeriod == 'annee') {
      firstDate = DateTime(now.year);
      initialDate = DateTime(_selectedDate.year);
    } else {
      firstDate = now;
      initialDate = isStart ? _selectedDate : (_endDate ?? _selectedDate);
    }
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.block,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _initiatePurchase() {
    // Check if user is logged in
    final user = AuthService.instance.currentUser;
    if (user == null) {
      _showLoginRequired();
      return;
    }

    // Check if couple profile exists
    if (!_hasCoupleProfile) {
      setState(() => _showCoupleForm = true);
      return;
    }

    _proceedWithPayment(user.id);
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.block,
        title: const Text('Connexion requise', style: TextStyle(color: AppColors.textLight)),
        content: const Text(
          'Veuillez créer un compte ou vous connecter pour effectuer cet achat.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SimpleSignupScreen()),
              );
              if (result == true) {
                _checkCoupleProfile();
              }
            },
            child: const Text('Créer un compte'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
              if (result == true) {
                _checkCoupleProfile();
              }
            },
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  Future<void> _createCoupleProfileAndPay() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;

    // Validate form (User only for temporal reports)
    if (_userNameController.text.trim().isEmpty || _userBirthdate == null) {
      _showSnack('Veuillez remplir vos informations de profil.');
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      // Create profile (using one person logic: partner is ignored but required by API)
      final createdId = await TemporalReportService.instance.createCoupleProfile(
        userFirstname: _userNameController.text.trim(),
        userBirthdate: _userBirthdate!,
        userGender: _userGender,
        partnerFirstname: 'Consultant', // Default for 1-person temporal reports
        partnerBirthdate: DateTime(1900, 1, 1),
        partnerGender: 'Autre',
        userId: user.id,
      );

      if (createdId != null) {
        setState(() {
          _hasCoupleProfile = true;
          _showCoupleForm = false;
        });
        // Now proceed with payment
        _proceedWithPayment(user.id);
      } else {
        setState(() => _isProcessingPayment = false);
        _showSnack('Erreur lors de la création de votre profil.');
      }
    } catch (e) {
      setState(() => _isProcessingPayment = false);
      _showSnack('Erreur: ${e.toString()}');
    }
  }

  void _proceedWithPayment(String userId) {
    if (!_isPriceConfigured) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.block,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Moyen de Paiement',
              style: GoogleFonts.philosopher(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sélectionnez votre méthode préférée pour finaliser votre commande.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 32),
            _buildPaymentMethodTile(
              'Kkiapay',
              'Cartes, Mobile Money (Bénin, Togo...)',
              'assets/images/kkiapay_logo.png',
              () {
                Navigator.pop(ctx);
                _handleKkiapayPayment(userId);
              },
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(
              'FedaPay',
              'Mobile Money, Cartes (Afrique de l\'Ouest)',
              'assets/images/fedapay_logo.png',
              () {
                Navigator.pop(ctx);
                _handleFedapayPayment(userId);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(String title, String subtitle, String assetPath, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E3B48),
            const Color(0xFF142933).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, o, s) => const Icon(Icons.payment, color: AppColors.primary, size: 30),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.philosopher(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleKkiapayPayment(String userId) {
    setState(() => _isProcessingPayment = true);
    KkiapayService.instance.startPayment(
      context: context,
      amount: _totalPrice,
      reason: 'Prévision $_selectedPeriod - $_periodLabel',
      callback: (success, transactionId, error) async {
        if (success && transactionId != null) {
          _onPaymentSuccess(userId, transactionId, 'kkiapay');
        } else {
          setState(() => _isProcessingPayment = false);
          _showSnack(error ?? 'Paiement échoué.');
        }
      },
    );
  }

  void _handleFedapayPayment(String userId) {
    final user = AuthService.instance.currentUser;
    setState(() => _isProcessingPayment = true);
    FedapayGateway.instance.initiatePayment(
      context: context,
      amountFcfa: _totalPrice,
      reason: 'Prévision $_selectedPeriod - $_periodLabel',
      customerEmail: user?.email ?? 'client@growpeak.agence',
      customerName: _userNameController.text,
      callback: (result) async {
        if (result.success && result.transactionId != null) {
          _onPaymentSuccess(userId, result.transactionId!, 'fedapay');
        } else {
          setState(() => _isProcessingPayment = false);
          _showSnack(result.errorMessage ?? 'Paiement annulé ou échoué.');
        }
      },
    );
  }

  Future<void> _onPaymentSuccess(String userId, String transactionId, String paymentMethod) async {
    try {
      // 1. Record payment in database
      await KkiapayService.instance.recordPayment(
        userId: userId,
        sessionId: null, // Not a compatibility session
        transactionId: transactionId,
        amountFcfa: _totalPrice,
        status: PaymentStatus.success,
        planType: 'temporel_$_selectedPeriod',
        paymentMethod: paymentMethod,
      );

      // 2. Generate the report
      final service = TemporalReportService.instance;
      final report = await service.generateReport(
        periode: _selectedPeriod,
        date: _selectedDate,
        userId: userId,
      );
      
      if (mounted) {
        setState(() => _isProcessingPayment = false);
        
        if (report != null) {
          _showSnack('Paiement réussi ! Votre prévision est prête.');
          Navigator.pop(context, report);
        } else {
          _showSnack('Erreur lors de la génération du rapport.');
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isProcessingPayment = false);
      _showSnack('Erreur: ${e.toString()}');
    }
  }

  void _toggleMenu() => setState(() => _isMenuOpen = !_isMenuOpen);

  List<MenuEntry> _buildMenuEntries() {
    return [
      // Mes achats - Historique
      MenuEntry(
        label: 'Mes achats',
        onTap: () async {
          if (AuthService.instance.isLoggedIn) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
            );
          } else {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) {
              if (mounted) Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
              );
            }
          }
        },
      ),
      if (!AuthService.instance.isLoggedIn) ...[
        MenuEntry(
          label: 'Se connecter',
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) _checkCoupleProfile();
          },
        ),
        MenuEntry(
          label: 'Créer un compte',
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SimpleSignupScreen()),
            );
            if (result == true) _checkCoupleProfile();
          },
        ),
      ],

      if (AuthService.instance.isLoggedIn)
        MenuEntry(
          label: 'Se déconnecter',
          onTap: () {
            AuthService.instance.signOut();
            setState(() {
              _hasCoupleProfile = false;
              _showCoupleForm = false;
            });
            _showSnack('Vous êtes déconnecté.');
          },
        ),

      MenuEntry(label: 'Contacter Growpeak', onTap: () => _launchUri(_supportEmailUri)),
      MenuEntry(label: 'WhatsApp Growpeak', onTap: () => _launchWhatsApp()),
      MenuEntry(label: 'Appeler Growpeak', onTap: () => _launchUri(_supportPhoneUri)),
    ];
  }

  // Dynamic support links helpers
  String get _supportEmail => AppSettingsService.instance.contactEmail;
  String get _supportWhatsApp => AppSettingsService.instance.contactWhatsApp;

  Uri get _supportEmailUri => Uri(
        scheme: 'mailto',
        path: _supportEmail,
        queryParameters: {'subject': 'Support Growpeak Agence'},
      );

  Uri get _supportPhoneUri => Uri(scheme: 'tel', path: _supportWhatsApp); // Using WhatsApp number as phone too or separate if needed

  Future<void> _launchWhatsApp() async {
    final phone = _supportWhatsApp.replaceAll(' ', '').replaceAll('+', '');
    final url = Uri.parse("https://wa.me/$phone");
    await _launchUri(url);
  }

  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showSnack('Impossible d\'ouvrir ce lien pour le moment.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
