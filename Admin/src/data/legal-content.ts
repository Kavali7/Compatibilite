export type LegalPage = {
    titre: string;
    contenu: string;
};

export const LEGAL_CONTENT: Record<string, LegalPage> = {
    confidentialite: {
        titre: 'Politique de confidentialité',
        contenu: `Growpeak Agence s'engage à protéger vos données personnelles conformément au RGPD et aux lois applicables.

Responsable du traitement : Growpeak Agence

Données collectées :
- Informations de contact (email, téléphone)
- Données de naissance pour le calcul numérologique
- Informations de paiement (traitées par Kkiapay)

Finalités :
- Fourniture du service de compatibilité
- Communication sur votre rapport
- Amélioration de nos services

Durée de conservation : 3 ans après la dernière interaction

Vos droits : accès, rectification, suppression, portabilité. Contact : contact@growpeakagency.com`,
    },
    conditions: {
        titre: "Conditions d'utilisation",
        contenu: `En utilisant les services Growpeak, vous acceptez les présentes conditions.

Objet : Le service fournit des analyses numérologiques à titre de divertissement et de développement personnel.

Accès : Le service est réservé aux personnes majeures.

Propriété intellectuelle : Tous les contenus (textes, algorithmes, designs) sont la propriété de Growpeak Agence.

Responsabilité : Les analyses sont fournies à titre indicatif. Growpeak ne saurait être tenu responsable des décisions prises sur la base de ces analyses.

Droit applicable : Droit béninois.`,
    },
    facturation: {
        titre: 'Facturation / Paiements',
        contenu: `Les paiements sont sécurisés via Kkiapay.

Modes de paiement acceptés :
- Mobile Money (MTN, Moov)
- Cartes bancaires

Tarification : Les prix sont affichés en FCFA et incluent toutes taxes.

Confirmation : Un email de confirmation est envoyé après chaque paiement réussi.

Factures : Disponibles sur demande à contact@growpeakagency.com`,
    },
    remboursement: {
        titre: 'Remboursements & rétractation',
        contenu: `Droit de rétractation : Conformément à la réglementation, vous disposez d'un délai de 14 jours pour vous rétracter.

Exceptions : Le droit de rétractation ne s'applique pas si le rapport a déjà été généré et consulté.

Procédure de remboursement :
1. Contactez-nous à contact@growpeakagency.com
2. Indiquez votre référence de paiement
3. Expliquez le motif de votre demande

Délai de remboursement : 14 jours ouvrés après validation.`,
    },
    cookies: {
        titre: 'Cookies & suivi',
        contenu: `Notre application utilise des cookies essentiels au fonctionnement du service.

Cookies essentiels :
- Session utilisateur
- Préférences de langue

Cookies analytiques (avec consentement) :
- Google Analytics pour améliorer l'expérience

Gestion : Vous pouvez désactiver les cookies dans les paramètres de votre navigateur.

Contact : Pour toute question, contact@growpeakagency.com`,
    },
};
