import { createClient, SupabaseClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const serviceRole = import.meta.env.VITE_SUPABASE_SERVICE_ROLE_KEY;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl) {
  throw new Error('VITE_SUPABASE_URL manquant');
}

// Par defaut on utilise la cle service_role pour l admin (ne pas exposer publiquement).
const keyToUse = serviceRole || anonKey;
if (!keyToUse) {
  throw new Error('Aucune cle Supabase fournie (service_role ou anon)');
}

export const supabase: SupabaseClient = createClient(supabaseUrl, keyToUse, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});
