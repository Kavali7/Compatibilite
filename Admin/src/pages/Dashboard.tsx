import { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';
import KPICard from '../components/KPICard';

export default function Dashboard() {
    const [stats, setStats] = useState({
        totalSessions: 0,
        totalRevenue: 0,
        paidSessions: 0,
        todaySessions: 0,
    });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadStats();
    }, []);

    async function loadStats() {
        setLoading(true);
        try {
            // Get all sessions
            const { data: sessions, error } = await supabase
                .from('sessions_compatibilite')
                .select('id, statut_paiement, montant_centimes, created_at');

            if (error) throw error;

            const today = new Date().toISOString().split('T')[0];
            const todayCount = sessions?.filter((s) =>
                s.created_at.startsWith(today)
            ).length || 0;

            const paidSessions = sessions?.filter(
                (s) => s.statut_paiement === 'paid'
            ) || [];

            const totalRevenue = paidSessions.reduce(
                (sum, s) => sum + (s.montant_centimes || 0),
                0
            );

            setStats({
                totalSessions: sessions?.length || 0,
                totalRevenue: totalRevenue / 100,
                paidSessions: paidSessions.length,
                todaySessions: todayCount,
            });
        } catch (e) {
            console.error('Dashboard load error:', e);
        }
        setLoading(false);
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page dashboard">
            <h2 className="page-title">Dashboard</h2>

            <div className="kpi-grid">
                <KPICard
                    icon="📊"
                    label="Sessions totales"
                    value={stats.totalSessions}
                />
                <KPICard
                    icon="💰"
                    label="Revenus (FCFA)"
                    value={stats.totalRevenue.toLocaleString()}
                />
                <KPICard
                    icon="✅"
                    label="Sessions payées"
                    value={stats.paidSessions}
                />
                <KPICard
                    icon="📅"
                    label="Aujourd'hui"
                    value={stats.todaySessions}
                />
            </div>

            <div className="dashboard-section">
                <h3>Activité récente</h3>
                <p className="muted">Les dernières sessions seront affichées ici.</p>
            </div>
        </div>
    );
}
