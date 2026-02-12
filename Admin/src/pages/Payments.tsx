import { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';

const SERVICE_LABELS: Record<string, { emoji: string; label: string }> = {
    'consultation': { emoji: '💑', label: 'Compatibilité' },
    'portrait_ame': { emoji: '✨', label: 'Portrait Âme' },
    'annee': { emoji: '📆', label: 'Prévision An' },
    'mois': { emoji: '📅', label: 'Prévision Mois' },
    'jour': { emoji: '📌', label: 'Prévision Jour' },
    'personal_cycle_annual': { emoji: '🔄', label: 'Cycle Perso' },
    'business_cycle_annual': { emoji: '💼', label: 'Cycle Business' },
    'health_cycle_annual': { emoji: '🏥', label: 'Cycle Santé' },
    'decision_credits': { emoji: '💡', label: 'Crédits' },
    'daily_guide_day': { emoji: '⏰', label: 'Guide Horaire' },
    'life_phase_report': { emoji: '🔮', label: 'Phases de Vie' },
    'lunar_timing_monthly': { emoji: '🌙', label: 'Timing Lunaire' },
};

type Payment = {
    id: string;
    user_id: string | null;
    session_id: string | null;
    transaction_id: string;
    amount_fcfa: number;
    payment_method: string | null;
    status: 'pending' | 'success' | 'failed' | 'cancelled';
    plan_type: string;
    created_at: string;
    notes: string | null;
    user_email?: string;
    user_name?: string;
};

export default function Payments() {
    const [payments, setPayments] = useState<Payment[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'success' | 'pending' | 'failed'>('all');
    const [dateRange, setDateRange] = useState({ from: '', to: '' });

    useEffect(() => {
        loadPayments();
    }, []);

    async function loadPayments() {
        setLoading(true);
        try {
            // Query payments (no JOIN with obsolete users table)
            const { data, error } = await supabase
                .from('payments')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(200);

            if (error) throw error;

            // Resolve user emails/names from auth.admin
            let userMap = new Map<string, { email: string; name: string | null }>();
            try {
                const { data: authData } = await supabase.auth.admin.listUsers({ perPage: 1000 });
                authData?.users?.forEach(u => {
                    userMap.set(u.id, {
                        email: u.email || '',
                        name: u.user_metadata?.name || u.user_metadata?.display_name || null,
                    });
                });
            } catch {
                // Fallback: try users table
                const userIds = [...new Set((data || []).map((p: any) => p.user_id).filter(Boolean))];
                if (userIds.length > 0) {
                    const { data: users } = await supabase
                        .from('users')
                        .select('id, email, name, display_name')
                        .in('id', userIds);
                    users?.forEach((u: any) => {
                        userMap.set(u.id, { email: u.email, name: u.name || u.display_name || null });
                    });
                }
            }

            // Enrich payments with user info
            const enriched = (data || []).map((p: any) => {
                const user = p.user_id ? userMap.get(p.user_id) : null;
                return {
                    ...p,
                    user_email: user?.email || null,
                    user_name: user?.name || null,
                };
            });

            setPayments(enriched as Payment[]);
        } catch (e) {
            console.error('Payments load error:', e);
            setPayments([]);
        }
        setLoading(false);
    }

    async function updatePaymentStatus(payment: Payment, newStatus: Payment['status']) {
        if (!confirm(`Changer le statut vers "${newStatus}" ?`)) return;

        try {
            const { error } = await supabase
                .from('payments')
                .update({ status: newStatus })
                .eq('id', payment.id);

            if (error) throw error;
            loadPayments();
        } catch (e) {
            console.error('Update status error:', e);
        }
    }

    const filteredPayments = payments.filter((p) => {
        // Filter by status
        if (filter !== 'all' && p.status !== filter) return false;

        // Filter by date
        if (dateRange.from) {
            const paymentDate = new Date(p.created_at);
            const fromDate = new Date(dateRange.from);
            if (paymentDate < fromDate) return false;
        }
        if (dateRange.to) {
            const paymentDate = new Date(p.created_at);
            const toDate = new Date(dateRange.to);
            toDate.setHours(23, 59, 59);
            if (paymentDate > toDate) return false;
        }

        return true;
    });

    const stats = {
        total: payments.length,
        success: payments.filter(p => p.status === 'success').length,
        pending: payments.filter(p => p.status === 'pending').length,
        failed: payments.filter(p => p.status === 'failed').length,
        revenue: payments
            .filter(p => p.status === 'success')
            .reduce((sum, p) => sum + p.amount_fcfa, 0),
    };

    function exportCSV() {
        const headers = ['ID', 'Date', 'Transaction', 'Montant FCFA', 'Méthode', 'Statut', 'Type'];
        const rows = filteredPayments.map(p => [
            p.id,
            new Date(p.created_at).toLocaleString('fr-FR'),
            p.transaction_id,
            p.amount_fcfa,
            p.payment_method || '-',
            p.status,
            p.plan_type,
        ]);

        const csv = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `paiements_${new Date().toISOString().split('T')[0]}.csv`;
        a.click();
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page payments">
            <div className="page-header">
                <div>
                    <h2 className="page-title">Paiements</h2>
                    <p className="page-subtitle">Table: <code>payments</code> • {payments.length} transactions</p>
                </div>
                <button className="btn-primary" onClick={exportCSV}>
                    📥 Export CSV
                </button>
            </div>

            <div className="payments-summary">
                <div className="summary-stat">
                    <span className="stat-value">{stats.revenue.toLocaleString()} FCFA</span>
                    <span className="stat-label">Revenus (success)</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.success}</span>
                    <span className="stat-label">Réussis</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.pending}</span>
                    <span className="stat-label">En attente</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.failed}</span>
                    <span className="stat-label">Échoués</span>
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

                <div className="date-filters">
                    <input
                        type="date"
                        value={dateRange.from}
                        onChange={(e) => setDateRange({ ...dateRange, from: e.target.value })}
                        aria-label="Date de début"
                    />
                    <span>→</span>
                    <input
                        type="date"
                        value={dateRange.to}
                        onChange={(e) => setDateRange({ ...dateRange, to: e.target.value })}
                        aria-label="Date de fin"
                    />
                </div>
            </div>

            <div className="payments-list">
                {filteredPayments.length === 0 ? (
                    <div className="empty-state">Aucun paiement trouvé</div>
                ) : (
                    filteredPayments.map((payment) => (
                        <div key={payment.id} className="payment-card">
                            <div className="payment-info">
                                <div className="payment-user">
                                    {payment.user_email ? (
                                        <span className="user-email">📧 {payment.user_email}</span>
                                    ) : (
                                        <span className="user-anonymous muted">👤 Anonyme (session)</span>
                                    )}
                                    {payment.user_name && <span className="user-name"> • {payment.user_name}</span>}
                                </div>
                                <div className="payment-names">
                                    <code>{payment.transaction_id}</code>
                                </div>
                                <div className="payment-date">
                                    {new Date(payment.created_at).toLocaleString('fr-FR')} •{' '}
                                    {payment.payment_method || 'N/A'} •{' '}
                                    {SERVICE_LABELS[payment.plan_type]?.emoji || '📋'} {SERVICE_LABELS[payment.plan_type]?.label || payment.plan_type}
                                </div>
                            </div>
                            <div className="payment-amount">
                                {payment.amount_fcfa.toLocaleString()} FCFA
                            </div>
                            <div className={`payment-status status-${payment.status}`}>
                                {payment.status}
                            </div>
                            <div className="payment-actions-dropdown">
                                <select
                                    value=""
                                    onChange={(e) => {
                                        if (e.target.value) {
                                            updatePaymentStatus(payment, e.target.value as Payment['status']);
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
        </div>
    );
}
