import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type ActivityEntry = {
    id: string;
    type: 'compatibility' | 'payment' | 'subscription';
    user_email: string;
    user_name: string | null;
    service: string;
    service_label: string;
    details: string;
    amount_fcfa: number | null;
    status: string;
    created_at: string;
};

const SERVICE_LABELS: Record<string, { emoji: string; label: string }> = {
    'consultation': { emoji: '💑', label: 'Compatibilité' },
    'portrait_ame': { emoji: '✨', label: 'Portrait de l\'Âme' },
    'annee': { emoji: '📆', label: 'Prévision Annuelle' },
    'mois': { emoji: '📅', label: 'Prévision Mensuelle' },
    'jour': { emoji: '📌', label: 'Prévision Journalière' },
    'personal_cycle_annual': { emoji: '🔄', label: 'Cycle Personnel' },
    'business_cycle_annual': { emoji: '💼', label: 'Cycle Business' },
    'health_cycle_annual': { emoji: '🏥', label: 'Cycle Santé' },
    'daily_guide_day': { emoji: '⏰', label: 'Guide Horaire' },
    'decision_credits': { emoji: '💡', label: 'Crédits Décision' },
    'life_phase_report': { emoji: '🔮', label: 'Phases de Vie' },
    'lunar_timing_monthly': { emoji: '🌙', label: 'Timing Lunaire' },
};

export default function Sessions() {
    const [activities, setActivities] = useState<ActivityEntry[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filterService, setFilterService] = useState('');
    const [filterType, setFilterType] = useState('');
    const [timeRange, setTimeRange] = useState('7');

    useEffect(() => {
        loadActivities();
    }, [timeRange]);

    async function loadActivities() {
        setLoading(true);
        setError(null);

        try {
            const allActivities: ActivityEntry[] = [];
            const dateSince = new Date();
            dateSince.setDate(dateSince.getDate() - parseInt(timeRange));
            const dateStr = dateSince.toISOString();

            // 1. Compatibility sessions
            const { data: sessions } = await supabase
                .from('sessions_compatibilite')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false })
                .limit(100);

            sessions?.forEach(s => {
                allActivities.push({
                    id: `session_${s.id}`,
                    type: 'compatibility',
                    user_email: s.email_a || s.partenaire_a_nom || '',
                    user_name: s.partenaire_a_nom || null,
                    service: 'consultation',
                    service_label: '💑 Compatibilité',
                    details: `${s.partenaire_a_nom || '?'} ↔ ${s.partenaire_b_nom || '?'}`,
                    amount_fcfa: null,
                    status: 'completed',
                    created_at: s.created_at,
                });
            });

            // 2. Payments (all services)
            const { data: payments } = await supabase
                .from('payments')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false })
                .limit(200);

            // Build user email cache from auth admin
            const userIds = [...new Set(payments?.map(p => p.user_id).filter(Boolean) || [])];
            const userMap = new Map<string, { email: string; name: string | null }>();

            if (userIds.length > 0) {
                // Try to batch resolve
                const { data: authData } = await supabase.auth.admin.listUsers({ perPage: 1000 });
                authData?.users?.forEach(u => {
                    userMap.set(u.id, {
                        email: u.email || '',
                        name: u.user_metadata?.name || u.user_metadata?.display_name || null,
                    });
                });
            }

            payments?.forEach(p => {
                const sl = SERVICE_LABELS[p.plan_type] || { emoji: '📦', label: p.plan_type };
                const user = userMap.get(p.user_id) || { email: p.user_id?.substring(0, 8) + '...', name: null };

                allActivities.push({
                    id: `payment_${p.id}`,
                    type: 'payment',
                    user_email: user.email,
                    user_name: user.name,
                    service: p.plan_type || 'unknown',
                    service_label: `${sl.emoji} ${sl.label}`,
                    details: p.notes || `Paiement ${p.payment_method || ''}`,
                    amount_fcfa: p.amount_fcfa,
                    status: p.status || 'unknown',
                    created_at: p.created_at,
                });
            });

            // 3. Subscriptions: personal cycle
            const { data: personalSubs } = await supabase
                .from('personal_cycle_subscriptions')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false });

            personalSubs?.forEach(s => {
                const user = userMap.get(s.user_id);
                allActivities.push({
                    id: `sub_personal_${s.id}`,
                    type: 'subscription',
                    user_email: user?.email || s.user_firstname || '',
                    user_name: user?.name || s.user_firstname || null,
                    service: 'personal_cycle_annual',
                    service_label: '🔄 Cycle Personnel',
                    details: `Abonnement ${s.status} (${s.start_date} → ${s.end_date})`,
                    amount_fcfa: null,
                    status: s.status || 'active',
                    created_at: s.created_at,
                });
            });

            // 4. Subscriptions: business cycle
            const { data: businessSubs } = await supabase
                .from('business_cycle_subscriptions')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false });

            businessSubs?.forEach(s => {
                const user = userMap.get(s.user_id);
                allActivities.push({
                    id: `sub_business_${s.id}`,
                    type: 'subscription',
                    user_email: user?.email || '',
                    user_name: user?.name || s.company_name || null,
                    service: 'business_cycle_annual',
                    service_label: '💼 Cycle Business',
                    details: `${s.company_name || 'Entreprise'} — ${s.status}`,
                    amount_fcfa: null,
                    status: s.status || 'active',
                    created_at: s.created_at,
                });
            });

            // 5. Subscriptions: health cycle
            const { data: healthSubs } = await supabase
                .from('health_cycle_subscriptions')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false });

            healthSubs?.forEach(s => {
                const user = userMap.get(s.user_id);
                allActivities.push({
                    id: `sub_health_${s.id}`,
                    type: 'subscription',
                    user_email: user?.email || '',
                    user_name: user?.name || s.user_name || null,
                    service: 'health_cycle_annual',
                    service_label: '🏥 Cycle Santé',
                    details: `Abonnement ${s.status}`,
                    amount_fcfa: null,
                    status: s.status || 'active',
                    created_at: s.created_at,
                });
            });

            // 6. Subscriptions: lunar
            const { data: lunarSubs } = await supabase
                .from('lunar_subscriptions')
                .select('*')
                .gte('created_at', dateStr)
                .order('created_at', { ascending: false });

            lunarSubs?.forEach(s => {
                const user = userMap.get(s.user_id);
                allActivities.push({
                    id: `sub_lunar_${s.id}`,
                    type: 'subscription',
                    user_email: user?.email || '',
                    user_name: user?.name || null,
                    service: 'lunar_timing_monthly',
                    service_label: '🌙 Timing Lunaire',
                    details: `Abonnement ${s.status}`,
                    amount_fcfa: null,
                    status: s.status || 'active',
                    created_at: s.created_at,
                });
            });

            // 7. Life phase purchases
            const { data: lifePhasePurchases } = await supabase
                .from('life_phase_purchases')
                .select('*')
                .gte('purchase_date', dateStr)
                .order('purchase_date', { ascending: false });

            lifePhasePurchases?.forEach(p => {
                const user = userMap.get(p.user_id);
                allActivities.push({
                    id: `life_phase_${p.id}`,
                    type: 'payment',
                    user_email: user?.email || '',
                    user_name: user?.name || null,
                    service: 'life_phase_report',
                    service_label: '🔮 Phases de Vie',
                    details: `Rapport acheté`,
                    amount_fcfa: null,
                    status: 'completed',
                    created_at: p.purchase_date,
                });
            });

            // Sort all by date
            allActivities.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

            setActivities(allActivities);
        } catch (e: any) {
            console.error('Activities load error:', e);
            setError(e.message || 'Erreur au chargement');
        }
        setLoading(false);
    }

    const filteredActivities = activities.filter(a => {
        if (filterService && a.service !== filterService) return false;
        if (filterType && a.type !== filterType) return false;
        return true;
    });

    const stats = {
        total: activities.length,
        payments: activities.filter(a => a.type === 'payment').length,
        sessions: activities.filter(a => a.type === 'compatibility').length,
        subscriptions: activities.filter(a => a.type === 'subscription').length,
        totalRevenue: activities.filter(a => a.amount_fcfa).reduce((sum, a) => sum + (a.amount_fcfa || 0), 0),
    };

    // Get unique services for filter
    const servicesList = [...new Set(activities.map(a => a.service))];

    function formatDateTime(dateStr: string) {
        const d = new Date(dateStr);
        return d.toLocaleDateString('fr-FR', {
            day: '2-digit', month: '2-digit', year: '2-digit',
            hour: '2-digit', minute: '2-digit',
        });
    }

    function typeIcon(type: string) {
        switch (type) {
            case 'compatibility': return '💑';
            case 'payment': return '💰';
            case 'subscription': return '📋';
            default: return '📌';
        }
    }

    if (loading) {
        return <div className="loading-message">Chargement de l'activité...</div>;
    }

    return (
        <div className="page sessions-activity">
            <div className="page-header">
                <div>
                    <h2 className="page-title">📊 Activité & Sessions</h2>
                    <p className="page-subtitle">
                        Toutes les sessions, paiements et abonnements — Tous services confondus
                    </p>
                </div>
                <button className="btn-primary" onClick={loadActivities}>🔄 Rafraîchir</button>
            </div>

            {error && (
                <div className="error-banner">{error}</div>
            )}

            {/* Stats */}
            <div className="stat-grid">
                <div className="stat-card">
                    <div className="stat-card__value stat-card__value--primary">{stats.total}</div>
                    <div className="stat-card__label--small">Activités</div>
                </div>
                <div className="stat-card">
                    <div className="stat-card__value stat-card__value--success">{stats.payments}</div>
                    <div className="stat-card__label--small">Paiements</div>
                </div>
                <div className="stat-card">
                    <div className="stat-card__value stat-card__value--warning">{stats.sessions}</div>
                    <div className="stat-card__label--small">Sessions</div>
                </div>
                <div className="stat-card">
                    <div className="stat-card__value stat-card__value--purple">{stats.subscriptions}</div>
                    <div className="stat-card__label--small">Abonnements</div>
                </div>
                {stats.totalRevenue > 0 && (
                    <div className="stat-card stat-card--wide">
                        <div className="stat-card__value stat-card__value--success">{stats.totalRevenue.toLocaleString('fr-FR')}</div>
                        <div className="stat-card__label--small">FCFA Période</div>
                    </div>
                )}
            </div>

            {/* Filters */}
            <div className="session-filter-bar">
                <select
                    value={timeRange}
                    onChange={e => setTimeRange(e.target.value)}
                    className="session-filter-select"
                    title="Période"
                >
                    <option value="1">24 heures</option>
                    <option value="7">7 jours</option>
                    <option value="30">30 jours</option>
                    <option value="90">90 jours</option>
                    <option value="365">1 an</option>
                </select>
                <select
                    value={filterType}
                    onChange={e => setFilterType(e.target.value)}
                    className="session-filter-select"
                    title="Type d'activité"
                >
                    <option value="">Tous les types</option>
                    <option value="payment">💰 Paiements</option>
                    <option value="compatibility">💑 Sessions Compatibilité</option>
                    <option value="subscription">📋 Abonnements</option>
                </select>
                <select
                    value={filterService}
                    onChange={e => setFilterService(e.target.value)}
                    className="session-filter-select"
                    title="Service"
                >
                    <option value="">Tous les services</option>
                    {servicesList.map(s => {
                        const sl = SERVICE_LABELS[s];
                        return <option key={s} value={s}>{sl ? `${sl.emoji} ${sl.label}` : s}</option>;
                    })}
                </select>
            </div>

            {/* Activity feed */}
            <div className="activity-feed">
                {filteredActivities.length === 0 ? (
                    <div className="empty-state">
                        Aucune activité pour cette période
                    </div>
                ) : (
                    filteredActivities.map(activity => (
                        <div key={activity.id} className="activity-item">
                            <span className="activity-item__icon">{typeIcon(activity.type)}</span>
                            <div className="activity-item__content">
                                <div className="activity-item__header">
                                    <span className="activity-item__name">
                                        {activity.user_name || activity.user_email}
                                    </span>
                                    <span className="activity-service-badge">
                                        {activity.service_label}
                                    </span>
                                    <span
                                        className={`activity-status-badge activity-status-badge--${activity.status}`}
                                    >
                                        {activity.status}
                                    </span>
                                </div>
                                <div className="activity-item__details">
                                    {activity.details}
                                </div>
                            </div>
                            {activity.amount_fcfa != null && activity.amount_fcfa > 0 && (
                                <span className="activity-item__amount">
                                    {activity.amount_fcfa.toLocaleString('fr-FR')} FCFA
                                </span>
                            )}
                            <span className="activity-item__time">
                                {formatDateTime(activity.created_at)}
                            </span>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
}
