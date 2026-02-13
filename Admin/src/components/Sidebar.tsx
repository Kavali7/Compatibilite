import { NavLink } from 'react-router-dom';

interface SidebarProps {
    collapsed: boolean;
    onToggle: () => void;
    mobileOpen: boolean;
    onMobileClose: () => void;
}

type MenuItem = {
    path: string;
    label: string;
    icon: string;
};

type MenuSection = {
    title: string;
    items: MenuItem[];
};

const MENU_SECTIONS: MenuSection[] = [
    {
        title: '📊 Tableau de Bord',
        items: [
            { path: '/', label: 'Dashboard', icon: '📊' },
        ],
    },
    {
        title: '👥 Clients & CRM',
        items: [
            { path: '/users', label: 'Utilisateurs', icon: '👥' },
            { path: '/compatibilite/prospects', label: 'Prospects (CRM)', icon: '🎯' },
            { path: '/compatibilite/sessions', label: 'Activité & Sessions', icon: '📋' },
        ],
    },
    {
        title: '💰 Finance',
        items: [
            { path: '/payments', label: 'Paiements (Global)', icon: '💳' },
            { path: '/compatibilite/promos', label: 'Codes Promo', icon: '🏷️' },
            { path: '/cycles/pricing', label: 'Tarification Cycles', icon: '💲' },
            { path: '/cycles/credit-packs', label: 'Packs de Crédits', icon: '📦' },
            { path: '/cycles/user-credits', label: 'Crédits Utilisateurs', icon: '💳' },
        ],
    },
    {
        title: '💑 Contenu — Compatibilité',
        items: [
            { path: '/compatibilite', label: 'Vue d\'ensemble', icon: '💑' },
            { path: '/compatibilite/interpretations', label: 'Interprétations', icon: '📝' },
            { path: '/compatibilite/content-bricks', label: 'Briques de Contenu', icon: '🧱' },
            { path: '/compatibilite/canonical-predictions', label: 'Prédictions Canon', icon: '📜' },
            { path: '/compatibilite/report-sections', label: 'Sections de Rapport', icon: '📄' },
            { path: '/compatibilite/text-type-settings', label: 'Types de Texte', icon: '⚙️' },
            { path: '/compatibilite/temporal-purchases', label: 'Prévisions Temporelles', icon: '🔮' },
            { path: '/compatibilite/pricing', label: 'Tarification', icon: '💲' },
        ],
    },
    {
        title: '🔄 Contenu — Cycles de Vie',
        items: [
            { path: '/cycles/soul-periods', label: 'Portrait de l\'Âme', icon: '✨' },
            { path: '/cycles/personal-cycle', label: 'Cycle Personnel', icon: '🔄' },
            { path: '/cycles/business-cycle', label: 'Cycle Business', icon: '💼' },
            { path: '/cycles/health-cycle', label: 'Cycle Santé', icon: '🏥' },
            { path: '/cycles/daily-periods', label: 'Guide Horaire', icon: '⏰' },
            { path: '/cycles/decision-types', label: 'Types de Décision', icon: '🧭' },
            { path: '/cycles/decision-advice', label: 'Conseils Décision', icon: '💡' },
        ],
    },
    {
        title: '🌙 Contenu — Complémentaires',
        items: [
            { path: '/cycles/life-phases', label: 'Phases de Vie', icon: '🔮' },
            { path: '/cycles/lunar-phases', label: 'Timing Lunaire', icon: '🌙' },
        ],
    },
    {
        title: '⚙️ Système',
        items: [
            { path: '/settings', label: 'Paramètres', icon: '⚙️' },
            { path: '/compatibilite/social-proof', label: 'Preuve Sociale', icon: '📢' },
            { path: '/compatibilite/legal', label: 'Pages Légales', icon: '📃' },
            { path: '/cycles/purchases', label: 'Achats Cycles', icon: '🛒' },
        ],
    },
];

export default function Sidebar({ collapsed, onToggle, mobileOpen, onMobileClose }: SidebarProps) {
    return (
        <aside className={`sidebar ${collapsed ? 'collapsed' : ''} ${mobileOpen ? 'mobile-open' : ''}`}>
            <div className="sidebar-header">
                <h1 className="sidebar-title">{collapsed ? '🌟' : '🌟 Kbal Admin'}</h1>
                <button
                    className="sidebar-toggle"
                    onClick={onToggle}
                    title={collapsed ? 'Développer' : 'Réduire'}
                >
                    {collapsed ? '▶' : '◀'}
                </button>
            </div>
            <nav className="sidebar-nav">
                {MENU_SECTIONS.map((section, idx) => (
                    <div key={idx} className="sidebar-section">
                        {!collapsed && (
                            <div className="sidebar-section-title">{section.title}</div>
                        )}
                        {section.items.map(item => (
                            <NavLink
                                key={item.path}
                                to={item.path}
                                className={({ isActive }) => `sidebar-link ${isActive ? 'active' : ''}`}
                                title={item.label}
                                end={item.path === '/' || item.path === '/compatibilite'}
                                onClick={onMobileClose}
                            >
                                <span className="sidebar-icon">{item.icon}</span>
                                {!collapsed && <span className="sidebar-label">{item.label}</span>}
                            </NavLink>
                        ))}
                    </div>
                ))}
            </nav>
        </aside>
    );
}
