import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class LegalSection {
  const LegalSection({required this.title, required this.body});
  final String title;
  final String body;
}

class LegalPage extends StatelessWidget {
  const LegalPage({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<LegalSection> sections;

  factory LegalPage.confidentialite() {
    return LegalPage(
      title: 'Politique de confidentialité',
      sections: const [
        LegalSection(
          title: 'Responsable et contacts',
          body:
              'Growpeak Agence est responsable du traitement. Contact : growpeak.agence@gmail.com / +225 54 255 584. '
              'Ajoutez votre adresse postale et, si nommé, un référent données ou DPO.',
        ),
        LegalSection(
          title: 'Données collectées',
          body:
              'Données saisies (noms, dates, préférences), données techniques (appareil, logs), statistiques anonymisées si activées. '
              'Aucune donnée n’est revendue.',
        ),
        LegalSection(
          title: 'Finalités et bases légales',
          body:
              'Fournir le service (exécution du contrat), support et sécurité (intérêt légitime), amélioration produit et statistiques '
              '(intérêt légitime), prospection uniquement avec consentement explicite si activée.',
        ),
        LegalSection(
          title: 'Durées de conservation',
          body:
              'Données d’usage : durée de la relation + délais légaux. Logs techniques : durée courte (ex. 12 mois max). '
              'Demandes support : jusqu’à 3 ans. Les durées seront précisées en cas d’activation de nouveaux traitements.',
        ),
        LegalSection(
          title: 'Partage et transferts',
          body:
              'Sous-traitants techniques ou analytics conformes (UE ou clauses contractuelles types). Pas de transfert sans garanties adéquates.',
        ),
        LegalSection(
          title: 'Droits des personnes',
          body:
              'Accès, rectification, effacement, limitation, opposition, portabilité, directives post-mortem (si applicables). '
              'Exercez vos droits via growpeak.agence@gmail.com. Réclamation possible auprès de l’autorité locale (ex. CNIL).',
        ),
        LegalSection(
          title: 'Sécurité',
          body:
              'Mesures techniques et organisationnelles raisonnables (chiffrement en transit, contrôle d’accès). '
              'Le niveau de sécurité sera adapté si des données supplémentaires sont collectées.',
        ),
      ],
    );
  }

  factory LegalPage.conditions() {
    return LegalPage(
      title: 'Conditions d’utilisation',
      sections: const [
        LegalSection(
          title: 'Objet',
          body:
              'Application de compatibilité/guidance. Aucune garantie de résultat, aucune vocation médicale, juridique ou financière.',
        ),
        LegalSection(
          title: 'Accès et comportement',
          body:
              'Fournir des informations exactes. Interdits : usage frauduleux, diffusion de contenu illicite, rétro-ingénierie, scraping, '
              'atteinte aux droits de tiers ou à la sécurité du service.',
        ),
        LegalSection(
          title: 'Propriété intellectuelle',
          body:
              'Le code, les textes et visuels restent la propriété de Growpeak Agence. Licence d’usage personnelle et non exclusive.',
        ),
        LegalSection(
          title: 'Disponibilité',
          body:
              'Service fourni “en l’état”. Des interruptions de maintenance ou incidents peuvent survenir sans engager la responsabilité de Growpeak Agence.',
        ),
        LegalSection(
          title: 'Responsabilités',
          body:
              'Les conseils sont indicatifs. L’utilisateur reste responsable de ses décisions. Aucune responsabilité en cas de dommage indirect '
              'ou de perte de données liée à l’usage.',
        ),
        LegalSection(
          title: 'Résiliation',
          body:
              'L’utilisateur peut cesser d’utiliser le service à tout moment. Growpeak Agence peut suspendre ou résilier en cas d’abus ou de violation des conditions.',
        ),
        LegalSection(
          title: 'Droit applicable',
          body:
              'Précisez la juridiction compétente (ex. droit français, tribunaux de [ville]). Adaptez selon votre pays.',
        ),
      ],
    );
  }

  factory LegalPage.facturation() {
    return LegalPage(
      title: 'Facturation / Paiements',
      sections: const [
        LegalSection(
          title: 'Statut actuel',
          body:
              'Aucun paiement en ligne n’est activé pour l’instant. Aucun moyen de paiement n’est collecté ni conservé.',
        ),
        LegalSection(
          title: 'Engagement de transparence',
          body:
              'Lorsque des offres payantes seront activées, les prix, taxes, échéances, prestataire de paiement, conditions de renouvellement '
              'et rétractation seront affichés avant tout paiement.',
        ),
        LegalSection(
          title: 'Absence de prélèvement',
          body:
              'Aucun prélèvement ne sera effectué sans affichage clair de l’offre et validation explicite par l’utilisateur.',
        ),
        LegalSection(
          title: 'Abonnements futurs',
          body:
              'En cas d’abonnement, les conditions de renouvellement automatique, préavis d’annulation et notifications seront précisées avant souscription.',
        ),
      ],
    );
  }

  factory LegalPage.remboursement() {
    return LegalPage(
      title: 'Remboursements & rétractation',
      sections: const [
        LegalSection(
          title: 'Contenu numérique livré immédiatement',
          body:
              'Si vous activez des contenus livrés immédiatement, le droit de rétractation peut être écarté après consentement exprès. '
              'Cela sera clairement indiqué avant le paiement.',
        ),
        LegalSection(
          title: 'Services différés ou abonnements',
          body:
              'Si applicable, un délai de rétractation (ex. 14 jours en UE) sera précisé pour les offres éligibles, ainsi que la procédure pour exercer ce droit.',
        ),
        LegalSection(
          title: 'Politique de remboursement',
          body:
              'Les cas d’éligibilité et le canal de demande (support) seront précisés au moment de l’activation d’une offre payante.',
        ),
      ],
    );
  }

  factory LegalPage.cookies() {
    return LegalPage(
      title: 'Cookies & suivi',
      sections: const [
        LegalSection(
          title: 'Essentiels',
          body:
              'Cookies ou stockage nécessaires au fonctionnement (sécurité, langue). Ils ne peuvent pas être désactivés sans dégrader le service.',
        ),
        LegalSection(
          title: 'Optionnels',
          body:
              'Analytics/performance uniquement avec consentement. L’utilisateur pourra activer/désactiver ces traceurs.',
        ),
        LegalSection(
          title: 'Pas de publicitaire par défaut',
          body:
              'Aucun cookie publicitaire tant qu’il n’est pas explicitement proposé et accepté.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.block,
        title: Text(
          title,
          style: GoogleFonts.philosopher(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, Color(0xFF0E1E2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.block.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: GoogleFonts.philosopher(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.body,
                    style: const TextStyle(color: AppColors.textMuted, height: 1.4),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
