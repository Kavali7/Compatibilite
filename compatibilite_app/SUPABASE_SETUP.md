# Plan de configuration Supabase (pour l agent Supabase)

## Prerequis
- Activer les extensions : `uuid-ossp`, `pgcrypto`.
- Auth : activer OTP email (passwordless). SMS optionnel.
- Definir l URL de redirection d auth (ex. `app://callback` ou une URL web).

## Schema SQL a creer (tables en francais)
```sql
-- Extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- Profils utilisateurs (lie a auth.users)
create table if not exists profils (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  telephone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Sessions de compatibilite
create table if not exists sessions_compatibilite (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  client_token text not null default gen_random_uuid(),
  created_at timestamptz not null default now(),
  partenaire_a_nom text not null,
  partenaire_a_naissance date not null,
  partenaire_b_nom text not null,
  partenaire_b_naissance date not null,
  statut_relation text,
  date_rencontre date,
  duree_relation text,
  defis text[] not null default '{}',
  notifications boolean not null default false,
  email_contact text,
  telephone_contact text,
  nombre_couple smallint not null,
  nombre_couple_jour smallint not null,
  genere_le timestamptz not null,
  statut_paiement text not null default 'pending' check (statut_paiement in ('pending','requires_action','paid','failed','refunded')),
  fournisseur_paiement text,
  reference_paiement text,
  montant_centimes integer,
  devise text not null default 'EUR',
  paye_le timestamptz,
  metadata jsonb not null default '{}'
);
create unique index if not exists idx_sessions_token on sessions_compatibilite(client_token);
create index if not exists idx_sessions_user on sessions_compatibilite(user_id);
create index if not exists idx_sessions_statut on sessions_compatibilite(statut_paiement);

-- Rapports detailles par partenaire
create table if not exists rapports_partenaires (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references sessions_compatibilite(id) on delete cascade,
  role_partenaire text not null,
  nom_partenaire text not null,
  chemin_vie smallint not null,
  nombre_nom smallint not null,
  nombre_kabbale smallint not null,
  nombre_intime smallint not null,
  nombre_personnalite smallint not null,
  nombre_heredite smallint not null,
  annee_personnelle smallint not null,
  mois_personnel smallint not null,
  jour_personnel smallint not null
);
create index if not exists idx_rapports_session on rapports_partenaires(session_id);
```

## Politiques RLS
```sql
alter table profils enable row level security;
alter table sessions_compatibilite enable row level security;
alter table rapports_partenaires enable row level security;

-- profils : chaque utilisateur ne voit/modifie que sa ligne
create policy "profils_self_select" on profils for select using (auth.uid() = id);
create policy "profils_self_insert" on profils for insert with check (auth.uid() = id);
create policy "profils_self_update" on profils for update using (auth.uid() = id) with check (auth.uid() = id);

-- sessions_compatibilite : insertion ouverte (cle anon) pour enregistrer un rapport
create policy "sessions_insert_anon" on sessions_compatibilite
  for insert to anon with check (true);

-- sessions_compatibilite : acces complet pour service_role (analytics / webhooks)
create policy "sessions_service_all" on sessions_compatibilite
  for all to service_role using (true) with check (true);

-- sessions_compatibilite : lecture pour l utilisateur authentifie sur ses lignes
create policy "sessions_user_select" on sessions_compatibilite
  for select using (auth.uid() is not null and auth.uid() = user_id);

-- sessions_compatibilite : lecture via client_token (a activer si necessaire)
-- create policy "sessions_client_token_read" on sessions_compatibilite
--   for select to anon using (client_token = current_setting('request.headers')::json->>'x-client-token');

-- rapports_partenaires : insertion autorisee si la session existe
create policy "rapports_insert_anon" on rapports_partenaires
  for insert to anon with check (exists (select 1 from sessions_compatibilite s where s.id = session_id));

-- rapports_partenaires : acces complet pour service_role
create policy "rapports_service_all" on rapports_partenaires
  for all to service_role using (true) with check (true);

-- rapports_partenaires : lecture pour l utilisateur authentifie (si user_id present sur la session)
create policy "rapports_user_select" on rapports_partenaires
  for select using (
    auth.uid() is not null and exists (
      select 1 from sessions_compatibilite s
      where s.id = session_id and s.user_id = auth.uid()
    )
  );
```

## Paiement (KKIAPAY)
- Creer/recuperer les cles KKIAPAY (public/private/secret).
- Configurer le callback KKIAPAY vers un endpoint (Edge Function ou webhook HTTP) protege par la `service_role`.
- A la notification de paiement reussi, mettre a jour Supabase :
  `update sessions_compatibilite set statut_paiement='paid', paye_le=now(), reference_paiement=<tx_id>, fournisseur_paiement='kkiapay' where reference_paiement=<tx_id>;`
- En cas d echec : `statut_paiement='failed'` pour la transaction.
- Ne jamais exposer la cle `service_role` dans l application cliente (uniquement cote serveur/webhook).

## Informations a remonter apres setup
- SUPABASE_URL (projet)
- SUPABASE_ANON_KEY (client)
- SUPABASE_SERVICE_ROLE_KEY (serveur/webhooks)
- Si paiement active : KKIAPAY_PUBLIC_KEY, KKIAPAY_PRIVATE_KEY, KKIAPAY_SECRET
- Confirmation : extensions actives, tables creees, RLS appliquees, webhook Stripe (URL + secret), OTP email active.

## Attentes cote app Flutter
- `.env` doit contenir : SUPABASE_URL, SUPABASE_ANON_KEY.
- Le wizard envoie : noms, dates de naissance, contexte, email, telephone, preferences, resultats numeriques.
- Les lignes sont inserees avec `statut_paiement='pending'`; le webhook Stripe doit passer a `paid`.
