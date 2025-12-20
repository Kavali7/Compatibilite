# Kkiapay Webhook - Supabase Edge Function

## Déploiement

### Prérequis
- Supabase CLI installé : `npm install -g supabase`
- Projet Supabase lié

### Étapes

1. **Liez votre projet Supabase** (si pas encore fait) :
   ```bash
   cd compatibilite_app
   supabase login
   supabase link --project-ref votre-project-ref
   ```

2. **Déployez la fonction** :
   ```bash
   supabase functions deploy kkiapay-webhook --no-verify-jwt
   ```

3. **L'URL du webhook sera** :
   ```
   https://votre-project-ref.supabase.co/functions/v1/kkiapay-webhook
   ```

4. **Configurez cette URL dans le dashboard Kkiapay** :
   - Allez dans Développeurs → Webhook
   - Ajoutez l'URL ci-dessus

## Table de logs (optionnelle)

Pour activer les logs de webhook, créez cette table dans Supabase :

```sql
CREATE TABLE IF NOT EXISTS webhook_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  provider TEXT NOT NULL,
  event_type TEXT,
  transaction_id TEXT,
  payload JSONB,
  processed_at TIMESTAMPTZ DEFAULT now()
);
```

## Test

Vous pouvez tester le webhook avec curl :

```bash
curl -X POST https://votre-project-ref.supabase.co/functions/v1/kkiapay-webhook \
  -H "Content-Type: application/json" \
  -d '{"transactionId": "test123", "status": "SUCCESS", "amount": 500}'
```
