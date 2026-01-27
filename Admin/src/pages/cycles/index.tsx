import { NavLink, Outlet } from 'react-router-dom';

export default function CyclesIndex() {
    const navItems = [
        { path: 'soul-periods', label: '🌟 Périodes Soul Cycle', description: 'Les 14 profils basés sur la date de naissance' },
        { path: 'daily-periods', label: '⏰ Périodes Quotidiennes', description: 'Les 7 périodes A-G de chaque jour' },
        { path: 'decision-types', label: '🎯 Types de Décisions', description: 'Catégories de décisions consultables' },
        { path: 'decision-advice', label: '💡 Conseils Décisions', description: 'Conseils par type × période' },
        { path: 'purchases', label: '📊 Achats Cycles', description: 'Historique des achats' },
    ];

    return (
        <div className="cycles-section">
            <div className="section-nav" style={{
                display: 'flex',
                gap: '0.5rem',
                marginBottom: '1.5rem',
                flexWrap: 'wrap',
                borderBottom: '1px solid var(--border-color)',
                paddingBottom: '1rem'
            }}>
                {navItems.map(item => (
                    <NavLink
                        key={item.path}
                        to={item.path}
                        className={({ isActive }) =>
                            `nav-pill ${isActive ? 'active' : ''}`
                        }
                        style={({ isActive }) => ({
                            padding: '0.75rem 1rem',
                            borderRadius: '8px',
                            textDecoration: 'none',
                            background: isActive ? 'var(--primary)' : 'var(--card-bg)',
                            color: isActive ? 'white' : 'inherit',
                            fontSize: '0.9rem',
                            fontWeight: isActive ? '600' : '400',
                            transition: 'all 0.2s',
                            cursor: 'pointer',
                            border: isActive ? 'none' : '1px solid var(--border-color)'
                        })}
                        title={item.description}
                    >
                        {item.label}
                    </NavLink>
                ))}
            </div>

            <Outlet />
        </div>
    );
}
