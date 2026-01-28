import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

// Type pour les plans Cycles de Vie enrichis
type CyclesPricingPlan = {
    id: string;
    plan_type: string;
    name: string;
    description: string | null;
    price_fcfa: number;
    duration_days: number | null;
    is_active: boolean;
    display_order: number;
    decision_credits_included: number;
    features: Array<{ icon: string; text: string; highlight?: boolean }>;
    badge_text: string | null;
};

export default function CyclesPricing() {
    const [plans, setPlans] = useState<CyclesPricingPlan[]>([]);
    const [loading, setLoading] = useState(true);
    const [editingPlan, setEditingPlan] = useState<CyclesPricingPlan | null>(null);
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
                .like('plan_type', 'cycle_vie_%')
                .order('price_fcfa');

            if (error) throw error;

            // Parser les features JSON
            const parsed = (data || []).map((p: any) => ({
                ...p,
                features: typeof p.features === 'string' ? JSON.parse(p.features) : (p.features || [])
            }));
            setPlans(parsed as CyclesPricingPlan[]);
        } catch (e) {
            console.error('Erreur chargement plans:', e);
            setPlans([]);
        }
        setLoading(false);
    }

    async function updatePlan(plan: CyclesPricingPlan) {
        setSaveStatus('Enregistrement...');
        try {
            const { error } = await supabase
                .from('pricing_plans')
                .update({
                    name: plan.name,
                    description: plan.description,
                    price_fcfa: plan.price_fcfa,
                    duration_days: plan.duration_days,
                    decision_credits_included: plan.decision_credits_included,
                    features: plan.features,
                    badge_text: plan.badge_text,
                    is_active: plan.is_active,
                })
                .eq('id', plan.id);

            if (error) throw error;
            setEditingPlan(null);
            setSaveStatus('✅ Plan mis à jour !');
            loadPlans();
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Erreur mise à jour:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function togglePlanStatus(plan: CyclesPricingPlan) {
        try {
            const { error } = await supabase
                .from('pricing_plans')
                .update({ is_active: !plan.is_active })
                .eq('id', plan.id);

            if (error) throw error;
            loadPlans();
        } catch (e) {
            console.error('Erreur toggle:', e);
        }
    }

    function getCreditsLabel(credits: number): string {
        if (credits === -1) return '∞ Illimité';
        if (credits === 0) return '0 (Aucun accès)';
        return `${credits} crédit${credits > 1 ? 's' : ''}`;
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page cycles-pricing">
            <div className="page-header">
                <div>
                    <h2 className="page-title">💰 Tarifs Cycles de Vie</h2>
                    <p className="page-subtitle">
                        Configurez les prix, crédits et avantages de chaque plan
                    </p>
                </div>
            </div>

            {saveStatus && (
                <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                    {saveStatus}
                </div>
            )}

            <div className="plans-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: '1.5rem' }}>
                {plans.map((plan) => (
                    <div
                        key={plan.id}
                        className={`plan-card ${!plan.is_active ? 'inactive' : ''}`}
                        style={{
                            background: 'var(--card-bg)',
                            borderRadius: '12px',
                            padding: '1.5rem',
                            border: plan.badge_text ? '2px solid var(--primary)' : '1px solid var(--border-color)',
                            position: 'relative'
                        }}
                    >
                        {plan.badge_text && (
                            <span style={{
                                position: 'absolute',
                                top: '-10px',
                                right: '1rem',
                                background: 'var(--primary)',
                                color: 'white',
                                padding: '0.25rem 0.75rem',
                                borderRadius: '20px',
                                fontSize: '0.75rem',
                                fontWeight: '600'
                            }}>
                                {plan.badge_text}
                            </span>
                        )}

                        {editingPlan?.id === plan.id ? (
                            <div className="plan-edit" style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                                <div>
                                    <label style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>Nom</label>
                                    <input
                                        type="text"
                                        value={editingPlan.name}
                                        onChange={(e) => setEditingPlan({ ...editingPlan, name: e.target.value })}
                                        style={{ width: '100%' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>Prix (FCFA)</label>
                                    <input
                                        type="number"
                                        value={editingPlan.price_fcfa}
                                        onChange={(e) => setEditingPlan({ ...editingPlan, price_fcfa: parseInt(e.target.value) || 0 })}
                                        style={{ width: '100%' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>
                                        Crédits décision inclus (-1 = illimité)
                                    </label>
                                    <input
                                        type="number"
                                        value={editingPlan.decision_credits_included}
                                        onChange={(e) => setEditingPlan({ ...editingPlan, decision_credits_included: parseInt(e.target.value) || 0 })}
                                        style={{ width: '100%' }}
                                        min="-1"
                                    />
                                </div>
                                <div>
                                    <label style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>Badge (optionnel)</label>
                                    <input
                                        type="text"
                                        value={editingPlan.badge_text || ''}
                                        onChange={(e) => setEditingPlan({ ...editingPlan, badge_text: e.target.value || null })}
                                        placeholder="Ex: Populaire, Premium"
                                        style={{ width: '100%' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>
                                        Features (JSON)
                                    </label>
                                    <textarea
                                        value={JSON.stringify(editingPlan.features, null, 2)}
                                        onChange={(e) => {
                                            try {
                                                const parsed = JSON.parse(e.target.value);
                                                setEditingPlan({ ...editingPlan, features: parsed });
                                            } catch {
                                                // Ignore parse errors while typing
                                            }
                                        }}
                                        style={{ width: '100%', minHeight: '120px', fontFamily: 'monospace', fontSize: '0.8rem' }}
                                    />
                                </div>
                                <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem' }}>
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
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '0.5rem' }}>
                                    <span style={{
                                        fontSize: '0.75rem',
                                        background: plan.is_active ? 'var(--success-bg)' : 'var(--error-bg)',
                                        color: plan.is_active ? 'var(--success)' : 'var(--error)',
                                        padding: '0.25rem 0.5rem',
                                        borderRadius: '4px'
                                    }}>
                                        {plan.is_active ? 'Actif' : 'Inactif'}
                                    </span>
                                    <span style={{ fontSize: '0.7rem', color: 'var(--text-muted)' }}>
                                        {plan.plan_type}
                                    </span>
                                </div>

                                <h3 style={{ margin: '0.5rem 0', fontSize: '1.25rem' }}>{plan.name}</h3>

                                <div style={{ fontSize: '2rem', fontWeight: 'bold', color: 'var(--primary)', marginBottom: '0.5rem' }}>
                                    {plan.price_fcfa.toLocaleString()} <span style={{ fontSize: '1rem', fontWeight: 'normal' }}>FCFA</span>
                                </div>

                                <div style={{
                                    background: 'var(--primary-light)',
                                    padding: '0.5rem 0.75rem',
                                    borderRadius: '8px',
                                    marginBottom: '1rem',
                                    fontSize: '0.9rem',
                                    fontWeight: '600',
                                    color: 'var(--primary)'
                                }}>
                                    🎯 {getCreditsLabel(plan.decision_credits_included)}
                                </div>

                                {plan.features && plan.features.length > 0 && (
                                    <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 1rem 0' }}>
                                        {plan.features.map((f, i) => (
                                            <li key={i} style={{
                                                display: 'flex',
                                                alignItems: 'center',
                                                gap: '0.5rem',
                                                marginBottom: '0.5rem',
                                                fontSize: '0.85rem',
                                                color: f.highlight ? 'var(--primary)' : 'inherit',
                                                fontWeight: f.highlight ? '600' : 'normal'
                                            }}>
                                                <span>✓</span>
                                                <span>{f.text}</span>
                                            </li>
                                        ))}
                                    </ul>
                                )}

                                <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                    <button
                                        onClick={() => setEditingPlan(plan)}
                                        style={{ flex: 1 }}
                                    >
                                        Modifier
                                    </button>
                                    <button
                                        onClick={() => togglePlanStatus(plan)}
                                        style={{ flex: 1 }}
                                    >
                                        {plan.is_active ? 'Désactiver' : 'Activer'}
                                    </button>
                                </div>
                            </>
                        )}
                    </div>
                ))}
            </div>

            <div style={{ marginTop: '2rem', padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', fontSize: '0.85rem' }}>
                <h4 style={{ margin: '0 0 0.5rem 0' }}>💡 Notes</h4>
                <ul style={{ margin: 0, paddingLeft: '1.25rem', color: 'var(--text-muted)' }}>
                    <li><strong>-1</strong> dans "Crédits décision" = accès illimité</li>
                    <li><strong>0</strong> = pas d'accès aux analyses de décision</li>
                    <li>Les features sont affichées dans l'app Flutter</li>
                    <li>Le badge apparaît en haut de la carte dans l'app</li>
                </ul>
            </div>
        </div>
    );
}
