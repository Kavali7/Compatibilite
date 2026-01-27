import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface DecisionAdvice {
    id: string;
    decision_type_id: string;
    cycle_type: string;
    period_number: number;
    favorability_score: number | null;
    advice_text: string;
    warnings: string | null;
    alternatives_suggestion: string | null;
    is_active: boolean;
}

interface DecisionType {
    id: string;
    code: string;
    label: string;
    category: string;
}

const CYCLE_TYPES = [
    { value: 'personal', label: '👤 Cycle Personnel' },
    { value: 'business', label: '💼 Cycle Business' },
    { value: 'health', label: '🏥 Cycle Santé' },
    { value: 'daily', label: '⏰ Cycle Quotidien' },
];

export default function DecisionAdvice() {
    const [advice, setAdvice] = useState<DecisionAdvice[]>([]);
    const [decisionTypes, setDecisionTypes] = useState<DecisionType[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filterType, setFilterType] = useState<string>('');
    const [filterCycle, setFilterCycle] = useState<string>('');
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<DecisionAdvice>>({});
    const [showAddForm, setShowAddForm] = useState(false);
    const [newAdvice, setNewAdvice] = useState<Partial<DecisionAdvice>>({
        cycle_type: 'personal',
        period_number: 1,
        favorability_score: 50,
        advice_text: '',
        is_active: true,
    });

    useEffect(() => {
        loadDecisionTypes();
        loadAdvice();
    }, []);

    async function loadDecisionTypes() {
        const { data } = await supabase
            .from('cycle_vie_decision_types')
            .select('id, code, label, category')
            .eq('is_active', true)
            .order('display_order');
        setDecisionTypes(data || []);
    }

    async function loadAdvice() {
        setLoading(true);
        try {
            let query = supabase
                .from('cycle_vie_decision_advice')
                .select('*')
                .order('decision_type_id')
                .order('cycle_type')
                .order('period_number');

            if (filterType) query = query.eq('decision_type_id', filterType);
            if (filterCycle) query = query.eq('cycle_type', filterCycle);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;
            setAdvice(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(item: DecisionAdvice) {
        setEditingId(item.id);
        setEditForm({
            favorability_score: item.favorability_score,
            advice_text: item.advice_text,
            warnings: item.warnings,
            alternatives_suggestion: item.alternatives_suggestion,
            is_active: item.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('cycle_vie_decision_advice')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadAdvice();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    async function createAdvice() {
        if (!newAdvice.decision_type_id || !newAdvice.advice_text) {
            alert('Le type de décision et le texte du conseil sont requis');
            return;
        }
        try {
            const { error: insertError } = await supabase
                .from('cycle_vie_decision_advice')
                .insert([newAdvice]);
            if (insertError) throw insertError;
            setShowAddForm(false);
            setNewAdvice({ cycle_type: 'personal', period_number: 1, favorability_score: 50, advice_text: '', is_active: true });
            loadAdvice();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    const getTypeName = (id: string) => decisionTypes.find(t => t.id === id)?.label || id;
    const getCycleName = (type: string) => CYCLE_TYPES.find(c => c.value === type)?.label || type;

    const getFavorabilityColor = (score: number | null) => {
        if (score === null) return '#6b7280';
        if (score >= 70) return '#10b981';
        if (score >= 40) return '#f59e0b';
        return '#ef4444';
    };

    return (
        <div className="page decision-advice">
            <h2 className="page-title">💡 Conseils par Décision</h2>
            <p className="page-subtitle">
                Conseils personnalisés par type de décision × type de cycle × numéro de période
            </p>

            {/* Stats + Add */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                <div>
                    <strong>{advice.length}</strong> conseils configurés
                </div>
                <button
                    onClick={() => setShowAddForm(true)}
                    style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                >
                    ➕ Ajouter un conseil
                </button>
            </div>

            {/* Add form */}
            {showAddForm && (
                <div style={{ marginBottom: '1.5rem', padding: '1.25rem', background: 'var(--card-bg)', borderRadius: '8px', border: '2px solid var(--primary)' }}>
                    <h3 style={{ marginBottom: '1rem' }}>Nouveau conseil</h3>
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Type de décision</label>
                            <select
                                value={newAdvice.decision_type_id || ''}
                                onChange={e => setNewAdvice({ ...newAdvice, decision_type_id: e.target.value })}
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            >
                                <option value="">Sélectionner...</option>
                                {decisionTypes.map(t => <option key={t.id} value={t.id}>{t.label}</option>)}
                            </select>
                        </div>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Type de cycle</label>
                            <select
                                value={newAdvice.cycle_type || 'personal'}
                                onChange={e => setNewAdvice({ ...newAdvice, cycle_type: e.target.value })}
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            >
                                {CYCLE_TYPES.map(c => <option key={c.value} value={c.value}>{c.label}</option>)}
                            </select>
                        </div>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Période (1-7)</label>
                            <input
                                type="number"
                                min={1}
                                max={7}
                                value={newAdvice.period_number || 1}
                                onChange={e => setNewAdvice({ ...newAdvice, period_number: parseInt(e.target.value) })}
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            />
                        </div>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Score (0-100)</label>
                            <input
                                type="number"
                                min={0}
                                max={100}
                                value={newAdvice.favorability_score || 50}
                                onChange={e => setNewAdvice({ ...newAdvice, favorability_score: parseInt(e.target.value) })}
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            />
                        </div>
                    </div>
                    <div style={{ marginBottom: '1rem' }}>
                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Texte du conseil</label>
                        <textarea
                            value={newAdvice.advice_text || ''}
                            onChange={e => setNewAdvice({ ...newAdvice, advice_text: e.target.value })}
                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                        />
                    </div>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                        <button onClick={createAdvice} style={{ padding: '0.5rem 1rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✓ Créer</button>
                        <button onClick={() => setShowAddForm(false)} style={{ padding: '0.5rem 1rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✗ Annuler</button>
                    </div>
                </div>
            )}

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select value={filterType} onChange={e => setFilterType(e.target.value)} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Tous les types de décision</option>
                    {decisionTypes.map(t => <option key={t.id} value={t.id}>{t.label}</option>)}
                </select>
                <select value={filterCycle} onChange={e => setFilterCycle(e.target.value)} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Tous les cycles</option>
                    {CYCLE_TYPES.map(c => <option key={c.value} value={c.value}>{c.label}</option>)}
                </select>
                <button onClick={loadAdvice} style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>🔍 Filtrer</button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : advice.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '3rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                    <p>Aucun conseil configuré.</p>
                    <p style={{ color: 'var(--text-muted)' }}>Créez des conseils personnalisés pour chaque combinaison type de décision × cycle × période.</p>
                </div>
            ) : (
                <div className="advice-list" style={{ display: 'grid', gap: '1rem' }}>
                    {advice.map(item => (
                        <div key={item.id} style={{
                            padding: '1rem',
                            background: 'var(--card-bg)',
                            borderRadius: '8px',
                            border: editingId === item.id ? '2px solid var(--primary)' : 'none',
                            opacity: item.is_active ? 1 : 0.5
                        }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
                                <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center', flexWrap: 'wrap' }}>
                                    <span style={{ fontWeight: '600' }}>{getTypeName(item.decision_type_id)}</span>
                                    <span style={{ fontSize: '0.8rem', padding: '0.15rem 0.5rem', borderRadius: '999px', background: 'var(--primary)', color: 'white' }}>
                                        {getCycleName(item.cycle_type)}
                                    </span>
                                    <span style={{ fontSize: '0.8rem', padding: '0.15rem 0.5rem', borderRadius: '999px', background: '#6b7280', color: 'white' }}>
                                        P{item.period_number}
                                    </span>
                                    {item.favorability_score !== null && (
                                        <span style={{ fontSize: '0.8rem', padding: '0.15rem 0.5rem', borderRadius: '999px', background: getFavorabilityColor(item.favorability_score), color: 'white' }}>
                                            {item.favorability_score}%
                                        </span>
                                    )}
                                </div>
                                <div>
                                    {editingId === item.id ? (
                                        <>
                                            <button onClick={saveEdit} style={{ marginRight: '0.5rem', padding: '0.25rem 0.75rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✓</button>
                                            <button onClick={() => setEditingId(null)} style={{ padding: '0.25rem 0.75rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✗</button>
                                        </>
                                    ) : (
                                        <button onClick={() => startEdit(item)} style={{ padding: '0.25rem 0.75rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✏️</button>
                                    )}
                                </div>
                            </div>
                            {editingId === item.id ? (
                                <div style={{ display: 'grid', gap: '0.5rem' }}>
                                    <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
                                        <label>Score:</label>
                                        <input type="number" min={0} max={100} value={editForm.favorability_score || 50} onChange={e => setEditForm({ ...editForm, favorability_score: parseInt(e.target.value) })} style={{ width: '80px', padding: '0.25rem' }} />
                                    </div>
                                    <textarea value={editForm.advice_text || ''} onChange={e => setEditForm({ ...editForm, advice_text: e.target.value })} style={{ minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }} placeholder="Conseil" />
                                    <textarea value={editForm.warnings || ''} onChange={e => setEditForm({ ...editForm, warnings: e.target.value })} style={{ minHeight: '40px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }} placeholder="Avertissements (optionnel)" />
                                </div>
                            ) : (
                                <p style={{ fontSize: '0.9rem', margin: 0 }}>{item.advice_text}</p>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
