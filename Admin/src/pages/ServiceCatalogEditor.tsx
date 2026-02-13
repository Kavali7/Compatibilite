import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type ServiceCatalogItem = {
    id: string;
    name: string;
    emoji: string;
    advantages: string[];
    plan_type: string;
    screen_route: string;
    enabled: boolean;
    display_order: number;
};

export default function ServiceCatalogEditor() {
    const [services, setServices] = useState<ServiceCatalogItem[]>([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<ServiceCatalogItem>>({});
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadServices();
    }, []);

    async function loadServices() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('service_catalog')
                .select('*')
                .order('display_order', { ascending: true });

            if (error) throw error;
            setServices(data || []);
        } catch (err) {
            console.error('Error loading services:', err);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(service: ServiceCatalogItem) {
        setEditingId(service.id);
        setEditForm({
            name: service.name,
            emoji: service.emoji,
            advantages: [...service.advantages],
            enabled: service.enabled,
            display_order: service.display_order,
        });
    }

    function cancelEdit() {
        setEditingId(null);
        setEditForm({});
    }

    async function saveService(id: string) {
        setSaving(true);
        setSaveStatus(null);
        try {
            const { error } = await supabase
                .from('service_catalog')
                .update({
                    name: editForm.name,
                    emoji: editForm.emoji,
                    advantages: editForm.advantages,
                    enabled: editForm.enabled,
                    display_order: editForm.display_order,
                })
                .eq('id', id);

            if (error) throw error;

            setSaveStatus('✅ Sauvegardé');
            setEditingId(null);
            loadServices();
        } catch (err) {
            console.error('Error saving service:', err);
            setSaveStatus('❌ Erreur de sauvegarde');
        } finally {
            setSaving(false);
            setTimeout(() => setSaveStatus(null), 3000);
        }
    }

    function updateAdvantage(index: number, value: string) {
        const newAdvantages = [...(editForm.advantages || [])];
        newAdvantages[index] = value;
        setEditForm({ ...editForm, advantages: newAdvantages });
    }

    async function moveService(serviceId: string, direction: 'up' | 'down') {
        const idx = services.findIndex(s => s.id === serviceId);
        if (idx < 0) return;
        const swapIdx = direction === 'up' ? idx - 1 : idx + 1;
        if (swapIdx < 0 || swapIdx >= services.length) return;

        const currentOrder = services[idx].display_order;
        const swapOrder = services[swapIdx].display_order;

        setSaving(true);
        try {
            // Swap display_order values between the two services
            const { error: e1 } = await supabase
                .from('service_catalog')
                .update({ display_order: swapOrder })
                .eq('id', services[idx].id);
            const { error: e2 } = await supabase
                .from('service_catalog')
                .update({ display_order: currentOrder })
                .eq('id', services[swapIdx].id);
            if (e1 || e2) throw e1 || e2;
            await loadServices();
        } catch (err) {
            console.error('Error reordering:', err);
        } finally {
            setSaving(false);
        }
    }

    if (loading) {
        return <div className="loading">Chargement du catalogue...</div>;
    }

    return (
        <div className="catalog-editor">
            <h2>📚 Édition du Catalogue des Services</h2>
            <p className="description">
                Modifiez les noms, emojis et descriptions des services affichés dans l'application.
            </p>

            {saveStatus && <div className="save-status">{saveStatus}</div>}

            <div className="services-list">
                {services.map((service) => (
                    <div key={service.id} className={`service-item ${editingId === service.id ? 'editing' : ''}`}>
                        {editingId === service.id ? (
                            // Edit mode
                            <div className="edit-form">
                                <div className="form-row">
                                    <label>Emoji:</label>
                                    <input
                                        type="text"
                                        value={editForm.emoji || ''}
                                        onChange={(e) => setEditForm({ ...editForm, emoji: e.target.value })}
                                        className="emoji-input"
                                        maxLength={4}
                                    />
                                </div>
                                <div className="form-row">
                                    <label>Nom:</label>
                                    <input
                                        type="text"
                                        value={editForm.name || ''}
                                        onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                                        className="name-input"
                                    />
                                </div>
                                <div className="form-row">
                                    <label>Activé:</label>
                                    <input
                                        type="checkbox"
                                        checked={editForm.enabled}
                                        onChange={(e) => setEditForm({ ...editForm, enabled: e.target.checked })}
                                    />
                                </div>
                                <div className="form-row">
                                    <label>Ordre:</label>
                                    <input
                                        type="number"
                                        value={editForm.display_order ?? 0}
                                        onChange={(e) => setEditForm({ ...editForm, display_order: parseInt(e.target.value) || 0 })}
                                        className="order-input"
                                        min={0}
                                    />
                                </div>
                                <div className="advantages-edit">
                                    <label>Avantages (5 max):</label>
                                    {(editForm.advantages || []).map((adv, i) => (
                                        <input
                                            key={i}
                                            type="text"
                                            value={adv}
                                            onChange={(e) => updateAdvantage(i, e.target.value)}
                                            placeholder={`Avantage ${i + 1}`}
                                            className="advantage-input"
                                        />
                                    ))}
                                </div>
                                <div className="edit-actions">
                                    <button
                                        onClick={() => saveService(service.id)}
                                        disabled={saving}
                                        className="save-btn"
                                    >
                                        {saving ? 'Sauvegarde...' : '💾 Sauvegarder'}
                                    </button>
                                    <button onClick={cancelEdit} className="cancel-btn">
                                        Annuler
                                    </button>
                                </div>
                            </div>
                        ) : (
                            // View mode
                            <div className="service-view">
                                <div className="service-header">
                                    <span className="order-badge">#{service.display_order}</span>
                                    <span className="service-emoji">{service.emoji}</span>
                                    <span className="service-name">{service.name}</span>
                                    <span className={`service-status ${service.enabled ? 'enabled' : 'disabled'}`}>
                                        {service.enabled ? '✅' : '❌'}
                                    </span>
                                </div>
                                <div className="service-advantages">
                                    {service.advantages.slice(0, 3).map((adv, i) => (
                                        <span key={i} className="advantage">✓ {adv}</span>
                                    ))}
                                    {service.advantages.length > 3 && (
                                        <span className="more">+{service.advantages.length - 3} autres</span>
                                    )}
                                </div>
                                <div className="service-actions">
                                    <div className="reorder-buttons">
                                        <button
                                            onClick={() => moveService(service.id, 'up')}
                                            disabled={saving || services.indexOf(service) === 0}
                                            className="reorder-btn"
                                            title="Monter"
                                        >▲</button>
                                        <button
                                            onClick={() => moveService(service.id, 'down')}
                                            disabled={saving || services.indexOf(service) === services.length - 1}
                                            className="reorder-btn"
                                            title="Descendre"
                                        >▼</button>
                                    </div>
                                    <button onClick={() => startEdit(service)} className="edit-btn">
                                        ✏️ Modifier
                                    </button>
                                </div>
                            </div>
                        )}
                    </div>
                ))}
            </div>

            <style>{`
                .catalog-editor {
                    padding: 24px;
                    max-width: 900px;
                }
                .catalog-editor h2 {
                    color: #f0e68c;
                    margin-bottom: 8px;
                }
                .description {
                    color: rgba(255, 255, 255, 0.7);
                    margin-bottom: 24px;
                }
                .save-status {
                    padding: 12px;
                    border-radius: 8px;
                    background: rgba(100, 255, 100, 0.1);
                    margin-bottom: 16px;
                    text-align: center;
                }
                .services-list {
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                }
                .service-item {
                    background: rgba(255, 255, 255, 0.05);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 12px;
                    padding: 16px;
                    transition: all 0.3s ease;
                }
                .service-item.editing {
                    background: rgba(159, 122, 234, 0.1);
                    border-color: rgba(159, 122, 234, 0.3);
                }
                .service-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 8px;
                }
                .service-emoji {
                    font-size: 24px;
                }
                .service-name {
                    flex: 1;
                    font-size: 16px;
                    font-weight: 600;
                    color: white;
                }
                .service-status {
                    font-size: 14px;
                }
                .service-advantages {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                    margin-bottom: 12px;
                }
                .advantage {
                    font-size: 12px;
                    color: rgba(255, 255, 255, 0.6);
                    background: rgba(0, 0, 0, 0.2);
                    padding: 4px 8px;
                    border-radius: 4px;
                }
                .more {
                    font-size: 12px;
                    color: rgba(159, 122, 234, 0.8);
                }
                .edit-btn {
                    background: linear-gradient(135deg, #667eea, #9f7aea);
                    border: none;
                    color: white;
                    padding: 8px 16px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 14px;
                }
                .edit-btn:hover {
                    opacity: 0.9;
                }
                .edit-form {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }
                .form-row {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .form-row label {
                    width: 80px;
                    color: rgba(255, 255, 255, 0.8);
                }
                .emoji-input {
                    width: 60px;
                    font-size: 24px;
                    text-align: center;
                    background: rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    border-radius: 6px;
                    color: white;
                    padding: 4px;
                }
                .name-input {
                    flex: 1;
                    background: rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    border-radius: 6px;
                    color: white;
                    padding: 8px 12px;
                    font-size: 14px;
                }
                .advantages-edit {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .advantages-edit label {
                    color: rgba(255, 255, 255, 0.8);
                }
                .advantage-input {
                    background: rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    border-radius: 6px;
                    color: white;
                    padding: 8px 12px;
                    font-size: 13px;
                }
                .edit-actions {
                    display: flex;
                    gap: 12px;
                    margin-top: 8px;
                }
                .save-btn {
                    background: linear-gradient(135deg, #48bb78, #38a169);
                    border: none;
                    color: white;
                    padding: 10px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 14px;
                }
                .save-btn:disabled {
                    opacity: 0.5;
                }
                .cancel-btn {
                    background: rgba(255, 255, 255, 0.1);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    color: white;
                    padding: 10px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                }
                .loading {
                    text-align: center;
                    padding: 40px;
                    color: rgba(255, 255, 255, 0.6);
                }
                .order-badge {
                    background: rgba(159, 122, 234, 0.3);
                    color: #c4b5fd;
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: 600;
                    min-width: 28px;
                    text-align: center;
                }
                .order-input {
                    width: 70px;
                    background: rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    border-radius: 6px;
                    color: white;
                    padding: 8px 12px;
                    font-size: 14px;
                    text-align: center;
                }
                .service-actions {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }
                .reorder-buttons {
                    display: flex;
                    gap: 4px;
                }
                .reorder-btn {
                    background: rgba(255, 255, 255, 0.08);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    color: rgba(255, 255, 255, 0.7);
                    padding: 4px 10px;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 12px;
                    transition: all 0.2s;
                }
                .reorder-btn:hover:not(:disabled) {
                    background: rgba(159, 122, 234, 0.2);
                    color: white;
                }
                .reorder-btn:disabled {
                    opacity: 0.3;
                    cursor: not-allowed;
                }
            `}</style>
        </div>
    );
}
