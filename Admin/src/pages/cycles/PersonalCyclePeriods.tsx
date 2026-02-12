import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface PersonalPeriod {
    id: string;
    period_number: number;
    period_name: string;
    theme_central: string;
    day_start: number;
    day_end: number;
    energie_periode: string;
    description_theme: string;
    domaines_favorables: any;
    domaines_eviter: any;
    conseils: string[];
    affirmation: string;
    influence_decisions: string;
    enseignement: string;
    is_active: boolean;
    updated_at: string;
}

export default function PersonalCyclePeriods() {
    const [periods, setPeriods] = useState<PersonalPeriod[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<PersonalPeriod>>({});

    useEffect(() => { loadPeriods(); }, []);

    async function loadPeriods() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('personal_cycle_periods')
                .select('*')
                .order('period_number');
            if (fetchError) throw fetchError;
            setPeriods(data || []);
        } catch (e: any) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    }

    function startEdit(p: PersonalPeriod) {
        setEditingId(p.id);
        setEditForm({
            period_name: p.period_name,
            theme_central: p.theme_central,
            energie_periode: p.energie_periode,
            description_theme: p.description_theme,
            affirmation: p.affirmation,
            influence_decisions: p.influence_decisions,
            enseignement: p.enseignement,
            is_active: p.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('personal_cycle_periods')
                .update({ ...editForm, updated_at: new Date().toISOString() })
                .eq('id', editingId);
            if (updateError) throw updateError;
            setEditingId(null);
            loadPeriods();
        } catch (e: any) {
            alert('Erreur: ' + e.message);
        }
    }

    return (
        <div className="page personal-cycle">
            <h2 className="page-title">🔄 Cycle Personnel</h2>
            <p className="page-subtitle">
                Les 7 périodes du cycle annuel personnel basé sur la date d'anniversaire
            </p>

            <div className="cycle-summary-bar">
                <strong>{periods.length}</strong> périodes ({periods.filter(p => p.is_active).length} actives)
                {' • '} Durée: ~52 jours chacune
            </div>

            {error && <div className="error-inline">{error}</div>}

            {loading ? (
                <div className="loading-message--compact">Chargement...</div>
            ) : (
                periods.map(period => (
                    <div key={period.id} className={`cycle-card${editingId === period.id ? ' cycle-card--editing' : ''}${!period.is_active ? ' cycle-card--inactive' : ''}`}>
                        <div className="cycle-card__header">
                            <div className="cycle-card__title-group">
                                <span className="cycle-badge cycle-badge--personal">
                                    P{period.period_number}
                                </span>
                                <span className="cycle-card__name">{period.period_name}</span>
                                <span className="cycle-card__theme">
                                    J{period.day_start}-J{period.day_end} • {period.theme_central}
                                </span>
                            </div>
                            <div>
                                {editingId === period.id ? (
                                    <>
                                        <button onClick={saveEdit} className="btn-cycle-save">✓ Sauvegarder</button>
                                        <button onClick={() => setEditingId(null)} className="btn-cycle-cancel">✗ Annuler</button>
                                    </>
                                ) : (
                                    <button onClick={() => startEdit(period)} className="btn-cycle-edit btn-cycle-edit--personal">✏️ Modifier</button>
                                )}
                            </div>
                        </div>

                        {editingId === period.id ? (
                            <div className="cycle-edit-grid">
                                <div className="cycle-edit-row">
                                    <div className="cycle-form-field">
                                        <label htmlFor={`name_pers_${period.id}`}>Nom</label>
                                        <input id={`name_pers_${period.id}`} type="text" value={editForm.period_name || ''} onChange={e => setEditForm({ ...editForm, period_name: e.target.value })} />
                                    </div>
                                    <div className="cycle-form-field">
                                        <label htmlFor={`theme_pers_${period.id}`}>Thème</label>
                                        <input id={`theme_pers_${period.id}`} type="text" value={editForm.theme_central || ''} onChange={e => setEditForm({ ...editForm, theme_central: e.target.value })} />
                                    </div>
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`energy_pers_${period.id}`}>Énergie de la période</label>
                                    <textarea id={`energy_pers_${period.id}`} value={editForm.energie_periode || ''} onChange={e => setEditForm({ ...editForm, energie_periode: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`desc_pers_${period.id}`}>Description du thème</label>
                                    <textarea id={`desc_pers_${period.id}`} value={editForm.description_theme || ''} onChange={e => setEditForm({ ...editForm, description_theme: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`affirm_pers_${period.id}`}>Affirmation</label>
                                    <textarea id={`affirm_pers_${period.id}`} className="short" value={editForm.affirmation || ''} onChange={e => setEditForm({ ...editForm, affirmation: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`influence_pers_${period.id}`}>Influence sur les décisions</label>
                                    <textarea id={`influence_pers_${period.id}`} className="short" value={editForm.influence_decisions || ''} onChange={e => setEditForm({ ...editForm, influence_decisions: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`enseign_pers_${period.id}`}>Enseignement</label>
                                    <textarea id={`enseign_pers_${period.id}`} className="short" value={editForm.enseignement || ''} onChange={e => setEditForm({ ...editForm, enseignement: e.target.value })} />
                                </div>
                                <div className="cycle-checkbox-field">
                                    <input type="checkbox" checked={editForm.is_active} onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })} id={`is_active_pers_${period.id}`} />
                                    <label htmlFor={`is_active_pers_${period.id}`}>Période active</label>
                                </div>
                            </div>
                        ) : (
                            <div className="cycle-view-grid">
                                <div><strong>Énergie:</strong> {period.energie_periode?.substring(0, 200)}...</div>
                                <div><strong>Affirmation:</strong> {period.affirmation?.substring(0, 150)}...</div>
                                {period.conseils?.length > 0 && (
                                    <div><strong>Conseils:</strong> {period.conseils.length} conseil(s)</div>
                                )}
                            </div>
                        )}
                    </div>
                ))
            )}
        </div>
    );
}
