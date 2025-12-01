import { useEffect, useState } from 'react';
import { supabase } from './supabaseClient';
import type { SessionCompatibilite, RapportPartenaire } from './types';

type JoinedSession = SessionCompatibilite & { rapports?: RapportPartenaire[] };

function App() {
  const [sessions, setSessions] = useState<JoinedSession[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  useEffect(() => {
    void fetchSessions();
  }, []);

  async function fetchSessions() {
    setLoading(true);
    setError(null);
    try {
      const { data, error: err } = await supabase
        .from('sessions_compatibilite')
        .select('*')
        .order('created_at', { ascending: false });
      if (err) throw err;
      const typed = (data ?? []) as SessionCompatibilite[];
      setSessions(typed);
    } catch (e: any) {
      setError(e.message ?? 'Erreur de chargement');
    } finally {
      setLoading(false);
    }
  }

  async function loadRapports(sessionId: string) {
    setError(null);
    try {
      const { data, error: err } = await supabase
        .from('rapports_partenaires')
        .select('*')
        .eq('session_id', sessionId);
      if (err) throw err;
      const rapports = (data ?? []) as RapportPartenaire[];
      setSessions((prev) =>
        prev.map((s) => (s.id === sessionId ? { ...s, rapports } : s)),
      );
    } catch (e: any) {
      setError(e.message ?? 'Erreur de chargement des rapports');
    }
  }

  const filtered = sessions.filter((s) => {
    const q = search.toLowerCase();
    return (
      s.email_contact?.toLowerCase().includes(q) ||
      s.telephone_contact?.toLowerCase().includes(q) ||
      s.partenaire_a_nom.toLowerCase().includes(q) ||
      s.partenaire_b_nom.toLowerCase().includes(q) ||
      s.client_token.toLowerCase().includes(q)
    );
  });

  return (
    <div className="page">
      <header className="header">
        <h1>Admin Compatibilite</h1>
        <div className="actions">
          <input
            type="text"
            placeholder="Rechercher email / tel / nom / token"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <button onClick={fetchSessions} disabled={loading}>
            {loading ? 'Chargement...' : 'Rafraichir'}
          </button>
        </div>
        {error && <div className="error">{error}</div>}
      </header>
      <main>
        <div className="list">
          {filtered.map((s) => (
            <div key={s.id} className="card">
              <div className="card-head">
                <div>
                  <div className="title">
                    {s.partenaire_a_nom} & {s.partenaire_b_nom}
                  </div>
                  <div className="muted">
                    {new Date(s.created_at).toLocaleString()} — Statut paiement:{' '}
                    <strong>{s.statut_paiement}</strong>{' '}
                    {s.fournisseur_paiement && `(${s.fournisseur_paiement})`}
                  </div>
                </div>
                <button onClick={() => loadRapports(s.id)}>Voir rapports</button>
              </div>
              <div className="grid">
                <Info label="Email" value={s.email_contact} />
                <Info label="Tel" value={s.telephone_contact} />
                <Info label="Token" value={s.client_token} />
                <Info label="Statut relation" value={s.statut_relation} />
                <Info label="Defis" value={s.defis.join(', ')} />
                <Info label="Notifications" value={s.notifications ? 'Oui' : 'Non'} />
                <Info
                  label="Montant"
                  value={
                    s.montant_centimes != null
                      ? `${(s.montant_centimes / 100).toFixed(2)} ${s.devise}`
                      : ''
                  }
                />
                <Info label="Ref paiement" value={s.reference_paiement} />
              </div>
              <div className="grid">
                <Info label="Nombre couple" value={String(s.nombre_couple)} />
                <Info label="Nombre du jour" value={String(s.nombre_couple_jour)} />
              </div>
              {s.rapports && (
                <div className="rapports">
                  <div className="subtitle">Rapports partenaires</div>
                  {s.rapports.map((r) => (
                    <div key={r.id} className="rapport">
                      <div className="bold">
                        {r.role_partenaire} — {r.nom_partenaire}
                      </div>
                      <div className="muted">
                        Chemin de vie {r.chemin_vie} / Nom {r.nombre_nom} / Kabbale {r.nombre_kabbale} / Intime {r.nombre_intime} / Perso {r.nombre_personnalite} / Heredite {r.nombre_heredite} / Annee {r.annee_personnelle}-{r.mois_personnel}-{r.jour_personnel}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
          {filtered.length === 0 && !loading && <div>Aucune session</div>}
        </div>
      </main>
    </div>
  );
}

function Info({ label, value }: { label: string; value?: string | number | null }) {
  if (value === null || value === undefined || value === '') return null;
  return (
    <div className="info">
      <div className="label">{label}</div>
      <div>{value}</div>
    </div>
  );
}

export default App;
