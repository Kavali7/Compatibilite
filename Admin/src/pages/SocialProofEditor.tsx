import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type SocialProofEntry = {
    id: string;
    proof_type: 'toast' | 'badge' | 'testimonial';
    target_screen: 'wizard' | 'catalog' | 'welcome';
    enabled: boolean;
    display_order: number;
    region: 'all' | 'africa' | 'europe';
    first_names: string[] | null;
    last_initials: string[] | null;
    message_templates: string[] | null;
    time_labels: string[] | null;
    show_duration_ms: number | null;
    pause_min_ms: number | null;
    pause_max_ms: number | null;
    badge_text: string | null;
    badge_counter: number | null;
    badge_counter_label: string | null;
    testimonial_name: string | null;
    testimonial_text: string | null;
    testimonial_rating: number | null;
    testimonial_photo_url: string | null;
    service_key: string | null;
};

const TABS = [
    { key: 'toast', label: '🔔 Notifications Toast', icon: '🔔' },
    { key: 'badge', label: '🏷️ Badges Popularité', icon: '🏷️' },
    { key: 'testimonial', label: '⭐ Témoignages', icon: '⭐' },
];

const REGIONS = [
    { value: 'all', label: '🌍 Tous' },
    { value: 'africa', label: '🌍 Afrique' },
    { value: 'europe', label: '🇪🇺 Europe' },
];

const SERVICE_KEYS = [
    { value: '', label: '— Global (aucun service)' },
    { value: 'compatibilite_couple', label: '❤️ Compatibilité Couple' },
    { value: 'previsions_temporelles', label: '🔮 Prévisions Temporelles' },
    { value: 'guidance_quotidienne', label: '☀️ Guidance Quotidienne' },
    { value: 'mois_decrypte', label: '📅 Mois Décrypté' },
    { value: 'avenir_annee', label: '🔮 Avenir Année' },
    { value: 'portrait_ame', label: '✨ Portrait de l\'Âme' },
    { value: 'cycle_personnel', label: '📅 Cycle Personnel' },
    { value: 'cycle_business', label: '💼 Cycle Business' },
    { value: 'cycle_sante', label: '💚 Cycle Santé' },
    { value: 'guide_horaire', label: '⏰ Guide Horaire' },
    { value: 'eclairage_decision', label: '💡 Éclairage Décision' },
    { value: 'phases_vie', label: '🛤️ Phases de Vie' },
    { value: 'timing_lunaire', label: '🌙 Timing Lunaire' },
];

export default function SocialProofEditor() {
    const [entries, setEntries] = useState<SocialProofEntry[]>([]);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [activeTab, setActiveTab] = useState('toast');
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<SocialProofEntry>>({});
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => { loadEntries(); }, []);

    async function loadEntries() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('social_proof_config')
                .select('*')
                .order('display_order', { ascending: true });
            if (error) throw error;
            setEntries(data || []);
        } catch (err) {
            console.error('Error loading social proof:', err);
        } finally {
            setLoading(false);
        }
    }

    const filtered = entries.filter(e => e.proof_type === activeTab);

    function startEdit(entry: SocialProofEntry) {
        setEditingId(entry.id);
        setEditForm({ ...entry });
    }

    function cancelEdit() {
        setEditingId(null);
        setEditForm({});
    }

    async function saveEntry(id: string) {
        setSaving(true);
        setSaveStatus(null);
        try {
            const updateData: Record<string, unknown> = {
                enabled: editForm.enabled,
                region: editForm.region,
                display_order: editForm.display_order,
            };

            if (activeTab === 'toast') {
                updateData.first_names = editForm.first_names;
                updateData.last_initials = editForm.last_initials;
                updateData.message_templates = editForm.message_templates;
                updateData.time_labels = editForm.time_labels;
                updateData.show_duration_ms = editForm.show_duration_ms;
                updateData.pause_min_ms = editForm.pause_min_ms;
                updateData.pause_max_ms = editForm.pause_max_ms;
            } else if (activeTab === 'badge') {
                updateData.badge_text = editForm.badge_text;
                updateData.badge_counter = editForm.badge_counter;
                updateData.badge_counter_label = editForm.badge_counter_label;
                updateData.service_key = editForm.service_key || null;
            } else if (activeTab === 'testimonial') {
                updateData.testimonial_name = editForm.testimonial_name;
                updateData.testimonial_text = editForm.testimonial_text;
                updateData.testimonial_rating = editForm.testimonial_rating;
            }

            const { error } = await supabase
                .from('social_proof_config')
                .update(updateData)
                .eq('id', id);

            if (error) throw error;
            setSaveStatus('✅ Sauvegardé');
            setEditingId(null);
            loadEntries();
        } catch (err) {
            console.error('Error saving:', err);
            setSaveStatus('❌ Erreur de sauvegarde');
        } finally {
            setSaving(false);
            setTimeout(() => setSaveStatus(null), 3000);
        }
    }

    async function toggleEnabled(entry: SocialProofEntry) {
        try {
            await supabase
                .from('social_proof_config')
                .update({ enabled: !entry.enabled })
                .eq('id', entry.id);
            loadEntries();
        } catch (err) {
            console.error('Error toggling:', err);
        }
    }

    async function deleteEntry(id: string) {
        if (!confirm('Supprimer cette entrée ?')) return;
        try {
            await supabase.from('social_proof_config').delete().eq('id', id);
            loadEntries();
        } catch (err) {
            console.error('Error deleting:', err);
        }
    }

    async function addEntry() {
        try {
            const newEntry: Record<string, unknown> = {
                proof_type: activeTab,
                target_screen: activeTab === 'toast' ? 'wizard' : activeTab === 'badge' ? 'catalog' : 'welcome',
                enabled: true,
                region: 'all',
                display_order: filtered.length + 1,
            };

            if (activeTab === 'toast') {
                newEntry.first_names = ['Prénom1', 'Prénom2'];
                newEntry.last_initials = ['A.', 'B.'];
                newEntry.message_templates = ['🎉 {name} vient de découvrir sa compatibilité'];
                newEntry.time_labels = ['il y a 2 min', 'il y a 5 min'];
            } else if (activeTab === 'badge') {
                newEntry.badge_text = '🔥 Populaire';
                newEntry.badge_counter = 1000;
                newEntry.badge_counter_label = 'analyses cette semaine';
            } else {
                newEntry.testimonial_name = 'Nouveau Témoin';
                newEntry.testimonial_text = 'Entrez le témoignage ici...';
                newEntry.testimonial_rating = 5;
            }

            const { error } = await supabase.from('social_proof_config').insert(newEntry);
            if (error) throw error;
            loadEntries();
        } catch (err) {
            console.error('Error adding:', err);
        }
    }

    function renderToastEdit() {
        return (
            <>
                <div className="sp-field">
                    <label htmlFor="sp-first-names">Prénoms (séparés par des virgules) :</label>
                    <textarea
                        id="sp-first-names"
                        value={(editForm.first_names || []).join(', ')}
                        onChange={(e) => setEditForm({
                            ...editForm,
                            first_names: e.target.value.split(',').map(s => s.trim()).filter(Boolean)
                        })}
                        className="sp-textarea"
                        rows={3}
                    />
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-initials">Initiales (séparées par des virgules) :</label>
                    <input
                        id="sp-initials"
                        type="text"
                        value={(editForm.last_initials || []).join(', ')}
                        onChange={(e) => setEditForm({
                            ...editForm,
                            last_initials: e.target.value.split(',').map(s => s.trim()).filter(Boolean)
                        })}
                        className="sp-input"
                    />
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-templates">Messages (un par ligne, utiliser {'{name}'} pour le prénom) :</label>
                    <textarea
                        id="sp-templates"
                        value={(editForm.message_templates || []).join('\n')}
                        onChange={(e) => setEditForm({
                            ...editForm,
                            message_templates: e.target.value.split('\n').filter(Boolean)
                        })}
                        className="sp-textarea"
                        rows={4}
                    />
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-time-labels">Labels de temps (séparés par des virgules) :</label>
                    <input
                        id="sp-time-labels"
                        type="text"
                        value={(editForm.time_labels || []).join(', ')}
                        onChange={(e) => setEditForm({
                            ...editForm,
                            time_labels: e.target.value.split(',').map(s => s.trim()).filter(Boolean)
                        })}
                        className="sp-input"
                    />
                </div>
                <div className="sp-row">
                    <div className="sp-field">
                        <label htmlFor="sp-duration">Durée affichage (ms) :</label>
                        <input id="sp-duration" type="number" value={editForm.show_duration_ms ?? 4000}
                            onChange={(e) => setEditForm({ ...editForm, show_duration_ms: parseInt(e.target.value) })}
                            className="sp-input-small" />
                    </div>
                    <div className="sp-field">
                        <label htmlFor="sp-pause-min">Pause min (ms) :</label>
                        <input id="sp-pause-min" type="number" value={editForm.pause_min_ms ?? 6000}
                            onChange={(e) => setEditForm({ ...editForm, pause_min_ms: parseInt(e.target.value) })}
                            className="sp-input-small" />
                    </div>
                    <div className="sp-field">
                        <label htmlFor="sp-pause-max">Pause max (ms) :</label>
                        <input id="sp-pause-max" type="number" value={editForm.pause_max_ms ?? 12000}
                            onChange={(e) => setEditForm({ ...editForm, pause_max_ms: parseInt(e.target.value) })}
                            className="sp-input-small" />
                    </div>
                </div>
            </>
        );
    }

    function renderBadgeEdit() {
        return (
            <>
                <div className="sp-field">
                    <label htmlFor="sp-badge-text">Texte du badge :</label>
                    <input id="sp-badge-text" type="text" value={editForm.badge_text ?? ''}
                        onChange={(e) => setEditForm({ ...editForm, badge_text: e.target.value })}
                        className="sp-input" placeholder="🔥 Populaire" />
                </div>
                <div className="sp-row">
                    <div className="sp-field">
                        <label htmlFor="sp-badge-counter">Compteur :</label>
                        <input id="sp-badge-counter" type="number" value={editForm.badge_counter ?? 0}
                            onChange={(e) => setEditForm({ ...editForm, badge_counter: parseInt(e.target.value) })}
                            className="sp-input-small" />
                    </div>
                    <div className="sp-field">
                        <label htmlFor="sp-badge-label">Label du compteur :</label>
                        <input id="sp-badge-label" type="text" value={editForm.badge_counter_label ?? ''}
                            onChange={(e) => setEditForm({ ...editForm, badge_counter_label: e.target.value })}
                            className="sp-input" placeholder="analyses cette semaine" />
                    </div>
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-badge-service">Service associé :</label>
                    <select id="sp-badge-service" value={editForm.service_key ?? ''}
                        onChange={(e) => setEditForm({ ...editForm, service_key: e.target.value || null })}
                        className="sp-select">
                        {SERVICE_KEYS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
                    </select>
                </div>
            </>
        );
    }

    function renderTestimonialEdit() {
        return (
            <>
                <div className="sp-field">
                    <label htmlFor="sp-testi-name">Nom :</label>
                    <input id="sp-testi-name" type="text" value={editForm.testimonial_name ?? ''}
                        onChange={(e) => setEditForm({ ...editForm, testimonial_name: e.target.value })}
                        className="sp-input" placeholder="Marie L." />
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-testi-text">Témoignage :</label>
                    <textarea id="sp-testi-text" value={editForm.testimonial_text ?? ''}
                        onChange={(e) => setEditForm({ ...editForm, testimonial_text: e.target.value })}
                        className="sp-textarea" rows={3}
                        placeholder="Grâce à cette analyse..." />
                </div>
                <div className="sp-field">
                    <label htmlFor="sp-testi-rating">Note (1-5) :</label>
                    <div className="sp-stars">
                        {[1, 2, 3, 4, 5].map(n => (
                            <span key={n}
                                className={`sp-star ${n <= (editForm.testimonial_rating ?? 5) ? 'active' : ''}`}
                                onClick={() => setEditForm({ ...editForm, testimonial_rating: n })}
                            >★</span>
                        ))}
                    </div>
                </div>
            </>
        );
    }

    if (loading) {
        return <div className="loading">Chargement de la preuve sociale...</div>;
    }

    return (
        <div className="sp-editor">
            <h2>📢 Preuve Sociale — Éditeur</h2>
            <p className="sp-desc">
                Gérez les notifications, badges et témoignages affichés dans l'application.
            </p>

            {saveStatus && <div className="sp-status">{saveStatus}</div>}

            {/* Tabs */}
            <div className="sp-tabs">
                {TABS.map(tab => (
                    <button key={tab.key}
                        className={`sp-tab ${activeTab === tab.key ? 'active' : ''}`}
                        onClick={() => { setActiveTab(tab.key); cancelEdit(); }}>
                        {tab.label}
                    </button>
                ))}
            </div>

            {/* Entries list */}
            <div className="sp-list">
                {filtered.length === 0 && (
                    <div className="sp-empty">Aucune entrée pour ce type.</div>
                )}
                {filtered.map(entry => (
                    <div key={entry.id} className={`sp-card ${editingId === entry.id ? 'editing' : ''} ${!entry.enabled ? 'disabled' : ''}`}>
                        {editingId === entry.id ? (
                            <div className="sp-edit-form">
                                <div className="sp-row">
                                    <div className="sp-field">
                                        <label htmlFor={`sp-region-${entry.id}`}>Région :</label>
                                        <select id={`sp-region-${entry.id}`} value={editForm.region ?? 'all'}
                                            onChange={(e) => setEditForm({ ...editForm, region: e.target.value as SocialProofEntry['region'] })}
                                            className="sp-select">
                                            {REGIONS.map(r => <option key={r.value} value={r.value}>{r.label}</option>)}
                                        </select>
                                    </div>
                                    <div className="sp-field">
                                        <label htmlFor={`sp-enabled-${entry.id}`}>Actif ?</label>
                                        <input id={`sp-enabled-${entry.id}`} type="checkbox" checked={editForm.enabled ?? true}
                                            onChange={(e) => setEditForm({ ...editForm, enabled: e.target.checked })} />
                                    </div>
                                    <div className="sp-field">
                                        <label htmlFor={`sp-order-${entry.id}`}>Ordre :</label>
                                        <input id={`sp-order-${entry.id}`} type="number" value={editForm.display_order ?? 0}
                                            onChange={(e) => setEditForm({ ...editForm, display_order: parseInt(e.target.value) })}
                                            className="sp-input-small" />
                                    </div>
                                </div>

                                {activeTab === 'toast' && renderToastEdit()}
                                {activeTab === 'badge' && renderBadgeEdit()}
                                {activeTab === 'testimonial' && renderTestimonialEdit()}

                                <div className="sp-actions">
                                    <button onClick={() => saveEntry(entry.id)} disabled={saving} className="sp-save-btn">
                                        {saving ? 'Sauvegarde...' : '💾 Sauvegarder'}
                                    </button>
                                    <button onClick={cancelEdit} className="sp-cancel-btn">Annuler</button>
                                </div>
                            </div>
                        ) : (
                            <div className="sp-view">
                                <div className="sp-view-header">
                                    <span className="sp-region-badge">{REGIONS.find(r => r.value === entry.region)?.label}</span>
                                    <span className="sp-order">#{entry.display_order}</span>
                                    {activeTab === 'toast' && (
                                        <span className="sp-summary">
                                            {(entry.first_names || []).length} prénoms · {(entry.message_templates || []).length} messages
                                        </span>
                                    )}
                                    {activeTab === 'badge' && (
                                        <span className="sp-summary">
                                            {entry.badge_text} — {entry.badge_counter} {entry.badge_counter_label}
                                            {(entry as any).service_key && <span className="sp-service-tag"> 🏷️ {(entry as any).service_key}</span>}
                                        </span>
                                    )}
                                    {activeTab === 'testimonial' && (
                                        <span className="sp-summary">
                                            {'★'.repeat(entry.testimonial_rating ?? 5)} {entry.testimonial_name} — "{(entry.testimonial_text ?? '').slice(0, 60)}..."
                                        </span>
                                    )}
                                    <span className={`sp-toggle ${entry.enabled ? 'on' : 'off'}`}
                                        onClick={() => toggleEnabled(entry)}>
                                        {entry.enabled ? '✅' : '❌'}
                                    </span>
                                </div>
                                <div className="sp-view-actions">
                                    <button onClick={() => startEdit(entry)} className="sp-edit-btn">✏️ Modifier</button>
                                    <button onClick={() => deleteEntry(entry.id)} className="sp-delete-btn">🗑️</button>
                                </div>
                            </div>
                        )}
                    </div>
                ))}
            </div>

            {/* Add button */}
            <button onClick={addEntry} className="sp-add-btn">
                + Ajouter {activeTab === 'toast' ? 'une notification' : activeTab === 'badge' ? 'un badge' : 'un témoignage'}
            </button>

            <style>{`
                .sp-editor { padding: 24px; max-width: 900px; }
                .sp-editor h2 { color: #f0e68c; margin-bottom: 8px; }
                .sp-desc { color: rgba(255,255,255,0.7); margin-bottom: 20px; }
                .sp-status { padding: 10px; border-radius: 8px; background: rgba(100,255,100,0.1); margin-bottom: 12px; text-align: center; }
                
                .sp-tabs { display: flex; gap: 8px; margin-bottom: 20px; }
                .sp-tab {
                    padding: 10px 18px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.15);
                    background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.7); cursor: pointer;
                    font-size: 14px; transition: all 0.2s;
                }
                .sp-tab.active { background: rgba(159,122,234,0.2); border-color: rgba(159,122,234,0.5); color: white; font-weight: 600; }
                .sp-tab:hover { background: rgba(159,122,234,0.1); }

                .sp-list { display: flex; flex-direction: column; gap: 12px; }
                .sp-card {
                    background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 12px; padding: 16px; transition: all 0.3s;
                }
                .sp-card.editing { background: rgba(159,122,234,0.1); border-color: rgba(159,122,234,0.3); }
                .sp-card.disabled { opacity: 0.5; }
                .sp-empty { text-align: center; padding: 32px; color: rgba(255,255,255,0.4); }

                .sp-view-header { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
                .sp-region-badge { background: rgba(100,200,255,0.15); color: #7dd3fc; padding: 2px 8px; border-radius: 4px; font-size: 12px; }
                .sp-order { color: #c4b5fd; font-size: 12px; font-weight: 600; }
                .sp-summary { flex: 1; color: rgba(255,255,255,0.8); font-size: 14px; }
                .sp-toggle { cursor: pointer; font-size: 16px; }
                .sp-service-tag { background: rgba(159,122,234,0.2); color: #c4b5fd; padding: 2px 6px; border-radius: 4px; font-size: 11px; margin-left: 6px; }

                .sp-view-actions { display: flex; gap: 8px; margin-top: 10px; }
                .sp-edit-btn {
                    background: linear-gradient(135deg, #667eea, #9f7aea); border: none; color: white;
                    padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px;
                }
                .sp-delete-btn {
                    background: rgba(255,100,100,0.15); border: 1px solid rgba(255,100,100,0.3);
                    color: #fca5a5; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 13px;
                }
                .sp-delete-btn:hover { background: rgba(255,100,100,0.25); }

                .sp-edit-form { display: flex; flex-direction: column; gap: 12px; }
                .sp-field { display: flex; flex-direction: column; gap: 4px; flex: 1; }
                .sp-field label { color: rgba(255,255,255,0.7); font-size: 12px; font-weight: 600; }
                .sp-row { display: flex; gap: 12px; flex-wrap: wrap; }

                .sp-input, .sp-textarea, .sp-select {
                    background: rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 6px; color: white; padding: 8px 12px; font-size: 13px;
                }
                .sp-textarea { resize: vertical; font-family: inherit; }
                .sp-input-small { width: 90px; background: rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 6px; color: white; padding: 8px; font-size: 13px; text-align: center; }
                .sp-select { cursor: pointer; }

                .sp-stars { display: flex; gap: 4px; }
                .sp-star { font-size: 24px; cursor: pointer; color: rgba(255,255,255,0.2); transition: color 0.2s; }
                .sp-star.active { color: #fbbf24; }
                .sp-star:hover { color: #fbbf24; }

                .sp-actions { display: flex; gap: 12px; margin-top: 8px; }
                .sp-save-btn {
                    background: linear-gradient(135deg, #48bb78, #38a169); border: none; color: white;
                    padding: 10px 20px; border-radius: 6px; cursor: pointer; font-size: 14px;
                }
                .sp-save-btn:disabled { opacity: 0.5; }
                .sp-cancel-btn {
                    background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2);
                    color: white; padding: 10px 20px; border-radius: 6px; cursor: pointer;
                }

                .sp-add-btn {
                    margin-top: 16px; width: 100%; padding: 12px; border-radius: 8px;
                    border: 2px dashed rgba(159,122,234,0.3); background: rgba(159,122,234,0.05);
                    color: rgba(159,122,234,0.8); cursor: pointer; font-size: 14px; transition: all 0.2s;
                }
                .sp-add-btn:hover { background: rgba(159,122,234,0.1); border-color: rgba(159,122,234,0.5); color: white; }
            `}</style>
        </div>
    );
}
