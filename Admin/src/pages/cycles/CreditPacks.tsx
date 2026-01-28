import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

// Type pour les packs de crédits
type CreditPack = {
    id: string;
    name: string;
    description: string | null;
    credits_count: number;
    price_fcfa: number;
    discount_percent: number;
    is_active: boolean;
    display_order: number;
    created_at: string;
};

export default function CreditPacks() {
    const [packs, setPacks] = useState<CreditPack[]>([]);
    const [loading, setLoading] = useState(true);
    const [editingPack, setEditingPack] = useState<CreditPack | null>(null);
    const [showAddForm, setShowAddForm] = useState(false);
    const [newPack, setNewPack] = useState({
        name: '',
        description: '',
        credits_count: 1,
        price_fcfa: 250,
        discount_percent: 0,
    });
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadPacks();
    }, []);

    async function loadPacks() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('decision_credit_packs')
                .select('*')
                .order('display_order');

            if (error) throw error;
            setPacks((data as CreditPack[]) || []);
        } catch (e) {
            console.error('Erreur chargement packs:', e);
            setPacks([]);
        }
        setLoading(false);
    }

    async function createPack() {
        if (!newPack.name || newPack.credits_count <= 0 || newPack.price_fcfa <= 0) {
            setSaveStatus('❌ Nom, crédits et prix requis');
            return;
        }

        setSaveStatus('Création...');
        try {
            const { error } = await supabase
                .from('decision_credit_packs')
                .insert({
                    name: newPack.name,
                    description: newPack.description || null,
                    credits_count: newPack.credits_count,
                    price_fcfa: newPack.price_fcfa,
                    discount_percent: newPack.discount_percent,
                    is_active: true,
                    display_order: packs.length + 1,
                });

            if (error) throw error;
            setShowAddForm(false);
            setNewPack({ name: '', description: '', credits_count: 1, price_fcfa: 250, discount_percent: 0 });
            setSaveStatus('✅ Pack créé !');
            loadPacks();
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Erreur création:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function updatePack(pack: CreditPack) {
        setSaveStatus('Enregistrement...');
        try {
            const { error } = await supabase
                .from('decision_credit_packs')
                .update({
                    name: pack.name,
                    description: pack.description,
                    credits_count: pack.credits_count,
                    price_fcfa: pack.price_fcfa,
                    discount_percent: pack.discount_percent,
                    is_active: pack.is_active,
                })
                .eq('id', pack.id);

            if (error) throw error;
            setEditingPack(null);
            setSaveStatus('✅ Pack mis à jour !');
            loadPacks();
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Erreur mise à jour:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function togglePackStatus(pack: CreditPack) {
        try {
            const { error } = await supabase
                .from('decision_credit_packs')
                .update({ is_active: !pack.is_active })
                .eq('id', pack.id);

            if (error) throw error;
            loadPacks();
        } catch (e) {
            console.error('Erreur toggle:', e);
        }
    }

    async function deletePack(pack: CreditPack) {
        if (!confirm(`Supprimer le pack "${pack.name}" ?`)) return;

        try {
            const { error } = await supabase
                .from('decision_credit_packs')
                .delete()
                .eq('id', pack.id);

            if (error) throw error;
            loadPacks();
        } catch (e) {
            console.error('Erreur suppression:', e);
        }
    }

    function getPricePerCredit(pack: CreditPack): number {
        return Math.round(pack.price_fcfa / pack.credits_count);
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page credit-packs">
            <div className="page-header">
                <div>
                    <h2 className="page-title">🎁 Packs de Crédits</h2>
                    <p className="page-subtitle">
                        Configurez les packs d'achat de crédits à la carte • {packs.length} pack{packs.length !== 1 ? 's' : ''}
                    </p>
                </div>
                <button className="btn-primary" onClick={() => setShowAddForm(!showAddForm)}>
                    {showAddForm ? 'Annuler' : '+ Nouveau pack'}
                </button>
            </div>

            {saveStatus && (
                <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                    {saveStatus}
                </div>
            )}

            {showAddForm && (
                <div className="promo-form" style={{ marginBottom: '24px', background: 'var(--card-bg)', padding: '1.5rem', borderRadius: '12px' }}>
                    <h3 style={{ marginTop: 0 }}>Créer un nouveau pack</h3>
                    <div className="form-row" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '1rem' }}>
                        <div className="form-group">
                            <label>Nom</label>
                            <input
                                type="text"
                                value={newPack.name}
                                onChange={(e) => setNewPack({ ...newPack, name: e.target.value })}
                                placeholder="Ex: Pack 5 Analyses"
                            />
                        </div>
                        <div className="form-group">
                            <label>Nombre de crédits</label>
                            <input
                                type="number"
                                value={newPack.credits_count}
                                onChange={(e) => setNewPack({ ...newPack, credits_count: parseInt(e.target.value) || 1 })}
                                min="1"
                            />
                        </div>
                        <div className="form-group">
                            <label>Prix (FCFA)</label>
                            <input
                                type="number"
                                value={newPack.price_fcfa}
                                onChange={(e) => setNewPack({ ...newPack, price_fcfa: parseInt(e.target.value) || 0 })}
                                min="1"
                            />
                        </div>
                        <div className="form-group">
                            <label>% Réduction affiché</label>
                            <input
                                type="number"
                                value={newPack.discount_percent}
                                onChange={(e) => setNewPack({ ...newPack, discount_percent: parseInt(e.target.value) || 0 })}
                                min="0"
                                max="100"
                            />
                        </div>
                    </div>
                    <div className="form-group" style={{ marginTop: '0.5rem' }}>
                        <label>Description (optionnel)</label>
                        <input
                            type="text"
                            value={newPack.description}
                            onChange={(e) => setNewPack({ ...newPack, description: e.target.value })}
                            placeholder="Description du pack"
                            style={{ width: '100%' }}
                        />
                    </div>
                    <button className="btn-primary" onClick={createPack} style={{ marginTop: '1rem' }}>
                        Créer le pack
                    </button>
                </div>
            )}

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1rem' }}>
                {packs.map((pack) => (
                    <div
                        key={pack.id}
                        style={{
                            background: 'var(--card-bg)',
                            borderRadius: '12px',
                            padding: '1.25rem',
                            border: pack.is_active ? '1px solid var(--border-color)' : '1px solid var(--error)',
                            opacity: pack.is_active ? 1 : 0.6,
                            position: 'relative'
                        }}
                    >
                        {pack.discount_percent > 0 && (
                            <span style={{
                                position: 'absolute',
                                top: '-8px',
                                right: '1rem',
                                background: '#10b981',
                                color: 'white',
                                padding: '0.2rem 0.6rem',
                                borderRadius: '12px',
                                fontSize: '0.75rem',
                                fontWeight: '600'
                            }}>
                                -{pack.discount_percent}%
                            </span>
                        )}

                        {editingPack?.id === pack.id ? (
                            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                                <input
                                    type="text"
                                    value={editingPack.name}
                                    onChange={(e) => setEditingPack({ ...editingPack, name: e.target.value })}
                                    placeholder="Nom"
                                />
                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.5rem' }}>
                                    <input
                                        type="number"
                                        value={editingPack.credits_count}
                                        onChange={(e) => setEditingPack({ ...editingPack, credits_count: parseInt(e.target.value) || 1 })}
                                        placeholder="Crédits"
                                        min="1"
                                    />
                                    <input
                                        type="number"
                                        value={editingPack.price_fcfa}
                                        onChange={(e) => setEditingPack({ ...editingPack, price_fcfa: parseInt(e.target.value) || 0 })}
                                        placeholder="Prix"
                                    />
                                </div>
                                <input
                                    type="number"
                                    value={editingPack.discount_percent}
                                    onChange={(e) => setEditingPack({ ...editingPack, discount_percent: parseInt(e.target.value) || 0 })}
                                    placeholder="% Réduction"
                                    min="0"
                                    max="100"
                                />
                                <div style={{ display: 'flex', gap: '0.5rem' }}>
                                    <button className="btn-primary" onClick={() => updatePack(editingPack)}>
                                        Sauvegarder
                                    </button>
                                    <button className="btn-secondary" onClick={() => setEditingPack(null)}>
                                        Annuler
                                    </button>
                                </div>
                            </div>
                        ) : (
                            <>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
                                    <h3 style={{ margin: 0, fontSize: '1.1rem' }}>{pack.name}</h3>
                                    <span style={{
                                        fontSize: '0.7rem',
                                        padding: '0.2rem 0.5rem',
                                        borderRadius: '4px',
                                        background: pack.is_active ? 'var(--success-bg)' : 'var(--error-bg)',
                                        color: pack.is_active ? 'var(--success)' : 'var(--error)'
                                    }}>
                                        {pack.is_active ? 'Actif' : 'Inactif'}
                                    </span>
                                </div>

                                <div style={{ display: 'flex', alignItems: 'baseline', gap: '0.5rem', marginBottom: '0.5rem' }}>
                                    <span style={{ fontSize: '1.75rem', fontWeight: 'bold', color: 'var(--primary)' }}>
                                        {pack.credits_count}
                                    </span>
                                    <span style={{ color: 'var(--text-muted)' }}>crédit{pack.credits_count > 1 ? 's' : ''}</span>
                                </div>

                                <div style={{ fontSize: '1.25rem', fontWeight: '600', marginBottom: '0.25rem' }}>
                                    {pack.price_fcfa.toLocaleString()} FCFA
                                </div>

                                <div style={{ fontSize: '0.8rem', color: 'var(--text-muted)', marginBottom: '1rem' }}>
                                    {getPricePerCredit(pack)} FCFA/crédit
                                </div>

                                {pack.description && (
                                    <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)', margin: '0 0 1rem 0' }}>
                                        {pack.description}
                                    </p>
                                )}

                                <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                    <button onClick={() => setEditingPack(pack)} style={{ fontSize: '0.85rem' }}>
                                        Modifier
                                    </button>
                                    <button onClick={() => togglePackStatus(pack)} style={{ fontSize: '0.85rem' }}>
                                        {pack.is_active ? 'Désactiver' : 'Activer'}
                                    </button>
                                    <button
                                        className="danger"
                                        onClick={() => deletePack(pack)}
                                        style={{ fontSize: '0.85rem' }}
                                    >
                                        Supprimer
                                    </button>
                                </div>
                            </>
                        )}
                    </div>
                ))}
            </div>

            {packs.length === 0 && !showAddForm && (
                <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--text-muted)' }}>
                    <p>Aucun pack de crédits créé</p>
                    <button className="btn-primary" onClick={() => setShowAddForm(true)}>
                        Créer le premier pack
                    </button>
                </div>
            )}
        </div>
    );
}
