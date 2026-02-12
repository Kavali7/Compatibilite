import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface LunarPhase {
    id: string;
    phase_number: number;
    phase_name: string;
    phase_key: string;
    theme: string;
    energy_type: string;
    full_content: string;
    activities_favorables: string[];
    activities_eviter: string[];
    conseil: string;
    duration_days: number;
    is_active: boolean;
    created_at: string;
}

const MOON_EMOJIS = ['🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘'];

export default function LunarPhases() {
    const [phases, setPhases] = useState<LunarPhase[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<LunarPhase>>({});

    useEffect(() => { loadPhases(); }, []);

    async function loadPhases() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('lunar_phases')
                .select('*')
                .order('phase_number');
            if (fetchError) throw fetchError;
            setPhases(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(p: LunarPhase) {
        setEditingId(p.id);
        setEditForm({
            phase_name: p.phase_name,
            theme: p.theme,
            energy_type: p.energy_type,
            full_content: p.full_content,
            conseil: p.conseil,
            is_active: p.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('lunar_phases')
                .update(editForm)
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadPhases();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    return (
        <div className="page lunar-phases">
            <h2 className="page-title">🌙 Timing Lunaire</h2>
            <p className="page-subtitle">
                Les 8 phases lunaires et leurs influences (~3.7 jours chacune)
            </p>

            <div className="cycle-summary-bar">
                <strong>{phases.length}</strong> phases ({phases.filter(p => p.is_active).length} actives)
                {' • '} Cycle lunaire: 29.53 jours
            </div>

            {error && <div className="error-inline">{error}</div>}

            {loading ? (
                <div className="loading-message--compact">Chargement...</div>
            ) : (
                phases.map(phase => (
                    <div key={phase.id} className={`cycle-card${editingId === phase.id ? ' cycle-card--editing' : ''}${!phase.is_active ? ' cycle-card--inactive' : ''}`}>
                        <div className="cycle-card__header">
                            <div className="cycle-card__title-group">
                                <span className="cycle-card__moon-icon">
                                    {MOON_EMOJIS[phase.phase_number - 1] || '🌙'}
                                </span>
                                <span className="cycle-badge cycle-badge--lunar">
                                    {phase.phase_number}
                                </span>
                                <span className="cycle-card__name">{phase.phase_name}</span>
                                <span className="cycle-card__theme">
                                    {phase.theme} • Énergie: {phase.energy_type}
                                </span>
                            </div>
                            <div>
                                {editingId === phase.id ? (
                                    <>
                                        <button onClick={saveEdit} className="btn-cycle-save">✓ Sauvegarder</button>
                                        <button onClick={() => setEditingId(null)} className="btn-cycle-cancel">✗ Annuler</button>
                                    </>
                                ) : (
                                    <button onClick={() => startEdit(phase)} className="btn-cycle-edit btn-cycle-edit--lunar">✏️ Modifier</button>
                                )}
                            </div>
                        </div>

                        {editingId === phase.id ? (
                            <div className="cycle-edit-grid">
                                <div className="cycle-edit-row">
                                    <div className="cycle-form-field">
                                        <label htmlFor={`name_lunar_${phase.id}`}>Nom de la phase</label>
                                        <input id={`name_lunar_${phase.id}`} type="text" value={editForm.phase_name || ''} onChange={e => setEditForm({ ...editForm, phase_name: e.target.value })} />
                                    </div>
                                    <div className="cycle-form-field">
                                        <label htmlFor={`theme_lunar_${phase.id}`}>Thème</label>
                                        <input id={`theme_lunar_${phase.id}`} type="text" value={editForm.theme || ''} onChange={e => setEditForm({ ...editForm, theme: e.target.value })} />
                                    </div>
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`energy_lunar_${phase.id}`}>Type d'énergie</label>
                                    <input id={`energy_lunar_${phase.id}`} type="text" value={editForm.energy_type || ''} onChange={e => setEditForm({ ...editForm, energy_type: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`content_lunar_${phase.id}`}>Contenu complet</label>
                                    <textarea id={`content_lunar_${phase.id}`} className="tall" value={editForm.full_content || ''} onChange={e => setEditForm({ ...editForm, full_content: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`conseil_lunar_${phase.id}`}>Conseil</label>
                                    <textarea id={`conseil_lunar_${phase.id}`} value={editForm.conseil || ''} onChange={e => setEditForm({ ...editForm, conseil: e.target.value })} />
                                </div>
                                <div className="cycle-checkbox-field">
                                    <input type="checkbox" checked={editForm.is_active} onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })} id={`is_active_lunar_${phase.id}`} />
                                    <label htmlFor={`is_active_lunar_${phase.id}`}>Phase active</label>
                                </div>
                            </div>
                        ) : (
                            <div className="cycle-view-grid">
                                <div><strong>Contenu:</strong> {phase.full_content?.substring(0, 250)}...</div>
                                <div><strong>Conseil:</strong> {phase.conseil?.substring(0, 150)}...</div>
                                <div className="cycle-view-activities">
                                    {phase.activities_favorables?.length > 0 && (
                                        <span className="cycle-view-favorable">✅ {phase.activities_favorables.length} activités favorables</span>
                                    )}
                                    {phase.activities_eviter?.length > 0 && (
                                        <span className="cycle-view-avoid">❌ {phase.activities_eviter.length} à éviter</span>
                                    )}
                                </div>
                            </div>
                        )}
                    </div>
                ))
            )}
        </div>
    );
}
