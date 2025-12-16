import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

// Types matching existing pricing_plans table
type PricingPlan = {
    id: string;
    plan_type: 'consultation' | 'subscription';
    name: string;
    price_fcfa: number;
    duration_days: number | null;
    is_active: boolean;
    created_at: string;
};

export default function Pricing() {
    const [plans, setPlans] = useState<PricingPlan[]>([]);
    const [loading, setLoading] = useState(true);
    const [editingPlan, setEditingPlan] = useState<PricingPlan | null>(null);
    const [showAddForm, setShowAddForm] = useState(false);
    const [newPlan, setNewPlan] = useState({
        plan_type: 'consultation' as 'consultation' | 'subscription',
        name: '',
        price_fcfa: 500,
        duration_days: null as number | null,
    });
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadPlans();
    }, []);

    async function loadPlans() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('pricing_plans')
                .select('*')
                .order('price_fcfa');

            if (error) throw error;
            setPlans((data as PricingPlan[]) || []);
        } catch (e) {
            console.error('Load pricing_plans error:', e);
            setPlans([]);
        }
        setLoading(false);
    }

    async function togglePlanStatus(plan: PricingPlan) {
        try {
            const { error } = await supabase
                .from('pricing_plans')
                .update({ is_active: !plan.is_active })
                .eq('id', plan.id);

            if (error) throw error;
            loadPlans();
        } catch (e) {
            console.error('Toggle error:', e);
        }
    }

    async function updatePlan(plan: PricingPlan) {
        setSaveStatus('Enregistrement...');
        try {
            const { error } = await supabase
                .from('pricing_plans')
                .update({
                    name: plan.name,
                    price_fcfa: plan.price_fcfa,
                    duration_days: plan.duration_days,
                })
                .eq('id', plan.id);

            if (error) throw error;
            setEditingPlan(null);
            setSaveStatus('✅ Mis à jour !');
            loadPlans();
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Update error:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function createPlan() {
        if (!newPlan.name || newPlan.price_fcfa <= 0) {
            setSaveStatus('Nom et prix requis');
            return;
        }

        setSaveStatus('Création...');
        try {
            const { error } = await supabase
                .from('pricing_plans')
                .insert({
                    plan_type: newPlan.plan_type,
                    name: newPlan.name,
                    price_fcfa: newPlan.price_fcfa,
                    duration_days: newPlan.plan_type === 'subscription' ? newPlan.duration_days : null,
                    is_active: true,
                });

            if (error) throw error;
            setShowAddForm(false);
            setNewPlan({ plan_type: 'consultation', name: '', price_fcfa: 500, duration_days: null });
            setSaveStatus('✅ Plan créé !');
            loadPlans();
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Create error:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function deletePlan(plan: PricingPlan) {
        if (!confirm(`Supprimer le plan "${plan.name}" ?`)) return;

        try {
            const { error } = await supabase
                .from('pricing_plans')
                .delete()
                .eq('id', plan.id);

            if (error) throw error;
            loadPlans();
        } catch (e) {
            console.error('Delete error:', e);
        }
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page pricing">
            <div className="page-header">
                <div>
                    <h2 className="page-title">Plans & Tarifs</h2>
                    <p className="page-subtitle">Table: <code>pricing_plans</code> • {plans.length} forfaits</p>
                </div>
                <button className="btn-primary" onClick={() => setShowAddForm(!showAddForm)}>
                    {showAddForm ? 'Annuler' : '+ Nouveau plan'}
                </button>
            </div>

            {saveStatus && (
                <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                    {saveStatus}
                </div>
            )}

            {showAddForm && (
                <div className="promo-form" style={{ marginBottom: '24px' }}>
                    <h3>Créer un nouveau plan</h3>
                    <div className="form-row">
                        <div className="form-group">
                            <label>Type</label>
                            <select
                                value={newPlan.plan_type}
                                onChange={(e) => setNewPlan({ ...newPlan, plan_type: e.target.value as 'consultation' | 'subscription' })}
                                aria-label="Type de plan"
                            >
                                <option value="consultation">Consultation (unique)</option>
                                <option value="subscription">Abonnement</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Nom</label>
                            <input
                                type="text"
                                value={newPlan.name}
                                onChange={(e) => setNewPlan({ ...newPlan, name: e.target.value })}
                                placeholder="Ex: Rapport Premium"
                            />
                        </div>
                        <div className="form-group">
                            <label>Prix (FCFA)</label>
                            <input
                                type="number"
                                value={newPlan.price_fcfa}
                                onChange={(e) => setNewPlan({ ...newPlan, price_fcfa: parseInt(e.target.value) || 0 })}
                                placeholder="500"
                            />
                        </div>
                        {newPlan.plan_type === 'subscription' && (
                            <div className="form-group">
                                <label>Durée (jours)</label>
                                <input
                                    type="number"
                                    value={newPlan.duration_days || ''}
                                    onChange={(e) => setNewPlan({ ...newPlan, duration_days: parseInt(e.target.value) || null })}
                                    placeholder="30"
                                />
                            </div>
                        )}
                    </div>
                    <button className="btn-primary" onClick={createPlan}>Créer le plan</button>
                </div>
            )}

            <div className="plans-grid">
                {plans.map((plan) => (
                    <div key={plan.id} className={`plan-card ${!plan.is_active ? 'inactive' : ''}`}>
                        {editingPlan?.id === plan.id ? (
                            <div className="plan-edit">
                                <input
                                    type="text"
                                    value={editingPlan.name}
                                    onChange={(e) => setEditingPlan({ ...editingPlan, name: e.target.value })}
                                    placeholder="Nom du forfait"
                                />
                                <input
                                    type="number"
                                    value={editingPlan.price_fcfa}
                                    onChange={(e) => setEditingPlan({ ...editingPlan, price_fcfa: parseInt(e.target.value) || 0 })}
                                    placeholder="Prix (FCFA)"
                                />
                                {plan.plan_type === 'subscription' && (
                                    <input
                                        type="number"
                                        value={editingPlan.duration_days || ''}
                                        onChange={(e) => setEditingPlan({ ...editingPlan, duration_days: parseInt(e.target.value) || null })}
                                        placeholder="Durée (jours)"
                                    />
                                )}
                                <div className="plan-edit-actions">
                                    <button className="btn-primary" onClick={() => updatePlan(editingPlan)}>
                                        Sauvegarder
                                    </button>
                                    <button className="btn-secondary" onClick={() => setEditingPlan(null)}>
                                        Annuler
                                    </button>
                                </div>
                            </div>
                        ) : (
                            <>
                                <div className="plan-header">
                                    <span className="plan-icon">
                                        {plan.plan_type === 'subscription' ? '⭐' : '📄'}
                                    </span>
                                    <span className={`plan-status ${plan.is_active ? 'active' : ''}`}>
                                        {plan.is_active ? 'Actif' : 'Inactif'}
                                    </span>
                                </div>
                                <h3 className="plan-name">{plan.name}</h3>
                                <div className="plan-price">
                                    {plan.price_fcfa.toLocaleString()} <span>FCFA</span>
                                </div>
                                {plan.duration_days && (
                                    <div className="plan-duration">{plan.duration_days} jours</div>
                                )}
                                <div className="plan-type">
                                    {plan.plan_type === 'subscription' ? 'Abonnement' : 'Consultation'}
                                </div>
                                <div className="plan-actions">
                                    <button onClick={() => setEditingPlan(plan)}>Modifier</button>
                                    <button onClick={() => togglePlanStatus(plan)}>
                                        {plan.is_active ? 'Désactiver' : 'Activer'}
                                    </button>
                                    <button className="danger" onClick={() => deletePlan(plan)}>
                                        Supprimer
                                    </button>
                                </div>
                            </>
                        )}
                    </div>
                ))}
            </div>
        </div>
    );
}
