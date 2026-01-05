export type SessionCompatibilite = {
  id: string;
  created_at: string;
  partenaire_a_nom: string;
  partenaire_a_naissance: string;
  partenaire_b_nom: string;
  partenaire_b_naissance: string;
  statut_relation: string | null;
  date_rencontre: string | null;
  duree_relation: string | null;
  defis: string[];
  notifications: boolean;
  email_contact: string | null;
  telephone_contact: string | null;
  nombre_couple: number;
  nombre_couple_jour: number;
  genere_le: string;
  statut_paiement: string;
  fournisseur_paiement: string | null;
  reference_paiement: string | null;
  montant_centimes: number | null;
  devise: string;
  paye_le: string | null;
  metadata: Record<string, unknown>;
  client_token: string;
};

export type RapportPartenaire = {
  id: string;
  session_id: string;
  role_partenaire: string;
  nom_partenaire: string;
  chemin_vie: number;
  nombre_nom: number;
  nombre_kabbale: number;
  nombre_intime: number;
  nombre_personnalite: number;
  nombre_heredite: number;
  annee_personnelle: number;
  mois_personnel: number;
  jour_personnel: number;
};

// === NEW ADMIN TYPES ===

export type Projet = {
  id: string;
  slug: string;
  nom: string;
  actif: boolean;
};

export type Interpretation = {
  id: string;
  projet_id?: string;
  categorie: 'chemin_vie' | 'couple' | 'defi';
  cle: string;
  titre?: string;
  contenu: string;
};

export type CodePromo = {
  id: string;
  projet_id?: string;
  code: string;
  type: 'pourcentage' | 'montant';
  valeur: number;
  date_expiration?: string;
  utilisation_max?: number;
  utilisation_actuelle: number;
  actif: boolean;
};

export type PageLegale = {
  id: string;
  slug: string;
  titre: string;
  contenu: string;
};

export type PricingPlan = {
  id: string;
  name: string;
  price_fcfa: number;
  plan_type: 'consultation' | 'subscription';
  duration_days?: number;
  is_active: boolean;
};

export type ReportSection = {
  code: string;
  label_fr: string;
  is_active: boolean;
  display_order: number;
  periode: string;
  description: string;
};
