import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/hamburger_menu_overlay.dart';

class HtmlFlowScreen extends StatefulWidget {
  const HtmlFlowScreen({super.key});

  @override
  State<HtmlFlowScreen> createState() => _HtmlFlowScreenState();
}

class _HtmlFlowScreenState extends State<HtmlFlowScreen> {
  final PageController _controller = PageController();
  int _index = 0;
  bool _menuOpen = false;
  final Map<int, String> _selected = {};
  static const int stepsCount = 14;

  List<MenuEntry> get _menuEntries => [
        const MenuEntry(label: 'Accueil'),
        const MenuEntry(label: 'Legal'),
        const MenuEntry(label: 'Contact'),
      ];

  void _next() {
    if (_index < stepsCount - 1) {
      setState(() => _index++);
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _back() {
    if (_index == 0) return;
    setState(() => _index--);
    _controller.animateToPage(
      _index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: _TopBar(
                        title: 'Arowpeak Agence',
                        showBack: _index > 0,
                        onBack: _back,
                        onMenu: () => setState(() => _menuOpen = true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _ProgressBar(
                        progress: (_index + 1) / stepsCount,
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stepsCount,
                        itemBuilder: (context, i) {
                          return SingleChildScrollView(
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth > 720
                                      ? 620
                                      : 560,
                                ),
                                child: _buildStep(context, i),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          if (_index > 0)
                            TextButton(
                              onPressed: _back,
                              child: const Text(
                                'Retour',
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                            ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: _next,
                            child: Text(_index == stepsCount - 1
                                ? 'Terminer'
                                : 'Continuer'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            HamburgerMenuOverlay(
              isOpen: _menuOpen,
              onToggle: () => setState(() => _menuOpen = !_menuOpen),
              entries: _menuEntries,
              isDark: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int i) {
    switch (i) {
      case 0:
        return _StepShell(
          title: 'Choisissez votre genre',
          description:
              'Sélectionner votre genre nous aide à créer un rapport astrologique personnalisé.',
          child: _OptionList(
            options: const ['Femme', 'Homme', 'Non-binaire'],
            selected: _selected[i],
            onSelected: (v) => setState(() => _selected[i] = v),
          ),
        );
      case 1:
        return _StepShell(
          title: 'Quelle est votre date de naissance ?',
          description:
              'Indiquez votre anniversaire pour que nous puissions créer un thème astral précis.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Input(label: 'Date (AAAA-MM-JJ)', hint: '2000-01-01'),
              _Input(label: 'Mois', hint: 'Janvier'),
              _Input(label: 'Jour', hint: '12'),
              _Input(label: 'Année', hint: '1995'),
            ],
          ),
        );
      case 2:
        return _StepShell(
          title: 'Connaissez-vous votre heure de naissance ?',
          description:
              'Si vous ne vous en souvenez pas, vous pouvez sauter cette étape.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Input(label: 'Heure de naissance', hint: '12:00'),
              SizedBox(height: 8),
              Text(
                "Je ne m'en souviens pas",
                style: TextStyle(
                  color: AppColors.textMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        );
      case 3:
        return _StepShell(
          title: 'Où êtes-vous né ?',
          description:
              'Renseignez le nom de votre ville natale pour ajuster nos prévisions.',
          child: const _Input(label: 'Ville ou région', hint: 'Littoral, Bénin'),
        );
      case 4:
        return _StepShell(
          title: 'Analyse de votre carte natale',
          description:
              'Nous examinons la position des planètes pour comprendre votre personnalité, vos défis et vos forces.',
          child: _CardBox(
            child: Column(
              children: const [
                Text('Votre thème natal révèle :'),
                SizedBox(height: 12),
                _TripleInfo(
                  items: [
                    ('Scorpion', 'Signe lunaire'),
                    ('Capricorne', 'Signe du soleil'),
                    ('Poissons', 'Ascendant'),
                  ],
                ),
              ],
            ),
          ),
        );
      case 5:
        return _StepShell(
          title: 'Précision des prévisions',
          description: '',
          child: Column(
            children: const [
              _Gauge(value: 34),
              SizedBox(height: 16),
              _SpeechBubble(
                text:
                    "L'énergie cosmique augmente ! Partagez encore un peu plus pour améliorer la précision.",
              ),
            ],
          ),
        );
      case 6:
        return _StepShell(
          title: 'Quel est votre statut relationnel ?',
          description: 'Choisissez l’option qui vous correspond le mieux.',
          child: _OptionList(
            options: const [
              'En couple',
              'Je viens de rompre',
              'Fiancé·e',
              'Marié·e',
              'À la recherche de l’âme sœur',
              'Célibataire',
              'C’est compliqué',
            ],
            selected: _selected[i],
            onSelected: (v) => setState(() => _selected[i] = v),
          ),
        );
      case 7:
        return _StepShell(
          title: 'Quels sont vos objectifs pour l’avenir ?',
          description:
              'Sélectionnez jusqu’à trois objectifs qui comptent le plus pour vous.',
          child: _OptionList(
            options: const [
              'Harmonie familiale',
              'Carrière',
              'Santé',
              'Me marier',
              'Voyager dans le monde',
              'Études',
              'Amis',
              'Avoir des enfants',
            ],
            selected: _selected[i],
            onSelected: (v) => setState(() => _selected[i] = v),
          ),
        );
      case 8:
        return _StepShell(
          title: 'Quelle est votre couleur préférée ?',
          description:
              'Votre couleur favorite en dit long sur votre énergie intérieure.',
          child: _OptionList(
            options: const ['Rouge', 'Jaune', 'Bleu', 'Orange', 'Vert', 'Violet'],
            selected: _selected[i],
            onSelected: (v) => setState(() => _selected[i] = v),
          ),
        );
      case 9:
        return _StepShell(
          title: 'Quel élément de la nature préférez-vous ?',
          description:
              'L’élément auquel vous vous identifiez influence votre personnalité.',
          child: _OptionList(
            options: const ['Terre', 'Eau', 'Feu', 'Air'],
            selected: _selected[i],
            onSelected: (v) => setState(() => _selected[i] = v),
          ),
        );
      case 10:
        return _StepShell(
          title: 'Vous',
          description:
              'Voici un aperçu rapide de votre carte astrale basé sur vos réponses.',
          child: Column(
            children: const [
              _CardBox(
                child: Column(
                  children: [
                    Text(
                      'Homme · Capricorne · Terre',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 14),
                    _TripleInfo(
                      items: [
                        ('Cardinal', 'Modalité'),
                        ('Féminine', 'Polarité'),
                      ],
                    ),
                    SizedBox(height: 14),
                    Divider(color: AppColors.textMuted),
                    SizedBox(height: 14),
                    _TripleInfo(
                      items: [
                        ('Scorpion', 'Signe lunaire'),
                        ('Capricorne', 'Signe du soleil'),
                        ('Poissons', 'Ascendant'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              _SpeechBubble(
                text:
                    'Votre carte montre une étincelle rare : découvrons comment utiliser ce pouvoir !',
              ),
            ],
          ),
        );
      case 11:
        return _StepShell(
          title: 'Précision des prévisions',
          description: '',
          child: Column(
            children: const [
              _Gauge(value: 67),
              SizedBox(height: 16),
              _SpeechBubble(
                text:
                    'La grande révélation est proche ! Confirmez une dernière chose pour découvrir votre histoire complète.',
              ),
            ],
          ),
        );
      case 12:
        return _StepShell(
          title: 'Prenez une photo de votre paume gauche',
          description:
              'Nous utilisons la lecture de la paume pour affiner vos prédictions. La confidentialité est notre priorité.',
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.block,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.primary.withValues(alpha: .3)),
                ),
                child: const Center(
                  child: Text(
                    'Illustration paume',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Prendre une photo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Téléverser'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 13:
        return _StepShell(
          title: 'Votre rapport est prêt !',
          description:
              'Basé sur vos réponses et votre lecture de paume, nous avons généré un rapport astrologique complet.',
          child: _CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ce qui est inclus :',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 10),
                _Bullet(text: 'Analyse détaillée de votre thème natal'),
                _Bullet(text: 'Prédictions mensuelles personnalisées'),
                _Bullet(text: 'Compatibilité amoureuse et professionnelle'),
                _Bullet(text: 'Lecture de votre paume'),
                SizedBox(height: 12),
                Text(
                  'Offre spéciale : 1,99 € pour 7 jours d’accès, puis 29,99 €/mois. Annulable à tout moment.',
                  style: TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepShell extends StatelessWidget {
  const _StepShell({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.left,
          style: GoogleFonts.philosopher(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (description.isNotEmpty)
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textMuted,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _OptionList extends StatelessWidget {
  const _OptionList({
    required this.options,
    required this.onSelected,
    this.selected,
  });

  final List<String> options;
  final ValueChanged<String> onSelected;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (o) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Material(
                color: selected == o
                    ? AppColors.block.withValues(alpha: .9)
                    : AppColors.block,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onSelected(o),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          selected == o
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color:
                              selected == o ? AppColors.primary : AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            o,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.block,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: const TextStyle(color: AppColors.accentText),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _CardBox extends StatelessWidget {
  const _CardBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.block,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
      ),
      child: child,
    );
  }
}

class _Gauge extends StatelessWidget {
  const _Gauge({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0e5063), Color(0xFF02283b)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            height: 140,
            width: 140,
            child: CircularProgressIndicator(
              value: value / 100,
              strokeWidth: 10,
              backgroundColor: AppColors.block,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Text(
            '${value.round()}%',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TripleInfo extends StatelessWidget {
  const _TripleInfo({required this.items});
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map((e) => Column(
                children: [
                  Text(
                    e.$1,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.$2,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.showBack,
    required this.onBack,
    required this.onMenu,
  });

  final String title;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          )
        else
          const SizedBox(width: 48),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onMenu,
          icon: const Icon(Icons.menu, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFF0a394e),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF5ca8dc)]),
          ),
        ),
      ),
    );
  }
}
