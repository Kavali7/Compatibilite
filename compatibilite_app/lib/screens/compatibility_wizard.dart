import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/compatibility_models.dart';
import '../services/numerology_service.dart';
import '../theme/app_theme.dart';
import '../widgets/hamburger_menu_overlay.dart';
import 'legal_page.dart';

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
  final NumerologyService _service = NumerologyService();

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
  bool _isMenuOpen = false;

  static const _supportEmail = 'growpeak.agence@gmail.com';
  static const _supportPhone = '0022654255584';

  static const _totalSteps = 7;
  static const _challengeOptions = [
    'Communication',
    'Confiance',
    'Finances',
    'Jalousie',
    'Organisation',
  ];
  static const _relationStatuses = [
    'En couple',
    'Marié·e',
    'Fiancé·e',
    'Relation complexe',
    'Célibataire curieux·se',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameAController.dispose();
    _nameBController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (!_validateCurrentStep()) return;
    if (_currentStep == _totalSteps - 2) {
      _computeSummary();
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

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _namesFormKey.currentState?.validate() ?? false;
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
    });
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
    _challenges.clear();
    _wantsNotifications = true;
    _summary = null;
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
      MenuEntry(
        label: 'Politique de confidentialite',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegalPage.confidentialite()),
        ),
      ),
      MenuEntry(
        label: "Conditions d'utilisation",
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegalPage.conditions()),
        ),
      ),
      MenuEntry(
        label: 'Facturation / Paiements',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegalPage.facturation()),
        ),
      ),
      MenuEntry(
        label: 'Remboursements & retractation',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegalPage.remboursement()),
        ),
      ),
      MenuEntry(
        label: 'Cookies & suivi',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegalPage.cookies()),
        ),
      ),
      MenuEntry(label: 'Contacter Growpeak', onTap: () => _launchUri(_supportEmailUri)),
      MenuEntry(label: 'Appeler Growpeak', onTap: () => _launchUri(_supportPhoneUri)),
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.background, Color(0xFF0E1E2A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60,
                right: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -30,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
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
          ),
        ),
      ),
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
              onPressed: _goBack,
              child: const Text('Retour aux étapes'),
            ),
          ),
        ],
      );
    }

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
              onPressed: _goBack,
              child: const Text('Précédent'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _goNext,
            child: Text(_currentStep == _totalSteps - 2 ? 'Voir mes résultats' : 'Continuer'),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Bienvenue',
            textAlign: TextAlign.center,
            style: GoogleFonts.philosopher(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Analyse la vibration de votre couple via un quiz d’une minute. Nous calculons le nombre du couple, les chemins de vie et un conseil quotidien.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.block.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Flow en étapes courtes : design nocturne et call-to-action clair.',
                    style: TextStyle(color: AppColors.accentText.withValues(alpha: 0.9)),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _goNext,
            child: const Text('Commencer'),
          ),
          const SizedBox(height: 12),
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
              style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Commencez par les prénoms pour engager l’utilisateur avant les questions plus personnelles.',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameAController,
              decoration: const InputDecoration(labelText: 'Prénom partenaire 1'),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Entrez un prénom' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameBController,
              decoration: const InputDecoration(labelText: 'Prénom partenaire 2'),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Entrez un prénom' : null,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Statut (facultatif)'),
              initialValue: _relationStatus,
              items: _relationStatuses
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _relationStatus = value),
            ),
            const SizedBox(height: 8),
            const Text('Exemple : Jean et Marie.'),
          ],
        ),
      ),
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
            'CoordonnǸes',
            style: GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez si vous voulez recevoir la guidance quotidienne.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _wantsNotifications,
            onChanged: (value) => setState(() => _wantsNotifications = value),
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
            title: const Text('Recevoir la guidance quotidienne'),
            subtitle: const Text('Optionnel, aucune donnǸe sensible stockǸe.'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsStep() {
    if (_summary == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    final summary = _summary!;
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

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
