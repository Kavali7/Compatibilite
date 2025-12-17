import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface ContentBrick {
    id: string;
    bloc: number;
    periode: string;
    type_brique: string;
    numero_cible: number;
    etat_relationnel: string;
    statut_utilisateur: string;
    ton: string;
    modele_texte: string;
    jours_refroidissement: number;
    poids: number;
    actif: boolean;
    tags: string[];
    langue: string;
    version: number;
    created_at: string;
}

export default function ContentBricks() {
    const [bricks, setBricks] = useState<ContentBrick[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filter, setFilter] = useState({ bloc: '', type_brique: '', actif: '' });
    const [stats, setStats] = useState({ total: 0, bloc1: 0, bloc2: 0, bloc3: 0 });

    useEffect(() => {
        loadBricks();
        loadStats();
    }, []);

    async function loadStats() {
        try {
            const { count: total } = await supabase.from('content_bricks').select('*', { count: 'exact', head: true });
            const { count: bloc1 } = await supabase.from('content_bricks').select('*', { count: 'exact', head: true }).eq('bloc', 1);
            const { count: bloc2 } = await supabase.from('content_bricks').select('*', { count: 'exact', head: true }).eq('bloc', 2);
            const { count: bloc3 } = await supabase.from('content_bricks').select('*', { count: 'exact', head: true }).eq('bloc', 3);
            setStats({ total: total || 0, bloc1: bloc1 || 0, bloc2: bloc2 || 0, bloc3: bloc3 || 0 });
        } catch (e) {
            console.error('Error loading stats:', e);
        }
    }

    async function loadBricks() {
        setLoading(true);
        try {
            let query = supabase.from('content_bricks').select('*').order('bloc').order('type_brique').limit(100);

            if (filter.bloc) query = query.eq('bloc', parseInt(filter.bloc));
            if (filter.type_brique) query = query.eq('type_brique', filter.type_brique);
            if (filter.actif === 'true') query = query.eq('actif', true);
            if (filter.actif === 'false') query = query.eq('actif', false);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;
            setBricks(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    async function toggleActive(brick: ContentBrick) {
        try {
            const { error: updateError } = await supabase
                .from('content_bricks')
                .update({ actif: !brick.actif })
                .eq('id', brick.id);
            if (updateError) throw updateError;
            loadBricks();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    const typeOptions = [
        'energie', 'focus', 'alerte', 'conseil',
        'posture', 'levier', 'risque',
        'acte', 'rituel', 'couple', 'travail', 'argent', 'sante', 'feu'
    ];

    return (
        <div className="page content-bricks">
            <h2 className="page-title">🧱 Briques de Contenu</h2>
            <p className="page-subtitle">
                Gérer les briques personnalisées pour les rapports temporels
            </p>

            {/* Stats Cards */}
            <div className="stats-row" style={{ display: 'flex', gap: '1rem', marginBottom: '1.5rem' }}>
                <div className="stat-card" style={{ flex: 1, padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: 'var(--primary)' }}>{stats.total}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Total</div>
                </div>
                <div className="stat-card" style={{ flex: 1, padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#3b82f6' }}>{stats.bloc1}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Bloc 1</div>
                </div>
                <div className="stat-card" style={{ flex: 1, padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#8b5cf6' }}>{stats.bloc2}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Bloc 2</div>
                </div>
                <div className="stat-card" style={{ flex: 1, padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#10b981' }}>{stats.bloc3}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Bloc 3</div>
                </div>
            </div>

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select value={filter.bloc} onChange={e => setFilter({ ...filter, bloc: e.target.value })} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Tous les blocs</option>
                    <option value="1">Bloc 1</option>
                    <option value="2">Bloc 2</option>
                    <option value="3">Bloc 3</option>
                </select>
                <select value={filter.type_brique} onChange={e => setFilter({ ...filter, type_brique: e.target.value })} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Tous les types</option>
                    {typeOptions.map(t => <option key={t} value={t}>{t}</option>)}
                </select>
                <select value={filter.actif} onChange={e => setFilter({ ...filter, actif: e.target.value })} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Actif/Inactif</option>
                    <option value="true">Actif uniquement</option>
                    <option value="false">Inactif uniquement</option>
                </select>
                <button onClick={loadBricks} style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                    🔍 Filtrer
                </button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : (
                <table className="data-table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                    <thead>
                        <tr style={{ background: 'var(--card-bg)' }}>
                            <th style={{ padding: '0.75rem', textAlign: 'left' }}>Bloc</th>
                            <th style={{ padding: '0.75rem', textAlign: 'left' }}>Type</th>
                            <th style={{ padding: '0.75rem', textAlign: 'left' }}>Numéro</th>
                            <th style={{ padding: '0.75rem', textAlign: 'left' }}>Texte</th>
                            <th style={{ padding: '0.75rem', textAlign: 'center' }}>Actif</th>
                            <th style={{ padding: '0.75rem', textAlign: 'center' }}>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {bricks.map(brick => (
                            <tr key={brick.id} style={{ borderBottom: '1px solid var(--border-color)' }}>
                                <td style={{ padding: '0.75rem' }}>
                                    <span style={{
                                        padding: '0.25rem 0.5rem',
                                        borderRadius: '4px',
                                        background: brick.bloc === 1 ? '#3b82f6' : brick.bloc === 2 ? '#8b5cf6' : '#10b981',
                                        color: 'white',
                                        fontSize: '0.85rem'
                                    }}>
                                        Bloc {brick.bloc}
                                    </span>
                                </td>
                                <td style={{ padding: '0.75rem' }}>{brick.type_brique}</td>
                                <td style={{ padding: '0.75rem' }}>{brick.numero_cible}</td>
                                <td style={{ padding: '0.75rem', maxWidth: '400px' }}>
                                    <div style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                                        {brick.modele_texte}
                                    </div>
                                </td>
                                <td style={{ padding: '0.75rem', textAlign: 'center' }}>
                                    <span style={{ color: brick.actif ? '#10b981' : '#ef4444' }}>
                                        {brick.actif ? '✓' : '✗'}
                                    </span>
                                </td>
                                <td style={{ padding: '0.75rem', textAlign: 'center' }}>
                                    <button
                                        onClick={() => toggleActive(brick)}
                                        style={{
                                            padding: '0.25rem 0.5rem',
                                            border: 'none',
                                            borderRadius: '4px',
                                            cursor: 'pointer',
                                            background: brick.actif ? '#fee2e2' : '#d1fae5',
                                            color: brick.actif ? '#dc2626' : '#059669'
                                        }}
                                    >
                                        {brick.actif ? 'Désactiver' : 'Activer'}
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            <p style={{ marginTop: '1rem', color: 'var(--text-muted)', fontSize: '0.9rem' }}>
                Affichage limité à 100 résultats. Utilisez les filtres pour affiner.
            </p>
        </div>
    );
}
