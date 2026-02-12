import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface LifePhase {
    id: string;
    phase_number: number;
    phase_name: string;
    age_start: number;
    age_end: number;
    theme: string;
    full_content: string;
    impacts: string[];
    questions_reflection: string[];
    travail_guerison: string[];
    is_active: boolean;
}

export default function LifePhases() {
    const [phases, setPhases] = useState<LifePhase[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<LifePhase>>({});

    useEffect(() => { loadPhases(); }, []);

    async function loadPhases() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('life_phase_periods')
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

    function startEdit(p: LifePhase) {
        setEditingId(p.id);
        setEditForm({
            phase_name: p.phase_name,
            theme: p.theme,
            full_content: p.full_content,
            is_active: p.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('life_phase_periods')
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
        <div className="page life-phases">
            <h2 className="page-title">🔮 Phases de Vie</h2>
            <p className="page-subtitle">
                Les 10 phases de vie (cycles de 7 ans) — de 0 à 70+ ans
            </p>

            <div className="cycle-summary-bar">
                <strong>{phases.length}</strong> phases ({phases.filter(p => p.is_active).length} actives)
            </div>

            {error && <div className="error-inline">{error}</div>}

            {loading ? (
                <div className="loading-message--compact">Chargement...</div>
            ) : (
                phases.map(phase => (
                    <div key={phase.id} className={`cycle-card${editingId === phase.id ? ' cycle-card--editing' : ''}${!phase.is_active ? ' cycle-card--inactive' : ''}`}>
                        <div className="cycle-card__header">
                            <div className="cycle-card__title-group">
                                <span className="cycle-badge cycle-badge--phase">
                                    Phase {phase.phase_number}
                                </span>
                                <span className="cycle-card__name">{phase.phase_name}</span>
                                <span className="cycle-card__theme">
                                    {phase.age_start}-{phase.age_end} ans • {phase.theme}
                                </span>
                            </div>
                            <div>
                                {editingId === phase.id ? (
                                    <>
                                        <button onClick={saveEdit} className="btn-cycle-save">✓ Sauvegarder</button>
                                        <button onClick={() => setEditingId(null)} className="btn-cycle-cancel">✗ Annuler</button>
                                    </>
                                ) : (
                                    <button onClick={() => startEdit(phase)} className="btn-cycle-edit btn-cycle-edit--phase">✏️ Modifier</button>
                                )}
                            </div>
                        </div>

                        {editingId === phase.id ? (
                            <div className="cycle-edit-grid">
                                <div className="cycle-edit-row">
                                    <div className="cycle-form-field">
                                        <label htmlFor={`name_lp_${phase.id}`}>Nom de la phase</label>
                                        <input id={`name_lp_${phase.id}`} type="text" value={editForm.phase_name || ''} onChange={e => setEditForm({ ...editForm, phase_name: e.target.value })} />
                                    </div>
                                    <div className="cycle-form-field">
                                        <label htmlFor={`theme_lp_${phase.id}`}>Thème</label>
                                        <input id={`theme_lp_${phase.id}`} type="text" value={editForm.theme || ''} onChange={e => setEditForm({ ...editForm, theme: e.target.value })} />
                                    </div>
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`content_lp_${phase.id}`}>Contenu complet</label>
                                    <textarea id={`content_lp_${phase.id}`} className="very-tall" value={editForm.full_content || ''} onChange={e => setEditForm({ ...editForm, full_content: e.target.value })} />
                                </div>
                                <div className="cycle-checkbox-field">
                                    <input type="checkbox" checked={editForm.is_active} onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })} id={`is_active_lp_${phase.id}`} />
                                    <label htmlFor={`is_active_lp_${phase.id}`}>Phase active</label>
                                </div>
                            </div>
                        ) : (
                            <div className="cycle-view-grid">
                                <div><strong>Contenu:</strong> {phase.full_content?.substring(0, 250)}...</div>
                                {phase.impacts?.length > 0 && (
                                    <div><strong>Impacts:</strong> {phase.impacts.join(', ').substring(0, 150)}...</div>
                                )}
                                {phase.questions_reflection?.length > 0 && (
                                    <div><strong>Questions:</strong> {phase.questions_reflection.length} question(s)</div>
                                )}
                            </div>
                        )}
                    </div>
                ))
            )}
        </div>
    );
}
