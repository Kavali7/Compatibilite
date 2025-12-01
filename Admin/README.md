# Admin Compatibilite (web)

Petit panneau d admin en React/Vite pour consulter les sessions et rapports dans Supabase.

## Prerequis
- Node 18+
- Variables dans `.env` (copier depuis `.env.example`) :
  - `VITE_SUPABASE_URL` = https://lqhdvlkfzjbwujfkceis.supabase.co
  - `VITE_SUPABASE_SERVICE_ROLE_KEY` = cle service_role (ne jamais publier)
  - Optionnel : `VITE_SUPABASE_ANON_KEY` si vous avez des policies admin cote RLS et pas besoin de service_role.

## Installation
```bash
cd Admin
npm install
npm run dev
```

## Securite
- Le service_role ne doit pas etre expose publiquement. Pour un deploy, proteger l acces (VPN / Basic auth) ou intercaler une fonction serveur (Edge) qui porte la cle.
- Sans policy admin cote RLS, seul le service_role permet de lire toutes les sessions.

## Fonctionnalites
- Liste des `sessions_compatibilite`, filtre par email/tel/nom/token.
- Detail paiements (statut, reference, montant).
- Chargement des `rapports_partenaires` par session.

## Evolutions possibles
- Auth admin OTP + policies RLS dediees.
- Edition des interpretations via une table Supabase.
- Gestion des paiements (changement de statut) via une fonction serveur securisee.
