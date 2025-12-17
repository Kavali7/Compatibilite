import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface CanonicalPrediction {
    id: string;
    numero: number;
    periode: string;
    climat_general: string;
    vie_pro: string;
    vie_sentimentale: string;
    finances: string;
    conseil_cle: string;
    version: number;
    created_at: string;
    updated_at: string;
}

const PERIODES = ['annee', 'mois', 'jour'];
const NUMEROS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33];

export default function CanonicalPredictions() {
    const [predictions, setPredictions] = useState<CanonicalPrediction[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filter, setFilter] = useState({ numero: '', periode: '' });
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<CanonicalPrediction>>({});

    useEffect(() => {
        loadPredictions();
    }, []);

    async function loadPredictions() {
        setLoading(true);
        try {
            let query = supabase.from('canonical_predictions').select('*').order('numero').order('periode');

            if (filter.numero) query = query.eq('numero', parseInt(filter.numero));
            if (filter.periode) query = query.eq('periode', filter.periode);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;
            setPredictions(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(pred: CanonicalPrediction) {
        setEditingId(pred.id);
        setEditForm({
            climat_general: pred.climat_general,
            vie_pro: pred.vie_pro,
            vie_sentimentale: pred.vie_sentimentale,
            finances: pred.finances,
            conseil_cle: pred.conseil_cle,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('canonical_predictions')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadPredictions();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    const periodeLabel = (p: string) => {
        switch (p) {
            case 'annee': return '📅 Année';
            case 'mois': return '📆 Mois';
            case 'jour': return '☀️ Jour';
            default: return p;
        }
    };

    return (
        <div className="page canonical-predictions">
            <h2 className="page-title">📜 Prédictions Canoniques</h2>
            <p className="page-subtitle">
                Textes du PDF pour chaque numéro (1-9, 11, 22, 33) × 3 périodes (année, mois, jour)
            </p>

            {/* Stats */}
            <div style={{ marginBottom: '1.5rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                <strong>{predictions.length}</strong> prédictions ({NUMEROS.length} numéros × {PERIODES.length} périodes = {NUMEROS.length * PERIODES.length} attendus)
            </div>

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select value={filter.numero} onChange={e => setFilter({ ...filter, numero: e.target.value })} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Tous les numéros</option>
                    {NUMEROS.map(n => <option key={n} value={n}>{n}</option>)}
                </select>
                <select value={filter.periode} onChange={e => setFilter({ ...filter, periode: e.target.value })} style={{ padding: '0.5rem', borderRadius: '4px' }}>
                    <option value="">Toutes les périodes</option>
                    {PERIODES.map(p => <option key={p} value={p}>{periodeLabel(p)}</option>)}
                </select>
                <button onClick={loadPredictions} style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                    🔍 Filtrer
                </button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : (
                <div className="predictions-list">
                    {predictions.map(pred => (
                        <div key={pred.id} style={{
                            marginBottom: '1.5rem',
                            padding: '1rem',
                            background: 'var(--card-bg)',
                            borderRadius: '8px',
                            border: editingId === pred.id ? '2px solid var(--primary)' : 'none'
                        }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
                                <div>
                                    <span style={{
                                        padding: '0.25rem 0.75rem',
                                        borderRadius: '999px',
                                        background: 'var(--primary)',
                                        color: 'white',
                                        marginRight: '0.5rem',
                                        fontWeight: 'bold'
                                    }}>
                                        {pred.numero}
                                    </span>
                                    <span>{periodeLabel(pred.periode)}</span>
                                </div>
                                <div>
                                    {editingId === pred.id ? (
                                        <>
                                            <button onClick={saveEdit} style={{ marginRight: '0.5rem', padding: '0.25rem 0.75rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                                ✓ Sauvegarder
                                            </button>
                                            <button onClick={() => setEditingId(null)} style={{ padding: '0.25rem 0.75rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                                ✗ Annuler
                                            </button>
                                        </>
                                    ) : (
                                        <button onClick={() => startEdit(pred)} style={{ padding: '0.25rem 0.75rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                                            ✏️ Modifier
                                        </button>
                                    )}
                                </div>
                            </div>

                            {editingId === pred.id ? (
                                <div style={{ display: 'grid', gap: '0.75rem' }}>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Climat général</label>
                                        <textarea
                                            value={editForm.climat_general || ''}
                                            onChange={e => setEditForm({ ...editForm, climat_general: e.target.value })}
                                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Vie professionnelle</label>
                                        <textarea
                                            value={editForm.vie_pro || ''}
                                            onChange={e => setEditForm({ ...editForm, vie_pro: e.target.value })}
                                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Vie sentimentale</label>
                                        <textarea
                                            value={editForm.vie_sentimentale || ''}
                                            onChange={e => setEditForm({ ...editForm, vie_sentimentale: e.target.value })}
                                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Finances</label>
                                        <textarea
                                            value={editForm.finances || ''}
                                            onChange={e => setEditForm({ ...editForm, finances: e.target.value })}
                                            style={{ width: '100%', minHeight: '80px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                    <div>
                                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Conseil clé</label>
                                        <textarea
                                            value={editForm.conseil_cle || ''}
                                            onChange={e => setEditForm({ ...editForm, conseil_cle: e.target.value })}
                                            style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                    </div>
                                </div>
                            ) : (
                                <div style={{ display: 'grid', gap: '0.5rem', fontSize: '0.9rem' }}>
                                    <div><strong>Climat:</strong> {pred.climat_general?.substring(0, 150)}...</div>
                                    <div><strong>Pro:</strong> {pred.vie_pro?.substring(0, 100)}...</div>
                                    <div><strong>Sentimental:</strong> {pred.vie_sentimentale?.substring(0, 100)}...</div>
                                    <div><strong>Finances:</strong> {pred.finances?.substring(0, 100)}...</div>
                                    <div><strong>Conseil:</strong> {pred.conseil_cle?.substring(0, 100)}...</div>
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
