
-- ============================================================
-- SCHEMA SUPABASE (POSTGRES) — PRÉVISIONS TEMPORELLES
-- Canon PDF (verbatim) + Bibliothèque de briques + Cache rapports
-- Enums en français (exigence projet)
-- ============================================================

-- Extensions utiles (Supabase les a souvent déjà, mais on sécurise)
create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
-- 1) TYPES (ENUMS) — valeurs en français
-- ------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'periode_rapport') then
    create type public.periode_rapport as enum ('jour', 'mois', 'annee');
  end if;

  if not exists (select 1 from pg_type where typname = 'periode_contenu') then
    create type public.periode_contenu as enum ('jour', 'mois', 'annee', 'toutes');
  end if;

  if not exists (select 1 from pg_type where typname = 'etat_relationnel') then
    create type public.etat_relationnel as enum ('indifferent', 'harmonieux', 'neutre', 'tendu');
  end if;

  if not exists (select 1 from pg_type where typname = 'statut_utilisateur') then
    create type public.statut_utilisateur as enum ('indifferent', 'en_couple', 'celibataire');
  end if;

  if not exists (select 1 from pg_type where typname = 'ton_redaction') then
    create type public.ton_redaction as enum ('direct_doux', 'direct', 'intense');
  end if;

  if not exists (select 1 from pg_type where typname = 'sexe_personne') then
    create type public.sexe_personne as enum ('non_precise', 'homme', 'femme', 'non_binaire');
  end if;
end $$;

-- ------------------------------------------------------------
-- 2) DOMAINES (contraintes réutilisables)
-- ------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'numero_vibration') then
    create domain public.numero_vibration as smallint
      check (value in (1,2,3,4,5,6,7,8,9,11,22,33));
  end if;
exception
  when duplicate_object then null;
end $$;

-- ------------------------------------------------------------
-- 3) TRIGGER updated_at (standard)
-- ------------------------------------------------------------
create or replace function public.fn_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ------------------------------------------------------------
-- 4) TABLES
-- ------------------------------------------------------------

-- 4A) Profil couple déclaré par l’utilisateur
create table if not exists public.couple_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,

  user_firstname text not null,
  user_birthdate date not null,
  user_gender public.sexe_personne not null default 'non_precise',

  partner_firstname text not null,
  partner_birthdate date not null,
  partner_gender public.sexe_personne not null default 'non_precise',

  relationship_start_date date null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint couple_profiles_one_per_user unique (user_id)
);

drop trigger if exists trg_couple_profiles_updated_at on public.couple_profiles;
create trigger trg_couple_profiles_updated_at
before update on public.couple_profiles
for each row execute function public.fn_set_updated_at();


-- 4B) Canon (PDF) — contenu verrouillé, copié/verbatim
-- Stocke ANNÉE / MOIS / JOUR pour numéros 1–9 + 11/22/33
create table if not exists public.canonical_predictions (
  id uuid primary key default gen_random_uuid(),

  periode public.periode_rapport not null,
  numero public.numero_vibration not null,

  titre text not null,
  contenu_md text not null,          -- markdown/texte formaté (contenu identique au PDF)
  contenu_sha256 text generated always as (
    encode(digest(contenu_md, 'sha256'), 'hex')
  ) stored,

  source_document text not null default 'Rapports couple.pdf',
  verrouille boolean not null default true,

  langue text not null default 'fr',
  version smallint not null default 1,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint canonical_predictions_unique unique (periode, numero, langue, version)
);

drop trigger if exists trg_canonical_predictions_updated_at on public.canonical_predictions;
create trigger trg_canonical_predictions_updated_at
before update on public.canonical_predictions
for each row execute function public.fn_set_updated_at();


-- 4C) Bibliothèque de briques (blocs 1–3 + overlays maîtres si besoin)
create table if not exists public.content_bricks (
  id uuid primary key default gen_random_uuid(),

  bloc smallint not null check (bloc in (1,2,3)),
  periode public.periode_contenu not null default 'jour',

  -- type_brique reste en texte pour flexibilité (ex: 'energie','focus','acte','argent'...)
  type_brique text not null,

  -- numéro cible : 1–9 ou 11/22/33
  numero_cible public.numero_vibration not null,

  -- colonnes dérivées (base/maître) pour faciliter le filtrage
  numero_base smallint generated always as (
    case
      when numero_cible = 11 then 2
      when numero_cible = 22 then 4
      when numero_cible = 33 then 6
      else numero_cible
    end
  ) stored,

  numero_maitre smallint generated always as (
    case when numero_cible in (11,22,33) then numero_cible else null end
  ) stored,

  etat_relationnel public.etat_relationnel not null default 'indifferent',
  statut_utilisateur public.statut_utilisateur not null default 'indifferent',
  ton public.ton_redaction not null default 'direct_doux',

  modele_texte text not null,  -- texte avec placeholders: {user}, {partner}, etc.

  jours_refroidissement integer not null default 21 check (jours_refroidissement >= 0),
  poids numeric not null default 1.0 check (poids > 0),
  actif boolean not null default true,

  -- clé de sélection pseudo-aléatoire (pré-calculée pour requêtes indexées)
  cle_choix integer not null default (floor(random()*1000000))::int check (cle_choix between 0 and 1000000),

  tags text[] not null default '{}'::text[],
  langue text not null default 'fr',
  version smallint not null default 1,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists trg_content_bricks_updated_at on public.content_bricks;
create trigger trg_content_bricks_updated_at
before update on public.content_bricks
for each row execute function public.fn_set_updated_at();

-- Index principal pour sélection rapide + stable
create index if not exists idx_content_bricks_lookup
on public.content_bricks (
  bloc, periode, type_brique, numero_cible, ton, etat_relationnel, statut_utilisateur, langue, version, cle_choix
)
where actif;

create index if not exists idx_content_bricks_base
on public.content_bricks (numero_base);

create index if not exists idx_content_bricks_master
on public.content_bricks (numero_maitre);

create index if not exists idx_content_bricks_tags
on public.content_bricks using gin (tags);


-- 4D) Anti-répétition (mémoire) — 1 ligne par (user, brique)
-- Stocke seulement le dernier usage, plus économique qu’un log infini.
create table if not exists public.brick_usage (
  user_id uuid not null references auth.users(id) on delete cascade,
  brick_id uuid not null references public.content_bricks(id) on delete cascade,

  dernier_usage date not null,
  dernier_report_id uuid null,

  updated_at timestamptz not null default now(),

  primary key (user_id, brick_id)
);

drop trigger if exists trg_brick_usage_updated_at on public.brick_usage;
create trigger trg_brick_usage_updated_at
before update on public.brick_usage
for each row execute function public.fn_set_updated_at();

create index if not exists idx_brick_usage_user_last
on public.brick_usage (user_id, dernier_usage desc);


-- 4E) Cache des rapports générés (jour/mois/année)
-- Le rapport du jour contiendra 4 blocs :
-- bloc0 = canon PDF (verbatim) + blocs 1..3 = briques (personnalisées).
create table if not exists public.generated_reports (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null references auth.users(id) on delete cascade,
  couple_profile_id uuid null references public.couple_profiles(id) on delete set null,

  periode public.periode_rapport not null,
  date_reference date not null, -- jour: date du jour ; mois: 1er du mois ; année: 1er janvier

  -- contexte numérologique (utile debug/analytics)
  numero_couple public.numero_vibration not null,
  numero_annee public.numero_vibration null,
  numero_mois public.numero_vibration null,
  numero_jour public.numero_vibration null,

  etat_rel public.etat_relationnel not null default 'indifferent',
  seed text not null,

  canonical_prediction_id uuid not null references public.canonical_predictions(id),

  -- Bloc 0 (canon) — copié tel quel depuis canonical_predictions (snapshot)
  bloc0_titre text not null,
  bloc0_contenu_md text not null,

  -- Blocs 1 à 3 (personnalisés)
  bloc1_contenu text null,
  bloc2_contenu text null,
  bloc3_contenu text null,

  briques_utilisees uuid[] not null default '{}'::uuid[],
  contexte jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),

  constraint generated_reports_unique unique (user_id, periode, date_reference)
);

create index if not exists idx_generated_reports_user_date
on public.generated_reports (user_id, periode, date_reference desc);

-- (Optionnel) vue compat : "daily_reports" = rapports jour
create or replace view public.daily_reports as
select * from public.generated_reports where periode = 'jour';


-- ------------------------------------------------------------
-- 5) RLS (Row Level Security)
-- ------------------------------------------------------------

-- couple_profiles : l’utilisateur gère son propre profil
alter table public.couple_profiles enable row level security;

drop policy if exists couple_profiles_select_own on public.couple_profiles;
create policy couple_profiles_select_own
on public.couple_profiles
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists couple_profiles_insert_own on public.couple_profiles;
create policy couple_profiles_insert_own
on public.couple_profiles
for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists couple_profiles_update_own on public.couple_profiles;
create policy couple_profiles_update_own
on public.couple_profiles
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists couple_profiles_delete_own on public.couple_profiles;
create policy couple_profiles_delete_own
on public.couple_profiles
for delete
to authenticated
using (user_id = auth.uid());


-- canonical_predictions : lecture autorisée, écriture réservée au service (pas de policy insert/update/delete)
alter table public.canonical_predictions enable row level security;

drop policy if exists canonical_predictions_select_auth on public.canonical_predictions;
create policy canonical_predictions_select_auth
on public.canonical_predictions
for select
to authenticated
using (true);


-- content_bricks : lecture autorisée, écriture réservée au service (pas de policy insert/update/delete)
alter table public.content_bricks enable row level security;

drop policy if exists content_bricks_select_auth on public.content_bricks;
create policy content_bricks_select_auth
on public.content_bricks
for select
to authenticated
using (true);


-- brick_usage : lecture autorisée sur soi ; écriture réservée au service (pas de policy insert/update/delete)
alter table public.brick_usage enable row level security;

drop policy if exists brick_usage_select_own on public.brick_usage;
create policy brick_usage_select_own
on public.brick_usage
for select
to authenticated
using (user_id = auth.uid());


-- generated_reports : lecture autorisée sur soi ; écriture réservée au service (pas de policy insert/update/delete)
alter table public.generated_reports enable row level security;

drop policy if exists generated_reports_select_own on public.generated_reports;
create policy generated_reports_select_own
on public.generated_reports
for select
to authenticated
using (user_id = auth.uid());

