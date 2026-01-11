import React, { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type TextTypeSetting = {
    type: string;
    label_display: string;
    is_active: boolean;
    display_order: number;
    hide_number: boolean;
    created_at?: string;
    updated_at?: string;
};

export default function TextTypeSettings() {
    const [settings, setSettings] = useState<TextTypeSetting[]>([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    useEffect(() => {
        fetchSettings();
    }, []);

    async function fetchSettings() {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('text_type_settings')
                .select('*')
                .order('display_order', { ascending: true });

            if (error) throw error;
            setSettings(data || []);
        } catch (error) {
            console.error('Error fetching text type settings:', error);
            setMessage({ type: 'error', text: 'Erreur lors du chargement des paramètres.' });
        } finally {
            setLoading(false);
        }
    }

    async function handleSave(setting: TextTypeSetting) {
        try {
            setSaving(true);
            setMessage(null);
            const { error } = await supabase
                .from('text_type_settings')
                .update({
                    label_display: setting.label_display,
                    is_active: setting.is_active,
                    hide_number: setting.hide_number,
                    updated_at: new Date().toISOString(),
                })
                .eq('type', setting.type);

            if (error) throw error;
            setMessage({ type: 'success', text: `Type "${setting.type}" mis à jour !` });

            setSettings(prev => prev.map(s => s.type === setting.type ? setting : s));
            setTimeout(() => setMessage(null), 3000);
        } catch (error) {
            console.error('Error updating setting:', error);
            setMessage({ type: 'error', text: 'Erreur lors de la sauvegarde.' });
        } finally {
            setSaving(false);
        }
    }

    const handleLabelChange = (type: string, newLabel: string) => {
        setSettings(prev => prev.map(s => s.type === type ? { ...s, label_display: newLabel } : s));
    };

    const handleActiveToggle = (type: string) => {
        setSettings(prev =>
            prev.map(s => {
                if (s.type === type) {
                    const updated = { ...s, is_active: !s.is_active };
                    handleSave(updated);
                    return updated;
                }
                return s;
            })
        );
    };

    const handleHideNumberToggle = (type: string) => {
        setSettings(prev =>
            prev.map(s => {
                if (s.type === type) {
                    const updated = { ...s, hide_number: !s.hide_number };
                    handleSave(updated);
                    return updated;
                }
                return s;
            })
        );
    };

    if (loading) return <div className="p-8 text-center">Chargement...</div>;

    return (
        <div className="page text-type-settings">
            <h2 className="page-title">Gestion des Types de Textes</h2>
            <p className="page-subtitle">
                Activez ou désactivez les sections du rapport • Table: <code>text_type_settings</code>
            </p>

            {message && (
                <div className={`alert ${message.type === 'success' ? 'alert-success' : 'alert-error'}`}>
                    {message.text}
                </div>
            )}

            <div className="settings-grid">
                {settings.map((setting) => (
                    <div
                        key={setting.type}
                        className={`setting-card ${!setting.is_active ? 'inactive' : ''}`}
                    >
                        <div className="setting-header">
                            <span className="setting-type">{setting.type}</span>
                            <button
                                onClick={() => handleActiveToggle(setting.type)}
                                className={`toggle-btn ${setting.is_active ? 'active' : ''}`}
                                title={setting.is_active ? 'Désactiver' : 'Activer'}
                            >
                                <span className="toggle-indicator"></span>
                            </button>
                        </div>

                        <div className="form-group">
                            <label>Label affiché à l'utilisateur</label>
                            <input
                                type="text"
                                value={setting.label_display}
                                onChange={(e) => handleLabelChange(setting.type, e.target.value)}
                                placeholder="Titre affiché dans le rapport"
                            />
                        </div>

                        <div className="setting-options">
                            <label className="checkbox-label">
                                <input
                                    type="checkbox"
                                    checked={setting.hide_number}
                                    onChange={() => handleHideNumberToggle(setting.type)}
                                />
                                Masquer les numéros (1-9, 11, 22, 33)
                            </label>
                        </div>

                        <div className="setting-footer">
                            <span className="order-badge">Ordre: {setting.display_order}</span>
                            <button
                                className="btn-save"
                                onClick={() => handleSave(setting)}
                                disabled={saving}
                            >
                                Sauvegarder
                            </button>
                        </div>
                    </div>
                ))}
            </div>

            <style>{`
                .text-type-settings {
                    padding: 2rem;
                }
                .page-title {
                    font-size: 1.5rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                }
                .page-subtitle {
                    color: #666;
                    margin-bottom: 1.5rem;
                }
                .page-subtitle code {
                    background: #f0f0f0;
                    padding: 2px 6px;
                    border-radius: 4px;
                    font-size: 0.875rem;
                }
                .alert {
                    padding: 1rem;
                    border-radius: 8px;
                    margin-bottom: 1rem;
                }
                .alert-success {
                    background: #d4edda;
                    color: #155724;
                }
                .alert-error {
                    background: #f8d7da;
                    color: #721c24;
                }
                .settings-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                    gap: 1.5rem;
                }
                .setting-card {
                    background: white;
                    border-radius: 12px;
                    padding: 1.5rem;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                    border: 2px solid transparent;
                    transition: all 0.2s;
                }
                .setting-card.inactive {
                    opacity: 0.6;
                    border-color: #e0e0e0;
                    background: #f8f8f8;
                }
                .setting-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 1rem;
                }
                .setting-type {
                    font-weight: 600;
                    font-size: 1rem;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                }
                .toggle-btn {
                    width: 48px;
                    height: 24px;
                    border-radius: 12px;
                    background: #ccc;
                    border: none;
                    cursor: pointer;
                    position: relative;
                    transition: background 0.3s;
                }
                .toggle-btn.active {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                }
                .toggle-indicator {
                    position: absolute;
                    top: 2px;
                    left: 2px;
                    width: 20px;
                    height: 20px;
                    background: white;
                    border-radius: 50%;
                    transition: transform 0.3s;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
                }
                .toggle-btn.active .toggle-indicator {
                    transform: translateX(24px);
                }
                .form-group {
                    margin-bottom: 1rem;
                }
                .form-group label {
                    display: block;
                    font-size: 0.75rem;
                    color: #666;
                    margin-bottom: 0.25rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }
                .form-group input[type="text"] {
                    width: 100%;
                    padding: 0.5rem 0.75rem;
                    border: 1px solid #ddd;
                    border-radius: 6px;
                    font-size: 0.9rem;
                }
                .form-group input[type="text"]:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                }
                .setting-options {
                    margin-bottom: 1rem;
                }
                .checkbox-label {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    font-size: 0.875rem;
                    color: #444;
                    cursor: pointer;
                }
                .checkbox-label input[type="checkbox"] {
                    width: 16px;
                    height: 16px;
                    accent-color: #667eea;
                }
                .setting-footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding-top: 1rem;
                    border-top: 1px solid #eee;
                }
                .order-badge {
                    font-size: 0.75rem;
                    color: #999;
                    background: #f0f0f0;
                    padding: 2px 8px;
                    border-radius: 4px;
                }
                .btn-save {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    border: none;
                    padding: 0.5rem 1rem;
                    border-radius: 6px;
                    font-size: 0.875rem;
                    font-weight: 500;
                    cursor: pointer;
                    transition: opacity 0.2s;
                }
                .btn-save:hover {
                    opacity: 0.9;
                }
                .btn-save:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }
            `}</style>
        </div>
    );
}
