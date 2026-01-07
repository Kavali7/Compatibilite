import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/compatibility_models.dart';
import '../models/legal_models.dart'; // Added
import '../services/numerology_service.dart';
import '../services/compatibility_repository.dart';
import '../services/supabase_manager.dart';
import '../services/auth_service.dart';
import '../services/pricing_service.dart';
import '../services/kkiapay_service.dart';
import '../services/temporal_report_service.dart';
import '../services/legal_repository.dart'; // Added
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/hamburger_menu_overlay.dart';
import '../widgets/selectable_card.dart';
import '../widgets/temporal_report_card.dart';
import 'dynamic_legal_page.dart'; // Added
// legal_page.dart removed - using dynamic_legal_page.dart and legal_models.dart instead

import 'temporal_purchase_screen.dart';
import 'login_page.dart';
import 'simple_signup_screen.dart';

// ===========================================
// DEBUG: Mettre à true pour bypasser le paiement
// IMPORTANT: Remettre à false avant la production!
// ===========================================
const bool kDebugBypassPayment = false;


class CompatibilityWizard extends StatefulWidget {
  const CompatibilityWizard({super.key});

  @override
  State<CompatibilityWizard> createState() => _CompatibilityWizardState();
}

class _CompatibilityWizardState extends State<CompatibilityWizard> {
  final PageController _pageController = PageController();
  final _namesFormKey = GlobalKey<FormState>();
  final _nameAController = TextEditingController();
  final _nameBController = TextEditingController();
  final _durationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final NumerologyService _service = NumerologyService();
  CompatibilityRepository? _repository;

  int _currentStep = 0;
  DateTime? _birthA;
  DateTime? _birthB;
  DateTime? _meetingDate;
  int? _yearA;
  int? _monthA;
  int? _dayA;
  int? _yearB;
  int? _monthB;
  int? _dayB;
  String? _relationStatus;
  final Set<String> _challenges = {};
  bool _wantsNotifications = true;
  CompatibilitySummary? _summary;
  PartnerInput? _partnerAInput;
  PartnerInput? _partnerBInput;
  bool _isSaving = false;
  String? _saveError;
  String? _sessionId;
  String? _clientToken;
  bool _isMenuOpen = false;
  bool _paymentCompleted = false;
  bool _isProcessingPayment = false;
  String _selectedPlanType = 'consultation';
  PricingPlan? _selectedPlan;
  String? _genderA; // Gender for partner A: 'Homme', 'Femme', 'Autre'
  String? _genderB; // Gender for partner B: 'Homme', 'Femme', 'Autre'
  
  // Temporal reports state
  TemporalReport? _yearReport;
  TemporalReport? _monthReport;
  TemporalReport? _dayReport;
  bool _isLoadingReports = false;
  String? _reportsError;
  List<LegalPage> _legalPages = []; // Dynamic legal pages
  
  // Email verification state
  bool _isCheckingEmail = false;
  bool _emailExists = false;
  String? _emailCheckError;


  static const _supportEmail = 'growpeak.agence@gmail.com';
  static const _supportPhone = '0022654255584';

  static const _totalSteps = 7; // Welcome, Names, BirthA, BirthB, Context, Contact, Results
  static const _challengeOptions = [
    'Communication',
    'Confiance',
    'Finances',
    'Jalousie',
    'Organisation',
  ];
  static const _relationStatuses = [
    'En couple',
    'Mariée',
    'Fiancée',
    'Relation complexe',
    'Célibataire curieux/se',
  ];
  static const _genderOptions = ['Homme', 'Femme', 'Autre'];

  @override
  void initState() {
    super.initState();
    if (SupabaseManager.isReady) {
      _repository = CompatibilityRepository(SupabaseManager.client);
    }
    // Load pricing plans
    PricingService.instance.fetchPlans().then((_) {
      if (mounted) {
        setState(() {
          try {
            _selectedPlan = PricingService.instance.consultationPlan;
          } catch (e) {
            debugPrint('Plan par défaut non trouvé: $e');
          }
        });
      }
    });
    
    // Check for existing session/profile
    _checkSession();
    
    // Load dynamic legal pages
    _loadLegalPages();
  }
  
  Future<void> _loadLegalPages() async {
    try {
      final pages = await LegalRepository.instance.getActivePages();
      if (mounted) {
        setState(() {
          _legalPages = pages;
        });
      }
    } catch (e) {
      debugPrint('Error loading legal pages: $e');
    }
  }

  Future<void> _checkSession() async {
    // If not logged in, nothing to restore
    if (!AuthService.instance.isLoggedIn) return;

    final user = AuthService.instance.currentUser;
    if (user == null) return;

    debugPrint('Wizard: Found active user session ${user.id}, attempting to restore profile...');
    
    // Try to fetch couple profile
    try {
      final client = SupabaseManager.client;
      final profile = await client
          .from('couple_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile != null) {
        debugPrint('Wizard: Profile found, restoring state...');
        // Restore state
        setState(() {
          _nameAController.text = profile['user_firstname'] ?? '';
          _birthA = DateTime.parse(profile['user_birthdate']);
          _genderA = _mapGenderFromDb(profile['user_gender']);
          
          _nameBController.text = profile['partner_firstname'] ?? '';
          _birthB = DateTime.parse(profile['partner_birthdate']);
          _genderB = _mapGenderFromDb(profile['partner_gender']);
          
          // Populate partner inputs for reports
          _partnerAInput = PartnerInput(name: _nameAController.text, birthDate: _birthA!, role: 'Partenaire 1');
          _partnerBInput = PartnerInput(name: _nameBController.text, birthDate: _birthB!, role: 'Partenaire 2');
          
          // Recompute summary
          _summary = _service.buildSummary(_partnerAInput!, _partnerBInput!);
          
          // Mark payment as done if user has subscription
          _paymentCompleted = user.hasActiveSubscription;
        });

        // If we have data, jump to results
        // Wait a bit for the UI to build
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _loadTemporalReports();
            setState(() => _currentStep = _totalSteps - 1); // Jump to results
            _pageController.jumpToPage(_totalSteps - 1);
          }
        });
      }
    } catch (e) {
      debugPrint('Wizard: Error restoring session: $e');
    }
  }

  String? _mapGenderFromDb(String? dbGender) {
    if (dbGender == null) return 'Autre';
    switch (dbGender) {
      case 'homme': return 'Homme';
      case 'femme': return 'Femme';
      default: return 'Autre';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameAController.dispose();
    _nameBController.dispose();
    _durationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    if (_isSaving || _isProcessingPayment) return;
    if (!_validateCurrentStep()) return;
    
    // Step 4 (Context) -> Step 5 (Contact): Prepare summary
    if (_currentStep == 4) {
      _computeSummary();
    }
    
    // Step 5 (Contact): Payment is handled by the button directly via _initiatePayment
    // This function is NOT called for step 5 when clicking "Voir mes résultats"
    // But handle edge case where user has subscription and can skip payment
    if (_currentStep == 5 && !_paymentCompleted) {
      // Check for active subscription - if yes, skip payment
      final email = _emailController.text.trim();
      final hasSubscription = await AuthService.instance.hasActiveSubscription(email);
      if (hasSubscription) {
        _paymentCompleted = true;
        await _saveSessionIfPossible();
        
        // Authenticate user if not already
        if (!AuthService.instance.isLoggedIn) {
          final password = _passwordController.text;
          await AuthService.instance.signIn(email: email, password: password);
        }
        
        if (AuthService.instance.isLoggedIn) {
          await _saveCoupleProfile();
        }
        
        _loadTemporalReports();
        // Continue to results
      } else {
        // No subscription, payment required - but this shouldn't happen
        // since button calls _initiatePayment directly
        return;
      }
    }
    
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep += 1;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Load temporal reports (year, month, day) for the current couple
  /// Only loads reports that are enabled as bonuses in app_settings
  /// This method is "best effort" - it won't block results if it fails
  Future<void> _loadTemporalReports() async {
    debugPrint('_loadTemporalReports: Starting...');
    
    // Early exit conditions - just skip silently, don't block results
    if (!SupabaseManager.isReady) {
      debugPrint('_loadTemporalReports: Supabase not ready, skipping bonus reports');
      return;
    }
    if (_partnerAInput == null || _partnerBInput == null) {
      debugPrint('_loadTemporalReports: Partner inputs null, skipping bonus reports');
      return;
    }
    if (_birthA == null || _birthB == null) {
      debugPrint('_loadTemporalReports: Birth dates null, skipping bonus reports');
      return;
    }
    
    setState(() {
      _isLoadingReports = true;
      _reportsError = null;
    });
    
    try {
      final service = TemporalReportService.instance;
      
      // Get userId from custom AuthService (not supabase.auth)
      final authUser = AuthService.instance.currentUser;
      if (authUser == null) {
        debugPrint('_loadTemporalReports: No authenticated user, bonus reports unavailable');
        if (mounted) {
          setState(() {
            _reportsError = 'Connectez-vous pour voir les prévisions temporelles.';
            _isLoadingReports = false;
          });
        }
        return; // Don't block - just show warning
      }
      
      // Create or update couple profile first
      debugPrint('_loadTemporalReports: Creating couple profile for user ${authUser.id}...');
      bool profileCreated = false;
      try {
        profileCreated = await service.createCoupleProfile(
          userFirstname: _nameAController.text.trim(),
          userBirthdate: _birthA!,
          userGender: _genderA ?? 'Autre',
          partnerFirstname: _nameBController.text.trim(),
          partnerBirthdate: _birthB!,
          partnerGender: _genderB ?? 'Autre',
          userId: authUser.id,
        );
      } catch (profileError) {
        debugPrint('_loadTemporalReports: Error creating profile: $profileError');
        // Continue anyway - profile might already exist
        profileCreated = true; 
      }
      debugPrint('_loadTemporalReports: Profile created: $profileCreated');
      
      if (!profileCreated) {
        debugPrint('_loadTemporalReports: Profile not created, using existing or skipping');
        // Don't block - try to fetch reports anyway, profile might exist
      }
      
      // Fetch bonus reports (respects app_settings configuration)
      debugPrint('>>> _loadTemporalReports: Fetching bonus reports for user ${authUser.id}...');
      debugPrint('>>> _loadTemporalReports: Calling getBonusReports...');
      final bonusReports = await service.getBonusReports(userId: authUser.id);
      debugPrint('>>> _loadTemporalReports: getBonusReports returned');
      debugPrint('>>> _loadTemporalReports: Received reports - Year: ${bonusReports['annee'] != null}, Month: ${bonusReports['mois'] != null}, Day: ${bonusReports['jour'] != null}');
      debugPrint('>>> _loadTemporalReports: Year report details: ${bonusReports['annee']?.titre ?? "null"}');
      debugPrint('>>> _loadTemporalReports: Month report details: ${bonusReports['mois']?.titre ?? "null"}');
      debugPrint('>>> _loadTemporalReports: Day report details: ${bonusReports['jour']?.titre ?? "null"}');
      
      if (mounted) {
        setState(() {
          _yearReport = bonusReports['annee'];
          _monthReport = bonusReports['mois'];
          _dayReport = bonusReports['jour'];
          _isLoadingReports = false;
          // Clear any previous error if we got at least one report
          if (_yearReport != null || _monthReport != null || _dayReport != null) {
            _reportsError = null;
          }
        });
      }
    } catch (e, stackTrace) {
      debugPrint('_loadTemporalReports: Error: $e');
      debugPrint('_loadTemporalReports: Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _reportsError = 'Prévisions temporelles indisponibles pour le moment.';
          _isLoadingReports = false;
        });
      }
    }
  }


  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        // Try form validation first
        if (_namesFormKey.currentState?.validate() ?? false) {
          // Also check gender selection
          if (_genderA == null) {
            _showSnack('Veuillez indiquer le sexe du partenaire 1.');
            return false;
          }
          if (_genderB == null) {
            _showSnack('Veuillez indiquer le sexe du partenaire 2.');
            return false;
          }
          return true;
        }
        // Fallback: Check controllers manually if form state is issues or just to be safe
        final nameA = _nameAController.text.trim();
        final nameB = _nameBController.text.trim();
        if (nameA.isEmpty || nameB.isEmpty) {
           _showSnack('Veuillez entrer les deux prénoms pour continuer.');
           return false;
        }
        // Check gender selection
        if (_genderA == null) {
          _showSnack('Veuillez indiquer le sexe du partenaire 1.');
          return false;
        }
        if (_genderB == null) {
          _showSnack('Veuillez indiquer le sexe du partenaire 2.');
          return false;
        }
        // If controllers are fine but validate() returned false (or was null),
        // it might be a weird state, but we can trust the text content.
        return true;
      case 2:
        final hasDateA = _birthA != null;
        if (!hasDateA) {
          _showSnack('Choisissez la date du partenaire 1.');
        }
        return hasDateA;
      case 3:
        final hasDateB = _birthB != null;
        if (!hasDateB) {
          _showSnack('Choisissez la date du partenaire 2.');
        }
        return hasDateB;
      case 5:
        final email = _emailController.text.trim();
        final password = _passwordController.text;
        if (email.isEmpty || !_isValidEmail(email)) {
          _showSnack('Entrez un email valide pour recevoir le rapport.');
          return false;
        }
        if (password.isEmpty || password.length < 6) {
          _showSnack('Le mot de passe doit contenir au moins 6 caractères.');
          return false;
        }
        return true;
      case 6:
        // Payment step - always return true here
        // The actual payment check/trigger happens in _goNext()
        return true;
      default:
        return true;
    }
  }

  void _goBack() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _computeSummary() {
    final partnerA = PartnerInput(
      name: _nameAController.text,
      birthDate: _birthA!,
      role: 'Partenaire 1',
    );
    final partnerB = PartnerInput(
      name: _nameBController.text,
      birthDate: _birthB!,
      role: 'Partenaire 2',
    );
    final summary = _service.buildSummary(partnerA, partnerB);
    setState(() {
      _summary = summary;
      _partnerAInput = partnerA;
      _partnerBInput = partnerB;
    });
  }

  Future<void> _saveCoupleProfile() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    
    // Check required fields
    if (_birthA == null || _birthB == null) return;

    try {
      debugPrint('Saving couple profile for user ${user.id}...');
      await TemporalReportService.instance.createCoupleProfile(
        userFirstname: _nameAController.text.trim(),
        userBirthdate: _birthA!,
        userGender: _genderA ?? 'Autre',
        partnerFirstname: _nameBController.text.trim(),
        partnerBirthdate: _birthB!,
        partnerGender: _genderB ?? 'Autre',
        userId: user.id,
      );
      debugPrint('Couple profile saved successfully');
    } catch (e) {
      debugPrint('Error saving couple profile: $e');
    }
  }

  Future<void> _saveSessionIfPossible() async {
    if (_repository == null || _summary == null || _partnerAInput == null || _partnerBInput == null) {
      return;
    }
    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    try {
      final result = await _repository!.saveSession(
        partnerA: _partnerAInput!,
        partnerB: _partnerBInput!,
        summary: _summary!,
        relationStatus: _relationStatus,
        meetingDate: _meetingDate,
        durationText: _durationController.text.trim().isEmpty ? null : _durationController.text.trim(),
        challenges: _challenges.toList(),
        wantsNotifications: _wantsNotifications,
        contactEmail: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        contactPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      setState(() {
        _sessionId = result.sessionId;
        _clientToken = result.clientToken;
      });
    } catch (error) {
      setState(() {
        _saveError = error.toString();
      });
      _showSnack('Impossible d\'enregistrer vos resultats pour le moment.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickMeetingDate() async {
    final now = DateTime.now();
    final initial = _meetingDate ?? DateTime(now.year - 1);
    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.block,
                ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      setState(() => _meetingDate = result);
    }
  }

  void _reset() {
    _nameAController.clear();
    _nameBController.clear();
    _durationController.clear();
    _emailController.clear();
    _phoneController.clear();
    _birthA = null;
    _birthB = null;
    _yearA = null;
    _monthA = null;
    _dayA = null;
    _yearB = null;
    _monthB = null;
    _dayB = null;
    _meetingDate = null;
    _relationStatus = null;
    _genderA = null;
    _genderB = null;
    _challenges.clear();
    _wantsNotifications = true;
    _summary = null;
    _partnerAInput = null;
    _partnerBInput = null;
    _saveError = null;
    _sessionId = null;
    _clientToken = null;
    _isSaving = false;
    setState(() {
      _currentStep = 0;
    });
    _pageController.jumpToPage(0);
  }

  String _formatDate(DateTime? date) => date == null ? 'Sélectionner' : DateFormat('dd/MM/yyyy').format(date);

  int _daysInMonth(int? year, int? month) {
    if (year == null || month == null) return 31;
    final beginningNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    final lastDayCurrentMonth = beginningNextMonth.subtract(const Duration(days: 1)).day;
    return lastDayCurrentMonth;
  }

  void _updateBirthDate(bool isFirst) {
    final year = isFirst ? _yearA : _yearB;
    final month = isFirst ? _monthA : _monthB;
    final day = isFirst ? _dayA : _dayB;
    if (year != null && month != null && day != null) {
      final maxDay = _daysInMonth(year, month);
      if (day > maxDay) {
        if (isFirst) {
          _dayA = null;
          _birthA = null;
        } else {
          _dayB = null;
          _birthB = null;
        }
        return;
      }
      final date = DateTime(year, month, day);
      setState(() {
        if (isFirst) {
          _birthA = date;
        } else {
          _birthB = date;
        }
      });
    }
  }

  void _toggleChallenge(String item) {
    setState(() {
      if (_challenges.contains(item)) {
        _challenges.remove(item);
      } else {
        _challenges.add(item);
      }
    });
  }

  void _toggleMenu() => setState(() => _isMenuOpen = !_isMenuOpen);

  List<MenuEntry> _buildMenuEntries(BuildContext context) {
    return [
      // Account / Login
      if (AuthService.instance.isLoggedIn)
        MenuEntry(
          label: 'Mon Compte',
          onTap: () {
            // TODO: Show account details modal?
            _showSnack('Compte: ${AuthService.instance.currentUser?.email}');
          },
        )
      else
        MenuEntry(
          label: 'Se connecter',
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) {
              // Login successful, restore session
              _checkSession();
            }
          },
        ),
        MenuEntry(
          label: 'Créer un compte',
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SimpleSignupScreen()),
            );
            if (result == true) {
              // Signup successful, restore session
              _checkSession();
            }
          },
        ),
        
      if (AuthService.instance.isLoggedIn)
         MenuEntry(
          label: 'Se déconnecter',
          onTap: () {
            AuthService.instance.signOut();
            setState(() {
               _reset(); // Clear data
            });
            _showSnack('Vous êtes déconnecté.');
          },
        ),

      // Dynamic Legal Pages
      ..._legalPages.map((page) => MenuEntry(
        label: page.title,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DynamicLegalPage(page: page)),
        ),
      )),

      MenuEntry(label: 'Contacter Growpeak', onTap: () => _launchUri(_supportEmailUri)),
      MenuEntry(label: 'Appeler Growpeak', onTap: () => _launchUri(_supportPhoneUri)),
      // Admin menu removed as requested
    ];
  }

  Uri get _supportEmailUri => Uri(
        scheme: 'mailto',
        path: _supportEmail,
        queryParameters: {'subject': 'Support Growpeak Agence'},
      );

  Uri get _supportPhoneUri => Uri(scheme: 'tel', path: _supportPhone);

  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showSnack('Impossible d\'ouvrir ce lien pour le moment.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = _buildHeader();
    final menuEntries = _buildMenuEntries(context);

    // Determine background image based on current step
    String? backgroundImage;
    bool showFullAnimation = false;

    if (_currentStep == 0) {
      // Welcome step
      backgroundImage = 'assets/images/backgrounds/bg_welcome.png';
      showFullAnimation = true;
    } else if (_currentStep == _totalSteps - 1) {
      // Results step
      backgroundImage = 'assets/images/backgrounds/bg_results.png';
      showFullAnimation = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: Background (Independent of content)
          Positioned.fill(
            child: showFullAnimation
                ? AnimatedBackground(
                    backgroundImage: backgroundImage,
                    showStars: true,
                    showOrbs: true,
                    starCount: 40,
                    overlayOpacity: 0.55,
                    child: const SizedBox.shrink(), // Background doesn't hold content anymore
                  )
                : SubtleAnimatedBackground(
                    showStars: true,
                    child: const SizedBox.shrink(),
                  ),
          ),
          
          // Layer 2: Content (Stable widget tree)
          Positioned.fill(
            child: SafeArea(
              child: _buildContent(header, menuEntries),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(Widget header, List<MenuEntry> menuEntries) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: header,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(),
                  _buildNamesStep(),
                  _buildBirthdatesStep(isFirst: true),
                  _buildBirthdatesStep(isFirst: false),
                  _buildContextStep(),
                  _buildContactStep(),
                  _buildResultsStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: _buildNavigation(),
            ),
          ],
        ),
        HamburgerMenuOverlay(
          isOpen: _isMenuOpen,
          onToggle: _toggleMenu,
          entries: menuEntries,
          isDark: true,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 56, left: 8, top: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                'Découvrez si vous êtes faits l’un pour l’autre',
                textAlign: TextAlign.center,
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Parcours en 6 étapes rapides, conçu pour rester fluide.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 14),
        StepProgressIndicator(
          totalSteps: _totalSteps,
          currentStep: _currentStep + 1,
          selectedColor: AppColors.primary,
          unselectedColor: AppColors.block,
          roundedEdges: const Radius.circular(12),
          size: 10,
        ),
        const SizedBox(height: 8),
        Text(
          'Étape ${_currentStep + 1} / $_totalSteps',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    final isLast = _currentStep == _totalSteps - 1;
    if (isLast) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.accentText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _reset,
              child: const Text('Recommencer'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _goBack,
              child: const Text('Retour aux étapes'),
            ),
          ),
        ],
      );
    }

    // Hide navigation on welcome step (step 0) - we have a custom button there
    if (_currentStep == 0) {
      return const SizedBox.shrink();
    }

    // Step 5 (Contact) is the last step before results - clicking triggers payment
    final isContactStep = _currentStep == 5 && !_paymentCompleted;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.accentText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _isSaving ? null : _goBack,
              child: const Text('Précédent'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: (_isSaving || _isProcessingPayment) ? null : () {
              debugPrint('>>> Button pressed! Step: $_currentStep, isContactStep: ${_currentStep == 5 && !_paymentCompleted}, _isSaving: $_isSaving, _isProcessingPayment: $_isProcessingPayment');
              if (_currentStep == 5 && !_paymentCompleted) {
                _initiatePayment();
              } else {
                _goNext();
              }
            },
            child: (_isSaving || _isProcessingPayment)
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(isContactStep 
                    ? 'Voir mes résultats (${_selectedPlan?.priceFcfa ?? 0} FCFA)' 
                    : 'Continuer'),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 0),
          // Main title with glow effect
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.textLight,
                AppColors.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Text(
              'Bienvenue',
              textAlign: TextAlign.center,
              style: GoogleFonts.philosopher(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Découvrez la vibration de votre couple en 1 minute',
              textAlign: TextAlign.center,
              style: GoogleFonts.philosopher(
                fontSize: 18,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Nous calculons votre nombre de couple, vos chemins de vie et vous offrons un conseil quotidien personnalisé.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          // Feature cards
          _buildFeatureCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Ne restez plus dans le doute',
            subtitle: 'Découvrez les blocages cachés qui freinent votre épanouissement',
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            icon: Icons.calendar_month_rounded,
            title: 'Évitez les conflits inutiles',
            subtitle: 'Anticipez les tensions grâce à vos prévisions jour après jour',
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            icon: Icons.timer_rounded,
            title: 'Des réponses claires, tout de suite',
            subtitle: 'Obtenez votre diagnostic amoureux complet en 1 minute',
          ),
          const SizedBox(height: 24),
          // CTA Button
          AnimatedPrimaryButton(
            label: 'Commencer le quiz',
            icon: Icons.arrow_forward_rounded,
            onPressed: _goNext,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Form(
        key: _namesFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prénoms du couple',
              style: GoogleFonts.philosopher(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Entrez vos prénoms pour personnaliser votre analyse',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            // Partner 1 name
            TextFormField(
              controller: _nameAController,
              decoration: const InputDecoration(
                labelText: 'Prénom partenaire 1',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Entrez un prénom' : null,
            ),
            const SizedBox(height: 12),
            // Partner 1 gender selection
            Text(
              'Sexe du partenaire 1 *',
              style: GoogleFonts.philosopher(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildGenderSelector(
              selectedValue: _genderA,
              onChanged: (value) => setState(() => _genderA = value),
            ),
            const SizedBox(height: 20),
            // Partner 2 name
            TextFormField(
              controller: _nameBController,
              decoration: const InputDecoration(
                labelText: 'Prénom partenaire 2',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.secondary),
              ),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Entrez un prénom' : null,
            ),
            const SizedBox(height: 12),
            // Partner 2 gender selection
            Text(
              'Sexe du partenaire 2 *',
              style: GoogleFonts.philosopher(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildGenderSelector(
              selectedValue: _genderB,
              onChanged: (value) => setState(() => _genderB = value),
            ),
            const SizedBox(height: 24),
            Text(
              'Votre situation (optionnel)',
              style: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SelectableCardGrid(
              options: _relationStatuses,
              selectedValue: _relationStatus,
              onChanged: (value) => setState(() => _relationStatus = value),
              icons: const [
                Icons.favorite,
                Icons.ring_volume,
                Icons.celebration,
                Icons.psychology,
                Icons.help_outline,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector({
    required String? selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: _genderOptions.map((gender) {
        final isSelected = selectedValue == gender;
        final IconData icon;
        switch (gender) {
          case 'Homme':
            icon = Icons.male;
            break;
          case 'Femme':
            icon = Icons.female;
            break;
          default:
            icon = Icons.transgender;
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: gender != _genderOptions.last ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => onChanged(gender),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.block.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gender,
                      style: TextStyle(
                        color: isSelected ? AppColors.textLight : AppColors.textMuted,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBirthdatesStep({required bool isFirst}) {
    final title = isFirst ? 'Date de naissance (Partenaire 1)' : 'Date de naissance (Partenaire 2)';
    final hint = 'Choisissez année, mois, jour pour ${isFirst ? "le premier partenaire" : "le second partenaire"}.';
    final selectedYear = isFirst ? _yearA : _yearB;
    final selectedMonth = isFirst ? _monthA : _monthB;
    final selectedDay = isFirst ? _dayA : _dayB;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          _buildDateDropdowns(
            selectedYear: selectedYear,
            selectedMonth: selectedMonth,
            selectedDay: selectedDay,
            onYearChanged: (year) {
              setState(() {
                if (isFirst) {
                  _yearA = year;
                } else {
                  _yearB = year;
                }
                _updateBirthDate(isFirst);
              });
            },
            onMonthChanged: (month) {
              setState(() {
                if (isFirst) {
                  _monthA = month;
                } else {
                  _monthB = month;
                }
                _updateBirthDate(isFirst);
              });
            },
            onDayChanged: (day) {
              setState(() {
                if (isFirst) {
                  _dayA = day;
                } else {
                  _dayB = day;
                }
                _updateBirthDate(isFirst);
              });
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Astuce : sur mobile, utilisez des champs larges en colonne unique pour limiter les erreurs.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDropdowns({
    required int? selectedYear,
    required int? selectedMonth,
    required int? selectedDay,
    required ValueChanged<int?> onYearChanged,
    required ValueChanged<int?> onMonthChanged,
    required ValueChanged<int?> onDayChanged,
  }) {
    final years = List<int>.generate(DateTime.now().year - 1919, (i) => 1920 + i).reversed.toList();
    final months = const [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    final maxDay = _daysInMonth(selectedYear, selectedMonth);
    final days = List<int>.generate(maxDay, (i) => i + 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Année'),
                  initialValue: selectedYear,
                  items: years
                      .map((y) => DropdownMenuItem<int>(
                            value: y,
                            child: Text('$y'),
                          ))
                      .toList(),
                  onChanged: onYearChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Mois'),
                  initialValue: selectedMonth,
                  items: List.generate(
                    months.length,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(months[index]),
                    ),
                  ),
                  onChanged: onMonthChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Jour'),
                  initialValue: selectedDay != null && selectedDay <= maxDay ? selectedDay : null,
                  items: days
                      .map((d) => DropdownMenuItem<int>(
                            value: d,
                            child: Text('$d'),
                          ))
                      .toList(),
                  onChanged: onDayChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContextStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contexte (optionnel)',
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Personnalisez les textes sans rallonger le flux principal. Cette étape peut être ignorée.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          _pillButton(
            label: _meetingDate == null ? 'Date de rencontre' : 'Rencontre : ${_formatDate(_meetingDate)}',
            icon: Icons.event,
            onTap: _pickMeetingDate,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Durée de la relation (ex: 3 ans)',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _challengeOptions
                .map(
                  (item) => FilterChip(
                    label: Text(item),
                    selected: _challenges.contains(item),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    onSelected: (_) => _toggleChallenge(item),
                    checkmarkColor: Colors.white,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bouton « Passer » recommandé pour rappeler que la section est facultative.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.accentText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _goNext,
              child: const Text('Passer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.block,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildContactStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _emailExists ? 'Bon retour parmi nous !' : 'Créez votre compte',
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _emailExists 
                ? 'Ce compte existe déjà. Entrez votre mot de passe pour vous connecter.'
                : 'Votre compte vous permettra de reconsulter vos rapports à tout moment.',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email *',
              hintText: 'vous@example.com',
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
              suffixIcon: _isCheckingEmail 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _emailExists 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
            ),
            onChanged: _onEmailChanged,
          ),
          if (_emailCheckError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _emailCheckError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: _emailExists ? 'Mot de passe *' : 'Créer un mot de passe *',
              hintText: _emailExists ? 'Entrez votre mot de passe' : 'Minimum 6 caractères',
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            ),
          ),
          if (_emailExists)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showSnack('Fonctionnalité bientôt disponible.');
                  },
                  child: const Text('Mot de passe oublié ?'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Téléphone (optionnel)',
              hintText: '+226...',
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.secondary),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _wantsNotifications,
            onChanged: (value) => setState(() => _wantsNotifications = value),
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
            title: const Text('Recevoir la guidance quotidienne'),
            subtitle: const Text('Optionnel, par email.'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.block.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.security, color: AppColors.primary.withValues(alpha: 0.8)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _emailExists
                        ? 'Connectez-vous pour retrouver vos précédentes analyses et vos éventuels abonnements actifs.'
                        : 'Ce mot de passe sécurise l\'accès à votre rapport et protège vos données personnelles. Choisissez-le avec soin et mémorisez-le pour pouvoir retrouver vos analyses à tout moment.',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Check if email exists when user changes it
  void _onEmailChanged(String email) {
    // Reset state
    setState(() {
      _emailCheckError = null;
    });
    
    // Debounce: only check after user stops typing
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (_emailController.text.trim() != email) return; // User still typing
      if (!_isValidEmail(email)) {
        setState(() => _emailExists = false);
        return;
      }
      
      setState(() => _isCheckingEmail = true);
      
      try {
        final exists = await AuthService.instance.emailExists(email);
        if (mounted && _emailController.text.trim() == email) {
          setState(() {
            _emailExists = exists;
            _isCheckingEmail = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isCheckingEmail = false;
            _emailCheckError = 'Vérification impossible. Continuez quand même.';
          });
        }
      }
    });
  }

  /// Payment step widget
  Widget _buildPaymentStep() {
    final pricingService = PricingService.instance;
    
    // Afficher un chargement si les plans ne sont pas encore chargés
    if (pricingService.plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('Chargement des offres...', style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                PricingService.instance.fetchPlans().then((_) {
                  if (mounted) setState(() {});
                });
              },
              child: const Text('Réactualiser'),
            ),
          ],
        ),
      );
    }

    PricingPlan consultationPlan;
    PricingPlan subscriptionPlan;

    // Sécuriser l'accès aux plans spécifiques
    try {
      consultationPlan = pricingService.consultationPlan;
      subscriptionPlan = pricingService.subscriptionPlan;
    } catch (e) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Les offres ne sont pas disponibles pour le moment.', style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez votre formule',
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sélectionnez un forfait pour accéder à votre rapport de compatibilité.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          
          // Consultation plan
          _buildPlanCard(
            plan: consultationPlan,
            isSelected: _selectedPlanType == 'consultation',
            icon: Icons.description_outlined,
            features: const [
              'Rapport complet de compatibilité',
              'Analyse numérologique des deux partenaires',
              'Conseil du jour personnalisé',
            ],
            onTap: () {
              setState(() {
                _selectedPlanType = 'consultation';
                _selectedPlan = consultationPlan;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Subscription plan
          _buildPlanCard(
            plan: subscriptionPlan,
            isSelected: _selectedPlanType == 'subscription',
            icon: Icons.star_outline,
            badge: 'MEILLEURE OFFRE',
            features: const [
              'Accès illimité pendant 30 jours',
              'Tous les rapports inclus',
              'Guidance quotidienne personnalisée',
              'Nouveaux rapports sans frais',
            ],
            onTap: () {
              setState(() {
                _selectedPlanType = 'subscription';
                _selectedPlan = subscriptionPlan;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
        // Payment button removed - use the main navigation button "Voir mes résultats"
        if (_paymentCompleted)
          _buildPaymentSuccessCard(),
          
          const SizedBox(height: 16),
          
          // Payment info
          const Center(
            child: Text(
              'Paiement sécurisé par Kkiapay',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 20, color: AppColors.textMuted.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Icon(Icons.credit_card, size: 20, color: AppColors.textMuted.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Icon(Icons.account_balance, size: 20, color: AppColors.textMuted.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required PricingPlan plan,
    required bool isSelected,
    required IconData icon,
    required List<String> features,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.block.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.block,
            width: isSelected ? 2 : 1,
          ),
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
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan.priceFcfa} FCFA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : AppColors.textLight,
                      ),
                    ),
                if (plan.isSubscription)
                  const Text(
                    '/mois',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTap,
              child: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
            const SizedBox(height: 12),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? AppColors.textLight : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          const Text(
            'Paiement réussi !',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cliquez sur Continuer pour voir vos résultats.',
            style: TextStyle(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _initiatePayment() async {
    debugPrint('>>> _initiatePayment called');
    
    // Validate contact step first
    if (!_validateCurrentStep()) {
      debugPrint('>>> _initiatePayment: Validation failed');
      return;
    }
    debugPrint('>>> _initiatePayment: Validation passed');
    
    // Compute summary if not already done
    if (_summary == null) {
      debugPrint('>>> _initiatePayment: Computing summary...');
      _computeSummary();
    }
    
    // Save session before payment
    debugPrint('>>> _initiatePayment: Saving session...');
    await _saveSessionIfPossible();
    
    // Auto-select consultation plan if not already selected
    if (_selectedPlan == null) {
      debugPrint('>>> _initiatePayment: No plan selected, fetching...');
      // Try to get from service
      final plans = PricingService.instance.plans;
      debugPrint('>>> _initiatePayment: Current plans count: ${plans.length}');
      
      if (plans.isEmpty) {
        // Fetch if not loaded
        debugPrint('>>> _initiatePayment: Plans empty, fetching from server...');
        await PricingService.instance.fetchPlans();
        debugPrint('>>> _initiatePayment: After fetch, plans count: ${PricingService.instance.plans.length}');
      }
      
      try {
        // Use safe getter with fallback
        final allPlans = PricingService.instance.plans;
        if (allPlans.isNotEmpty) {
          // Try to find consultation plan, or use first available
          _selectedPlan = allPlans.firstWhere(
            (p) => p.planType.toLowerCase().contains('consultation'),
            orElse: () => allPlans.first,
          );
          debugPrint('>>> _initiatePayment: Selected plan: ${_selectedPlan?.planType} - ${_selectedPlan?.priceFcfa} FCFA');
        }
      } catch (e) {
        debugPrint('>>> _initiatePayment: Error selecting plan: $e');
      }
      
      if (_selectedPlan == null) {
        debugPrint('>>> _initiatePayment: FAILED - No plan available');
        _showSnack('Erreur: impossible de charger les forfaits. Vérifiez votre connexion.');
        return;
      }
    }
    debugPrint('>>> _initiatePayment: Plan ready: ${_selectedPlan!.planType} - ${_selectedPlan!.priceFcfa} FCFA');

    setState(() => _isProcessingPayment = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final name = '${_nameAController.text} & ${_nameBController.text}';

    KkiapayService.instance.startPayment(
      context: context,
      amount: _selectedPlan!.priceFcfa,
      reason: _selectedPlan!.isSubscription
          ? 'Abonnement mensuel Compatibilité'
          : 'Rapport de compatibilité',
      email: email,
      name: name,
      phone: phone.isNotEmpty ? phone : null,
      callback: (success, transactionId, error) async {
        if (!success || transactionId == null) {
          setState(() => _isProcessingPayment = false);
          _showSnack(error ?? 'Paiement échoué. Veuillez réessayer.');
          return;
        }

        try {
          // Create or sign in user
          final authService = AuthService.instance;
          AppUser? user;

          if (await authService.emailExists(email)) {
            user = await authService.signIn(email: email, password: password);
          } else {
            user = await authService.signUp(
              email: email,
              password: password,
              name: name,
            );
          }

          if (user == null) {
            if (mounted) setState(() => _isProcessingPayment = false);
            _showSnack('Erreur lors de la création du compte.');
            return;
          }

          // Record payment
          final payment = await KkiapayService.instance.recordPayment(
            userId: user.id,
            sessionId: _sessionId,
            transactionId: transactionId,
            amountFcfa: _selectedPlan!.priceFcfa,
            status: PaymentStatus.success,
            planType: _selectedPlan!.planType,
          );

          // If subscription, create subscription record
          if (_selectedPlan!.isSubscription && _selectedPlan!.durationDays != null) {
            await authService.createSubscription(
              userId: user.id,
              planId: _selectedPlan!.id,
              paymentId: payment?.id ?? transactionId,
              durationDays: _selectedPlan!.durationDays!,
            );
          }

          // Link report to user
          if (_sessionId != null) {
            await KkiapayService.instance.linkReportToUser(
              userId: user.id,
              sessionId: _sessionId!,
            );
          }

          if (mounted) {
            setState(() {
              _isProcessingPayment = false;
              _paymentCompleted = true;
            });
            _showSnack('Paiement réussi !');
          }

          // Directly advance to results step instead of calling _goNext()
          // to avoid re-checking payment conditions
          if (mounted) {
            _loadTemporalReports();
            setState(() {
              _currentStep = _totalSteps - 1; // Jump to results
            });
            _pageController.animateToPage(
              _totalSteps - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() => _isProcessingPayment = false);
            _showSnack('Erreur: ${e.toString()}');
          }
        }
      },
    );
  }

Widget _buildResultsStep() {
    if (_summary == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    final summary = _summary!;
    final saveStatus = _buildSaveStatus();
    final partnerCards = [
      _partnerCard('Partenaire 1', summary.partnerA),
      _partnerCard('Partenaire 2', summary.partnerB),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vos résultats',
            style: GoogleFonts.philosopher(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (saveStatus != null) ...[
            saveStatus,
            const SizedBox(height: 12),
          ],
          _coupleCard(summary),
          const SizedBox(height: 12),
          _coupleDeepCard(summary),
          const SizedBox(height: 12),
          ...partnerCards,
          const SizedBox(height: 12),
          _dailyAdviceCard(summary),
          if (_relationStatus != null || _durationController.text.isNotEmpty || _meetingDate != null) ...[
            const SizedBox(height: 12),
            _contextCard(),
          ],
          
          // Temporal Reports Section
          const SizedBox(height: 24),
          Text(
            'Prévisions Temporelles',
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrez vos prévisions pour l\'année, le mois et la journée en cours.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 16),
          
          // Loading state
          if (_isLoadingReports) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 12),
                    Text('Chargement des prévisions...'),
                  ],
                ),
              ),
            ),
          ],
          
          // Error state
          if (_reportsError != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.block,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_reportsError!)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Show reports if available
          if (!_isLoadingReports && _reportsError == null) ...[
            // Year Report
            if (_yearReport != null) ...[
              TemporalReportCard(report: _yearReport!, isExpanded: true),
            ],
            
            // Month Report
            if (_monthReport != null) ...[
              TemporalReportCard(report: _monthReport!, isExpanded: true),
            ],
            
            // Day Report (expanded by default)
            if (_dayReport != null) ...[
              TemporalReportCard(report: _dayReport!, isExpanded: true),
            ],
          ],
          
          // CTA for tomorrow's report
          const SizedBox(height: 24),
          TomorrowReportCTA(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemporalPurchaseScreen(),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget? _buildSaveStatus() {
    if (_repository == null) {
      return _infoBox(
        title: 'Sauvegarde inactive',
        body: 'Ajoutez SUPABASE_URL et SUPABASE_ANON_KEY dans .env pour synchroniser vos rapports.',
        tone: AppColors.block,
      );
    }
    if (_isSaving) {
      return _infoBox(
        title: 'Enregistrement en cours',
        body: 'Vos donnees sont envoyees de maniere securisee.',
        tone: AppColors.block,
      );
    }
    if (_saveError != null) {
      return _infoBox(
        title: 'Sauvegarde echouee',
        body: _saveError!,
        tone: AppColors.block,
      );
    }
    if (_sessionId != null) {
      final token = _clientToken ?? 'token en cours';
      return _infoBox(
        title: 'Rapport enregistre',
        body: 'Session: $_sessionId\nToken de reprise: $token',
        tone: AppColors.primary.withValues(alpha: 0.15),
      );
    }
    return null;
  }

  Widget _infoBox({required String title, required String body, Color tone = AppColors.block}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }


Widget _coupleCard(CompatibilitySummary summary) {
    final interpretation = _service.describeCoupleNumber(summary.coupleNumber);
    final label = _service.archetypeLabel(summary.coupleNumber);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dynamique du couple : $label',
            style: GoogleFonts.philosopher(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(interpretation),
          const SizedBox(height: 10),
          Text(
            'Calculé le ${DateFormat('dd/MM').format(summary.generatedAt)}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _coupleDeepCard(CompatibilitySummary summary) {
    final deep = _service.describeCoupleDeep(summary.coupleNumber);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rapport du couple',
            style: GoogleFonts.philosopher(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(deep),
        ],
      ),
    );
  }


  Widget _partnerCard(String title, PartnerReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portrait de ${report.input.name}',
            style: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _numberRow('Profil essentiel', report.lifePath, _service.describeBaseNumber(report.lifePath)),
          const SizedBox(height: 6),
          _numberRow('Signature relationnelle', report.nameNumber, _service.describeNameNumber(report.nameNumber)),
          const SizedBox(height: 6),
          _numberRow('Tonalité intime', report.intimateNumber, _service.describeIntimateNumber(report.intimateNumber)),
          const SizedBox(height: 6),
          _numberRow('Style social', report.personalityNumber, _service.describePersonalityNumber(report.personalityNumber)),
          const SizedBox(height: 6),
          _numberRow('Racines', report.heredityNumber, _service.describeHeredityNumber(report.heredityNumber)),
          const SizedBox(height: 6),
          _numberRow('Énergie complémentaire', report.kabbalahNumber, _service.describeKabbalahNumber(report.kabbalahNumber)),
          const SizedBox(height: 6),
          _numberRow('Rythme annuel', report.personalYear, _service.describePersonalYear(report.personalYear)),
          const SizedBox(height: 8),
          _guideRow(report),
        ],
      ),
    );
  }

  Widget _guideRow(PartnerReport report) {
    final guide = _service.describeGuide(report.lifePath, report.nameNumber);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Points d’appui',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            guide,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _numberRow(String label, int value, String meaning) {
    final archetype = _service.archetypeLabel(value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          child: const Icon(Icons.star, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                archetype,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(meaning, style: const TextStyle(color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dailyAdviceCard(CompatibilitySummary summary) {
    final hint = _service.describeCoupleDailyAction(summary.coupleDailyNumber);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conseil du jour (couple) : ${summary.coupleDailyNumber}',
            style: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(hint.isEmpty ? 'Laissez-vous guider par vos cycles personnels.' : hint),
          const SizedBox(height: 6),
          const Text(
            'Les cycles changent chaque jour : invitez l’utilisateur à revenir.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _contextCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contexte noté',
            style: GoogleFonts.philosopher(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (_relationStatus != null) Text('Statut : $_relationStatus'),
          if (_durationController.text.isNotEmpty) Text('Durée : ${_durationController.text}'),
          if (_meetingDate != null) Text('Rencontre : ${_formatDate(_meetingDate)}'),
          if (_challenges.isNotEmpty) Text('Défis : ${_challenges.join(', ')}'),
        ],
      ),
    );
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
