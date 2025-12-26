-- ============================================================
-- SCRIPT DE CORRECTION : Table generated_reports
-- Exécutez ce script dans Supabase SQL Editor pour créer/corriger la table
-- ============================================================

-- 1) Créer les types manquants s'ils n'existent pas
do $$
begin
  if not exists (select 1 from pg_type where typname = 'periode_rapport') then
    create type public.periode_rapport as enum ('jour', 'mois', 'annee');
  end if;

  if not exists (select 1 from pg_type where typname = 'etat_relationnel') then
    create type public.etat_relationnel as enum ('indifferent', 'harmonieux', 'neutre', 'tendu');
  end if;

  if not exists (select 1 from pg_type where typname = 'sexe_personne') then
    create type public.sexe_personne as enum ('non_precise', 'homme', 'femme', 'non_binaire');
  end if;
end $$;

-- 2) Créer le domaine numero_vibration s'il n'existe pas
do $$
begin
  if not exists (select 1 from pg_type where typname = 'numero_vibration') then
    create domain public.numero_vibration as smallint
      check (value in (1,2,3,4,5,6,7,8,9,11,22,33));
  end if;
exception
  when duplicate_object then null;
end $$;

-- 3) Créer la table generated_reports si elle n'existe pas
create table if not exists public.generated_reports (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null,
  couple_profile_id uuid null,

  periode public.periode_rapport not null,
  date_reference date not null,

  numero_couple smallint not null,
  numero_annee smallint null,
  numero_mois smallint null,
  numero_jour smallint null,

  etat_rel public.etat_relationnel not null default 'indifferent',
  seed text not null default '',

  canonical_prediction_id uuid null,

  bloc0_titre text not null default '',
  bloc0_contenu_md text not null default '',

  bloc1_contenu text null,
  bloc2_contenu text null,
  bloc3_contenu text null,

  briques_utilisees uuid[] not null default '{}'::uuid[],
  contexte jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now()
);

-- 4) Ajouter les colonnes manquantes si la table existe déjà mais incomplète
do $$
begin
  -- Ajouter periode si manquante
  if not exists (
    select 1 from information_schema.columns 
    where table_schema = 'public' 
    and table_name = 'generated_reports' 
    and column_name = 'periode'
  ) then
    alter table public.generated_reports add column periode public.periode_rapport not null default 'jour';
  end if;

  -- Ajouter date_reference si manquante
  if not exists (
    select 1 from information_schema.columns 
    where table_schema = 'public' 
    and table_name = 'generated_reports' 
    and column_name = 'date_reference'
  ) then
    alter table public.generated_reports add column date_reference date not null default current_date;
  end if;

  -- Ajouter etat_rel si manquante
  if not exists (
    select 1 from information_schema.columns 
    where table_schema = 'public' 
    and table_name = 'generated_reports' 
    and column_name = 'etat_rel'
  ) then
    alter table public.generated_reports add column etat_rel public.etat_relationnel not null default 'indifferent';
  end if;

  -- Ajouter contexte si manquante
  if not exists (
    select 1 from information_schema.columns 
    where table_schema = 'public' 
    and table_name = 'generated_reports' 
    and column_name = 'contexte'
  ) then
    alter table public.generated_reports add column contexte jsonb not null default '{}'::jsonb;
  end if;
end $$;

-- 5) Créer l'index
create index if not exists idx_generated_reports_user_date
on public.generated_reports (user_id, periode, date_reference desc);

-- 6) Activer RLS
alter table public.generated_reports enable row level security;

-- 7) Créer la politique de lecture
drop policy if exists generated_reports_select_own on public.generated_reports;
create policy generated_reports_select_own
on public.generated_reports
for select
to authenticated
using (user_id = auth.uid());

-- 8) Vérification finale
select 
  column_name, 
  data_type, 
  is_nullable
from information_schema.columns 
where table_schema = 'public' 
and table_name = 'generated_reports'
order by ordinal_position;
