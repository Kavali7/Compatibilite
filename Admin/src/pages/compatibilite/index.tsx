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
            to: '/compatibilite/content-bricks',
            icon: '🧱',
            title: 'Briques de Contenu',
            description: 'Gérer les briques personnalisées (énergie, focus, conseils, etc.)',
        },
        {
            to: '/compatibilite/canonical-predictions',
            icon: '📜',
            title: 'Prédictions Canon',
            description: 'Modifier les textes du PDF pour chaque numéro et période',
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
        {
            to: '/compatibilite/temporal-purchases',
            icon: '🔮',
            title: 'Prévisions Temporelles',
            description: 'Gérer les achats de prévisions (jour, mois, année)',
        },
        {
            to: '/compatibilite/report-sections',
            icon: '📋',
            title: 'Sections Rapport',
            description: 'Activer/désactiver les sections du rapport temporel',
        },
        {
            to: '/compatibilite/text-type-settings',
            icon: '⚙️',
            title: 'Types de Textes',
            description: 'Gérer l\'activation et l\'affichage des types de numérologie',
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
