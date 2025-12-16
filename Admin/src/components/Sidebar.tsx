import { NavLink } from 'react-router-dom';
import { useProjet } from '../hooks/useProjet';

type SidebarProps = {
    collapsed: boolean;
    onToggle: () => void;
};

export default function Sidebar({ collapsed, onToggle }: SidebarProps) {
    const { currentProjet } = useProjet();

    const navItems = [
        { to: '/', icon: '📊', label: 'Dashboard' },
        { to: '/compatibilite', icon: '💕', label: 'Compatibilité' },
        { to: '/payments', icon: '💰', label: 'Paiements' },
        { to: '/legal', icon: '📜', label: 'Pages Légales' },
        { to: '/settings', icon: '⚙️', label: 'Paramètres' },
    ];

    const compatibiliteSubItems = [
        { to: '/compatibilite/interpretations', label: 'Interprétations' },
        { to: '/compatibilite/pricing', label: 'Plans & Tarifs' },
        { to: '/compatibilite/promos', label: 'Codes Promo' },
        { to: '/compatibilite/sessions', label: 'Sessions' },
    ];

    return (
        <aside className={`sidebar ${collapsed ? 'sidebar-collapsed' : ''}`}>
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
                {navItems.map((item) => (
                    <div key={item.to}>
                        <NavLink
                            to={item.to}
                            end={item.to === '/'}
                            className={({ isActive }) =>
                                `sidebar-link ${isActive ? 'active' : ''}`
                            }
                        >
                            <span className="sidebar-icon">{item.icon}</span>
                            {!collapsed && <span className="sidebar-label">{item.label}</span>}
                        </NavLink>

                        {/* Sub-menu for Compatibilité */}
                        {item.to === '/compatibilite' && !collapsed && (
                            <div className="sidebar-submenu">
                                {compatibiliteSubItems.map((sub) => (
                                    <NavLink
                                        key={sub.to}
                                        to={sub.to}
                                        className={({ isActive }) =>
                                            `sidebar-sublink ${isActive ? 'active' : ''}`
                                        }
                                    >
                                        {sub.label}
                                    </NavLink>
                                ))}
                            </div>
                        )}
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
