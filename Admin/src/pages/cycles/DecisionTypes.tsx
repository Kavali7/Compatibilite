import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface DecisionType {
    id: string;
    code: string;
    label: string;
    category: string | null;
    icon_name: string | null;
    description: string | null;
    display_order: number;
    is_active: boolean;
    created_at: string;
    updated_at: string;
}

const CATEGORIES = [
    { value: 'immobilier', label: '🏠 Immobilier', color: '#3b82f6' },
    { value: 'finance', label: '💰 Finance', color: '#f59e0b' },
    { value: 'juridique', label: '📜 Juridique', color: '#8b5cf6' },
    { value: 'business', label: '🚀 Business', color: '#10b981' },
    { value: 'carriere', label: '💼 Carrière', color: '#6366f1' },
    { value: 'personnel', label: '❤️ Personnel', color: '#ec4899' },
    { value: 'sante', label: '🏥 Santé', color: '#ef4444' },
    { value: 'autre', label: '📌 Autre', color: '#6b7280' },
];

export default function DecisionTypes() {
    const [types, setTypes] = useState<DecisionType[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<DecisionType>>({});
    const [filterCategory, setFilterCategory] = useState<string>('');
    const [showAddForm, setShowAddForm] = useState(false);
    const [newType, setNewType] = useState<Partial<DecisionType>>({
        code: '',
        label: '',
        category: 'autre',
        description: '',
        display_order: 50,
        is_active: true,
    });

    useEffect(() => {
        loadTypes();
    }, []);

    async function loadTypes() {
        setLoading(true);
        try {
            let query = supabase
                .from('cycle_vie_decision_types')
                .select('*')
                .order('display_order')
                .order('label');

            if (filterCategory) query = query.eq('category', filterCategory);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;
            setTypes(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(type: DecisionType) {
        setEditingId(type.id);
        setEditForm({
            code: type.code,
            label: type.label,
            category: type.category,
            icon_name: type.icon_name,
            description: type.description,
            display_order: type.display_order,
            is_active: type.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('cycle_vie_decision_types')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadTypes();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    async function createType() {
        if (!newType.code || !newType.label) {
            alert('Le code et le libellé sont requis');
            return;
        }
        try {
            const { error: insertError } = await supabase
                .from('cycle_vie_decision_types')
                .insert([newType]);
            if (insertError) throw insertError;
            setShowAddForm(false);
            setNewType({ code: '', label: '', category: 'autre', description: '', display_order: 50, is_active: true });
            loadTypes();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    async function toggleActive(type: DecisionType) {
        try {
            const { error: updateError } = await supabase
                .from('cycle_vie_decision_types')
                .update({ is_active: !type.is_active, updated_at: new Date().toISOString() })
                .eq('id', type.id);
            if (updateError) throw updateError;
            loadTypes();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    const getCategoryInfo = (cat: string | null) =>
        CATEGORIES.find(c => c.value === cat) || { label: cat || '?', color: '#6b7280' };

    return (
        <div className="page decision-types">
            <h2 className="page-title">🎯 Types de Décisions</h2>
            <p className="page-subtitle">
                Catégories de décisions que les utilisateurs peuvent consulter (location, achat, voyage, etc.)
            </p>

            {/* Stats + Add button */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                <div>
                    <strong>{types.length}</strong> types de décisions ({types.filter(t => t.is_active).length} actifs)
                </div>
                <button
                    onClick={() => setShowAddForm(true)}
                    style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                >
                    ➕ Ajouter un type
                </button>
            </div>

            {/* Add form */}
            {showAddForm && (
                <div style={{ marginBottom: '1.5rem', padding: '1.25rem', background: 'var(--card-bg)', borderRadius: '8px', border: '2px solid var(--primary)' }}>
                    <h3 style={{ marginBottom: '1rem' }}>Nouveau type de décision</h3>
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Code (unique)</label>
                            <input
                                type="text"
                                value={newType.code || ''}
                                onChange={e => setNewType({ ...newType, code: e.target.value.toLowerCase().replace(/[^a-z0-9_]/g, '_') })}
                                placeholder="ex: achat_terrain"
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            />
                        </div>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Libellé</label>
                            <input
                                type="text"
                                value={newType.label || ''}
                                onChange={e => setNewType({ ...newType, label: e.target.value })}
                                placeholder="ex: Achat de Terrain"
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            />
                        </div>
                        <div>
                            <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Catégorie</label>
                            <select
                                value={newType.category || 'autre'}
                                onChange={e => setNewType({ ...newType, category: e.target.value })}
                                style={{ width: '100%', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                            >
                                {CATEGORIES.map(cat => <option key={cat.value} value={cat.value}>{cat.label}</option>)}
                            </select>
                        </div>
                    </div>
                    <div style={{ marginBottom: '1rem' }}>
                        <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '0.25rem' }}>Description</label>
                        <textarea
                            value={newType.description || ''}
                            onChange={e => setNewType({ ...newType, description: e.target.value })}
                            placeholder="Description courte pour l'utilisateur"
                            style={{ width: '100%', minHeight: '60px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                        />
                    </div>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                        <button onClick={createType} style={{ padding: '0.5rem 1rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                            ✓ Créer
                        </button>
                        <button onClick={() => setShowAddForm(false)} style={{ padding: '0.5rem 1rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
                            ✗ Annuler
                        </button>
                    </div>
                </div>
            )}

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select
                    value={filterCategory}
                    onChange={e => setFilterCategory(e.target.value)}
                    style={{ padding: '0.5rem', borderRadius: '4px' }}
                >
                    <option value="">Toutes les catégories</option>
                    {CATEGORIES.map(cat => <option key={cat.value} value={cat.value}>{cat.label}</option>)}
                </select>
                <button
                    onClick={loadTypes}
                    style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                >
                    🔍 Filtrer
                </button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : (
                <div className="types-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(350px, 1fr))', gap: '1rem' }}>
                    {types.map(type => {
                        const catInfo = getCategoryInfo(type.category);
                        return (
                            <div key={type.id} style={{
                                padding: '1rem',
                                background: 'var(--card-bg)',
                                borderRadius: '8px',
                                border: editingId === type.id ? '2px solid var(--primary)' : 'none',
                                opacity: type.is_active ? 1 : 0.5
                            }}>
                                {editingId === type.id ? (
                                    <div style={{ display: 'grid', gap: '0.75rem' }}>
                                        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.5rem' }}>
                                            <input
                                                type="text"
                                                value={editForm.label || ''}
                                                onChange={e => setEditForm({ ...editForm, label: e.target.value })}
                                                placeholder="Libellé"
                                                style={{ padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            />
                                            <select
                                                value={editForm.category || 'autre'}
                                                onChange={e => setEditForm({ ...editForm, category: e.target.value })}
                                                style={{ padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                            >
                                                {CATEGORIES.map(cat => <option key={cat.value} value={cat.value}>{cat.label}</option>)}
                                            </select>
                                        </div>
                                        <textarea
                                            value={editForm.description || ''}
                                            onChange={e => setEditForm({ ...editForm, description: e.target.value })}
                                            placeholder="Description"
                                            style={{ minHeight: '50px', padding: '0.5rem', borderRadius: '4px', border: '1px solid var(--border-color)' }}
                                        />
                                        <div style={{ display: 'flex', gap: '0.5rem' }}>
                                            <button onClick={saveEdit} style={{ padding: '0.25rem 0.75rem', background: '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✓</button>
                                            <button onClick={() => setEditingId(null)} style={{ padding: '0.25rem 0.75rem', background: '#6b7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>✗</button>
                                        </div>
                                    </div>
                                ) : (
                                    <>
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '0.5rem' }}>
                                            <div>
                                                <div style={{ fontWeight: '600', marginBottom: '0.25rem' }}>{type.label}</div>
                                                <span style={{
                                                    fontSize: '0.75rem',
                                                    padding: '0.15rem 0.5rem',
                                                    borderRadius: '999px',
                                                    background: catInfo.color,
                                                    color: 'white'
                                                }}>
                                                    {catInfo.label}
                                                </span>
                                            </div>
                                            <div style={{ display: 'flex', gap: '0.25rem' }}>
                                                <button onClick={() => startEdit(type)} style={{ padding: '0.25rem 0.5rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer', fontSize: '0.8rem' }}>✏️</button>
                                                <button onClick={() => toggleActive(type)} style={{ padding: '0.25rem 0.5rem', background: type.is_active ? '#ef4444' : '#10b981', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer', fontSize: '0.8rem' }}>
                                                    {type.is_active ? '🚫' : '✓'}
                                                </button>
                                            </div>
                                        </div>
                                        {type.description && (
                                            <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)', margin: 0 }}>{type.description}</p>
                                        )}
                                        <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: '0.5rem' }}>
                                            Code: {type.code} • Ordre: {type.display_order}
                                        </div>
                                    </>
                                )}
                            </div>
                        );
                    })}
                </div>
            )}
        </div>
    );
}
