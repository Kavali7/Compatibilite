import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type TrackingPixelsConfig = {
    meta_pixel_id: string;
    tiktok_pixel_id: string;
    ga4_measurement_id: string;
    enabled: boolean;
};

const DEFAULT_CONFIG: TrackingPixelsConfig = {
    meta_pixel_id: '',
    tiktok_pixel_id: '',
    ga4_measurement_id: '',
    enabled: true,
};

export default function TrackingPixels() {
    const [config, setConfig] = useState<TrackingPixelsConfig>(DEFAULT_CONFIG);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadConfig();
    }, []);

    async function loadConfig() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', 'tracking_pixels')
                .maybeSingle();

            if (error) throw error;
            if (data?.value) {
                setConfig({ ...DEFAULT_CONFIG, ...data.value });
            }
        } catch (e) {
            console.error('Load tracking config error:', e);
        }
        setLoading(false);
    }

    async function saveConfig() {
        setSaving(true);
        setSaveStatus(null);
        try {
            const { error } = await supabase
                .from('app_settings')
                .upsert({
                    key: 'tracking_pixels',
                    value: config,
                    updated_at: new Date().toISOString(),
                });

            if (error) throw error;
            setSaveStatus('✅ Configuration enregistrée ! Les pixels seront actifs au prochain chargement de l\'app.');
            setTimeout(() => setSaveStatus(null), 5000);
        } catch (e: any) {
            console.error('Save tracking config error:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
        setSaving(false);
    }

    function getPixelStatus(id: string): { label: string; className: string } {
        if (!config.enabled) return { label: 'Désactivé (global)', className: 'status-disabled' };
        if (!id || id.trim() === '') return { label: 'Non configuré', className: 'status-pending' };
        return { label: 'Actif ✓', className: 'status-active' };
    }

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page tracking-pixels">
            <h2 className="page-title">📊 Tracking & Pixels</h2>
            <p className="muted tracking-description">
                Configurez vos pixels de tracking pour analyser vos campagnes publicitaires et retargeter vos visiteurs.
                Les pixels sont chargés automatiquement sur l'app web lorsqu'un ID est renseigné.
            </p>

            {/* Global toggle */}
            <div className="tracking-section">
                <div className="tracking-toggle-row">
                    <div className="tracking-toggle-info">
                        <span className="tracking-toggle-icon">🌐</span>
                        <div>
                            <strong>Activer les pixels de tracking</strong>
                            <p className="muted small">Si désactivé, aucun pixel ne sera chargé même si les IDs sont configurés</p>
                        </div>
                    </div>
                    <button
                        className={`toggle-btn ${config.enabled ? 'active' : ''}`}
                        onClick={() => setConfig(prev => ({ ...prev, enabled: !prev.enabled }))}
                    >
                        {config.enabled ? 'Activé' : 'Désactivé'}
                    </button>
                </div>
            </div>

            {/* Meta Pixel */}
            <div className="tracking-section">
                <div className="tracking-card">
                    <div className="tracking-card-header">
                        <div className="tracking-card-title">
                            <span className="tracking-card-icon">📘</span>
                            <div>
                                <h3>Meta Pixel (Facebook/Instagram)</h3>
                                <p className="muted small">Retargeting Facebook & Instagram, audiences similaires, analyse de campagnes</p>
                            </div>
                        </div>
                        <span className={`tracking-status ${getPixelStatus(config.meta_pixel_id).className}`}>
                            {getPixelStatus(config.meta_pixel_id).label}
                        </span>
                    </div>
                    <div className="tracking-card-body">
                        <label>Meta Pixel ID</label>
                        <input
                            type="text"
                            value={config.meta_pixel_id}
                            onChange={(e) => setConfig(prev => ({ ...prev, meta_pixel_id: e.target.value.trim() }))}
                            className="tracking-input"
                            placeholder="Ex: 123456789012345"
                        />
                        <p className="muted small">
                            📍 Où le trouver : <a href="https://business.facebook.com/events_manager" target="_blank" rel="noopener noreferrer">
                                Meta Business Suite → Gestionnaire d'événements → Sources de données
                            </a>
                        </p>
                    </div>
                </div>
            </div>

            {/* TikTok Pixel */}
            <div className="tracking-section">
                <div className="tracking-card">
                    <div className="tracking-card-header">
                        <div className="tracking-card-title">
                            <span className="tracking-card-icon">🎵</span>
                            <div>
                                <h3>TikTok Pixel</h3>
                                <p className="muted small">Mesure de conversions TikTok, retargeting, optimisation de campagnes</p>
                            </div>
                        </div>
                        <span className={`tracking-status ${getPixelStatus(config.tiktok_pixel_id).className}`}>
                            {getPixelStatus(config.tiktok_pixel_id).label}
                        </span>
                    </div>
                    <div className="tracking-card-body">
                        <label>TikTok Pixel ID</label>
                        <input
                            type="text"
                            value={config.tiktok_pixel_id}
                            onChange={(e) => setConfig(prev => ({ ...prev, tiktok_pixel_id: e.target.value.trim() }))}
                            className="tracking-input"
                            placeholder="Ex: CXXXXXXXXXXXXXXX"
                        />
                        <p className="muted small">
                            📍 Où le trouver : <a href="https://ads.tiktok.com" target="_blank" rel="noopener noreferrer">
                                TikTok Ads → Assets → Events → Web Events → Créer un Pixel
                            </a>
                        </p>
                    </div>
                </div>
            </div>

            {/* GA4 */}
            <div className="tracking-section">
                <div className="tracking-card">
                    <div className="tracking-card-header">
                        <div className="tracking-card-title">
                            <span className="tracking-card-icon">📈</span>
                            <div>
                                <h3>Google Analytics 4 (GA4)</h3>
                                <p className="muted small">Analyse comportementale, parcours utilisateur, sources de trafic</p>
                            </div>
                        </div>
                        <span className={`tracking-status ${getPixelStatus(config.ga4_measurement_id).className}`}>
                            {getPixelStatus(config.ga4_measurement_id).label}
                        </span>
                    </div>
                    <div className="tracking-card-body">
                        <label>GA4 Measurement ID</label>
                        <input
                            type="text"
                            value={config.ga4_measurement_id}
                            onChange={(e) => setConfig(prev => ({ ...prev, ga4_measurement_id: e.target.value.trim() }))}
                            className="tracking-input"
                            placeholder="Ex: G-XXXXXXXXXX"
                        />
                        <p className="muted small">
                            📍 Où le trouver : <a href="https://analytics.google.com" target="_blank" rel="noopener noreferrer">
                                Google Analytics → Admin → Flux de données → Web
                            </a>
                        </p>
                    </div>
                </div>
            </div>

            {/* Events info */}
            <div className="tracking-section">
                <div className="tracking-card events-info">
                    <h3>📋 Événements trackés automatiquement</h3>
                    <table className="tracking-events-table">
                        <thead>
                            <tr>
                                <th>Action</th>
                                <th>Meta</th>
                                <th>TikTok</th>
                                <th>GA4</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>Visite du site</td><td>PageView</td><td>page()</td><td>page_view</td></tr>
                            <tr><td>Consultation service</td><td>ViewContent</td><td>ViewContent</td><td>view_item</td></tr>
                            <tr><td>Inscription</td><td>CompleteRegistration</td><td>CompleteRegistration</td><td>sign_up</td></tr>
                            <tr><td>Début paiement</td><td>InitiateCheckout</td><td>InitiateCheckout</td><td>begin_checkout</td></tr>
                            <tr><td>Achat réussi</td><td>Purchase</td><td>CompletePayment</td><td>purchase</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Save button */}
            <button
                className="btn-primary tracking-save-btn"
                onClick={saveConfig}
                disabled={saving}
            >
                {saving ? 'Enregistrement...' : '💾 Enregistrer la configuration'}
            </button>

            {saveStatus && (
                <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                    {saveStatus}
                </div>
            )}

            <style>{`
                .tracking-pixels {
                    max-width: 800px;
                }
                .tracking-description {
                    margin-bottom: 24px;
                }
                .tracking-section {
                    margin-bottom: 20px;
                }
                .tracking-toggle-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 20px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                }
                .tracking-toggle-info {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                }
                .tracking-toggle-icon {
                    font-size: 28px;
                }
                .tracking-toggle-info .muted.small {
                    font-size: 12px;
                    margin: 4px 0 0 0;
                }
                .tracking-card {
                    background: rgba(255,255,255,0.03);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                    overflow: hidden;
                }
                .tracking-card-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 18px 20px;
                    background: rgba(255,255,255,0.02);
                    border-bottom: 1px solid rgba(255,255,255,0.06);
                }
                .tracking-card-title {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                }
                .tracking-card-icon {
                    font-size: 28px;
                }
                .tracking-card-title h3 {
                    margin: 0;
                    font-size: 16px;
                }
                .tracking-card-title .muted.small {
                    font-size: 12px;
                    margin: 4px 0 0 0;
                }
                .tracking-status {
                    padding: 6px 14px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                    white-space: nowrap;
                }
                .tracking-status.status-active {
                    background: rgba(34, 197, 94, 0.15);
                    color: #22c55e;
                    border: 1px solid rgba(34, 197, 94, 0.3);
                }
                .tracking-status.status-pending {
                    background: rgba(251, 191, 36, 0.15);
                    color: #fbbf24;
                    border: 1px solid rgba(251, 191, 36, 0.3);
                }
                .tracking-status.status-disabled {
                    background: rgba(107, 114, 128, 0.15);
                    color: #6b7280;
                    border: 1px solid rgba(107, 114, 128, 0.3);
                }
                .tracking-card-body {
                    padding: 18px 20px;
                }
                .tracking-card-body label {
                    display: block;
                    font-weight: 600;
                    color: white;
                    margin-bottom: 8px;
                    font-size: 13px;
                }
                .tracking-input {
                    width: 100%;
                    padding: 12px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 2px solid rgba(255,255,255,0.1);
                    border-radius: 12px;
                    color: white;
                    font-size: 15px;
                    font-family: 'SF Mono', 'Fira Code', monospace;
                    letter-spacing: 0.5px;
                    box-sizing: border-box;
                }
                .tracking-input:focus {
                    outline: none;
                    border-color: #667eea;
                    background: rgba(255,255,255,0.08);
                }
                .tracking-input::placeholder {
                    color: rgba(255,255,255,0.25);
                    font-family: inherit;
                }
                .tracking-card-body .muted.small {
                    margin-top: 10px;
                    font-size: 12px;
                }
                .tracking-card-body a {
                    color: #667eea;
                    text-decoration: none;
                }
                .tracking-card-body a:hover {
                    text-decoration: underline;
                }
                .events-info {
                    padding: 20px;
                }
                .events-info h3 {
                    margin: 0 0 16px 0;
                    font-size: 15px;
                }
                .tracking-events-table {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 13px;
                }
                .tracking-events-table th {
                    text-align: left;
                    padding: 10px 12px;
                    color: rgba(255,255,255,0.5);
                    font-weight: 600;
                    border-bottom: 1px solid rgba(255,255,255,0.1);
                    font-size: 11px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }
                .tracking-events-table td {
                    padding: 10px 12px;
                    color: rgba(255,255,255,0.7);
                    border-bottom: 1px solid rgba(255,255,255,0.04);
                    font-family: 'SF Mono', 'Fira Code', monospace;
                    font-size: 12px;
                }
                .tracking-events-table td:first-child {
                    font-family: inherit;
                    font-size: 13px;
                    color: white;
                }
                .tracking-events-table tbody tr:hover {
                    background: rgba(255,255,255,0.03);
                }
                .tracking-save-btn {
                    width: 100%;
                    margin-top: 8px;
                    padding: 14px;
                    font-size: 16px;
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
            `}</style>
        </div>
    );
}
