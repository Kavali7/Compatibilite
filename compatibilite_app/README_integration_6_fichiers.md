# Guide d’intégration — Prévisions (6 fichiers)

Ce guide explique **quoi faire avec chacun des 6 fichiers**, dans quel ordre les exécuter/importer dans **Supabase**, et quels points vérifier (RLS, encodage, caractères spéciaux).

---

## Vue d’ensemble

Votre système de prévisions repose sur 2 sources de contenu :

1) **Le “Canon PDF”** (verbatim, verrouillé)  
→ Table `canonical_predictions` (ANNÉE / MOIS / JOUR, numéros 1–9 + 11/22/33), issu du PDF *Rapports couple.pdf*.

2) **La “Bibliothèque de briques”** (modulaire, premium)  
→ Table `content_bricks` (blocs 1–3), utilisée par le moteur pour générer les rapports :
- Bloc 1 : énergie + focus + alerte + conseil (288 briques)
- Bloc 2 : posture + levier + risque, selon l’état relationnel (486 briques)
- Bloc 3 : checklist premium direct_doux (648 briques)

Le rapport **JOUR** affiché à l’utilisateur = **4 blocs** :
- **Bloc 0** : Canon PDF (verbatim)
- **Blocs 1–3** : briques (personnalisées)

---

## Ordre recommandé d’intégration

1) Exécuter : **`schema_supabase.sql`** (création du schéma)  
2) Exécuter : **`canonical_predictions.sql`** (injection du canon PDF)  
3) Exécuter : **`rpc_generer_rapport.sql`** (moteur d’assemblage RPC)  
4) Import CSV : **`content_bricks_bloc1.csv`** (288 lignes)  
5) Import CSV : **`content_bricks_bloc2.csv`** (486 lignes)  
6) Import CSV : **`content_bricks_bloc3.csv`** (648 lignes)

---

## Fichier 1 — `schema_supabase.sql`

### Rôle
- Crée les **enums en français** : `periode_rapport`, `etat_relationnel`, `ton_redaction`, etc.
- Crée les tables :
  - `couple_profiles`
  - `canonical_predictions` (Canon PDF)
  - `content_bricks` (briques)
  - `brick_usage` (anti-répétition, dernier usage)
  - `generated_reports` (cache final des rapports)
- Ajoute des **index** et active la **RLS** :
  - `couple_profiles` : accessible uniquement par le propriétaire (`auth.uid()`)
  - `canonical_predictions` et `content_bricks` : lecture autorisée aux authentifiés, écriture réservée au service
  - `generated_reports` / `brick_usage` : lecture par propriétaire, écriture réservée au service

### Où l’exécuter
Supabase → **SQL Editor** (avec un rôle admin/service).

---

## Fichier 2 — `canonical_predictions.sql`

### Rôle
- Insère dans `canonical_predictions` le **contenu canon** (verbatim du PDF) pour :
  - périodes : `annee`, `mois`, `jour`
  - numéros : 1–9 + 11/22/33
- Total : **36 entrées** (12 numéros × 3 périodes)
- UPSERT : vous pouvez réexécuter le script sans doublons.

### Important (respect PDF)
- Le contenu du champ `contenu_md` est **copié tel quel** depuis le PDF (aucune réécriture).
- Vous pouvez uniquement ajuster la **mise en forme** (ex : titres Markdown) si nécessaire, mais pas le fond.

---

## Fichier 3 — `rpc_generer_rapport.sql`

### Rôle
- Ajoute les fonctions de calcul conformes au PDF :
  - réduction avec maîtres **11/22/33**
  - réduction “mois” sans maîtres (11 = novembre → 2)
  - calcul couple → année → mois → jour
- Ajoute une RPC : **`rpc_generer_rapport(periode, date)`** qui :
  1. calcule les numéros
  2. récupère le **Bloc 0** (canon) depuis `canonical_predictions`
  3. sélectionne des briques (Blocs 1–3) de manière **stable** et **anti-répétition**
  4. applique les placeholders (`{user}`, `{partner}`, etc.)
  5. écrit en cache dans `generated_reports`
  6. met à jour `brick_usage` (dernier usage des briques)

### Test rapide
Après avoir créé un `couple_profiles` pour un user connecté :
```sql
select public.rpc_generer_rapport('jour', current_date);
select public.rpc_generer_rapport('mois', current_date);
select public.rpc_generer_rapport('annee', current_date);
```

---

## Fichier 4 — `content_bricks_bloc1.csv` (288 briques)

### Contenu
- `bloc = 1`, `periode = toutes`, `ton = direct_doux`
- `type_brique` ∈ {`energie`, `focus`, `alerte`, `conseil`}
- 8 variantes par type et par numéro (1–9)

### Import
Supabase → Table `content_bricks` → **Import data (CSV)**

---

## Fichier 5 — `content_bricks_bloc2.csv` (486 briques)

### Contenu
- `bloc = 2`, `periode = toutes`, `ton = direct_doux`
- `type_brique` ∈ {`posture`, `levier`, `risque`}
- États : `harmonieux`, `neutre`, `tendu`
- 6 variantes par type × 3 états × 9 numéros

---

## Fichier 6 — `content_bricks_bloc3.csv` (648 briques)

### Contenu
- `bloc = 3`, `periode = toutes`, `ton = direct_doux`
- Checklist premium, briques :
  - `acte` (14)
  - `rituel` (14)
  - `couple` (10)
  - `travail` (9)
  - `argent` (9)
  - `sante` (9)
  - `feu` (7)
→ par numéro : 72 briques ; sur 9 numéros : 648

---

## Caractères spéciaux (“caractères bizarres”) à surveiller

Les CSV de briques contiennent de la ponctuation typographique (UTF‑8), par exemple :
- **’** apostrophe typographique
- **« »** guillemets français
- **“ ”** guillemets courbes
- **— / –** tirets longs
- **…** points de suspension

> Supabase/Postgres supporte UTF‑8, donc **ces caractères ne sont pas un problème** si vos fichiers restent en UTF‑8.  
> En revanche, **Excel** ou certains éditeurs peuvent changer l’encodage et casser les accents/ponctuations.

### Recommandations
1) Ne pas ouvrir/ré‑enregistrer les CSV dans Excel (risque d’encodage).  
2) Utiliser VS Code / Notepad++ et vérifier **UTF‑8**.  
3) Si vous souhaitez “normaliser” (optionnel) :
   - ’ → '
   - “ ” → "
   - — / – → -
   - … → ...

### Attention
- Ne pas supprimer les placeholders `{user}`, `{partner}`, `{role_partenaire}`, `{pronom_partenaire}`.
- La colonne `tags` est un **tableau Postgres** (`text[]`) au format `{ "tag1","tag2" }` : ne pas casser les accolades ni les guillemets.

---

## Vérifications après import

### Canon PDF
```sql
select periode, count(*) from public.canonical_predictions group by 1 order by 1;
```
Attendu : 12 par période (1–9 + 11/22/33).

### Briques
```sql
select bloc, count(*) from public.content_bricks group by 1 order by 1;
```
Attendu :
- bloc 1 : 288
- bloc 2 : 486
- bloc 3 : 648

### Cache
Après un appel RPC, vérifier :
```sql
select periode, count(*) from public.generated_reports group by 1;
```

---

## Notes d’exploitation

- Les imports CSV doivent être faits avec un rôle admin/service (RLS).
- Les utilisateurs finaux ne doivent **pas** pouvoir écrire dans `content_bricks` et `canonical_predictions`.
- Le rendu du Bloc 0 et du Bloc 3 contient du **Markdown** (ex: `**Acte du jour :**`) → afficher via un renderer Markdown côté front.

