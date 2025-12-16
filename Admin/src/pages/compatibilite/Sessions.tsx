import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';
import type { SessionCompatibilite, RapportPartenaire } from '../../types';

type JoinedSession = SessionCompatibilite & { rapports?: RapportPartenaire[] };

export default function Sessions() {
    const [sessions, setSessions] = useState<JoinedSession[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [expandedId, setExpandedId] = useState<string | null>(null);

    useEffect(() => {
        loadSessions();
    }, []);

    async function loadSessions() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('sessions_compatibilite')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(50);

            if (error) throw error;
            setSessions((data as SessionCompatibilite[]) || []);
        } catch (e) {
            console.error('Load sessions error:', e);
        }
        setLoading(false);
    }

    async function loadRapports(sessionId: string) {
        try {
            const { data, error } = await supabase
                .from('rapports_partenaires')
                .select('*')
                .eq('session_id', sessionId);

            if (error) throw error;
            setSessions((prev) =>
                prev.map((s) => (s.id === sessionId ? { ...s, rapports: data as RapportPartenaire[] } : s))
            );
        } catch (e) {
            console.error('Load rapports error:', e);
        }
    }

    function toggleExpand(session: JoinedSession) {
        if (expandedId === session.id) {
            setExpandedId(null);
        } else {
            setExpandedId(session.id);
            if (!session.rapports) {
                loadRapports(session.id);
            }
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

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page sessions">
            <h2 className="page-title">Sessions utilisateurs</h2>
            <p className="page-subtitle">Consultation des sessions pour le support client</p>

            <div className="search-bar">
                <input
                    type="text"
                    placeholder="Rechercher par email, téléphone, nom ou token..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                />
                <button onClick={loadSessions}>Rafraîchir</button>
            </div>

            <div className="sessions-list">
                {filtered.length === 0 ? (
                    <div className="empty-state">Aucune session trouvée</div>
                ) : (
                    filtered.map((session) => (
                        <div key={session.id} className="session-card">
                            <div className="session-header" onClick={() => toggleExpand(session)}>
                                <div className="session-names">
                                    {session.partenaire_a_nom} & {session.partenaire_b_nom}
                                </div>
                                <div className="session-meta">
                                    <span className={`status-badge status-${session.statut_paiement}`}>
                                        {session.statut_paiement}
                                    </span>
                                    <span className="session-date">
                                        {new Date(session.created_at).toLocaleString('fr-FR')}
                                    </span>
                                </div>
                                <span className="expand-icon">{expandedId === session.id ? '▼' : '▶'}</span>
                            </div>

                            {expandedId === session.id && (
                                <div className="session-details">
                                    <div className="detail-grid">
                                        <div className="detail-item">
                                            <label>Email</label>
                                            <span>{session.email_contact || '-'}</span>
                                        </div>
                                        <div className="detail-item">
                                            <label>Téléphone</label>
                                            <span>{session.telephone_contact || '-'}</span>
                                        </div>
                                        <div className="detail-item">
                                            <label>Token</label>
                                            <span className="token">{session.client_token}</span>
                                        </div>
                                        <div className="detail-item">
                                            <label>Statut relation</label>
                                            <span>{session.statut_relation || '-'}</span>
                                        </div>
                                        <div className="detail-item">
                                            <label>Nombre du couple</label>
                                            <span>{session.nombre_couple}</span>
                                        </div>
                                        <div className="detail-item">
                                            <label>Montant payé</label>
                                            <span>
                                                {session.montant_centimes
                                                    ? `${(session.montant_centimes / 100).toLocaleString()} ${session.devise}`
                                                    : '-'}
                                            </span>
                                        </div>
                                    </div>

                                    {session.rapports && session.rapports.length > 0 && (
                                        <div className="rapports-section">
                                            <h4>Rapports partenaires</h4>
                                            {session.rapports.map((r) => (
                                                <div key={r.id} className="rapport-item">
                                                    <strong>{r.role_partenaire} - {r.nom_partenaire}</strong>
                                                    <div className="rapport-numbers">
                                                        Chemin: {r.chemin_vie} | Nom: {r.nombre_nom} |
                                                        Intime: {r.nombre_intime} | Personnalité: {r.nombre_personnalite}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    ))
                )}
            </div>
        </div>
    );
}
