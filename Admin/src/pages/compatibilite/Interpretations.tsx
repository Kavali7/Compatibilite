import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

// Types from existing numerology_texts table
type NumerologyText = {
    id?: number;
    type: string;
    number: number;
    locale: string;
    title: string | null;
    body: string;
    segment: string;
    created_at?: string;
    updated_at?: string;
};

const TEXT_TYPES = [
    { value: 'base', label: 'Chemin de vie (base)' },
    { value: 'couple', label: 'Couple (détaillé)' },
    { value: 'couple_deep', label: 'Couple (synthèse)' },
    { value: 'daily_action', label: 'Action du jour' },
    { value: 'kabbalah', label: 'Kabbale' },
    { value: 'name', label: 'Nombre du nom' },
    { value: 'personal_day', label: 'Jour personnel' },
    { value: 'personal_year', label: 'Année personnelle' },
];

const NUMBERS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33];

export default function Interpretations() {
    const [texts, setTexts] = useState<NumerologyText[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedType, setSelectedType] = useState('base');
    const [editingItem, setEditingItem] = useState<NumerologyText | null>(null);
    const [formData, setFormData] = useState({
        number: 1,
        title: '',
        body: '',
        segment: '',
    });
    const [saveStatus, setSaveStatus] = useState<string | null>(null);

    useEffect(() => {
        loadTexts();
    }, [selectedType]);

    async function loadTexts() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('numerology_texts')
                .select('*')
                .eq('type', selectedType)
                .eq('locale', 'fr')
                .order('number');

            if (error) throw error;
            setTexts((data as NumerologyText[]) || []);
        } catch (e) {
            console.error('Load numerology_texts error:', e);
            setTexts([]);
        }
        setLoading(false);
    }

    async function saveText() {
        if (!formData.body) {
            setSaveStatus('Le contenu est requis');
            return;
        }

        setSaveStatus('Enregistrement...');
        try {
            if (editingItem?.id) {
                // Update existing
                const { error } = await supabase
                    .from('numerology_texts')
                    .update({
                        title: formData.title || null,
                        body: formData.body,
                        segment: formData.segment,
                        updated_at: new Date().toISOString(),
                    })
                    .eq('id', editingItem.id);

                if (error) throw error;
                setSaveStatus('✅ Mis à jour !');
            } else {
                // Insert new - use upsert with conflict handling
                const { error } = await supabase
                    .from('numerology_texts')
                    .upsert({
                        type: selectedType,
                        number: formData.number,
                        locale: 'fr',
                        title: formData.title || null,
                        body: formData.body,
                        segment: formData.segment,
                    }, {
                        onConflict: 'type,number,locale,segment'
                    });

                if (error) throw error;
                setSaveStatus('✅ Ajouté !');
            }

            setEditingItem(null);
            setFormData({ number: 1, title: '', body: '', segment: '' });
            loadTexts();

            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Save error:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    async function deleteText(item: NumerologyText) {
        if (!confirm(`Supprimer l'interprétation ${item.type} #${item.number} ?`)) return;

        try {
            const { error } = await supabase
                .from('numerology_texts')
                .delete()
                .eq('id', item.id);

            if (error) throw error;
            loadTexts();
        } catch (e) {
            console.error('Delete error:', e);
        }
    }

    function startEdit(item: NumerologyText) {
        setEditingItem(item);
        setFormData({
            number: item.number,
            title: item.title || '',
            body: item.body,
            segment: item.segment,
        });
    }

    function cancelEdit() {
        setEditingItem(null);
        setFormData({ number: 1, title: '', body: '', segment: '' });
        setSaveStatus(null);
    }

    return (
        <div className="page interpretations">
            <h2 className="page-title">Interprétations numérologiques</h2>
            <p className="page-subtitle">Table: <code>numerology_texts</code> • {texts.length} entrées pour "{selectedType}"</p>

            <div className="category-tabs">
                {TEXT_TYPES.map((t) => (
                    <button
                        key={t.value}
                        className={`tab-btn ${selectedType === t.value ? 'active' : ''}`}
                        onClick={() => setSelectedType(t.value)}
                    >
                        {t.label}
                    </button>
                ))}
            </div>

            <div className="interpretations-content">
                <div className="form-section">
                    <h3>{editingItem ? `Modifier #${editingItem.number}` : 'Ajouter une interprétation'}</h3>

                    <div className="form-group">
                        <label>Nombre</label>
                        <select
                            value={formData.number}
                            onChange={(e) => setFormData({ ...formData, number: parseInt(e.target.value) })}
                            disabled={!!editingItem}
                            aria-label="Sélectionner un nombre"
                        >
                            {NUMBERS.map((n) => (
                                <option key={n} value={n}>{n}</option>
                            ))}
                        </select>
                    </div>

                    <div className="form-group">
                        <label>Titre (optionnel)</label>
                        <input
                            type="text"
                            value={formData.title}
                            onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                            placeholder="Ex: Initiateur, Harmoniseur..."
                        />
                    </div>

                    <div className="form-group">
                        <label>Contenu</label>
                        <textarea
                            rows={8}
                            value={formData.body}
                            onChange={(e) => setFormData({ ...formData, body: e.target.value })}
                            placeholder="Texte de l'interprétation..."
                        />
                    </div>

                    <div className="form-group">
                        <label>Segment (optionnel)</label>
                        <input
                            type="text"
                            value={formData.segment}
                            onChange={(e) => setFormData({ ...formData, segment: e.target.value })}
                            placeholder="Pour variantes"
                        />
                    </div>

                    {saveStatus && (
                        <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                            {saveStatus}
                        </div>
                    )}

                    <div className="form-actions">
                        <button className="btn-primary" onClick={saveText}>
                            {editingItem ? 'Mettre à jour' : 'Ajouter'}
                        </button>
                        {editingItem && (
                            <button className="btn-secondary" onClick={cancelEdit}>
                                Annuler
                            </button>
                        )}
                    </div>
                </div>

                <div className="list-section">
                    <h3>Textes existants ({texts.length})</h3>
                    {loading ? (
                        <div className="loading">Chargement...</div>
                    ) : texts.length === 0 ? (
                        <div className="empty-state">
                            Aucune interprétation "{selectedType}" trouvée.
                        </div>
                    ) : (
                        <div className="interpretations-list">
                            {texts.map((item) => (
                                <div key={item.id || `${item.type}-${item.number}`} className="interpretation-card">
                                    <div className="interpretation-header">
                                        <span className="interpretation-key">{item.number}</span>
                                        {item.title && <span className="interpretation-title">{item.title}</span>}
                                    </div>
                                    <p className="interpretation-preview">
                                        {item.body.substring(0, 200)}...
                                    </p>
                                    <div className="interpretation-actions">
                                        <button onClick={() => startEdit(item)}>Modifier</button>
                                        <button className="danger" onClick={() => deleteText(item)}>
                                            Supprimer
                                        </button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
