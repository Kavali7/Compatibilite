import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

type TemporalPurchase = {
    id: string;
    user_id: string;
    purchase_type: 'year' | 'month' | 'day' | 'range';
    start_date: string;
    end_date: string;
    bonus_year: boolean;
    bonus_month: boolean;
    bonus_day: boolean;
    amount_fcfa: number;
    payment_status: 'pending' | 'success' | 'failed' | 'cancelled';
    transaction_id: string | null;
    created_at: string;
};

export default function TemporalPurchases() {
    const [purchases, setPurchases] = useState<TemporalPurchase[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'success' | 'pending' | 'failed'>('all');
    const [typeFilter, setTypeFilter] = useState<'all' | 'year' | 'month' | 'day'>('all');

    useEffect(() => {
        loadPurchases();
    }, []);

    async function loadPurchases() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('temporal_purchases')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(200);

            if (error) throw error;
            setPurchases((data as TemporalPurchase[]) || []);
        } catch (e) {
            console.error('Load temporal_purchases error:', e);
            setPurchases([]);
        }
        setLoading(false);
    }

    async function updateStatus(purchase: TemporalPurchase, newStatus: TemporalPurchase['payment_status']) {
        if (!confirm(`Changer le statut vers "${newStatus}" ?`)) return;

        try {
            const { error } = await supabase
                .from('temporal_purchases')
                .update({ payment_status: newStatus })
                .eq('id', purchase.id);

            if (error) throw error;
            loadPurchases();
        } catch (e) {
            console.error('Update status error:', e);
        }
    }

    const filteredPurchases = purchases.filter((p) => {
        if (filter !== 'all' && p.payment_status !== filter) return false;
        if (typeFilter !== 'all' && p.purchase_type !== typeFilter) return false;
        return true;
    });

    const stats = {
        total: purchases.length,
        success: purchases.filter(p => p.payment_status === 'success').length,
        pending: purchases.filter(p => p.payment_status === 'pending').length,
        failed: purchases.filter(p => p.payment_status === 'failed').length,
        revenue: purchases
            .filter(p => p.payment_status === 'success')
            .reduce((sum, p) => sum + p.amount_fcfa, 0),
        byType: {
            year: purchases.filter(p => p.purchase_type === 'year' && p.payment_status === 'success').length,
            month: purchases.filter(p => p.purchase_type === 'month' && p.payment_status === 'success').length,
            day: purchases.filter(p => p.purchase_type === 'day' && p.payment_status === 'success').length,
        }
    };

    function formatDate(dateStr: string) {
        const date = new Date(dateStr);
        return date.toLocaleDateString('fr-FR');
    }

    function formatPurchaseType(type: string) {
        switch (type) {
            case 'year': return '📆 Année';
            case 'month': return '📅 Mois';
            case 'day': return '📌 Jour';
            case 'range': return '📊 Plage';
            default: return type;
        }
    }

    function exportCSV() {
        const headers = ['ID', 'Date', 'Type', 'Période', 'Montant FCFA', 'Statut', 'Transaction', 'Bonus'];
        const rows = filteredPurchases.map(p => [
            p.id,
            new Date(p.created_at).toLocaleString('fr-FR'),
            p.purchase_type,
            `${p.start_date} → ${p.end_date}`,
            p.amount_fcfa,
            p.payment_status,
            p.transaction_id || '-',
            [
                p.bonus_year ? 'Année' : '',
                p.bonus_month ? 'Mois' : '',
                p.bonus_day ? 'Jour' : ''
            ].filter(Boolean).join('+') || 'Aucun',
        ]);

        const csv = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `previsions_temporelles_${new Date().toISOString().split('T')[0]}.csv`;
        a.click();
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page temporal-purchases">
            <div className="page-header">
                <div>
                    <h2 className="page-title">Prévisions Temporelles</h2>
                    <p className="page-subtitle">Table: <code>temporal_purchases</code> • {purchases.length} achats</p>
                </div>
                <button className="btn-primary" onClick={exportCSV}>
                    📥 Export CSV
                </button>
            </div>

            <div className="payments-summary">
                <div className="summary-stat">
                    <span className="stat-value">{stats.revenue.toLocaleString()} FCFA</span>
                    <span className="stat-label">Revenus prévisions</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.byType.year}</span>
                    <span className="stat-label">📆 Années</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.byType.month}</span>
                    <span className="stat-label">📅 Mois</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.byType.day}</span>
                    <span className="stat-label">📌 Jours</span>
                </div>
            </div>

            <div className="filter-bar">
                <button
                    className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
                    onClick={() => setFilter('all')}
                >
                    Tous ({stats.total})
                </button>
                <button
                    className={`filter-btn ${filter === 'success' ? 'active' : ''}`}
                    onClick={() => setFilter('success')}
                >
                    ✅ Réussis ({stats.success})
                </button>
                <button
                    className={`filter-btn ${filter === 'pending' ? 'active' : ''}`}
                    onClick={() => setFilter('pending')}
                >
                    ⏳ En attente ({stats.pending})
                </button>
                <button
                    className={`filter-btn ${filter === 'failed' ? 'active' : ''}`}
                    onClick={() => setFilter('failed')}
                >
                    ❌ Échoués ({stats.failed})
                </button>

                <div className="type-filters" style={{ marginLeft: 'auto' }}>
                    <select
                        value={typeFilter}
                        onChange={(e) => setTypeFilter(e.target.value as any)}
                        aria-label="Filtrer par type"
                    >
                        <option value="all">Tous types</option>
                        <option value="year">📆 Année</option>
                        <option value="month">📅 Mois</option>
                        <option value="day">📌 Jour</option>
                    </select>
                </div>
            </div>

            <div className="payments-list">
                {filteredPurchases.length === 0 ? (
                    <div className="empty-state">Aucun achat de prévision trouvé</div>
                ) : (
                    filteredPurchases.map((purchase) => (
                        <div key={purchase.id} className="payment-card">
                            <div className="payment-info">
                                <div className="payment-names">
                                    <span style={{ marginRight: '12px' }}>
                                        {formatPurchaseType(purchase.purchase_type)}
                                    </span>
                                    <strong>
                                        {formatDate(purchase.start_date)}
                                        {purchase.start_date !== purchase.end_date &&
                                            ` → ${formatDate(purchase.end_date)}`
                                        }
                                    </strong>
                                </div>
                                <div className="payment-date">
                                    {new Date(purchase.created_at).toLocaleString('fr-FR')}
                                    {purchase.transaction_id && (
                                        <> • <code>{purchase.transaction_id.slice(0, 12)}...</code></>
                                    )}
                                </div>
                                {(purchase.bonus_year || purchase.bonus_month || purchase.bonus_day) && (
                                    <div className="bonus-tags" style={{ marginTop: '4px' }}>
                                        <span style={{ fontSize: '12px', color: '#888' }}>Bonus: </span>
                                        {purchase.bonus_year && <span className="bonus-tag">+Année</span>}
                                        {purchase.bonus_month && <span className="bonus-tag">+Mois</span>}
                                        {purchase.bonus_day && <span className="bonus-tag">+Jour</span>}
                                    </div>
                                )}
                            </div>
                            <div className="payment-amount">
                                {purchase.amount_fcfa.toLocaleString()} FCFA
                            </div>
                            <div className={`payment-status status-${purchase.payment_status}`}>
                                {purchase.payment_status}
                            </div>
                            <div className="payment-actions-dropdown">
                                <select
                                    value=""
                                    onChange={(e) => {
                                        if (e.target.value) {
                                            updateStatus(purchase, e.target.value as TemporalPurchase['payment_status']);
                                        }
                                    }}
                                    aria-label="Changer le statut"
                                >
                                    <option value="">Changer...</option>
                                    <option value="success">✅ Success</option>
                                    <option value="pending">⏳ Pending</option>
                                    <option value="failed">❌ Failed</option>
                                    <option value="cancelled">🚫 Cancelled</option>
                                </select>
                            </div>
                        </div>
                    ))
                )}
            </div>

            <style>{`
                .bonus-tags {
                    display: flex;
                    gap: 6px;
                    align-items: center;
                }
                .bonus-tag {
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    color: white;
                    padding: 2px 8px;
                    border-radius: 12px;
                    font-size: 11px;
                    font-weight: 500;
                }
            `}</style>
        </div>
    );
}
