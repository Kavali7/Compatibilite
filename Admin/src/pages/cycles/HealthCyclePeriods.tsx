import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

interface HealthPeriod {
    id: string;
    period_number: number;
    period_name: string;
    theme_central: string;
    etat_energetique: string;
    points_vigilance: string[];
    activites_recommandees: string[];
    activites_moderer: string[];
    alimentation_privilegier: string[];
    alimentation_eviter: string[];
    repos_sommeil: string;
    conseils_pratiques: string[];
    affirmation_bien_etre: string;
    enseignement: string;
    avertissement: string;
    is_active: boolean;
    updated_at: string;
}

export default function HealthCyclePeriods() {
    const [periods, setPeriods] = useState<HealthPeriod[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editForm, setEditForm] = useState<Partial<HealthPeriod>>({});

    useEffect(() => { loadPeriods(); }, []);

    async function loadPeriods() {
        setLoading(true);
        try {
            const { data, error: fetchError } = await supabase
                .from('health_cycle_periods')
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

    function startEdit(p: HealthPeriod) {
        setEditingId(p.id);
        setEditForm({
            period_name: p.period_name,
            theme_central: p.theme_central,
            etat_energetique: p.etat_energetique,
            repos_sommeil: p.repos_sommeil,
            affirmation_bien_etre: p.affirmation_bien_etre,
            enseignement: p.enseignement,
            avertissement: p.avertissement,
            is_active: p.is_active,
        });
    }

    async function saveEdit() {
        if (!editingId) return;
        try {
            const { error: updateError } = await supabase
                .from('health_cycle_periods')
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
        <div className="page health-cycle">
            <h2 className="page-title">🏥 Cycle Santé</h2>
            <p className="page-subtitle">
                Les 7 périodes du cycle santé et bien-être
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
                                <span className="cycle-badge cycle-badge--health">
                                    S{period.period_number}
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
                                    <button onClick={() => startEdit(period)} className="btn-cycle-edit btn-cycle-edit--health">✏️ Modifier</button>
                                )}
                            </div>
                        </div>

                        {editingId === period.id ? (
                            <div className="cycle-edit-grid">
                                <div className="cycle-edit-row">
                                    <div className="cycle-form-field">
                                        <label htmlFor={`name_health_${period.id}`}>Nom</label>
                                        <input id={`name_health_${period.id}`} type="text" value={editForm.period_name || ''} onChange={e => setEditForm({ ...editForm, period_name: e.target.value })} />
                                    </div>
                                    <div className="cycle-form-field">
                                        <label htmlFor={`theme_health_${period.id}`}>Thème central</label>
                                        <input id={`theme_health_${period.id}`} type="text" value={editForm.theme_central || ''} onChange={e => setEditForm({ ...editForm, theme_central: e.target.value })} />
                                    </div>
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`etat_health_${period.id}`}>État énergétique</label>
                                    <textarea id={`etat_health_${period.id}`} value={editForm.etat_energetique || ''} onChange={e => setEditForm({ ...editForm, etat_energetique: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`repos_health_${period.id}`}>Repos & Sommeil</label>
                                    <textarea id={`repos_health_${period.id}`} className="short" value={editForm.repos_sommeil || ''} onChange={e => setEditForm({ ...editForm, repos_sommeil: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`affirm_health_${period.id}`}>Affirmation bien-être</label>
                                    <textarea id={`affirm_health_${period.id}`} className="short" value={editForm.affirmation_bien_etre || ''} onChange={e => setEditForm({ ...editForm, affirmation_bien_etre: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`enseign_health_${period.id}`}>Enseignement</label>
                                    <textarea id={`enseign_health_${period.id}`} className="short" value={editForm.enseignement || ''} onChange={e => setEditForm({ ...editForm, enseignement: e.target.value })} />
                                </div>
                                <div className="cycle-form-field">
                                    <label htmlFor={`avert_health_${period.id}`}>Avertissement médical</label>
                                    <textarea id={`avert_health_${period.id}`} className="compact" value={editForm.avertissement || ''} onChange={e => setEditForm({ ...editForm, avertissement: e.target.value })} />
                                </div>
                                <div className="cycle-checkbox-field">
                                    <input type="checkbox" checked={editForm.is_active} onChange={e => setEditForm({ ...editForm, is_active: e.target.checked })} id={`is_active_health_${period.id}`} />
                                    <label htmlFor={`is_active_health_${period.id}`}>Période active</label>
                                </div>
                            </div>
                        ) : (
                            <div className="cycle-view-grid">
                                <div><strong>État:</strong> {period.etat_energetique?.substring(0, 200)}...</div>
                                <div><strong>Repos:</strong> {period.repos_sommeil?.substring(0, 150)}...</div>
                                {period.points_vigilance?.length > 0 && (
                                    <div><strong>⚠️ Vigilance:</strong> {period.points_vigilance.join(', ').substring(0, 150)}...</div>
                                )}
                            </div>
                        )}
                    </div>
                ))
            )}
        </div>
    );
}
