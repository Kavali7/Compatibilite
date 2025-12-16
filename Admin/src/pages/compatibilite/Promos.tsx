import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type PromoCode = {
    id: string;
    code: string;
    type: 'pourcentage' | 'montant';
    valeur: number;
    date_expiration?: string;
    utilisation_max?: number;
    utilisation_actuelle: number;
    actif: boolean;
};

export default function Promos() {
    const [promos, setPromos] = useState<PromoCode[]>([]);
    const [loading, setLoading] = useState(true);
    const [showForm, setShowForm] = useState(false);
    const [formData, setFormData] = useState({
        code: '',
        type: 'pourcentage' as 'pourcentage' | 'montant',
        valeur: 10,
        date_expiration: '',
        utilisation_max: '',
    });

    useEffect(() => {
        loadPromos();
    }, []);

    async function loadPromos() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('codes_promo')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            setPromos((data as PromoCode[]) || []);
        } catch (e) {
            console.error('Load promos error:', e);
            setPromos([]);
        }
        setLoading(false);
    }

    async function createPromo() {
        if (!formData.code || formData.valeur <= 0) return;

        try {
            await supabase.from('codes_promo').insert({
                code: formData.code.toUpperCase(),
                type: formData.type,
                valeur: formData.valeur,
                date_expiration: formData.date_expiration || null,
                utilisation_max: formData.utilisation_max ? parseInt(formData.utilisation_max) : null,
                utilisation_actuelle: 0,
                actif: true,
            });
            setShowForm(false);
            setFormData({ code: '', type: 'pourcentage', valeur: 10, date_expiration: '', utilisation_max: '' });
            loadPromos();
        } catch (e) {
            console.error('Create promo error:', e);
        }
    }

    async function togglePromo(promo: PromoCode) {
        try {
            await supabase
                .from('codes_promo')
                .update({ actif: !promo.actif })
                .eq('id', promo.id);
            loadPromos();
        } catch (e) {
            console.error('Toggle error:', e);
        }
    }

    async function deletePromo(id: string) {
        if (!confirm('Supprimer ce code promo ?')) return;
        try {
            await supabase.from('codes_promo').delete().eq('id', id);
            loadPromos();
        } catch (e) {
            console.error('Delete error:', e);
        }
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page promos">
            <div className="page-header">
                <h2 className="page-title">Codes Promo</h2>
                <button className="btn-primary" onClick={() => setShowForm(!showForm)}>
                    {showForm ? 'Annuler' : '+ Nouveau code'}
                </button>
            </div>

            {showForm && (
                <div className="promo-form">
                    <div className="form-row">
                        <div className="form-group">
                            <label>Code</label>
                            <input
                                type="text"
                                value={formData.code}
                                onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                                placeholder="NOEL2024"
                            />
                        </div>
                        <div className="form-group">
                            <label>Type</label>
                            <select
                                value={formData.type}
                                onChange={(e) => setFormData({ ...formData, type: e.target.value as 'pourcentage' | 'montant' })}
                            >
                                <option value="pourcentage">Pourcentage (%)</option>
                                <option value="montant">Montant fixe (FCFA)</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Valeur</label>
                            <input
                                type="number"
                                value={formData.valeur}
                                onChange={(e) => setFormData({ ...formData, valeur: parseInt(e.target.value) || 0 })}
                            />
                        </div>
                    </div>
                    <div className="form-row">
                        <div className="form-group">
                            <label>Date d'expiration (optionnel)</label>
                            <input
                                type="date"
                                value={formData.date_expiration}
                                onChange={(e) => setFormData({ ...formData, date_expiration: e.target.value })}
                            />
                        </div>
                        <div className="form-group">
                            <label>Limite d'utilisation (optionnel)</label>
                            <input
                                type="number"
                                value={formData.utilisation_max}
                                onChange={(e) => setFormData({ ...formData, utilisation_max: e.target.value })}
                                placeholder="Illimité"
                            />
                        </div>
                    </div>
                    <button className="btn-primary" onClick={createPromo}>
                        Créer le code promo
                    </button>
                </div>
            )}

            <div className="promos-list">
                {promos.length === 0 ? (
                    <div className="empty-state">
                        Aucun code promo.
                        <br />
                        <span className="muted">Créez votre premier code promo ci-dessus.</span>
                    </div>
                ) : (
                    promos.map((promo) => (
                        <div key={promo.id} className={`promo-card ${!promo.actif ? 'inactive' : ''}`}>
                            <div className="promo-code">{promo.code}</div>
                            <div className="promo-value">
                                {promo.type === 'pourcentage' ? `${promo.valeur}%` : `${promo.valeur} FCFA`}
                            </div>
                            <div className="promo-stats">
                                <span>Utilisé: {promo.utilisation_actuelle}</span>
                                {promo.utilisation_max && <span> / {promo.utilisation_max}</span>}
                            </div>
                            {promo.date_expiration && (
                                <div className="promo-expiry">
                                    Expire: {new Date(promo.date_expiration).toLocaleDateString('fr-FR')}
                                </div>
                            )}
                            <div className="promo-actions">
                                <button onClick={() => togglePromo(promo)}>
                                    {promo.actif ? 'Désactiver' : 'Activer'}
                                </button>
                                <button className="danger" onClick={() => deletePromo(promo.id)}>
                                    Supprimer
                                </button>
                            </div>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
}
