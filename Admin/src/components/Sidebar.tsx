import { NavLink } from 'react-router-dom';
import { useProjet } from '../hooks/useProjet';

type SidebarProps = {
    collapsed: boolean;
    onToggle: () => void;
    mobileOpen?: boolean;
    onMobileClose?: () => void;
};

export default function Sidebar({ collapsed, onToggle, mobileOpen, onMobileClose }: SidebarProps) {
    const { currentProjet } = useProjet();

    const sections = [
        {
            title: null, // Main
            items: [
                { to: '/', icon: '📊', label: 'Dashboard' },
            ]
        },
        {
            title: 'Contenu',
            items: [
                { to: '/compatibilite/interpretations', icon: '📖', label: 'Interprétations' },
                { to: '/compatibilite/content-bricks', icon: '🧱', label: 'Briques Temporelles' },
                { to: '/compatibilite/canonical-predictions', icon: '🔮', label: 'Prédictions Canon' },
                { to: '/compatibilite/report-sections', icon: '📑', label: 'Structure Rapport' },
            ]
        },
        {
            title: '🌀 Cycles de Vie',
            items: [
                { to: '/cycles/soul-periods', icon: '🌟', label: 'Périodes Soul' },
                { to: '/cycles/daily-periods', icon: '⏰', label: 'Périodes Quotidiennes' },
                { to: '/cycles/decision-types', icon: '🎯', label: 'Types Décisions' },
                { to: '/cycles/decision-advice', icon: '💡', label: 'Conseils' },
                { to: '/cycles/purchases', icon: '📊', label: 'Achats Cycles' },
            ]
        },
        {
            title: 'Business',
            items: [
                { to: '/payments', icon: '💰', label: 'Paiements (Global)' },
                { to: '/pricing', icon: '🏷️', label: 'Tarifs Unifiés' },
                { to: '/subscriptions', icon: '📋', label: 'Abonnements' },
                { to: '/compatibilite/promos', icon: '🎁', label: 'Codes Promo' },
            ]
        },
        {
            title: 'Suivi',
            items: [
                { to: '/users', icon: '👤', label: 'Utilisateurs' },
                { to: '/compatibilite/sessions', icon: '👥', label: 'Sessions' },
                { to: '/compatibilite/temporal-purchases', icon: '🛒', label: 'Achats Temporels' },
                { to: '/compatibilite/prospects', icon: '🎯', label: 'Prospects (Relances)' },
            ]
        },
        {
            title: 'Système',
            items: [
                { to: '/settings', icon: '⚙️', label: 'Paramètres' },
                { to: '/reports', icon: '📝', label: 'Config Rapports' },
                { to: '/legal', icon: '📜', label: 'Pages Légales' },
                { to: '/admin-users', icon: '👥', label: 'Gestion Admins' },
            ]
        }
    ];

    return (
        <aside
            className={`sidebar ${collapsed ? 'sidebar-collapsed' : ''} ${mobileOpen ? 'open' : ''}`}
            onClick={(e) => {
                // Close mobile menu when clicking a link
                if ((e.target as HTMLElement).closest('a')) {
                    onMobileClose?.();
                }
            }}
        >
            <div className="sidebar-header">
                <div className="sidebar-logo">
                    {!collapsed && <span className="logo-text">🔷 GROWPEAK</span>}
                    {collapsed && <span className="logo-icon">🔷</span>}
                </div>
                <button className="sidebar-toggle" onClick={onToggle}>
                    {collapsed ? '→' : '←'}
                </button>
            </div>

            <nav className="sidebar-nav">
                {sections.map((section, idx) => (
                    <div key={idx} className="sidebar-section">
                        {section.title && !collapsed && (
                            <div className="sidebar-section-title">{section.title}</div>
                        )}
                        {section.items.map((item) => (
                            <NavLink
                                key={item.to}
                                to={item.to}
                                end={item.to === '/'}
                                className={({ isActive }) =>
                                    `sidebar-link ${isActive ? 'active' : ''}`
                                }
                                title={collapsed ? item.label : undefined}
                            >
                                <span className="sidebar-icon">{item.icon}</span>
                                {!collapsed && <span className="sidebar-label">{item.label}</span>}
                            </NavLink>
                        ))}
                    </div>
                ))}
            </nav>

            {currentProjet && !collapsed && (
                <div className="sidebar-footer">
                    <div className="current-projet">
                        <span className="projet-badge">{currentProjet.nom}</span>
                    </div>
                </div>
            )}
        </aside>
    );
}
