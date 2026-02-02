import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

interface Subscription {
    id: string;
    user_id: string;
    user_email?: string;
    user_name?: string;
    service_type: string;
    purchase_date: string;
    expiry_date: string | null;
    amount_fcfa: number;
    status: 'active' | 'expired' | 'cancelled';
    source_table: string;
}

// Service type labels
const SERVICE_LABELS: Record<string, { emoji: string; label: string }> = {
    'personal_cycle_annual': { emoji: '🔄', label: 'Cycle Personnel' },
    'business_cycle_annual': { emoji: '💼', label: 'Cycle Business' },
    'health_cycle_annual': { emoji: '🏥', label: 'Cycle Santé' },
    'lunar_timing_monthly': { emoji: '🌙', label: 'Timing Lunaire' },
    'consultation': { emoji: '💑', label: 'Compatibilité' },
    'annee': { emoji: '📆', label: 'Prévision Annuelle' },
    'mois': { emoji: '📅', label: 'Prévision Mensuelle' },
    'jour': { emoji: '📌', label: 'Prévision Journalière' },
    'portrait_ame': { emoji: '✨', label: 'Portrait de l\'Âme' },
    'life_phase_report': { emoji: '🔄', label: 'Phases de Vie' },
    'daily_guide_day': { emoji: '⏰', label: 'Guide Horaire' },
};

export default function Subscriptions() {
    const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'active' | 'expired'>('all');
    const [serviceFilter, setServiceFilter] = useState<string>('all');
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        loadSubscriptions();
    }, []);

    async function loadSubscriptions() {
        setLoading(true);
        setError(null);
        const allSubs: Subscription[] = [];

        try {
            // Load from payments table (main source)
            const { data: payments, error: payErr } = await supabase
                .from('payments')
                .select('id, user_id, plan_type, amount_fcfa, status, created_at')
                .eq('status', 'success')
                .order('created_at', { ascending: false });

            if (payErr) throw payErr;

            // Get user info for emails
            const userIds = [...new Set(payments?.map(p => p.user_id).filter(Boolean) || [])];
            const { data: users } = await supabase
                .from('users')
                .select('id, email, name')
                .in('id', userIds);

            const userMap = new Map(users?.map(u => [u.id, u]) || []);

            // Map payments to subscriptions
            payments?.forEach(p => {
                const user = userMap.get(p.user_id);
                const expiryDate = calculateExpiry(p.plan_type, p.created_at);

                allSubs.push({
                    id: p.id,
                    user_id: p.user_id,
                    user_email: user?.email,
                    user_name: user?.name,
                    service_type: p.plan_type,
                    purchase_date: p.created_at,
                    expiry_date: expiryDate,
                    amount_fcfa: p.amount_fcfa || 0,
                    status: getStatus(expiryDate),
                    source_table: 'payments',
                });
            });

            // Also load from cycle_vie_purchases if exists
            try {
                const { data: cycleData } = await supabase
                    .from('cycle_vie_purchases')
                    .select('id, user_id, service_type, amount_fcfa, status, created_at, validity_start, validity_end')
                    .eq('status', 'success');

                cycleData?.forEach(p => {
                    const user = userMap.get(p.user_id);
                    allSubs.push({
                        id: p.id,
                        user_id: p.user_id,
                        user_email: user?.email,
                        user_name: user?.name,
                        service_type: p.service_type,
                        purchase_date: p.created_at,
                        expiry_date: p.validity_end,
                        amount_fcfa: p.amount_fcfa || 0,
                        status: getStatus(p.validity_end),
                        source_table: 'cycle_vie_purchases',
                    });
                });
            } catch (e) {
                // Table may not exist, ignore
            }

            // Also load from temporal_purchases if exists
            try {
                const { data: tempData } = await supabase
                    .from('temporal_purchases')
                    .select('id, user_id, purchase_type, amount_fcfa, status, created_at')
                    .eq('status', 'success');

                tempData?.forEach(p => {
                    const user = userMap.get(p.user_id);
                    allSubs.push({
                        id: p.id,
                        user_id: p.user_id,
                        user_email: user?.email,
                        user_name: user?.name,
                        service_type: p.purchase_type,
                        purchase_date: p.created_at,
                        expiry_date: null, // one-time
                        amount_fcfa: p.amount_fcfa || 0,
                        status: 'active',
                        source_table: 'temporal_purchases',
                    });
                });
            } catch (e) {
                // Table may not exist, ignore
            }

            setSubscriptions(allSubs);
        } catch (e: any) {
            console.error('Error loading subscriptions:', e);
            setError(e.message);
        }
        setLoading(false);
    }

    function calculateExpiry(planType: string, purchaseDate: string): string | null {
        const date = new Date(purchaseDate);
        if (planType.includes('annual')) {
            date.setFullYear(date.getFullYear() + 1);
            return date.toISOString();
        }
        if (planType.includes('monthly')) {
            date.setMonth(date.getMonth() + 1);
            return date.toISOString();
        }
        // One-time purchases don't expire
        return null;
    }

    function getStatus(expiryDate: string | null): 'active' | 'expired' {
        if (!expiryDate) return 'active'; // one-time = always active
        return new Date(expiryDate) > new Date() ? 'active' : 'expired';
    }

    function getServiceLabel(type: string) {
        return SERVICE_LABELS[type] || { emoji: '📋', label: type };
    }

    const filteredSubs = subscriptions.filter(sub => {
        if (filter === 'active' && sub.status !== 'active') return false;
        if (filter === 'expired' && sub.status !== 'expired') return false;
        if (serviceFilter !== 'all' && sub.service_type !== serviceFilter) return false;
        return true;
    });

    const stats = {
        total: subscriptions.length,
        active: subscriptions.filter(s => s.status === 'active').length,
        expired: subscriptions.filter(s => s.status === 'expired').length,
        revenue: subscriptions.reduce((sum, s) => sum + s.amount_fcfa, 0),
    };

    // Get unique service types for filter
    const serviceTypes = [...new Set(subscriptions.map(s => s.service_type))];

    if (loading) {
        return <div className="page-loading">Chargement des abonnements...</div>;
    }

    return (
        <div className="page subscriptions">
            <header className="page-header">
                <h1>📋 Centre des Abonnements</h1>
                <p className="muted">Vue unifiée de tous les achats et abonnements actifs.</p>
            </header>

            {error && <div className="error-banner">{error}</div>}

            {/* Stats */}
            <div className="stats-row">
                <div className="stat-card">
                    <span className="stat-value">{stats.total}</span>
                    <span className="stat-label">Total Achats</span>
                </div>
                <div className="stat-card active">
                    <span className="stat-value">{stats.active}</span>
                    <span className="stat-label">Actifs</span>
                </div>
                <div className="stat-card expired">
                    <span className="stat-value">{stats.expired}</span>
                    <span className="stat-label">Expirés</span>
                </div>
                <div className="stat-card revenue">
                    <span className="stat-value">{stats.revenue.toLocaleString('fr-FR')}</span>
                    <span className="stat-label">Revenus FCFA</span>
                </div>
            </div>

            {/* Filters */}
            <div className="filter-bar">
                <div className="filter-group">
                    <button
                        className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
                        onClick={() => setFilter('all')}
                    >
                        Tous ({stats.total})
                    </button>
                    <button
                        className={`filter-btn ${filter === 'active' ? 'active' : ''}`}
                        onClick={() => setFilter('active')}
                    >
                        ✅ Actifs ({stats.active})
                    </button>
                    <button
                        className={`filter-btn ${filter === 'expired' ? 'active' : ''}`}
                        onClick={() => setFilter('expired')}
                    >
                        ⏳ Expirés ({stats.expired})
                    </button>
                </div>
                <select
                    className="service-filter"
                    value={serviceFilter}
                    onChange={e => setServiceFilter(e.target.value)}
                    aria-label="Filtrer par service"
                >
                    <option value="all">Tous les services</option>
                    {serviceTypes.map(type => (
                        <option key={type} value={type}>
                            {getServiceLabel(type).emoji} {getServiceLabel(type).label}
                        </option>
                    ))}
                </select>
            </div>

            {/* Subscriptions Table */}
            <div className="subs-table-container">
                <table className="subs-table">
                    <thead>
                        <tr>
                            <th>Service</th>
                            <th>Utilisateur</th>
                            <th>Date d'achat</th>
                            <th>Expiration</th>
                            <th>Montant</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredSubs.length === 0 ? (
                            <tr>
                                <td colSpan={6} className="empty-state">Aucun abonnement trouvé</td>
                            </tr>
                        ) : (
                            filteredSubs.map(sub => {
                                const serviceInfo = getServiceLabel(sub.service_type);
                                return (
                                    <tr key={`${sub.source_table}-${sub.id}`}>
                                        <td>
                                            <span className="service-badge">
                                                {serviceInfo.emoji} {serviceInfo.label}
                                            </span>
                                        </td>
                                        <td>
                                            <div className="user-cell">
                                                <strong>{sub.user_name || 'N/A'}</strong>
                                                <span className="user-email">{sub.user_email}</span>
                                            </div>
                                        </td>
                                        <td>{new Date(sub.purchase_date).toLocaleDateString('fr-FR')}</td>
                                        <td>
                                            {sub.expiry_date
                                                ? new Date(sub.expiry_date).toLocaleDateString('fr-FR')
                                                : '—'
                                            }
                                        </td>
                                        <td>
                                            {sub.amount_fcfa === 0
                                                ? <span className="free-badge">🎁 Gratuit</span>
                                                : `${sub.amount_fcfa.toLocaleString('fr-FR')} FCFA`
                                            }
                                        </td>
                                        <td>
                                            <span className={`status-badge ${sub.status}`}>
                                                {sub.status === 'active' ? '✅ Actif' : '⏳ Expiré'}
                                            </span>
                                        </td>
                                    </tr>
                                );
                            })
                        )}
                    </tbody>
                </table>
            </div>

            <style>{`
                .subscriptions {
                    max-width: 1400px;
                }
                .stats-row {
                    display: flex;
                    gap: 16px;
                    margin-bottom: 24px;
                    flex-wrap: wrap;
                }
                .stat-card {
                    flex: 1;
                    min-width: 150px;
                    padding: 20px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    text-align: center;
                }
                .stat-card.active { border-left: 4px solid #22c55e; }
                .stat-card.expired { border-left: 4px solid #f59e0b; }
                .stat-card.revenue { border-left: 4px solid #667eea; }
                .stat-value {
                    display: block;
                    font-size: 28px;
                    font-weight: bold;
                    color: #667eea;
                }
                .stat-label {
                    font-size: 13px;
                    color: #888;
                }
                .filter-bar {
                    display: flex;
                    gap: 16px;
                    margin-bottom: 24px;
                    flex-wrap: wrap;
                    align-items: center;
                }
                .filter-group {
                    display: flex;
                    gap: 8px;
                }
                .filter-btn {
                    padding: 8px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 20px;
                    color: #aaa;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .filter-btn:hover {
                    background: rgba(255,255,255,0.1);
                }
                .filter-btn.active {
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    border-color: transparent;
                    color: white;
                }
                .service-filter {
                    padding: 10px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 14px;
                    min-width: 200px;
                }
                .subs-table-container {
                    overflow-x: auto;
                    background: rgba(255,255,255,0.02);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                }
                .subs-table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .subs-table th,
                .subs-table td {
                    padding: 14px 16px;
                    text-align: left;
                    border-bottom: 1px solid rgba(255,255,255,0.08);
                }
                .subs-table th {
                    background: rgba(255,255,255,0.03);
                    color: #888;
                    font-weight: 600;
                    font-size: 12px;
                    text-transform: uppercase;
                }
                .subs-table tbody tr:hover {
                    background: rgba(255,255,255,0.03);
                }
                .service-badge {
                    background: rgba(102,126,234,0.15);
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-size: 13px;
                }
                .user-cell {
                    display: flex;
                    flex-direction: column;
                }
                .user-email {
                    font-size: 12px;
                    color: #888;
                }
                .free-badge {
                    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                    padding: 4px 8px;
                    border-radius: 6px;
                    font-size: 12px;
                }
                .status-badge {
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 12px;
                }
                .status-badge.active {
                    background: rgba(34,197,94,0.2);
                    color: #22c55e;
                }
                .status-badge.expired {
                    background: rgba(245,158,11,0.2);
                    color: #f59e0b;
                }
                .empty-state {
                    text-align: center;
                    padding: 40px;
                    color: #666;
                }
                .error-banner {
                    padding: 16px;
                    background: rgba(239,68,68,0.2);
                    border: 1px solid #ef4444;
                    border-radius: 12px;
                    color: #ef4444;
                    margin-bottom: 24px;
                }
                @media (max-width: 768px) {
                    .stats-row {
                        flex-wrap: wrap;
                    }
                    .stat-card {
                        min-width: calc(50% - 8px);
                    }
                }
            `}</style>
        </div>
    );
}
