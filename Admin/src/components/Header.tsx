import { useAuth } from '../hooks/useAuth';
import { useProjet } from '../hooks/useProjet';

export default function Header() {
    const { logout } = useAuth();
    const { projets, currentProjet, setCurrentProjet } = useProjet();

    return (
        <header className="header">
            <div className="header-left">
                <h1 className="header-title">Admin Growpeak</h1>
            </div>

            <div className="header-right">
                <select
                    className="projet-select"
                    value={currentProjet?.id || ''}
                    onChange={(e) => {
                        const p = projets.find((p) => p.id === e.target.value);
                        setCurrentProjet(p || null);
                    }}
                >
                    {projets.map((p) => (
                        <option key={p.id} value={p.id} disabled={!p.actif}>
                            {p.nom} {!p.actif && '(bientôt)'}
                        </option>
                    ))}
                </select>

                <button className="header-logout" onClick={logout}>
                    Déconnexion
                </button>
            </div>
        </header>
    );
}
