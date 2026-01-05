-- ============================================================
-- MIGRATION : Système de Pages Légales Dynamiques
-- ============================================================

-- 1. Création de la table legal_pages
create table if not exists public.legal_pages (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  
  slug text not null unique,         -- Identifiant unique (ex: 'cgv', 'privacy')
  title text not null,               -- Titre affiché (ex: 'Conditions Générales')
  content text not null,             -- Contenu (Markdown supporté)
  is_active boolean default true,    -- Pour masquer temporairement
  display_order integer default 0    -- Pour l'ordre d'affichage dans le menu
);

-- 2. Sécurité (RLS)
alter table public.legal_pages enable row level security;

-- Lecture publique (tout le monde peut voir les pages légales)
drop policy if exists "Public read legal pages" on public.legal_pages;
create policy "Public read legal pages"
  on public.legal_pages
  for select
  using (true);

-- Écriture restreinte (seuls les admins authentifiés)
-- Note: Adapter si vous avez un rôle 'admin' spécifique, sinon 'authenticated'
drop policy if exists "Admins manage legal pages" on public.legal_pages;
create policy "Admins manage legal pages"
  on public.legal_pages
  for all
  to authenticated
  using (true)
  with check (true);

-- 3. Données initiales (Fusion et Consolidation)

-- A) Mentions Légales & Confidentialité (Fusionne Privacy + Cookies)
insert into public.legal_pages (slug, title, display_order, content)
values (
  'confidentialite', 
  'Mentions Légales & Confidentialité', 
  10,
  E'# Responsable et contacts\nGrowpeak Agence est responsable du traitement.\nContact : growpeak.agence@gmail.com / +225 54 255 584.\n\n# Données collectées\nNous collectons les données saisies (noms, dates) et techniques pour le fonctionnement du service. Aucune donnée n’est revendue.\n\n# Cookies\nNous utilisons des cookies essentiels au fonctionnement. Les cookies analytiques ne sont activés qu''avec votre consentement.\n\n# Vos Droits\nVous disposez d''un droit d''accès, de modification et de suppression de vos données. Contactez-nous par email pour toute demande.'
)
on conflict (slug) do nothing;

-- B) Conditions Générales de Vente (Fusionne CGU + Paiements + Remboursements)
insert into public.legal_pages (slug, title, display_order, content)
values (
  'cgv', 
  'Conditions Générales de Vente', 
  20,
  E'# Objet\nService de compatibilité et guidance numérologique. Aucune garantie de résultat.\n\n# Paiements\nLes paiements sont sécurisés. Les tarifs sont indiqués clairement avant toute validation.\n\n# Remboursements\nCompte tenu de la nature numérique et immédiate du service, le droit de rétractation peut être levé après accord explicite lors de l''achat, conformément à la législation en vigueur.\n\n# Résiliation\nL''utilisateur peut cesser d''utiliser le service à tout moment.'
)
on conflict (slug) do nothing;

-- C) Aide & Support (Nouveau)
insert into public.legal_pages (slug, title, display_order, content)
values (
  'aide', 
  'Aide & Support', 
  30,
  E'# Besoin d''aide ?\nPour toute question technique ou commerciale, vous pouvez nous contacter :\n\n- Email : growpeak.agence@gmail.com\n- Téléphone : +225 54 255 584\n\nNous répondons généralement sous 24h ouvrées.'
)
on conflict (slug) do nothing;
