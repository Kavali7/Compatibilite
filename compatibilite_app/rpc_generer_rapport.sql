
-- ============================================================
-- FICHIER 3 — MOTEUR D’ASSEMBLAGE (RPC) : génération des rapports
-- - Respecte la logique du PDF (1–9 + maîtres 11/22/33)
-- - Rapport JOUR = 4 blocs : Bloc 0 (canon PDF) + Blocs 1..3 (briques)
-- - Rapport MOIS/ANNÉE = Bloc 0 (canon PDF) + Blocs 1..3 (briques période)
-- - Anti-répétition via brick_usage (dernier usage par brique)
-- ============================================================

create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
-- 1) Fonctions utilitaires : somme des chiffres + réduction
-- ------------------------------------------------------------

create or replace function public.fn_somme_chiffres_txt(p_txt text)
returns integer
language sql
immutable
as $$
  select coalesce(sum(substring(p_txt from i for 1)::int), 0)
  from generate_series(1, length(p_txt)) as i
  where substring(p_txt from i for 1) ~ '[0-9]';
$$;

-- Réduction avec nombres maîtres : s’arrête sur 11/22/33
create or replace function public.fn_reduire_maitre(p_n integer)
returns integer
language plpgsql
immutable
as $$
declare
  n integer := abs(p_n);
begin
  loop
    if n in (11,22,33) then
      return n;
    end if;
    if n < 10 then
      return n;
    end if;
    n := public.fn_somme_chiffres_txt(n::text);
  end loop;
end;
$$;

-- Réduction sans maîtres : s’arrête à 1 chiffre (utile pour N° du mois 10/11/12)
create or replace function public.fn_reduire_sans_maitre(p_n integer)
returns integer
language plpgsql
immutable
as $$
declare
  n integer := abs(p_n);
begin
  loop
    if n < 10 then
      return n;
    end if;
    n := public.fn_somme_chiffres_txt(n::text);
  end loop;
end;
$$;

-- Renvoie la base d’un nombre (11→2, 22→4, 33→6, sinon inchangé)
create or replace function public.fn_base_nombre(p_n integer)
returns integer
language sql
immutable
as $$
  select case
    when p_n = 11 then 2
    when p_n = 22 then 4
    when p_n = 33 then 6
    else p_n
  end;
$$;

-- ------------------------------------------------------------
-- 2) Calculs numérologiques selon le PDF (couple / année / mois / jour)
-- ------------------------------------------------------------

-- Nombre d'une personne (date de naissance) : somme DDMMYYYY puis réduction maîtres
create or replace function public.fn_nombre_personne(p_date date)
returns integer
language sql
immutable
as $$
  select public.fn_reduire_maitre(
    public.fn_somme_chiffres_txt(to_char(p_date, 'DDMMYYYY'))
  );
$$;

-- Année universelle : somme des chiffres de l'année puis réduction maîtres
create or replace function public.fn_annee_universelle(p_annee integer)
returns integer
language sql
immutable
as $$
  select public.fn_reduire_maitre(public.fn_somme_chiffres_txt(p_annee::text));
$$;

-- Numéro du mois (1..12) réduit SANS maîtres (11=novembre→2)
create or replace function public.fn_numero_mois(p_mois integer)
returns integer
language sql
immutable
as $$
  select public.fn_reduire_sans_maitre(p_mois);
$$;

-- Réduction du jour du mois : somme des chiffres du jour puis réduction maîtres
create or replace function public.fn_reduction_jour(p_jour integer)
returns integer
language sql
immutable
as $$
  select public.fn_reduire_maitre(public.fn_somme_chiffres_txt(p_jour::text));
$$;

-- ------------------------------------------------------------
-- 3) État relationnel (harmonieux/neutre/tendu) — heuristique
-- ------------------------------------------------------------

create or replace function public.fn_etat_relationnel(
  p_periode public.periode_rapport,
  p_nb_couple integer,
  p_nb_annee integer,
  p_nb_mois integer,
  p_nb_jour integer
)
returns public.etat_relationnel
language plpgsql
immutable
as $$
declare
  couple_base int := public.fn_base_nombre(p_nb_couple);
  annee_base  int := public.fn_base_nombre(p_nb_annee);
  mois_base   int := public.fn_base_nombre(p_nb_mois);
  jour_base   int := public.fn_base_nombre(p_nb_jour);
  score int;
begin
  if p_periode = 'jour' then
    score := abs(jour_base - mois_base) + abs(jour_base - couple_base);
    if score <= 2 then return 'harmonieux';
    elsif score <= 6 then return 'neutre';
    else return 'tendu';
    end if;

  elsif p_periode = 'mois' then
    score := abs(mois_base - annee_base) + abs(mois_base - couple_base);
    if score <= 2 then return 'harmonieux';
    elsif score <= 6 then return 'neutre';
    else return 'tendu';
    end if;

  else -- année
    score := abs(annee_base - couple_base);
    if score <= 1 then return 'harmonieux';
    elsif score <= 4 then return 'neutre';
    else return 'tendu';
    end if;
  end if;
end;
$$;

-- ------------------------------------------------------------
-- 4) Placeholders : personnalisation minimaliste
-- ------------------------------------------------------------

create or replace function public.fn_appliquer_placeholders(
  p_template text,
  p_user text,
  p_partner text,
  p_user_gender public.sexe_personne,
  p_partner_gender public.sexe_personne
)
returns text
language plpgsql
immutable
as $$
declare
  t text := p_template;
  user_formate text;
  partner_formate text;
  role_partenaire text;
  pronom_partenaire text;
begin
  -- Format names with Mme/M. prefix based on gender
  user_formate := case 
    when p_user_gender = 'femme' then 'Mme ' || coalesce(p_user,'')
    when p_user_gender = 'homme' then 'M. ' || coalesce(p_user,'')
    else coalesce(p_user,'')
  end;
  
  partner_formate := case 
    when p_partner_gender = 'femme' then 'Mme ' || coalesce(p_partner,'')
    when p_partner_gender = 'homme' then 'M. ' || coalesce(p_partner,'')
    else coalesce(p_partner,'')
  end;

  role_partenaire := case when p_partner_gender = 'femme' then 'votre partenaire' else 'votre partenaire' end;
  pronom_partenaire := case when p_partner_gender = 'femme' then 'elle' else 'il' end;

  t := replace(t, '{user}', user_formate);
  t := replace(t, '{partner}', partner_formate);
  t := replace(t, '{role_partenaire}', role_partenaire);
  t := replace(t, '{pronom_partenaire}', pronom_partenaire);

  return t;
end;
$$;

-- ------------------------------------------------------------
-- 5) Sélection stable d'une brique (pseudo-aléatoire indexé)
-- ------------------------------------------------------------

create or replace function public.fn_choisir_brique(
  p_user_id uuid,
  p_bloc smallint,
  p_periode public.periode_contenu,
  p_type_brique text,
  p_numero public.numero_vibration,
  p_ton public.ton_redaction,
  p_etat public.etat_relationnel,
  p_statut public.statut_utilisateur,
  p_date date,
  p_seed text,
  p_langue text default 'fr',
  p_version smallint default 1
)
returns table (id uuid, modele_texte text)
language plpgsql
stable
as $$
declare
  v_seed_num int;
begin
  v_seed_num := abs(hashtext(p_seed || '|' || p_bloc::text || '|' || p_type_brique || '|' || p_numero::text)) % 1000001;

  return query
  with candidates as (
    select cb.id, cb.modele_texte, cb.cle_choix
    from public.content_bricks cb
    left join public.brick_usage bu
      on bu.user_id = p_user_id and bu.brick_id = cb.id
    where cb.actif = true
      and cb.bloc = p_bloc
      and cb.periode in (p_periode, 'toutes')
      and cb.type_brique = p_type_brique
      and cb.numero_cible = p_numero
      -- Ton filter removed for flexibility (any active brick matches)
      and cb.etat_relationnel in ('indifferent', p_etat)
      and cb.statut_utilisateur in ('indifferent', p_statut)
      and cb.langue = p_langue
      and cb.version = p_version
      and (
        bu.dernier_usage is null
        or bu.dernier_usage <= (p_date - cb.jours_refroidissement)
      )
  ),
  pick as (
    (select id, modele_texte from candidates where cle_choix >= v_seed_num order by cle_choix asc limit 1)
    union all
    (select id, modele_texte from candidates where cle_choix <  v_seed_num order by cle_choix asc limit 1)
    limit 1
  )
  select id, modele_texte from pick;
end;
$$;

-- ------------------------------------------------------------
-- 6) RPC principale : génération/cache d'un rapport
-- ------------------------------------------------------------
-- IMPORTANT :
-- - SECURITY DEFINER permet d'écrire dans generated_reports / brick_usage même sans policy client.
-- - Le rapport est généré 1 seule fois par (user, période, date_reference) puis relu depuis le cache.
-- - Le Bloc 0 (canon) est copié/snapshot tel quel (contenu PDF intact).
-- ------------------------------------------------------------

create or replace function public.rpc_generer_rapport(
  p_periode public.periode_rapport,
  p_date date default current_date,
  p_user_id uuid default null  -- Optional: pass user ID for custom auth systems
)
returns public.generated_reports
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := coalesce(p_user_id, auth.uid());  -- Use passed ID or fall back to auth.uid()
  v_ref_date date;
  v_periode_contenu public.periode_contenu;

  v_profile public.couple_profiles%rowtype;

  v_nb_user int;
  v_nb_partner int;
  v_nb_couple int;

  v_year_u int;
  v_year_c int;
  v_month_idx int;
  v_month_c int;
  v_day_red int;
  v_day_c int;

  v_num_periode int;
  v_num_base int;

  v_etat public.etat_relationnel;
  v_statut public.statut_utilisateur := 'en_couple';

  v_seed text;

  v_canon public.canonical_predictions%rowtype;

  -- Briques (ids + templates)
  b1_energy_id uuid; b1_energy_tpl text;
  b1_focus_id uuid;  b1_focus_tpl text;
  b1_alert_id uuid;  b1_alert_tpl text;
  b1_advice_id uuid; b1_advice_tpl text;

  b2_posture_id uuid; b2_posture_tpl text;
  b2_levier_id uuid;  b2_levier_tpl text;
  b2_risque_id uuid;  b2_risque_tpl text;

  b3_acte_id uuid;    b3_acte_tpl text;
  b3_rituel_id uuid;  b3_rituel_tpl text;
  b3_couple_id uuid;  b3_couple_tpl text;
  b3_travail_id uuid; b3_travail_tpl text;
  b3_argent_id uuid;  b3_argent_tpl text;
  b3_sante_id uuid;   b3_sante_tpl text;
  b3_feu_id uuid;     b3_feu_tpl text;

  v_bloc1 text;
  v_bloc2 text;
  v_bloc3 text;

  v_briques uuid[];
  v_new public.generated_reports%rowtype;
  
  -- Configuration dynamique des sections
  v_config jsonb;
begin
  -- Chargement de la configuration (titres et activation)
  select jsonb_object_agg(code, jsonb_build_object('label', label_fr, 'is_active', is_active))
  into v_config
  from public.report_sections;

  -- Fallback si la table est vide (sécurité)
  v_config := coalesce(v_config, '{}'::jsonb);

  if v_uid is null then
    raise exception 'Utilisateur non authentifié';
  end if;

  -- date_reference selon période
  if p_periode = 'jour' then
    v_ref_date := p_date;
    v_periode_contenu := 'jour';
  elsif p_periode = 'mois' then
    v_ref_date := date_trunc('month', p_date)::date;
    v_periode_contenu := 'mois';
  else
    v_ref_date := date_trunc('year', p_date)::date;
    v_periode_contenu := 'annee';
  end if;

  -- Cache : si déjà généré, on renvoie
  select * into v_new
  from public.generated_reports
  where user_id = v_uid and periode = p_periode and date_reference = v_ref_date;

  if found then
    return v_new;
  end if;

  -- Profil couple
  select * into v_profile
  from public.couple_profiles
  where user_id = v_uid;

  if not found then
    raise exception 'Profil couple introuvable pour cet utilisateur';
  end if;

  -- Calculs selon PDF
  v_nb_user    := public.fn_nombre_personne(v_profile.user_birthdate);
  v_nb_partner := public.fn_nombre_personne(v_profile.partner_birthdate);
  v_nb_couple  := public.fn_reduire_maitre(v_nb_user + v_nb_partner);

  v_year_u := public.fn_annee_universelle(extract(year from v_ref_date)::int);
  v_year_c := public.fn_reduire_maitre(v_nb_couple + v_year_u);

  v_month_idx := public.fn_numero_mois(extract(month from v_ref_date)::int);
  v_month_c   := public.fn_reduire_maitre(v_year_c + v_month_idx);

  v_day_red := public.fn_reduction_jour(extract(day from v_ref_date)::int);
  v_day_c   := public.fn_reduire_maitre(v_month_c + v_day_red);

  if p_periode = 'annee' then
    v_num_periode := v_year_c;
  elsif p_periode = 'mois' then
    v_num_periode := v_month_c;
  else
    v_num_periode := v_day_c;
  end if;

  v_num_base := public.fn_base_nombre(v_num_periode);

  v_etat := public.fn_etat_relationnel(p_periode, v_nb_couple, v_year_c, v_month_c, v_day_c);

  -- Seed stable (using md5 - native PostgreSQL function, no extension needed)
  v_seed := md5(
    v_uid::text || '|' || v_ref_date::text || '|' || p_periode::text || '|' || v_num_periode::text
  );

  -- Canon : chercher numéro exact (incluant 11/22/33)
  select * into v_canon
  from public.canonical_predictions
  where periode = p_periode
    and numero = v_num_periode::public.numero_vibration
    and langue = 'fr'
    and version = 1;

  -- Fallback canon : si numéro maître absent, on tombe sur la base (11→2, etc.)
  if not found then
    select * into v_canon
    from public.canonical_predictions
    where periode = p_periode
      and numero = v_num_base::public.numero_vibration
      and langue = 'fr'
      and version = 1;

    if not found then
      raise exception 'Prévision canon introuvable (periode %, numero %)', p_periode, v_num_periode;
    end if;
  end if;

  -- ==========================
  -- Sélection des briques
  -- Règle : essayer d'abord le numéro exact, sinon fallback base.
  -- (Vous pourrez écrire des briques spécifiques 11/22/33 plus tard.)
  -- ==========================

  -- Bloc 1 (energie, focus, alerte, conseil)
  select id, modele_texte into b1_energy_id, b1_energy_tpl
  from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'energie', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b1_energy_id is null then
    select id, modele_texte into b1_energy_id, b1_energy_tpl
    from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'energie', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b1_focus_id, b1_focus_tpl
  from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'focus', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b1_focus_id is null then
    select id, modele_texte into b1_focus_id, b1_focus_tpl
    from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'focus', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b1_alert_id, b1_alert_tpl
  from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'alerte', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b1_alert_id is null then
    select id, modele_texte into b1_alert_id, b1_alert_tpl
    from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'alerte', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b1_advice_id, b1_advice_tpl
  from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'conseil', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b1_advice_id is null then
    select id, modele_texte into b1_advice_id, b1_advice_tpl
    from public.fn_choisir_brique(v_uid, 1, v_periode_contenu, 'conseil', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  v_bloc1 := trim(
    coalesce(public.fn_appliquer_placeholders(b1_energy_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || ' ' ||
    coalesce(public.fn_appliquer_placeholders(b1_focus_tpl,  v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || ' ' ||
    coalesce(public.fn_appliquer_placeholders(b1_alert_tpl,  v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || ' ' ||
    coalesce(public.fn_appliquer_placeholders(b1_advice_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'')
  );

  -- Bloc 2 (posture, levier, risque)
  select id, modele_texte into b2_posture_id, b2_posture_tpl
  from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'posture', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b2_posture_id is null then
    select id, modele_texte into b2_posture_id, b2_posture_tpl
    from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'posture', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b2_levier_id, b2_levier_tpl
  from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'levier', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b2_levier_id is null then
    select id, modele_texte into b2_levier_id, b2_levier_tpl
    from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'levier', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b2_risque_id, b2_risque_tpl
  from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'risque', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b2_risque_id is null then
    select id, modele_texte into b2_risque_id, b2_risque_tpl
    from public.fn_choisir_brique(v_uid, 2, v_periode_contenu, 'risque', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  v_bloc2 := trim(
    coalesce(public.fn_appliquer_placeholders(b2_posture_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || ' ' ||
    coalesce(public.fn_appliquer_placeholders(b2_levier_tpl,  v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || ' ' ||
    coalesce(public.fn_appliquer_placeholders(b2_risque_tpl,  v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'')
  );

  -- Bloc 3 (checklist premium)
  select id, modele_texte into b3_acte_id, b3_acte_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'acte', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_acte_id is null then
    select id, modele_texte into b3_acte_id, b3_acte_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'acte', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_rituel_id, b3_rituel_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'rituel', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_rituel_id is null then
    select id, modele_texte into b3_rituel_id, b3_rituel_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'rituel', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_couple_id, b3_couple_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'couple', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_couple_id is null then
    select id, modele_texte into b3_couple_id, b3_couple_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'couple', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_travail_id, b3_travail_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'travail', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_travail_id is null then
    select id, modele_texte into b3_travail_id, b3_travail_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'travail', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_argent_id, b3_argent_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'argent', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_argent_id is null then
    select id, modele_texte into b3_argent_id, b3_argent_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'argent', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_sante_id, b3_sante_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'sante', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_sante_id is null then
    select id, modele_texte into b3_sante_id, b3_sante_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'sante', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  select id, modele_texte into b3_feu_id, b3_feu_tpl
  from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'feu', v_num_periode::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
  limit 1;
  if b3_feu_id is null then
    select id, modele_texte into b3_feu_id, b3_feu_tpl
    from public.fn_choisir_brique(v_uid, 3, v_periode_contenu, 'feu', v_num_base::public.numero_vibration, 'neutre', v_etat, v_statut, v_ref_date, v_seed)
    limit 1;
  end if;

  v_bloc3 := '';

  -- Construction dynamique selon la période
  if p_periode = 'jour' then
     if (v_config->'b3_acte_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_acte_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_acte_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_rituel_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_rituel_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_rituel_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n\n';
     end if;
     if (v_config->'b3_couple_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_couple_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_couple_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_travail_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_travail_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_travail_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_argent_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_argent_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_argent_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_sante_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_sante_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_sante_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_feu_jour'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_feu_jour'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_feu_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'');
     end if;

  elsif p_periode = 'mois' then
     if (v_config->'b3_acte_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_acte_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_acte_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_rituel_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_rituel_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_rituel_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n\n';
     end if;
     if (v_config->'b3_couple_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_couple_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_couple_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_travail_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_travail_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_travail_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_argent_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_argent_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_argent_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_sante_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_sante_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_sante_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_feu_mois'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_feu_mois'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_feu_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'');
     end if;

  else -- annee
     if (v_config->'b3_acte_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_acte_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_acte_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_rituel_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_rituel_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_rituel_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n\n';
     end if;
     if (v_config->'b3_couple_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_couple_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_couple_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_travail_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_travail_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_travail_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_argent_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_argent_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_argent_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_sante_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_sante_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_sante_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'') || E'\n';
     end if;
     if (v_config->'b3_feu_annee'->>'is_active')::boolean is not false then
        v_bloc3 := v_bloc3 || (v_config->'b3_feu_annee'->>'label') || ' ' || coalesce(public.fn_appliquer_placeholders(b3_feu_tpl, v_profile.user_firstname, v_profile.partner_firstname, v_profile.user_gender, v_profile.partner_gender),'');
     end if;
  end if;

  -- Liste des briques utilisées (sans null)
  v_briques := array_remove(ARRAY[
    b1_energy_id, b1_focus_id, b1_alert_id, b1_advice_id,
    b2_posture_id, b2_levier_id, b2_risque_id,
    b3_acte_id, b3_rituel_id, b3_couple_id, b3_travail_id, b3_argent_id, b3_sante_id, b3_feu_id
  ], null);

  -- Insertion cache
  insert into public.generated_reports (
    user_id, couple_profile_id, periode, date_reference,
    numero_couple, numero_annee, numero_mois, numero_jour,
    etat_rel, seed,
    canonical_prediction_id,
    bloc0_titre, bloc0_contenu_md,
    bloc1_contenu, bloc2_contenu, bloc3_contenu,
    briques_utilisees,
    contexte
  )
  values (
    v_uid, v_profile.id, p_periode, v_ref_date,
    v_nb_couple::public.numero_vibration,
    v_year_c::public.numero_vibration,
    v_month_c::public.numero_vibration,
    v_day_c::public.numero_vibration,
    v_etat, v_seed,
    v_canon.id,
    v_canon.titre, v_canon.contenu_md,
    nullif(v_bloc1,''), nullif(v_bloc2,''), nullif(v_bloc3,''),
    v_briques,
    jsonb_build_object(
      'numeros', jsonb_build_object(
        'utilisateur', v_nb_user,
        'partenaire', v_nb_partner,
        'couple', v_nb_couple,
        'annee_universelle', v_year_u,
        'annee', v_year_c,
        'mois_index', v_month_idx,
        'mois', v_month_c,
        'jour_reduit', v_day_red,
        'jour', v_day_c
      ),
      'periode', p_periode,
      'date_reference', v_ref_date,
      'etat_relationnel', v_etat,
      'seed', v_seed,
      'note', 'Bloc 0 = contenu canon PDF (verbatim), Blocs 1..3 = briques personnalisées'
    )
  )
  returning * into v_new;

  -- Anti-répétition : upsert dernier usage
  if array_length(v_briques, 1) is not null then
    for i in 1..array_length(v_briques, 1) loop
      insert into public.brick_usage (user_id, brick_id, dernier_usage, dernier_report_id)
      values (v_uid, v_briques[i], v_ref_date, v_new.id)
      on conflict (user_id, brick_id)
      do update set dernier_usage = excluded.dernier_usage,
                    dernier_report_id = excluded.dernier_report_id,
                    updated_at = now();
    end loop;
  end if;

  return v_new;
end;
$$;

-- Sécuriser l'exécution : uniquement utilisateurs authentifiés
revoke all on function public.rpc_generer_rapport(public.periode_rapport, date, uuid) from public;
grant execute on function public.rpc_generer_rapport(public.periode_rapport, date, uuid) to authenticated;


