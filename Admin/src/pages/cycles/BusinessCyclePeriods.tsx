import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface BusinessPeriod {
    id: string;
    period_number: number;
    period_name: string;
    theme_central: string;
    focus_strategique: string;
    energie_business: string;
    fenetre_strategique: any;
    actions_recommandees: string[];
    risques_eviter: string[];
    indicateurs_cles: any;
    decisions_favorables: string[];
    decisions_defavorables: string[];
    astuce_strategique: string;
    is_active: boolean;
    updated_at: string;
}

export default function BusinessCyclePeriods() {
    const [periods, setPeriods] = useState<BusinessPeriod[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<BusinessPeriod>>({});

    useEffect(() => { loadPeriods(); }, []);

    async function loadPeriods() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('business_cycle_periods')
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

    function startEdit(p: BusinessPeriod) {
        setEditingId(p.id);
        setEditForm({
            period_name: p.period_name,
            theme_central: p.theme_central,
            focus_strategique: p.focus_strategique,
            energie_business: p.energie_business,
            astuce_strategique: p.astuce_strategique,
            is_active: p.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('business_cycle_periods')
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
        <div className="page business-cycle">
            <h2 className="page-title">💼 Cycle Business</h2>
            <p className="page-subtitle">
                Les 7 périodes du cycle business annuel pour la stratégie d'entreprise
            </p>

            <div className="cycle-summary-bar">
                <strong>{periods.length}</strong> périodes ({periods.filter(p => p.is_active).length} actives)
            </div>

            {error && <div className="error-inline">{error}</div>}

            {loading ? (
                <div className="loading-message--compact">Chargement...</div>
            ) : (
                periods.map(period => (
                    <div key={period.id} className={`cycle-card${editingId === period.id ? ' cycle-card--editing' : ''}${!period.is_active ? ' cycle-card--inactive' : ''}`}>
                        <div className="cycle-card__header">
                            <div className="cycle-card__title-group">
                                <span className="cycle-badge cycle-badge--business">
                                    B{period.period_number}
                                </span>
                                <span className="cycle-card__name">{period.period_name}</span>
                                <span className="cycle-card__theme">{period.theme_central}</span>
                            </div>
                            <div>
                                {editingId === period.id ? (
                                    <>
                                        <button onClick={saveEdit} className="btn-cycle-save">✓ Sauvegarder</button>
                                        <button onClick={() => setEditingId(null)} className="btn-cycle-cancel">✗ Annuler</button>
                                    </>
                                ) : (
                                    <button onClick={() => startEdit(period)} className="btn-cycle-edit btn-cycle-edit--business">✏️ Modifier</button>
                                )}
                            </div>
                        </div>

                        {editingId === period.id ? (
                            <div className="cycle-edit-grid">
                                <div className="cycle-edit-row">
                                    <div className="cycle-form-field">
                                        <label htmlFor={`name_biz_${period.id}`}>Nom</label>
                                        <input id={`name_biz_${period.id}`} type="text" value={editForm.period_name || ''} onChange={e => setEditForm({ ...editForm, period_name: e.target.value })} />
                                    </div>
                                    <div className="cycle-form-field">
                                        <label htmlFor={`theme_biz_${period.id}`}>Thème central</label>
                                        <input id={`theme_biz_${period.id}`} type="text" value={editForm.theme_central || ''} onChange={e => setEditForm({ ...editForm, theme_central: e.target.value })} />
                                    </div>
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`focus_biz_${period.id}`}>Focus stratégique</label>
                                    <textarea id={`focus_biz_${period.id}`} value={editForm.focus_strategique || ''} onChange={e => setEditForm({ ...editForm, focus_strategique: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`energy_biz_${period.id}`}>Énergie business</label>
                                    <textarea id={`energy_biz_${period.id}`} value={editForm.energie_business || ''} onChange={e => setEditForm({ ...editForm, energie_business: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`tip_biz_${period.id}`}>Astuce stratégique</label>
                                    <textarea id={`tip_biz_${period.id}`} className="short" value={editForm.astuce_strategique || ''} onChange={e => setEditForm({ ...editForm, astuce_strategique: e.target.value })} />
                                </div>
                                <div className="cycle-checkbox-field">
                                    <input type="checkbox" checked={editForm.is_active} onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })} id={`is_active_biz_${period.id}`} />
                                    <label htmlFor={`is_active_biz_${period.id}`}>Période active</label>
                                </div>
                            </div>
                        ) : (
                            <div className="cycle-view-grid">
                                <div><strong>Focus:</strong> {period.focus_strategique?.substring(0, 200)}...</div>
                                <div><strong>Énergie:</strong> {period.energie_business?.substring(0, 150)}...</div>
                                {period.actions_recommandees?.length > 0 && (
                                    <div><strong>Actions:</strong> {period.actions_recommandees.length} recommandation(s)</div>
                                )}
                            </div>
                        )}
                    </div>
                ))
            )}
        </div>
    );
}
