import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface CyclePurchase {
    id: string;
    user_id: string;
    payment_id: string | null;
    service_type: string;
    user_birthdate: string;
    user_firstname: string | null;
    consultation_date: string | null;
    decision_type_id: string | null;
    decision_detail: string | null;
    status: string;
    created_at: string;
    expires_at: string | null;
}

interface DecisionType {
    id: string;
    code: string;
    label: string;
}

const SERVICE_LABELS: Record<string, { label: string; icon: string; color: string }> = {
    express: { label: 'Lecture Express', icon: '⚡', color: '#f59e0b' },
    strategique: { label: 'Lecture Stratégique', icon: '🎯', color: '#6366f1' },
    consultation: { label: 'Consultation Date', icon: '📅', color: '#10b981' },
    abonnement: { label: 'Abonnement Premium', icon: '👑', color: '#ec4899' },
};

export default function CyclesPurchases() {
    const [purchases, setPurchases] = useState<CyclePurchase[]>([]);
    const [decisionTypes, setDecisionTypes] = useState<DecisionType[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filterService, setFilterService] = useState<string>('');
    const [stats, setStats] = useState({ total: 0, today: 0, byService: {} as Record<string, number> });

    useEffect(() => {
        loadDecisionTypes();
        loadPurchases();
    }, []);

    async function loadDecisionTypes() {
        const { data } = await supabase
            .from('cycle_vie_decision_types')
            .select('id, code, label');
        setDecisionTypes(data || []);
    }

    async function loadPurchases() {
        setLoading(true);
        try {
            let query = supabase
                .from('cycle_vie_purchases')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(100);

            if (filterService) query = query.eq('service_type', filterService);

            const { data, error: fetchError } = await query;
            if (fetchError) throw fetchError;

            const purchaseData = data || [];
            setPurchases(purchaseData);

            // Calculate stats
            const today = new Date().toISOString().split('T')[0];
            const todayCount = purchaseData.filter(p => p.created_at.startsWith(today)).length;
            const byService: Record<string, number> = {};
            purchaseData.forEach(p => {
                byService[p.service_type] = (byService[p.service_type] || 0) + 1;
            });
            setStats({ total: purchaseData.length, today: todayCount, byService });
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    const getDecisionLabel = (id: string | null) => {
        if (!id) return '-';
        return decisionTypes.find(t => t.id === id)?.label || id;
    };

    const formatDate = (dateStr: string) => {
        const date = new Date(dateStr);
        return date.toLocaleDateString('fr-FR', {
            day: '2-digit',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    };

    const getServiceInfo = (type: string) => SERVICE_LABELS[type] || { label: type, icon: '📦', color: '#6b7280' };

    return (
        <div className="page cycles-purchases">
            <h2 className="page-title">📊 Achats Cycles de Vie</h2>
            <p className="page-subtitle">
                Historique des achats de services Cycles de Vie
            </p>

            {/* Stats */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: '1rem', marginBottom: '1.5rem' }}>
                <div style={{ padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: 'var(--primary)' }}>{stats.total}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Total achats</div>
                </div>
                <div style={{ padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                    <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#10b981' }}>{stats.today}</div>
                    <div style={{ color: 'var(--text-muted)' }}>Aujourd'hui</div>
                </div>
                {Object.entries(stats.byService).map(([service, count]) => {
                    const info = getServiceInfo(service);
                    return (
                        <div key={service} style={{ padding: '1rem', background: 'var(--card-bg)', borderRadius: '8px', textAlign: 'center' }}>
                            <div style={{ fontSize: '2rem', fontWeight: 'bold', color: info.color }}>{count}</div>
                            <div style={{ color: 'var(--text-muted)' }}>{info.icon} {info.label}</div>
                        </div>
                    );
                })}
            </div>

            {/* Filters */}
            <div className="filters" style={{ display: 'flex', gap: '1rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
                <select
                    value={filterService}
                    onChange={e => setFilterService(e.target.value)}
                    style={{ padding: '0.5rem', borderRadius: '4px' }}
                >
                    <option value="">Tous les services</option>
                    {Object.entries(SERVICE_LABELS).map(([value, info]) => (
                        <option key={value} value={value}>{info.icon} {info.label}</option>
                    ))}
                </select>
                <button
                    onClick={loadPurchases}
                    style={{ padding: '0.5rem 1rem', background: 'var(--primary)', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                >
                    🔄 Actualiser
                </button>
            </div>

            {error && <div className="error" style={{ color: 'red', marginBottom: '1rem' }}>{error}</div>}

            {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>Chargement...</div>
            ) : purchases.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '3rem', background: 'var(--card-bg)', borderRadius: '8px' }}>
                    <p style={{ fontSize: '3rem', marginBottom: '0.5rem' }}>📭</p>
                    <p>Aucun achat enregistré</p>
                </div>
            ) : (
                <div style={{ overflowX: 'auto' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse', background: 'var(--card-bg)', borderRadius: '8px', overflow: 'hidden' }}>
                        <thead>
                            <tr style={{ background: 'var(--primary)', color: 'white' }}>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Date</th>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Service</th>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Utilisateur</th>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Date naissance</th>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Consultation</th>
                                <th style={{ padding: '0.75rem', textAlign: 'left' }}>Type décision</th>
                                <th style={{ padding: '0.75rem', textAlign: 'center' }}>Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            {purchases.map((purchase, i) => {
                                const serviceInfo = getServiceInfo(purchase.service_type);
                                return (
                                    <tr key={purchase.id} style={{ borderBottom: '1px solid var(--border-color)', background: i % 2 === 0 ? 'transparent' : 'rgba(0,0,0,0.02)' }}>
                                        <td style={{ padding: '0.75rem' }}>{formatDate(purchase.created_at)}</td>
                                        <td style={{ padding: '0.75rem' }}>
                                            <span style={{
                                                padding: '0.25rem 0.5rem',
                                                borderRadius: '4px',
                                                background: serviceInfo.color,
                                                color: 'white',
                                                fontSize: '0.85rem'
                                            }}>
                                                {serviceInfo.icon} {serviceInfo.label}
                                            </span>
                                        </td>
                                        <td style={{ padding: '0.75rem' }}>
                                            {purchase.user_firstname || '-'}
                                            <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                                                {purchase.user_id.substring(0, 8)}...
                                            </div>
                                        </td>
                                        <td style={{ padding: '0.75rem' }}>{purchase.user_birthdate}</td>
                                        <td style={{ padding: '0.75rem' }}>{purchase.consultation_date || '-'}</td>
                                        <td style={{ padding: '0.75rem' }}>{getDecisionLabel(purchase.decision_type_id)}</td>
                                        <td style={{ padding: '0.75rem', textAlign: 'center' }}>
                                            <span style={{
                                                padding: '0.25rem 0.5rem',
                                                borderRadius: '4px',
                                                background: purchase.status === 'completed' ? '#10b981' : '#f59e0b',
                                                color: 'white',
                                                fontSize: '0.8rem'
                                            }}>
                                                {purchase.status}
                                            </span>
                                            {purchase.expires_at && (
                                                <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: '0.25rem' }}>
                                                    Expire: {new Date(purchase.expires_at).toLocaleDateString('fr-FR')}
                                                </div>
                                            )}
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            )}
        </div>
    );
}
