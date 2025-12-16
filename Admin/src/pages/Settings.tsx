export default function Settings() {
    return (
        <div className="page settings">
            <h2 className="page-title">Paramètres</h2>

            <div className="settings-section">
                <h3>Configuration générale</h3>
                <p className="muted">
                    Les paramètres système seront configurables ici.
                </p>
            </div>

            <div className="settings-section">
                <h3>Connexions</h3>
                <div className="settings-item">
                    <span className="settings-label">Supabase</span>
                    <span className="settings-value status-connected">Connecté</span>
                </div>
                <div className="settings-item">
                    <span className="settings-label">Kkiapay</span>
                    <span className="settings-value status-connected">Configuré</span>
                </div>
            </div>

            <div className="settings-section">
                <h3>Coordonnées Growpeak</h3>
                <div className="contact-info">
                    <p>📧 contact@growpeakagency.com</p>
                    <p>📞 +229 XX XX XX XX</p>
                </div>
            </div>
        </div>
    );
}
