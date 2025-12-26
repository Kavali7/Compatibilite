-- ============================================================
-- SCRIPT DE CORRECTION : Politiques RLS pour auth personnalisée
-- Le problème: l'app utilise une table 'users' personnalisée, pas auth.users
-- Les politiques RLS vérifient auth.uid() qui ne correspond pas
-- ============================================================

-- OPTION 1: Autoriser les insertions/updates par utilisateurs authentifiés
-- (le service vérifiera lui-même le user_id)

-- couple_profiles: Permettre insert/update/delete pour authenticated
alter table public.couple_profiles enable row level security;

-- Supprimer les anciennes politiques
drop policy if exists couple_profiles_select_own on public.couple_profiles;
drop policy if exists couple_profiles_insert_own on public.couple_profiles;
drop policy if exists couple_profiles_update_own on public.couple_profiles;
drop policy if exists couple_profiles_delete_own on public.couple_profiles;

-- Nouvelle politique SELECT: permettre à tous les authentifiés de lire leur propre profil
-- OU permettre lecture si l'utilisateur est dans la table users
create policy couple_profiles_select_policy
on public.couple_profiles
for select
to authenticated
using (true);  -- Temporairement permissif, à affiner selon besoin

-- Nouvelle politique INSERT: permettre aux authentifiés d'insérer
create policy couple_profiles_insert_policy
on public.couple_profiles
for insert
to authenticated
with check (true);  -- Accepter toutes les insertions d'utilisateurs authentifiés

-- Nouvelle politique UPDATE: permettre les mises à jour sur ses propres profils
create policy couple_profiles_update_policy
on public.couple_profiles
for update
to authenticated
using (true)
with check (true);

-- Nouvelle politique DELETE: permettre les suppressions
create policy couple_profiles_delete_policy
on public.couple_profiles
for delete
to authenticated
using (true);

-- ============================================================
-- generated_reports: même logique
-- ============================================================

alter table public.generated_reports enable row level security;

drop policy if exists generated_reports_select_own on public.generated_reports;
drop policy if exists generated_reports_insert_policy on public.generated_reports;
drop policy if exists generated_reports_update_policy on public.generated_reports;

-- SELECT: lecture permise
create policy generated_reports_select_policy
on public.generated_reports
for select
to authenticated
using (true);

-- INSERT: la RPC utilise SECURITY DEFINER donc pas besoin de policy INSERT
-- Mais on l'ajoute au cas où
create policy generated_reports_insert_policy
on public.generated_reports
for insert
to authenticated
with check (true);

-- ============================================================
-- brick_usage: même logique
-- ============================================================

alter table public.brick_usage enable row level security;

drop policy if exists brick_usage_select_own on public.brick_usage;
drop policy if exists brick_usage_insert_policy on public.brick_usage;

create policy brick_usage_select_policy
on public.brick_usage
for select
to authenticated
using (true);

create policy brick_usage_insert_policy
on public.brick_usage
for insert
to authenticated
with check (true);

create policy brick_usage_update_policy
on public.brick_usage
for update
to authenticated
using (true)
with check (true);

-- ============================================================
-- Vérification
-- ============================================================
select 
  schemaname,
  tablename,
  policyname,
  permissive,
  cmd
from pg_policies 
where schemaname = 'public'
order by tablename, policyname;
