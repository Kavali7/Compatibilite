import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface SoulPeriod {
    id: string;
    period_number: number;
    polarity: string;
    date_start: string;
    date_end: string;
    period_name: string;
    period_title: string;
    description_general: string;
    traits_positifs: string | null;
    traits_vigilance: string | null;
    professions_favorables: string | null;
    sante_vigilance: string | null;
    pays_affinites: string | null;
    is_active: boolean;
    updated_at: string;
}

export default function SoulPeriods() {
    const [periods, setPeriods] = useState<SoulPeriod[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<SoulPeriod>>({});
    const [filterPeriod, setFilterPeriod] = useState<string>('');
    const [filterPolarity, setFilterPolarity] = useState<string>('');

    useEffect(() => {
        loadPeriods();
    }, []);

    async function loadPeriods() {
        setLoading(true);
        try {
            let query = supabase
                .from('cycle_vie_soul_periods')
                .select('*')
                .order('period_number')
                .order('polarity');

            if (filterPeriod) query = query.eq('period_number', parseInt(filterPeriod));
            if (filterPolarity) query = query.eq('polarity', filterPolarity);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;
            setPeriods(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(period: SoulPeriod) {
        setEditingId(period.id);
        setEditForm({
            period_name: period.period_name,
            period_title: period.period_title,
            description_general: period.description_general,
            traits_positifs: period.traits_positifs,
            traits_vigilance: period.traits_vigilance,
            professions_favorables: period.professions_favorables,
            sante_vigilance: period.sante_vigilance,
            pays_affinites: period.pays_affinites,
            is_active: period.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('cycle_vie_soul_periods')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadPeriods();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    const formatDateRange = (start: string, end: string) => {
        const months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
        const [sm, sd] = start.split('-').map(Number);
        const [em, ed] = end.split('-').map(Number);
        return `${sd} ${months[sm]} - ${ed} ${months[em]}`;
    };

    return (
        <div className="page soul-periods">
            <h2 className="page-title">🌟 Périodes Soul Cycle</h2>
            <p className="page-subtitle">
                Les 14 profils de personnalité basés sur la date de naissance (7 périodes × 2 polarités)
            </p>

            {/* Stats */}
            <div style={{ marginBottom: '1.5rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                <strong>{periods.length}</strong> périodes ({periods.filter(p => p.is_active).length} actives)
            </div>

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select
                    value={filterPeriod}
                    onChange={e => setFilterPeriod(e.target.value)}
                    style={{ padding: '0.5rem', borderRadius: '4px' }}
                >
                    <option value="">Toutes les périodes</option>
                    {[1, 2, 3, 4, 5, 6, 7].map(n => <option key={n} value={n}>Période {n}</option>)}
                </select>
                <select
                    value={filterPolarity}
                    onChange={e => setFilterPolarity(e.target.value)}
                    style={{ padding: '0.5rem', borderRadius: '4px' }}
                >
                    <option value="">Toutes les polarités</option>
                    <option value="A">Polarité A (Active)</option>
                    <option value="B">Polarité B (Passive)</option>
                </select>
                <button
                    onClick={loadPeriods}
                    style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                >
                    🔍 Filtrer
                </button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : (
                <div className="periods-list">
                    {periods.map(period => (
                        <div key={period.id} style={{
                            marginBottom: '1.5rem',
                            padding: '1.25rem',
                            background: 'var(--card-bg)',
                            borderRadius: '8px',
                            border: editingId === period.id ? '2px solid var(--primary)' : 'none',
                            opacity: period.is_active ? 1 : 0.6
                        }}>
                            {/* Header */}
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                                    <span style={{
                                        padding: '0.25rem 0.75rem',
                                        borderRadius: '999px',
                                        background: 'var(--primary)',
                                        color: 'white',
                                        fontWeight: 'bold'
                                    }}>
                                        {period.period_number}{period.polarity}
                                    </span>
                                    <span style={{ fontWeight: '600' }}>{period.period_name}</span>
                                    <span style={{ color: 'var(--text-muted)', fontSize: '0.9rem' }}>
                                        {formatDateRange(period.date_start, period.date_end)}
                                    </span>
                                </div>
                                <div>
                                    {editingId === period.id ? (
                                        <>
                                            <button onClick={saveEdit} style={{ marginRight: '0.5rem', padding: '0.25rem 0.75rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                                ✓ Sauvegarder
                                            </button>
                                            <button onClick={() => setEditingId(null)} style={{ padding: '0.25rem 0.75rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                                ✗ Annuler
                                            </button>
                                        </>
                                    ) : (
                                        <button onClick={() => startEdit(period)} style={{ padding: '0.25rem 0.75rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                            ✏️ Modifier
                                        </button>
                                    )}
                                </div>
                            </div>

                            {/* Content */}
                            {editingId === period.id ? (
                                <div style={{ display: 'grid', gap: '0.75rem' }}>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Nom de la période</label>
                                            <input
                                                type="text"
                                                value={editForm.period_name || ''}
                                                onChange={e => setEditForm({ ...editForm, period_name: e.target.value })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Titre du profil</label>
                                            <input
                                                type="text"
                                                value={editForm.period_title || ''}
                                                onChange={e => setEditForm({ ...editForm, period_title: e.target.value })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Description générale</label>
                                        <textarea
                                            value={editForm.description_general || ''}
                                            onChange={e => setEditForm({ ...editForm, description_general: e.target.value })}
                                            style={{ width: '100%', minHeight: '100px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Traits positifs</label>
                                            <textarea
                                                value={editForm.traits_positifs || ''}
                                                onChange={e => setEditForm({ ...editForm, traits_positifs: e.target.value })}
                                                style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Points de vigilance</label>
                                            <textarea
                                                value={editForm.traits_vigilance || ''}
                                                onChange={e => setEditForm({ ...editForm, traits_vigilance: e.target.value })}
                                                style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                    </div>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Professions favorables</label>
                                            <textarea
                                                value={editForm.professions_favorables || ''}
                                                onChange={e => setEditForm({ ...editForm, professions_favorables: e.target.value })}
                                                style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Vigilance santé</label>
                                            <textarea
                                                value={editForm.sante_vigilance || ''}
                                                onChange={e => setEditForm({ ...editForm, sante_vigilance: e.target.value })}
                                                style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                        <input
                                            type="checkbox"
                                            checked={editForm.is_active}
                                            onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })}
                                            id="is_active"
                                        />
                                        <label htmlFor="is_active">Période active</label>
                                    </div>
                                </div>
                            ) : (
                                <div style={{ display: 'grid', gap: '0.5rem', fontSize: '0.9rem' }}>
                                    <div><strong>Titre:</strong> {period.period_title}</div>
                                    <div><strong>Description:</strong> {period.description_general?.substring(0, 200)}...</div>
                                    {period.traits_positifs && (
                                        <div><strong>Points forts:</strong> {period.traits_positifs?.substring(0, 100)}...</div>
                                    )}
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
