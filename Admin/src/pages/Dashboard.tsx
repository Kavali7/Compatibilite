import { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';
import KPICard from '../components/KPICard';

interface ServiceStats {
    service: string;
    label: string;
    emoji: string;
    count: number;
    revenue: number;
}

interface RecentActivity {
    id: string;
    type: 'payment' | 'user' | 'session';
    description: string;
    timestamp: string;
    amount?: number;
}

interface TopClient {
    email: string;
    name: string | null;
    totalSpent: number;
    purchaseCount: number;
}

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
};

export default function Dashboard() {
    const [globalStats, setGlobalStats] = useState({
        totalRevenue: 0,
        totalPurchases: 0,
        totalUsers: 0,
        todayRevenue: 0,
    });
    const [serviceStats, setServiceStats] = useState<ServiceStats[]>([]);
    const [recentActivity, setRecentActivity] = useState<RecentActivity[]>([]);
    const [topClients, setTopClients] = useState<TopClient[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadDashboardData();
    }, []);

    async function loadDashboardData() {
        setLoading(true);
        try {
            await Promise.all([
                loadGlobalStats(),
                loadServiceStats(),
                loadRecentActivity(),
                loadTopClients(),
            ]);
        } catch (e) {
            console.error('Dashboard load error:', e);
        }
        setLoading(false);
    }

    async function loadGlobalStats() {
        // Get all payments
        const { data: payments } = await supabase
            .from('payments')
            .select('amount_fcfa, status, created_at')
            .eq('status', 'success');

        // Get users count
        const { count: usersCount } = await supabase
            .from('users')
            .select('id', { count: 'exact', head: true });

        const today = new Date().toISOString().split('T')[0];
        const todayPayments = payments?.filter(p => p.created_at.startsWith(today)) || [];

        setGlobalStats({
            totalRevenue: payments?.reduce((sum, p) => sum + (p.amount_fcfa || 0), 0) || 0,
            totalPurchases: payments?.length || 0,
            totalUsers: usersCount || 0,
            todayRevenue: todayPayments.reduce((sum, p) => sum + (p.amount_fcfa || 0), 0),
        });
    }

    async function loadServiceStats() {
        const { data: payments } = await supabase
            .from('payments')
            .select('plan_type, amount_fcfa')
            .eq('status', 'success');

        // Group by service
        const statsMap = new Map<string, { count: number; revenue: number }>();
        payments?.forEach(p => {
            const current = statsMap.get(p.plan_type) || { count: 0, revenue: 0 };
            statsMap.set(p.plan_type, {
                count: current.count + 1,
                revenue: current.revenue + (p.amount_fcfa || 0),
            });
        });

        const stats: ServiceStats[] = [];
        statsMap.forEach((value, key) => {
            const info = SERVICE_LABELS[key] || { emoji: '📋', label: key };
            stats.push({
                service: key,
                label: info.label,
                emoji: info.emoji,
                count: value.count,
                revenue: value.revenue,
            });
        });

        // Sort by revenue descending
        stats.sort((a, b) => b.revenue - a.revenue);
        setServiceStats(stats.slice(0, 6)); // Top 6 services
    }

    async function loadRecentActivity() {
        // Get recent payments
        const { data: payments } = await supabase
            .from('payments')
            .select('id, plan_type, amount_fcfa, status, created_at')
            .order('created_at', { ascending: false })
            .limit(10);

        const activities: RecentActivity[] = [];

        payments?.forEach(p => {
            const info = SERVICE_LABELS[p.plan_type] || { emoji: '📋', label: p.plan_type };
            activities.push({
                id: p.id,
                type: 'payment',
                description: `${info.emoji} ${p.status === 'success' ? 'Achat' : 'Tentative'}: ${info.label}`,
                timestamp: p.created_at,
                amount: p.amount_fcfa,
            });
        });

        setRecentActivity(activities.slice(0, 8));
    }

    async function loadTopClients() {
        const { data: payments } = await supabase
            .from('payments')
            .select('user_id, amount_fcfa')
            .eq('status', 'success');

        // Group by user
        const userStats = new Map<string, { total: number; count: number }>();
        payments?.forEach(p => {
            if (p.user_id) {
                const current = userStats.get(p.user_id) || { total: 0, count: 0 };
                userStats.set(p.user_id, {
                    total: current.total + (p.amount_fcfa || 0),
                    count: current.count + 1,
                });
            }
        });

        // Get top 5 user IDs
        const sorted = [...userStats.entries()]
            .sort((a, b) => b[1].total - a[1].total)
            .slice(0, 5);

        if (sorted.length === 0) {
            setTopClients([]);
            return;
        }

        // Fetch user details
        const userIds = sorted.map(([id]) => id);
        const { data: users } = await supabase
            .from('users')
            .select('id, email, name')
            .in('id', userIds);

        const userMap = new Map(users?.map(u => [u.id, u]) || []);

        const clients: TopClient[] = sorted.map(([id, stats]) => {
            const user = userMap.get(id);
            return {
                email: user?.email || 'N/A',
                name: user?.name || null,
                totalSpent: stats.total,
                purchaseCount: stats.count,
            };
        });

        setTopClients(clients);
    }

    function formatTime(timestamp: string): string {
        const date = new Date(timestamp);
        const now = new Date();
        const diff = now.getTime() - date.getTime();
        const minutes = Math.floor(diff / 60000);
        const hours = Math.floor(diff / 3600000);
        const days = Math.floor(diff / 86400000);

        if (minutes < 60) return `Il y a ${minutes}m`;
        if (hours < 24) return `Il y a ${hours}h`;
        if (days < 7) return `Il y a ${days}j`;
        return date.toLocaleDateString('fr-FR');
    }

    if (loading) {
        return <div className="page-loading">Chargement du tableau de bord...</div>;
    }

    return (
        <div className="page dashboard">
            <h2 className="page-title">📊 Tableau de Bord</h2>
            <p className="page-subtitle muted">Vue d'ensemble de l'activité Kbal</p>

            {/* Global KPIs */}
            <div className="kpi-grid">
                <KPICard
                    icon="💰"
                    label="Revenus Totaux"
                    value={`${globalStats.totalRevenue.toLocaleString('fr-FR')} FCFA`}
                />
                <KPICard
                    icon="🛒"
                    label="Achats Totaux"
                    value={globalStats.totalPurchases}
                />
                <KPICard
                    icon="👥"
                    label="Utilisateurs"
                    value={globalStats.totalUsers}
                />
                <KPICard
                    icon="📅"
                    label="Revenus Aujourd'hui"
                    value={`${globalStats.todayRevenue.toLocaleString('fr-FR')} FCFA`}
                />
            </div>

            {/* Service Stats */}
            {serviceStats.length > 0 && (
                <div className="dashboard-section">
                    <h3>📈 Top Services</h3>
                    <div className="service-stats-grid">
                        {serviceStats.map(stat => (
                            <div key={stat.service} className="service-stat-card">
                                <span className="service-emoji">{stat.emoji}</span>
                                <div className="service-stat-info">
                                    <span className="service-stat-label">{stat.label}</span>
                                    <span className="service-stat-count">{stat.count} ventes</span>
                                </div>
                                <span className="service-stat-revenue">
                                    {stat.revenue.toLocaleString('fr-FR')} FCFA
                                </span>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            <div className="dashboard-columns">
                {/* Recent Activity */}
                <div className="dashboard-section">
                    <h3>⚡ Activité Récente</h3>
                    {recentActivity.length === 0 ? (
                        <p className="muted">Aucune activité récente</p>
                    ) : (
                        <div className="activity-feed">
                            {recentActivity.map(activity => (
                                <div key={activity.id} className="activity-item">
                                    <div className="activity-info">
                                        <span className="activity-desc">{activity.description}</span>
                                        <span className="activity-time">{formatTime(activity.timestamp)}</span>
                                    </div>
                                    {activity.amount !== undefined && (
                                        <span className="activity-amount">
                                            {activity.amount.toLocaleString('fr-FR')} F
                                        </span>
                                    )}
                                </div>
                            ))}
                        </div>
                    )}
                </div>

                {/* Top Clients */}
                <div className="dashboard-section">
                    <h3>🏆 Meilleurs Clients</h3>
                    {topClients.length === 0 ? (
                        <p className="muted">Pas encore de données clients</p>
                    ) : (
                        <div className="top-clients-list">
                            {topClients.map((client, idx) => (
                                <div key={client.email} className="client-row">
                                    <span className="client-rank">#{idx + 1}</span>
                                    <div className="client-info">
                                        <span className="client-name">{client.name || client.email}</span>
                                        <span className="client-purchases">{client.purchaseCount} achats</span>
                                    </div>
                                    <span className="client-total">
                                        {client.totalSpent.toLocaleString('fr-FR')} F
                                    </span>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>

            <style>{`
                .dashboard .page-subtitle {
                    margin-bottom: 24px;
                }
                .service-stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 12px;
                    margin-top: 16px;
                }
                .service-stat-card {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 16px;
                    background: rgba(255,255,255,0.03);
                    border-radius: 12px;
                    border: 1px solid rgba(255,255,255,0.08);
                }
                .service-emoji {
                    font-size: 24px;
                }
                .service-stat-info {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                }
                .service-stat-label {
                    font-weight: 600;
                    font-size: 14px;
                }
                .service-stat-count {
                    font-size: 12px;
                    color: #888;
                }
                .service-stat-revenue {
                    font-weight: 700;
                    color: #22c55e;
                    font-size: 14px;
                }
                .dashboard-columns {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 24px;
                    margin-top: 24px;
                }
                .dashboard-section {
                    background: rgba(255,255,255,0.02);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                    padding: 20px;
                }
                .dashboard-section h3 {
                    margin: 0 0 16px 0;
                    font-size: 16px;
                }
                .activity-feed {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .activity-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 10px 12px;
                    background: rgba(255,255,255,0.03);
                    border-radius: 8px;
                }
                .activity-info {
                    display: flex;
                    flex-direction: column;
                }
                .activity-desc {
                    font-size: 13px;
                }
                .activity-time {
                    font-size: 11px;
                    color: #666;
                }
                .activity-amount {
                    font-weight: 600;
                    color: #667eea;
                    font-size: 13px;
                }
                .top-clients-list {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .client-row {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 10px 12px;
                    background: rgba(255,255,255,0.03);
                    border-radius: 8px;
                }
                .client-rank {
                    font-weight: 700;
                    color: #f59e0b;
                    width: 28px;
                }
                .client-info {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                }
                .client-name {
                    font-size: 13px;
                    font-weight: 500;
                }
                .client-purchases {
                    font-size: 11px;
                    color: #666;
                }
                .client-total {
                    font-weight: 600;
                    color: #22c55e;
                    font-size: 13px;
                }
                @media (max-width: 768px) {
                    .dashboard-columns {
                        grid-template-columns: 1fr;
                    }
                    .service-stats-grid {
                        grid-template-columns: 1fr;
                    }
                }
            `}</style>
        </div>
    );
}
