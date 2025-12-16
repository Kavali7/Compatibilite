import { Link } from 'react-router-dom';

export default function CompatibiliteIndex() {
    const modules = [
        {
            to: '/compatibilite/interpretations',
            icon: '📝',
            title: 'Interprétations',
            description: 'Gérer les textes numérologiques (chemins de vie, compatibilité, défis)',
        },
        {
            to: '/compatibilite/pricing',
            icon: '💳',
            title: 'Plans & Tarifs',
            description: 'Configurer les forfaits et prix',
        },
        {
            to: '/compatibilite/promos',
            icon: '🏷️',
            title: 'Codes Promo',
            description: 'Créer et gérer les codes de réduction',
        },
        {
            to: '/compatibilite/sessions',
            icon: '👥',
            title: 'Sessions',
            description: 'Consulter les sessions utilisateurs (support)',
        },
    ];

    return (
        <div className="page compatibilite-index">
            <h2 className="page-title">La Compatibilité</h2>
            <p className="page-subtitle">
                Gestion du projet de compatibilité numérologique
            </p>

            <div className="module-grid">
                {modules.map((mod) => (
                    <Link key={mod.to} to={mod.to} className="module-card">
                        <span className="module-icon">{mod.icon}</span>
                        <h3>{mod.title}</h3>
                        <p>{mod.description}</p>
                    </Link>
                ))}
            </div>
        </div>
    );
}
