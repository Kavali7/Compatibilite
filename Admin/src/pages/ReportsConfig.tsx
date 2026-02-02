import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

interface ReportSection {
    id: string;
    service_type: string;
    section_key: string;
    section_label: string;
    is_visible: boolean;
    display_order: number;
    custom_text: string | null;
    default_text: string | null;
}

// Services that have configurable reports
const REPORT_SERVICES = [
    { id: 'compatibilite', label: '💑 Rapport de Compatibilité', sections: ['intro', 'compatibility_score', 'strengths', 'challenges', 'advice', 'conclusion'] },
    { id: 'portrait_ame', label: '✨ Portrait de l\'Âme', sections: ['intro', 'life_path', 'expression', 'soul_urge', 'personality', 'challenges', 'advice'] },
    { id: 'prevision_annee', label: '📆 Prévision Annuelle', sections: ['intro', 'general', 'love', 'career', 'health', 'finances', 'advice'] },
    { id: 'prevision_mois', label: '📅 Prévision Mensuelle', sections: ['intro', 'general', 'focus', 'opportunities', 'advice'] },
    { id: 'cycle_personnel', label: '🔄 Cycle Personnel', sections: ['intro', 'current_period', 'energy', 'focus', 'advice'] },
    { id: 'cycle_business', label: '💼 Cycle Business', sections: ['intro', 'current_period', 'business_energy', 'opportunities', 'risks', 'advice'] },
    { id: 'cycle_sante', label: '🏥 Cycle Santé', sections: ['intro', 'current_period', 'vitality', 'attention_areas', 'wellness_tips', 'advice'] },
    { id: 'guide_horaire', label: '⏰ Guide Horaire', sections: ['intro', 'morning', 'afternoon', 'evening', 'best_hours', 'advice'] },
    { id: 'eclairage_decision', label: '💡 Éclairage Décision', sections: ['intro', 'context', 'pros', 'cons', 'timing', 'recommendation'] },
    { id: 'phases_vie', label: '🔄 Phases de Vie', sections: ['intro', 'current_phase', 'lessons', 'opportunities', 'transition'] },
    { id: 'timing_lunaire', label: '🌙 Timing Lunaire', sections: ['intro', 'current_phase', 'moon_influence', 'activities', 'advice'] },
];

const SECTION_LABELS: Record<string, string> = {
    'intro': 'Introduction',
    'compatibility_score': 'Score de Compatibilité',
    'strengths': 'Points Forts',
    'challenges': 'Défis',
    'advice': 'Conseils',
    'conclusion': 'Conclusion',
    'life_path': 'Chemin de Vie',
    'expression': 'Nombre d\'Expression',
    'soul_urge': 'Désir de l\'Âme',
    'personality': 'Personnalité',
    'general': 'Tendances Générales',
    'love': 'Amour & Relations',
    'career': 'Carrière',
    'health': 'Santé',
    'finances': 'Finances',
    'focus': 'Focus du Mois',
    'opportunities': 'Opportunités',
    'current_period': 'Période Actuelle',
    'energy': 'Énergie',
    'current_phase': 'Phase Actuelle',
    'lessons': 'Leçons',
    'transition': 'Transition',
    // Cycle Business
    'business_energy': 'Énergie Business',
    'risks': 'Risques à Éviter',
    // Cycle Santé
    'vitality': 'Vitalité',
    'attention_areas': 'Zones d\'Attention',
    'wellness_tips': 'Conseils Bien-être',
    // Guide Horaire
    'morning': 'Matinée',
    'afternoon': 'Après-midi',
    'evening': 'Soirée',
    'best_hours': 'Meilleures Heures',
    // Éclairage Décision
    'context': 'Contexte',
    'pros': 'Points Positifs',
    'cons': 'Points Négatifs',
    'timing': 'Timing Idéal',
    'recommendation': 'Recommandation',
    // Timing Lunaire
    'moon_influence': 'Influence Lunaire',
    'activities': 'Activités Favorables',
};

export default function ReportsConfig() {
    const [sections, setSections] = useState<ReportSection[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeService, setActiveService] = useState(REPORT_SERVICES[0].id);
    const [editingSection, setEditingSection] = useState<string | null>(null);
    const [editText, setEditText] = useState('');
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        loadSections();
    }, []);

    async function loadSections() {
        setLoading(true);
        setError(null);
        try {
            // Try to load existing sections from report_sections table
            const { data, error: fetchError } = await supabase
                .from('report_sections')
                .select('*')
                .order('service_type')
                .order('display_order');

            if (fetchError) {
                // Table might not exist, create default structure
                console.log('Creating default sections structure');
                const defaultSections = generateDefaultSections();
                setSections(defaultSections);
            } else {
                setSections(data || []);
            }
        } catch (e: any) {
            console.error('Error loading sections:', e);
            // Fallback to default structure
            setSections(generateDefaultSections());
        }
        setLoading(false);
    }

    function generateDefaultSections(): ReportSection[] {
        const defaults: ReportSection[] = [];
        REPORT_SERVICES.forEach(service => {
            service.sections.forEach((section, idx) => {
                defaults.push({
                    id: `${service.id}_${section}`,
                    service_type: service.id,
                    section_key: section,
                    section_label: SECTION_LABELS[section] || section,
                    is_visible: true,
                    display_order: idx + 1,
                    custom_text: null,
                    default_text: null,
                });
            });
        });
        return defaults;
    }

    async function toggleVisibility(sectionId: string) {
        const section = sections.find(s => s.id === sectionId);
        if (!section) return;

        setSaving(true);
        try {
            // Try to update in database
            const { error: updateError } = await supabase
                .from('report_sections')
                .upsert({
                    id: sectionId,
                    service_type: section.service_type,
                    section_key: section.section_key,
                    section_label: section.section_label,
                    is_visible: !section.is_visible,
                    display_order: section.display_order,
                    custom_text: section.custom_text,
                });

            if (updateError) throw updateError;

            // Update local state
            setSections(prev => prev.map(s =>
                s.id === sectionId ? { ...s, is_visible: !s.is_visible } : s
            ));
        } catch (e: any) {
            console.error('Error updating visibility:', e);
            // Still update locally if DB fails
            setSections(prev => prev.map(s =>
                s.id === sectionId ? { ...s, is_visible: !s.is_visible } : s
            ));
        }
        setSaving(false);
    }

    async function saveCustomText(sectionId: string) {
        const section = sections.find(s => s.id === sectionId);
        if (!section) return;

        setSaving(true);
        try {
            const { error: updateError } = await supabase
                .from('report_sections')
                .upsert({
                    id: sectionId,
                    service_type: section.service_type,
                    section_key: section.section_key,
                    section_label: section.section_label,
                    is_visible: section.is_visible,
                    display_order: section.display_order,
                    custom_text: editText || null,
                });

            if (updateError) throw updateError;

            setSections(prev => prev.map(s =>
                s.id === sectionId ? { ...s, custom_text: editText || null } : s
            ));
            setEditingSection(null);
        } catch (e: any) {
            console.error('Error saving text:', e);
            setError(e.message);
        }
        setSaving(false);
    }

    function startEditing(section: ReportSection) {
        setEditingSection(section.id);
        setEditText(section.custom_text || '');
    }

    const serviceSections = sections.filter(s => s.service_type === activeService);
    const currentService = REPORT_SERVICES.find(s => s.id === activeService);

    if (loading) {
        return <div className="page-loading">Chargement de la configuration...</div>;
    }

    return (
        <div className="page reports-config">
            <header className="page-header">
                <h1>📝 Configuration des Rapports</h1>
                <p className="muted">
                    Activez/désactivez ou personnalisez les sections de chaque type de rapport.
                </p>
            </header>

            {error && <div className="error-banner">{error}</div>}

            {/* Service Tabs */}
            <div className="service-tabs">
                {REPORT_SERVICES.map(service => (
                    <button
                        key={service.id}
                        className={`service-tab ${activeService === service.id ? 'active' : ''}`}
                        onClick={() => setActiveService(service.id)}
                    >
                        {service.label}
                    </button>
                ))}
            </div>

            {/* Sections List */}
            <div className="sections-container">
                <h3>{currentService?.label} - Sections</h3>

                {serviceSections.length === 0 ? (
                    <p className="muted">Aucune section configurée pour ce service.</p>
                ) : (
                    <div className="sections-list">
                        {serviceSections.map(section => (
                            <div key={section.id} className={`section-card ${!section.is_visible ? 'hidden-section' : ''}`}>
                                <div className="section-header">
                                    <div className="section-info">
                                        <span className="section-order">#{section.display_order}</span>
                                        <strong>{section.section_label}</strong>
                                        <span className="section-key">({section.section_key})</span>
                                    </div>
                                    <div className="section-actions">
                                        <button
                                            className={`visibility-btn ${section.is_visible ? 'visible' : 'hidden'}`}
                                            onClick={() => toggleVisibility(section.id)}
                                            disabled={saving}
                                            title={section.is_visible ? 'Masquer cette section' : 'Afficher cette section'}
                                        >
                                            {section.is_visible ? '👁️ Visible' : '🙈 Masqué'}
                                        </button>
                                        <button
                                            className="edit-btn"
                                            onClick={() => startEditing(section)}
                                            title="Personnaliser le texte"
                                        >
                                            ✏️ Texte
                                        </button>
                                    </div>
                                </div>

                                {section.custom_text && (
                                    <div className="custom-text-preview">
                                        <span className="custom-badge">Texte personnalisé:</span>
                                        <p>{section.custom_text.substring(0, 100)}...</p>
                                    </div>
                                )}

                                {editingSection === section.id && (
                                    <div className="edit-modal">
                                        <h4>✏️ Personnaliser "{section.section_label}"</h4>
                                        <textarea
                                            value={editText}
                                            onChange={e => setEditText(e.target.value)}
                                            placeholder="Entrez le texte personnalisé pour cette section..."
                                            rows={5}
                                            className="edit-textarea"
                                            aria-label="Texte personnalisé"
                                        />
                                        <p className="muted small">
                                            Laissez vide pour utiliser le texte par défaut généré dynamiquement.
                                        </p>
                                        <div className="edit-actions">
                                            <button
                                                className="btn-cancel"
                                                onClick={() => setEditingSection(null)}
                                            >
                                                Annuler
                                            </button>
                                            <button
                                                className="btn-save"
                                                onClick={() => saveCustomText(section.id)}
                                                disabled={saving}
                                            >
                                                {saving ? 'Enregistrement...' : '💾 Enregistrer'}
                                            </button>
                                        </div>
                                    </div>
                                )}
                            </div>
                        ))}
                    </div>
                )}
            </div>

            <style>{`
                .reports-config {
                    max-width: 1000px;
                }
                .service-tabs {
                    display: flex;
                    gap: 8px;
                    margin-bottom: 24px;
                    flex-wrap: wrap;
                }
                .service-tab {
                    padding: 10px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 8px;
                    color: #aaa;
                    cursor: pointer;
                    transition: all 0.2s;
                    font-size: 13px;
                }
                .service-tab:hover {
                    background: rgba(255,255,255,0.1);
                }
                .service-tab.active {
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    border-color: transparent;
                    color: white;
                }
                .sections-container {
                    background: rgba(255,255,255,0.02);
                    border-radius: 16px;
                    border: 1px solid rgba(255,255,255,0.08);
                    padding: 24px;
                }
                .sections-container h3 {
                    margin: 0 0 20px 0;
                    color: #9f7aea;
                }
                .sections-list {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }
                .section-card {
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    padding: 16px;
                    transition: all 0.2s;
                }
                .section-card.hidden-section {
                    opacity: 0.5;
                    border-left: 3px solid #f59e0b;
                }
                .section-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    flex-wrap: wrap;
                    gap: 12px;
                }
                .section-info {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .section-order {
                    background: rgba(102,126,234,0.2);
                    padding: 4px 8px;
                    border-radius: 6px;
                    font-size: 12px;
                    color: #667eea;
                }
                .section-key {
                    font-size: 12px;
                    color: #666;
                }
                .section-actions {
                    display: flex;
                    gap: 8px;
                }
                .visibility-btn, .edit-btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 12px;
                    transition: all 0.2s;
                }
                .visibility-btn.visible {
                    background: rgba(34,197,94,0.2);
                    color: #22c55e;
                }
                .visibility-btn.hidden {
                    background: rgba(245,158,11,0.2);
                    color: #f59e0b;
                }
                .edit-btn {
                    background: rgba(102,126,234,0.2);
                    color: #667eea;
                }
                .custom-text-preview {
                    margin-top: 12px;
                    padding: 12px;
                    background: rgba(255,255,255,0.03);
                    border-radius: 8px;
                    font-size: 13px;
                }
                .custom-badge {
                    color: #9f7aea;
                    font-size: 11px;
                    text-transform: uppercase;
                }
                .custom-text-preview p {
                    margin: 8px 0 0 0;
                    color: #888;
                }
                .edit-modal {
                    margin-top: 16px;
                    padding: 16px;
                    background: rgba(0,0,0,0.3);
                    border-radius: 12px;
                    border: 1px solid rgba(102,126,234,0.3);
                }
                .edit-modal h4 {
                    margin: 0 0 12px 0;
                    font-size: 14px;
                }
                .edit-textarea {
                    width: 100%;
                    padding: 12px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 14px;
                    resize: vertical;
                    min-height: 100px;
                }
                .edit-actions {
                    display: flex;
                    gap: 12px;
                    margin-top: 12px;
                }
                .btn-cancel, .btn-save {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-size: 14px;
                }
                .btn-cancel {
                    background: rgba(255,255,255,0.1);
                    color: white;
                }
                .btn-save {
                    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                    color: white;
                }
                .btn-save:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }
                .error-banner {
                    padding: 16px;
                    background: rgba(239,68,68,0.2);
                    border: 1px solid #ef4444;
                    border-radius: 12px;
                    color: #ef4444;
                    margin-bottom: 24px;
                }
                @media (max-width: 768px) {
                    .service-tabs {
                        overflow-x: auto;
                        flex-wrap: nowrap;
                        padding-bottom: 8px;
                    }
                    .section-header {
                        flex-direction: column;
                        align-items: flex-start;
                    }
                }
            `}</style>
        </div>
    );
}
