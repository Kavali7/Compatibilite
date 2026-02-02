import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

// Currency conversion rates (1 FCFA = X other currency)
const CURRENCY_RATES = {
    FCFA: 1,
    EUR: 0.001524,  // 1 FCFA = 1/655.957 EUR (official fixed rate)
    USD: 0.001626,  // 1 FCFA ≈ 1/615 USD (market rate ~2026)
};

type Currency = 'FCFA' | 'EUR' | 'USD';

interface PricingPlan {
    id: string;
    plan_type: string;
    name: string;
    description: string | null;
    price_fcfa: number;
    currency: string;
    duration_days: number | null;
    is_active: boolean;
    display_order: number;
    created_at: string;
}

// Service mapping for display
const SERVICE_LABELS: Record<string, { emoji: string; category: string }> = {
    'consultation': { emoji: '💑', category: 'Compatibilité' },
    'subscription': { emoji: '📅', category: 'Abonnement' },
    'annee': { emoji: '📆', category: 'Prévision Annuelle' },
    'mois': { emoji: '📅', category: 'Prévision Mensuelle' },
    'jour': { emoji: '📌', category: 'Prévision Journalière' },
    'bundle': { emoji: '📦', category: 'Bundle' },
    'portrait_ame': { emoji: '✨', category: 'Portrait de l\'Âme' },
    'portrait_ame_express': { emoji: '✨', category: 'Portrait Express' },
    'portrait_ame_strategic': { emoji: '✨', category: 'Portrait Stratégique' },
    'personal_cycle_annual': { emoji: '🔄', category: 'Cycle Personnel' },
    'business_cycle_annual': { emoji: '💼', category: 'Cycle Business' },
    'health_cycle_annual': { emoji: '🏥', category: 'Cycle Santé' },
    'daily_guide_day': { emoji: '⏰', category: 'Guide Horaire' },
    'life_phase_report': { emoji: '🔄', category: 'Phases de Vie' },
    'lunar_timing_monthly': { emoji: '🌙', category: 'Timing Lunaire' },
    'decision_credit_pack': { emoji: '💡', category: 'Crédits Décision' },
};

export default function UnifiedPricing() {
    const [plans, setPlans] = useState<PricingPlan[]>([]);
    const [loading, setLoading] = useState(true);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editPrice, setEditPrice] = useState('');
    const [displayCurrency, setDisplayCurrency] = useState<Currency>('FCFA');
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        loadPlans();
        loadCurrency();
    }, []);

    async function loadPlans() {
        setLoading(true);
        setError(null);
        try {
            const { data, error: fetchError } = await supabase
                .from('pricing_plans')
                .select('*')
                .order('plan_type')
                .order('display_order');

            if (fetchError) throw fetchError;
            setPlans(data || []);
        } catch (e: any) {
            console.error('Error loading plans:', e);
            setError(e.message);
        }
        setLoading(false);
    }

    async function loadCurrency() {
        try {
            const { data } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'devise')
                .maybeSingle();

            if (data?.value?.devise) {
                setDisplayCurrency(data.value.devise as Currency);
            }
        } catch (e) {
            console.error('Error loading currency:', e);
        }
    }

    function convertToDisplay(priceFcfa: number): string {
        if (displayCurrency === 'FCFA') {
            return formatNumber(priceFcfa) + ' FCFA';
        }
        const converted = priceFcfa * CURRENCY_RATES[displayCurrency];
        const symbol = displayCurrency === 'EUR' ? '€' : '$';
        return `${symbol}${converted.toFixed(2)}`;
    }

    function formatNumber(num: number): string {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    async function savePlanPrice(planId: string, newPrice: number) {
        setSaving(true);
        try {
            const { error: updateError } = await supabase
                .from('pricing_plans')
                .update({ price_fcfa: newPrice, updated_at: new Date().toISOString() })
                .eq('id', planId);

            if (updateError) throw updateError;
            await loadPlans();
            setEditingId(null);
        } catch (e: any) {
            console.error('Error saving price:', e);
            setError(e.message);
        }
        setSaving(false);
    }

    async function togglePlanActive(plan: PricingPlan) {
        try {
            const { error: updateError } = await supabase
                .from('pricing_plans')
                .update({ is_active: !plan.is_active })
                .eq('id', plan.id);

            if (updateError) throw updateError;
            await loadPlans();
        } catch (e: any) {
            console.error('Error toggling plan:', e);
            setError(e.message);
        }
    }

    function getServiceInfo(planType: string) {
        return SERVICE_LABELS[planType] || { emoji: '📋', category: planType };
    }

    function startEdit(plan: PricingPlan) {
        setEditingId(plan.id);
        setEditPrice(plan.price_fcfa.toString());
    }

    function handleSaveEdit(planId: string) {
        const price = parseInt(editPrice, 10);
        if (!isNaN(price) && price >= 0) {
            savePlanPrice(planId, price);
        }
    }

    // Group plans by category for display
    const groupedPlans = plans.reduce((acc, plan) => {
        const info = getServiceInfo(plan.plan_type);
        const category = info.category;
        if (!acc[category]) acc[category] = [];
        acc[category].push(plan);
        return acc;
    }, {} as Record<string, PricingPlan[]>);

    if (loading) {
        return <div className="page-loading">Chargement des tarifs...</div>;
    }

    return (
        <div className="page unified-pricing">
            <header className="page-header">
                <h1>💰 Tarifs Unifiés</h1>
                <p className="muted">
                    Gérez tous les tarifs depuis un seul endroit. Les prix sont stockés en FCFA et convertis automatiquement.
                </p>
            </header>

            {error && <div className="error-banner">{error}</div>}

            {/* Currency Display Selector */}
            <div className="currency-switcher">
                <span>Afficher en:</span>
                {(['FCFA', 'EUR', 'USD'] as Currency[]).map(cur => (
                    <button
                        key={cur}
                        className={`currency-btn ${displayCurrency === cur ? 'active' : ''}`}
                        onClick={() => setDisplayCurrency(cur)}
                    >
                        {cur}
                    </button>
                ))}
            </div>

            {/* Stats Summary */}
            <div className="pricing-stats">
                <div className="stat-card">
                    <span className="stat-value">{plans.length}</span>
                    <span className="stat-label">Plans Total</span>
                </div>
                <div className="stat-card">
                    <span className="stat-value">{plans.filter(p => p.is_active).length}</span>
                    <span className="stat-label">Actifs</span>
                </div>
                <div className="stat-card">
                    <span className="stat-value">{plans.filter(p => p.price_fcfa === 0).length}</span>
                    <span className="stat-label">Gratuits</span>
                </div>
            </div>

            {/* Grouped Plans */}
            {Object.entries(groupedPlans).map(([category, categoryPlans]) => (
                <div key={category} className="pricing-category">
                    <h3 className="category-title">{getServiceInfo(categoryPlans[0].plan_type).emoji} {category}</h3>
                    <div className="pricing-table-container">
                        <table className="pricing-table">
                            <thead>
                                <tr>
                                    <th>Plan</th>
                                    <th>Prix FCFA</th>
                                    <th>Prix {displayCurrency !== 'FCFA' ? displayCurrency : 'EUR/USD'}</th>
                                    <th>Durée</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {categoryPlans.map(plan => (
                                    <tr key={plan.id} className={!plan.is_active ? 'inactive-row' : ''}>
                                        <td>
                                            <div className="plan-name">
                                                <strong>{plan.name}</strong>
                                                {plan.description && (
                                                    <span className="plan-desc">{plan.description}</span>
                                                )}
                                            </div>
                                        </td>
                                        <td>
                                            {editingId === plan.id ? (
                                                <input
                                                    type="number"
                                                    value={editPrice}
                                                    onChange={(e) => setEditPrice(e.target.value)}
                                                    className="price-input"
                                                    autoFocus
                                                    aria-label="Prix en FCFA"
                                                    placeholder="Prix FCFA"
                                                />
                                            ) : (
                                                <span className={plan.price_fcfa === 0 ? 'free-badge' : ''}>
                                                    {plan.price_fcfa === 0 ? '🎁 GRATUIT' : `${formatNumber(plan.price_fcfa)} FCFA`}
                                                </span>
                                            )}
                                        </td>
                                        <td className="converted-price">
                                            {displayCurrency !== 'FCFA' ? (
                                                convertToDisplay(plan.price_fcfa)
                                            ) : (
                                                <>
                                                    <span className="eur">{convertToDisplay(plan.price_fcfa).replace('FCFA', '')}€{(plan.price_fcfa * CURRENCY_RATES.EUR).toFixed(2)}</span>
                                                    <span className="usd">${(plan.price_fcfa * CURRENCY_RATES.USD).toFixed(2)}</span>
                                                </>
                                            )}
                                        </td>
                                        <td>
                                            {plan.duration_days
                                                ? `${plan.duration_days} jours`
                                                : plan.plan_type.includes('annual') ? '1 an'
                                                    : plan.plan_type.includes('monthly') ? '1 mois'
                                                        : '—'}
                                        </td>
                                        <td>
                                            <button
                                                className={`status-badge ${plan.is_active ? 'active' : 'inactive'}`}
                                                onClick={() => togglePlanActive(plan)}
                                            >
                                                {plan.is_active ? '✅ Actif' : '❌ Inactif'}
                                            </button>
                                        </td>
                                        <td>
                                            {editingId === plan.id ? (
                                                <div className="action-btns">
                                                    <button
                                                        className="save-btn small"
                                                        onClick={() => handleSaveEdit(plan.id)}
                                                        disabled={saving}
                                                    >
                                                        {saving ? '...' : '✓'}
                                                    </button>
                                                    <button
                                                        className="cancel-btn small"
                                                        onClick={() => setEditingId(null)}
                                                    >
                                                        ✕
                                                    </button>
                                                </div>
                                            ) : (
                                                <button
                                                    className="edit-btn small"
                                                    onClick={() => startEdit(plan)}
                                                >
                                                    ✏️ Prix
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            ))}

            <style>{`
                .unified-pricing {
                    max-width: 1200px;
                }
                .currency-switcher {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 24px;
                    padding: 16px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                }
                .currency-btn {
                    padding: 8px 16px;
                    border: 2px solid rgba(255,255,255,0.2);
                    background: transparent;
                    color: #aaa;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .currency-btn.active {
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    border-color: #667eea;
                    color: white;
                }
                .pricing-stats {
                    display: flex;
                    gap: 16px;
                    margin-bottom: 24px;
                }
                .stat-card {
                    flex: 1;
                    padding: 20px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    text-align: center;
                }
                .stat-value {
                    display: block;
                    font-size: 32px;
                    font-weight: bold;
                    color: #667eea;
                }
                .stat-label {
                    color: #888;
                    font-size: 14px;
                }
                .pricing-category {
                    margin-bottom: 32px;
                    padding: 20px;
                    background: rgba(255,255,255,0.02);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                }
                .category-title {
                    margin: 0 0 16px 0;
                    color: #9f7aea;
                    font-size: 18px;
                }
                .pricing-table-container {
                    overflow-x: auto;
                }
                .pricing-table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .pricing-table th,
                .pricing-table td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid rgba(255,255,255,0.1);
                }
                .pricing-table th {
                    color: #888;
                    font-weight: 600;
                    font-size: 12px;
                    text-transform: uppercase;
                }
                .inactive-row {
                    opacity: 0.5;
                }
                .plan-name {
                    display: flex;
                    flex-direction: column;
                }
                .plan-desc {
                    font-size: 12px;
                    color: #888;
                    margin-top: 4px;
                }
                .price-input {
                    width: 100px;
                    padding: 8px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid #667eea;
                    border-radius: 6px;
                    color: white;
                    font-size: 14px;
                }
                .free-badge {
                    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                    padding: 4px 8px;
                    border-radius: 6px;
                    font-size: 12px;
                }
                .converted-price {
                    color: #888;
                    font-size: 13px;
                }
                .converted-price .eur,
                .converted-price .usd {
                    display: inline-block;
                    margin-right: 8px;
                    padding: 2px 6px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 4px;
                }
                .status-badge {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 20px;
                    font-size: 12px;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .status-badge.active {
                    background: rgba(16, 185, 129, 0.2);
                    color: #10b981;
                }
                .status-badge.inactive {
                    background: rgba(239, 68, 68, 0.2);
                    color: #ef4444;
                }
                .action-btns {
                    display: flex;
                    gap: 8px;
                }
                .small {
                    padding: 6px 12px;
                    font-size: 14px;
                }
                .save-btn.small {
                    background: #10b981;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                }
                .cancel-btn.small {
                    background: #ef4444;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                }
                .edit-btn.small {
                    background: rgba(102, 126, 234, 0.2);
                    color: #667eea;
                    border: 1px solid #667eea;
                    border-radius: 6px;
                    cursor: pointer;
                }
                .error-banner {
                    padding: 16px;
                    background: rgba(239, 68, 68, 0.2);
                    border: 1px solid #ef4444;
                    border-radius: 12px;
                    color: #ef4444;
                    margin-bottom: 24px;
                }
                @media (max-width: 768px) {
                    .pricing-stats {
                        flex-wrap: wrap;
                    }
                    .stat-card {
                        min-width: calc(50% - 8px);
                    }
                    .currency-switcher {
                        flex-wrap: wrap;
                    }
                }
            `}</style>
        </div>
    );
}
