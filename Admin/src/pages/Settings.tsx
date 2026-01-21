import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type TemporalBonusSettings = {
    enabled: boolean;
    year: boolean;
    month: boolean;
    day: boolean;
};

type PaymentMethodSettings = {
    kkiapay: boolean;
    fedapay: boolean;
};

type PrimaryServiceOption = 'compatibilite' | 'prevision_jour' | 'prevision_mois' | 'prevision_annee';

const SERVICE_LABELS: Record<PrimaryServiceOption, string> = {
    compatibilite: '💑 Rapport de Compatibilité',
    prevision_jour: '📌 Prévision du Jour',
    prevision_mois: '📅 Prévision du Mois',
    prevision_annee: '📆 Prévision de l\'Année',
};

export default function Settings() {
    const [bonusSettings, setBonusSettings] = useState<TemporalBonusSettings>({
        enabled: true,
        year: true,
        month: true,
        day: true,
    });
    const [paymentMethods, setPaymentMethods] = useState<PaymentMethodSettings>({
        kkiapay: true,
        fedapay: true,
    });
    const [primaryService, setPrimaryService] = useState<PrimaryServiceOption>('compatibilite');
    const [contactEmail, setContactEmail] = useState('growpeak.agence@gmail.com');
    const [contactWhatsApp, setContactWhatsApp] = useState('+22654255584');
    const [currency, setCurrency] = useState<'FCFA' | 'EUR' | 'USD'>('FCFA');
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadSettings();
    }, []);

    async function loadSettings() {
        setLoading(true);
        try {
            // Load bonus settings
            const { data: bonusData, error: bonusError } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'bonus_temporels')
                .maybeSingle();

            if (bonusError) throw bonusError;
            if (bonusData?.value) {
                const frValue = bonusData.value as { activé?: boolean; année?: boolean; mois?: boolean; jour?: boolean };
                setBonusSettings({
                    enabled: frValue.activé ?? true,
                    year: frValue.année ?? true,
                    month: frValue.mois ?? true,
                    day: frValue.jour ?? true,
                });
            }

            // Load primary service setting
            const { data: serviceData, error: serviceError } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'service_principal')
                .maybeSingle();

            if (serviceError) throw serviceError;
            if (serviceData?.value?.service) {
                setPrimaryService(serviceData.value.service as PrimaryServiceOption);
            }

            // Load contact details
            const { data: contactData, error: contactError } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'contact_details')
                .maybeSingle();

            if (contactError) throw contactError;
            if (contactData?.value) {
                setContactEmail(contactData.value.email || 'growpeak.agence@gmail.com');
                setContactWhatsApp(contactData.value.whatsapp || '+22654255584');
            }

            // Load payment method settings
            const { data: payData, error: payError } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'modes_paiement')
                .maybeSingle();

            if (payError) throw payError;
            if (payData?.value) {
                setPaymentMethods({
                    kkiapay: payData.value.kkiapay ?? true,
                    fedapay: payData.value.fedapay ?? true,
                });
            }

            // Load currency setting
            const { data: currencyData, error: currencyError } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'devise')
                .maybeSingle();

            if (currencyError) throw currencyError;
            if (currencyData?.value?.devise) {
                setCurrency(currencyData.value.devise as 'FCFA' | 'EUR' | 'USD');
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
            // Save bonus settings (French keys for database)
            const frValue = {
                activé: bonusSettings.enabled,
                année: bonusSettings.year,
                mois: bonusSettings.month,
                jour: bonusSettings.day,
            };

            const { error: bonusError } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'bonus_temporels',
                    value: frValue,
                    updated_at: new Date().toISOString(),
                });

            if (bonusError) throw bonusError;

            // Save primary service setting
            const { error: serviceError } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'service_principal',
                    value: {
                        service: primaryService,
                        options: ['compatibilite', 'prevision_jour', 'prevision_mois', 'prevision_annee']
                    },
                    updated_at: new Date().toISOString(),
                });

            if (serviceError) throw serviceError;

            // Save contact details
            const { error: contactError } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'contact_details',
                    value: {
                        email: contactEmail,
                        whatsapp: contactWhatsApp,
                    },
                    updated_at: new Date().toISOString(),
                });

            if (contactError) throw contactError;

            // Save payment method settings
            const { error: payError } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'modes_paiement',
                    value: paymentMethods,
                    updated_at: new Date().toISOString(),
                });

            if (payError) throw payError;

            // Save currency setting
            const { error: currencyError } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'devise',
                    value: { devise: currency },
                    updated_at: new Date().toISOString(),
                });

            if (currencyError) throw currencyError;

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

            {/* Primary Service Section */}
            <div className="settings-section">
                <h3>🏠 Service Principal (Accueil)</h3>
                <p className="muted">
                    Choisissez le service affiché par défaut à l'ouverture de l'application mobile.
                </p>

                <div className="primary-service-selector">
                    {(Object.keys(SERVICE_LABELS) as PrimaryServiceOption[]).map((service) => (
                        <button
                            key={service}
                            className={`service-option ${primaryService === service ? 'active' : ''}`}
                            onClick={() => setPrimaryService(service)}
                        >
                            <span className="service-label">{SERVICE_LABELS[service]}</span>
                            {primaryService === service && <span className="check-icon">✓</span>}
                        </button>
                    ))}
                </div>
            </div>

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
                <h3>💳 Modes de Paiement</h3>
                <p className="muted">
                    Activez ou désactivez les services de paiement disponibles pour les utilisateurs.
                </p>

                <div className="payment-method-settings">
                    <div className="settings-toggle-row">
                        <label className="toggle-label">
                            <span className="toggle-icon">💜</span>
                            <div>
                                <strong>Kkiapay</strong>
                                <p className="muted small">Cartes & Mobile Money (BJ, CI, SN, TG...)</p>
                            </div>
                        </label>
                        <button
                            className={`toggle-btn ${paymentMethods.kkiapay ? 'active' : ''}`}
                            onClick={() => setPaymentMethods(prev => ({ ...prev, kkiapay: !prev.kkiapay }))}
                        >
                            {paymentMethods.kkiapay ? 'Activé' : 'Désactivé'}
                        </button>
                    </div>

                    <div className="settings-toggle-row">
                        <label className="toggle-label">
                            <span className="toggle-icon">💚</span>
                            <div>
                                <strong>FedaPay</strong>
                                <p className="muted small">Mobile Money & Cartes (BJ, TG, ML, SN...)</p>
                            </div>
                        </label>
                        <button
                            className={`toggle-btn ${paymentMethods.fedapay ? 'active' : ''}`}
                            onClick={() => setPaymentMethods(prev => ({ ...prev, fedapay: !prev.fedapay }))}
                        >
                            {paymentMethods.fedapay ? 'Activé' : 'Désactivé'}
                        </button>
                    </div>
                </div>
            </div>

            <div className="settings-section">
                <h3>💰 Devise d'affichage</h3>
                <p className="muted">
                    Choisissez la devise pour l'affichage des montants dans l'application.
                </p>
                <div className="currency-selector">
                    {(['FCFA', 'EUR', 'USD'] as const).map((c) => (
                        <button
                            key={c}
                            className={`currency-option ${currency === c ? 'active' : ''}`}
                            onClick={() => setCurrency(c)}
                        >
                            {c === 'FCFA' ? '🇧🇯 FCFA' : c === 'EUR' ? '🇪🇺 EUR' : '🇺🇸 USD'}
                        </button>
                    ))}
                </div>
            </div>

            <div className="settings-section">
                <h3>🔗 Connexions</h3>
                <div className="settings-item">
                    <span className="settings-label">Supabase</span>
                    <span className="settings-value status-connected">Connecté</span>
                </div>
                <div className="settings-item">
                    <span className="settings-label">Kkiapay</span>
                    <span className="settings-value status-connected">Configuré</span>
                </div>
                <div className="settings-item">
                    <span className="settings-label">FedaPay</span>
                    <span className="settings-value status-connected">Configuré</span>
                </div>
            </div>

            <div className="settings-section">
                <h3>Coordonnées Growpeak Agence</h3>
                <p className="muted">
                    Modifiez l'email et le numéro WhatsApp de contact utilisés dans l'application mobile.
                </p>
                <div className="contact-info-edit">
                    <div className="input-group">
                        <label>📧 Email de contact</label>
                        <input
                            type="email"
                            value={contactEmail}
                            onChange={(e) => setContactEmail(e.target.value)}
                            className="settings-input"
                            placeholder="growpeak.agence@gmail.com"
                        />
                    </div>
                    <div className="input-group">
                        <label>💬 WhatsApp (format international)</label>
                        <input
                            type="text"
                            value={contactWhatsApp}
                            onChange={(e) => setContactWhatsApp(e.target.value)}
                            className="settings-input"
                            placeholder="+22654255584"
                        />
                        <p className="muted small">Exemple: +229XXXXXXXX ou +226XXXXXXXX (sans espaces)</p>
                    </div>
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
                .primary-service-selector {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                    margin-top: 16px;
                }
                .service-option {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 16px 20px;
                    background: rgba(255,255,255,0.05);
                    border: 2px solid rgba(255,255,255,0.1);
                    border-radius: 12px;
                    color: #aaa;
                    cursor: pointer;
                    transition: all 0.2s;
                    font-size: 16px;
                }
                .service-option:hover {
                    background: rgba(255,255,255,0.08);
                    border-color: rgba(255,255,255,0.2);
                }
                .service-option.active {
                    background: linear-gradient(135deg, rgba(102,126,234,0.2) 0%, rgba(159,122,234,0.2) 100%);
                    border-color: #667eea;
                    color: white;
                }
                .check-icon {
                    color: #667eea;
                    font-size: 20px;
                    font-weight: bold;
                }
                .contact-info-edit {
                    margin-top: 16px;
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                }
                .input-group {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .input-group label {
                    font-weight: 600;
                    color: white;
                }
                .settings-input {
                    padding: 12px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 2px solid rgba(255,255,255,0.1);
                    border-radius: 12px;
                    color: white;
                    font-size: 16px;
                    width: 100%;
                }
                .settings-input:focus {
                    outline: none;
                    border-color: #667eea;
                    background: rgba(255,255,255,0.08);
                }
                .currency-selector {
                    display: flex;
                    gap: 12px;
                    margin-top: 16px;
                }
                .currency-option {
                    flex: 1;
                    padding: 12px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 2px solid rgba(255,255,255,0.1);
                    border-radius: 12px;
                    color: #aaa;
                    cursor: pointer;
                    font-size: 14px;
                    transition: all 0.2s;
                }
                .currency-option:hover {
                    background: rgba(255,255,255,0.08);
                    border-color: rgba(255,255,255,0.2);
                }
                .currency-option.active {
                    background: linear-gradient(135deg, rgba(102,126,234,0.2) 0%, rgba(159,122,234,0.2) 100%);
                    border-color: #667eea;
                    color: white;
                }
            `}</style>
        </div>
    );
}
