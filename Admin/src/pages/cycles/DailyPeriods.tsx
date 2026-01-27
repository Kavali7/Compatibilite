import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface DailyPeriod {
    id: string;
    period_letter: string;
    weekday_number: number | null;
    period_name: string;
    keyword: string;
    description: string;
    activities_favorables: string | null;
    activities_eviter: string | null;
    color_code: string | null;
    energy_level: string | null;
    is_active: boolean;
    updated_at: string;
}

const WEEKDAYS = ['', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
const ENERGY_LEVELS = [
    { value: 'high', label: '🔥 Haute', color: '#ef4444' },
    { value: 'medium', label: '⚡ Moyenne', color: '#f59e0b' },
    { value: 'neutral', label: '➖ Neutre', color: '#6b7280' },
    { value: 'low', label: '🧘 Basse', color: '#8b5cf6' },
];

export default function DailyPeriods() {
    const [periods, setPeriods] = useState<DailyPeriod[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<DailyPeriod>>({});

    useEffect(() => {
        loadPeriods();
    }, []);

    async function loadPeriods() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('cycle_vie_daily_periods')
                .select('*')
                .order('period_letter');

            if (fetchError) throw fetchError;
            setPeriods(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(period: DailyPeriod) {
        setEditingId(period.id);
        setEditForm({
            period_name: period.period_name,
            keyword: period.keyword,
            description: period.description,
            activities_favorables: period.activities_favorables,
            activities_eviter: period.activities_eviter,
            color_code: period.color_code,
            energy_level: period.energy_level,
            weekday_number: period.weekday_number,
            is_active: period.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('cycle_vie_daily_periods')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadPeriods();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    return (
        <div className="page daily-periods">
            <h2 className="page-title">⏰ Périodes Quotidiennes</h2>
            <p className="page-subtitle">
                Les 7 périodes de chaque jour (A-G), chacune d'environ 3h25. Chaque jour commence par une période différente.
            </p>

            {/* Info */}
            <div style={{ marginBottom: '1.5rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                <strong>Structure:</strong> Chaque jour de la semaine commence par une période différente.
                Exemple: Lundi commence par A, Mardi par B, etc.
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : (
                <div className="periods-grid" style={{ display: 'grid', gap: '1rem' }}>
                    {periods.map(period => (
                        <div key={period.id} style={{
                            padding: '1.25rem',
                            background: 'var(--card-bg)',
                            borderRadius: '8px',
                            border: editingId === period.id ? '2px solid var(--primary)' : `3px solid ${period.color_code || 'var(--border-color)'}`,
                            opacity: period.is_active ? 1 : 0.6
                        }}>
                            {/* Header */}
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                                    <span style={{
                                        width: '40px',
                                        height: '40px',
                                        borderRadius: '50%',
                                        background: period.color_code || 'var(--primary)',
                                        color: 'white',
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        fontWeight: 'bold',
                                        fontSize: '1.2rem'
                                    }}>
                                        {period.period_letter}
                                    </span>
                                    <div>
                                        <div style={{ fontWeight: '600' }}>{period.period_name}</div>
                                        <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>
                                            Mot-clé: {period.keyword}
                                            {period.weekday_number && ` • Début: ${WEEKDAYS[period.weekday_number]}`}
                                        </div>
                                    </div>
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
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Nom</label>
                                            <input
                                                type="text"
                                                value={editForm.period_name || ''}
                                                onChange={e => setEditForm({ ...editForm, period_name: e.target.value })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Mot-clé</label>
                                            <input
                                                type="text"
                                                value={editForm.keyword || ''}
                                                onChange={e => setEditForm({ ...editForm, keyword: e.target.value })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Couleur</label>
                                            <input
                                                type="color"
                                                value={editForm.color_code || '#6366f1'}
                                                onChange={e => setEditForm({ ...editForm, color_code: e.target.value })}
                                                style={{ width: '100%', height: '38px', padding: '0.25rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                    </div>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Jour de début</label>
                                            <select
                                                value={editForm.weekday_number || ''}
                                                onChange={e => setEditForm({ ...editForm, weekday_number: e.target.value ? parseInt(e.target.value) : null })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            >
                                                <option value="">Non défini</option>
                                                {WEEKDAYS.slice(1).map((day, i) => <option key={i} value={i + 1}>{day}</option>)}
                                            </select>
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Niveau d'énergie</label>
                                            <select
                                                value={editForm.energy_level || ''}
                                                onChange={e => setEditForm({ ...editForm, energy_level: e.target.value })}
                                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            >
                                                <option value="">Non défini</option>
                                                {ENERGY_LEVELS.map(level => <option key={level.value} value={level.value}>{level.label}</option>)}
                                            </select>
                                        </div>
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Description</label>
                                        <textarea
                                            value={editForm.description || ''}
                                            onChange={e => setEditForm({ ...editForm, description: e.target.value })}
                                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Activités favorables</label>
                                            <textarea
                                                value={editForm.activities_favorables || ''}
                                                onChange={e => setEditForm({ ...editForm, activities_favorables: e.target.value })}
                                                style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                        <div>
                                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Activités à éviter</label>
                                            <textarea
                                                value={editForm.activities_eviter || ''}
                                                onChange={e => setEditForm({ ...editForm, activities_eviter: e.target.value })}
                                                style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                        </div>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                        <input
                                            type="checkbox"
                                            checked={editForm.is_active}
                                            onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })}
                                            id="is_active_daily"
                                        />
                                        <label htmlFor="is_active_daily">Période active</label>
                                    </div>
                                </div>
                            ) : (
                                <div style={{ fontSize: '0.9rem' }}>
                                    <p style={{ marginBottom: '0.5rem' }}>{period.description}</p>
                                    {period.activities_favorables && (
                                        <p style={{ color: '#10b981' }}>✅ {period.activities_favorables}</p>
                                    )}
                                    {period.activities_eviter && (
                                        <p style={{ color: '#ef4444' }}>⚠️ {period.activities_eviter}</p>
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
