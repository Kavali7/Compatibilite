import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type TemporalBonusSettings = {
    enabled: boolean;
    year: boolean;
    month: boolean;
    day: boolean;
};

export default function Settings() {
    const [bonusSettings, setBonusSettings] = useState<TemporalBonusSettings>({
        enabled: true,
        year: true,
        month: true,
        day: true,
    });
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadSettings();
    }, []);

    async function loadSettings() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'temporal_bonuses')
                .maybeSingle();

            if (error) throw error;
            if (data?.value) {
                setBonusSettings(data.value as TemporalBonusSettings);
            }
        } catch (e) {
            console.error('Load settings error:', e);
        }
        setLoading(false);
    }

    async function saveSettings() {
        setSaving(true);
        setSaveStatus(null);
        try {
            const { error } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'temporal_bonuses',
                    value: bonusSettings,
                    updated_at: new Date().toISOString(),
                });

            if (error) throw error;
            setSaveStatus('✅ Paramètres enregistrés !');
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Save settings error:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
        setSaving(false);
    }

    function toggleSetting(key: keyof TemporalBonusSettings) {
        setBonusSettings(prev => ({ ...prev, [key]: !prev[key] }));
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page settings">
            <h2 className="page-title">Paramètres</h2>

            {/* Temporal Bonuses Section */}
            <div className="settings-section">
                <h3>🎁 Bonus Temporels (Rapport de base)</h3>
                <p className="muted">
                    Configurez les prévisions temporelles incluses gratuitement avec chaque rapport de compatibilité.
                </p>

                <div className="bonus-settings">
                    <div className="settings-toggle-row">
                        <label className="toggle-label">
                            <span className="toggle-icon">🔮</span>
                            <div>
                                <strong>Activer les bonus temporels</strong>
                                <p className="muted small">Si désactivé, aucun bonus ne sera inclus</p>
                            </div>
                        </label>
                        <button
                            className={`toggle-btn ${bonusSettings.enabled ? 'active' : ''}`}
                            onClick={() => toggleSetting('enabled')}
                        >
                            {bonusSettings.enabled ? 'Activé' : 'Désactivé'}
                        </button>
                    </div>

                    {bonusSettings.enabled && (
                        <>
                            <div className="settings-toggle-row">
                                <label className="toggle-label">
                                    <span className="toggle-icon">📆</span>
                                    <div>
                                        <strong>Prévision Année en cours</strong>
                                        <p className="muted small">Inclure la prévision de l'année actuelle</p>
                                    </div>
                                </label>
                                <button
                                    className={`toggle-btn ${bonusSettings.year ? 'active' : ''}`}
                                    onClick={() => toggleSetting('year')}
                                >
                                    {bonusSettings.year ? 'Inclus' : 'Exclu'}
                                </button>
                            </div>

                            <div className="settings-toggle-row">
                                <label className="toggle-label">
                                    <span className="toggle-icon">📅</span>
                                    <div>
                                        <strong>Prévision Mois en cours</strong>
                                        <p className="muted small">Inclure la prévision du mois actuel</p>
                                    </div>
                                </label>
                                <button
                                    className={`toggle-btn ${bonusSettings.month ? 'active' : ''}`}
                                    onClick={() => toggleSetting('month')}
                                >
                                    {bonusSettings.month ? 'Inclus' : 'Exclu'}
                                </button>
                            </div>

                            <div className="settings-toggle-row">
                                <label className="toggle-label">
                                    <span className="toggle-icon">📌</span>
                                    <div>
                                        <strong>Prévision Jour en cours</strong>
                                        <p className="muted small">Inclure la prévision d'aujourd'hui</p>
                                    </div>
                                </label>
                                <button
                                    className={`toggle-btn ${bonusSettings.day ? 'active' : ''}`}
                                    onClick={() => toggleSetting('day')}
                                >
                                    {bonusSettings.day ? 'Inclus' : 'Exclu'}
                                </button>
                            </div>
                        </>
                    )}

                    <button
                        className="btn-primary save-btn"
                        onClick={saveSettings}
                        disabled={saving}
                    >
                        {saving ? 'Enregistrement...' : 'Enregistrer les paramètres'}
                    </button>

                    {saveStatus && (
                        <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                            {saveStatus}
                        </div>
                    )}
                </div>
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

            <style>{`
                .bonus-settings {
                    margin-top: 16px;
                }
                .settings-toggle-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 16px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    margin-bottom: 12px;
                }
                .toggle-label {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .toggle-icon {
                    font-size: 24px;
                }
                .toggle-label .muted.small {
                    font-size: 12px;
                    margin: 0;
                }
                .toggle-btn {
                    padding: 8px 16px;
                    border-radius: 20px;
                    border: 2px solid #666;
                    background: transparent;
                    color: #888;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .toggle-btn.active {
                    border-color: #667eea;
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    color: white;
                }
                .save-btn {
                    margin-top: 16px;
                    width: 100%;
                }
            `}</style>
        </div>
    );
}
