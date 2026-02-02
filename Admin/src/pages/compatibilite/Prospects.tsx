import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type ProspectStatus = 'to_contact' | 'contacted' | 'converted' | 'lost';

type Prospect = {
    id: string;
    email: string | null;
    phone: string | null;
    source: string;
    last_action: string;
    status: ProspectStatus;
    notes: string | null;
    captured_at: string;
    updated_at: string;
};

const STATUS_OPTIONS: { value: ProspectStatus; label: string; color: string }[] = [
    { value: 'to_contact', label: '📞 À contacter', color: '#ef4444' },
    { value: 'contacted', label: '💬 Contacté', color: '#f59e0b' },
    { value: 'converted', label: '✅ Converti', color: '#22c55e' },
    { value: 'lost', label: '❌ Perdu', color: '#6b7280' },
];

export default function Prospects() {
    const [prospects, setProspects] = useState<Prospect[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | ProspectStatus>('all');
    const [search, setSearch] = useState('');
    const [editingNote, setEditingNote] = useState<string | null>(null);
    const [noteText, setNoteText] = useState('');
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        loadProspects();
    }, []);

    async function loadProspects() {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('marketing_prospects')
                .select('*')
                .order('updated_at', { ascending: false });

            if (error) throw error;
            setProspects(data || []);
        } catch (e) {
            console.error('Error loading prospects:', e);
        }
        setLoading(false);
    }

    async function updateStatus(id: string, newStatus: ProspectStatus) {
        setSaving(true);
        try {
            const { error } = await supabase
                .from('marketing_prospects')
                .update({ status: newStatus, updated_at: new Date().toISOString() })
                .eq('id', id);

            if (error) throw error;
            setProspects(prev => prev.map(p =>
                p.id === id ? { ...p, status: newStatus, updated_at: new Date().toISOString() } : p
            ));
        } catch (e) {
            console.error('Error updating status:', e);
        }
        setSaving(false);
    }

    async function saveNote(id: string) {
        setSaving(true);
        try {
            const { error } = await supabase
                .from('marketing_prospects')
                .update({ notes: noteText, updated_at: new Date().toISOString() })
                .eq('id', id);

            if (error) throw error;
            setProspects(prev => prev.map(p =>
                p.id === id ? { ...p, notes: noteText } : p
            ));
            setEditingNote(null);
            setNoteText('');
        } catch (e) {
            console.error('Error saving note:', e);
        }
        setSaving(false);
    }

    function formatDate(dateStr: string) {
        return new Date(dateStr).toLocaleString('fr-FR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
        });
    }

    function exportCSV() {
        const headers = ['Date', 'Email', 'Téléphone', 'Source', 'Dernière Action', 'Statut', 'Notes'];
        const rows = filteredProspects.map(p => [
            formatDate(p.updated_at),
            p.email || '',
            p.phone || '',
            p.source,
            p.last_action,
            p.status,
            (p.notes || '').replace(/,/g, ';'),
        ]);

        const csv = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `prospects_${new Date().toISOString().split('T')[0]}.csv`;
        a.click();
    }

    function openWhatsApp(phone: string) {
        const cleanPhone = phone.replace(/[^0-9+]/g, '');
        window.open(`https://wa.me/${cleanPhone}`, '_blank');
    }

    function openEmail(email: string) {
        window.open(`mailto:${email}?subject=Suivi%20Kbal&body=Bonjour,%0A%0A`, '_blank');
    }

    const filteredProspects = prospects.filter(p => {
        if (filter !== 'all' && p.status !== filter) return false;
        if (search) {
            const searchLower = search.toLowerCase();
            return (
                p.email?.toLowerCase().includes(searchLower) ||
                p.phone?.includes(search) ||
                p.source.toLowerCase().includes(searchLower)
            );
        }
        return true;
    });

    const stats = {
        total: prospects.length,
        to_contact: prospects.filter(p => p.status === 'to_contact').length,
        contacted: prospects.filter(p => p.status === 'contacted').length,
        converted: prospects.filter(p => p.status === 'converted').length,
        lost: prospects.filter(p => p.status === 'lost').length,
    };

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page prospects-crm">
            <header className="page-header">
                <div>
                    <h2 className="page-title">🎯 Prospects & Relances CRM</h2>
                    <p className="page-subtitle">Gérez vos leads et suivez vos relances</p>
                </div>
                <button className="btn-primary" onClick={exportCSV}>
                    📥 Export CSV
                </button>
            </header>

            {/* Stats Cards */}
            <div className="prospects-stats">
                <div className="stat-card" onClick={() => setFilter('all')}>
                    <span className="stat-value">{stats.total}</span>
                    <span className="stat-label">Total</span>
                </div>
                <div className="stat-card to_contact" onClick={() => setFilter('to_contact')}>
                    <span className="stat-value">{stats.to_contact}</span>
                    <span className="stat-label">À contacter</span>
                </div>
                <div className="stat-card contacted" onClick={() => setFilter('contacted')}>
                    <span className="stat-value">{stats.contacted}</span>
                    <span className="stat-label">Contactés</span>
                </div>
                <div className="stat-card converted" onClick={() => setFilter('converted')}>
                    <span className="stat-value">{stats.converted}</span>
                    <span className="stat-label">Convertis</span>
                </div>
            </div>

            {/* Filters */}
            <div className="filter-bar">
                <input
                    type="text"
                    placeholder="🔍 Rechercher email, téléphone, source..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="search-input"
                    aria-label="Rechercher"
                />
                <div className="filter-buttons">
                    {STATUS_OPTIONS.map(opt => (
                        <button
                            key={opt.value}
                            className={`filter-btn ${filter === opt.value ? 'active' : ''}`}
                            onClick={() => setFilter(filter === opt.value ? 'all' : opt.value)}
                        >
                            {opt.label}
                        </button>
                    ))}
                </div>
            </div>

            {/* Prospects List */}
            <div className="prospects-list">
                {filteredProspects.length === 0 ? (
                    <div className="empty-state">Aucun prospect trouvé</div>
                ) : (
                    filteredProspects.map((p) => (
                        <div key={p.id} className={`prospect-card status-${p.status}`}>
                            <div className="prospect-main">
                                <div className="prospect-contact">
                                    {p.email && (
                                        <div className="contact-row">
                                            <span>✉️ {p.email}</span>
                                            <button
                                                className="action-btn email"
                                                onClick={() => openEmail(p.email!)}
                                                title="Envoyer email"
                                            >
                                                📧
                                            </button>
                                        </div>
                                    )}
                                    {p.phone && (
                                        <div className="contact-row">
                                            <span>📞 {p.phone}</span>
                                            <button
                                                className="action-btn whatsapp"
                                                onClick={() => openWhatsApp(p.phone!)}
                                                title="Ouvrir WhatsApp"
                                            >
                                                💬
                                            </button>
                                        </div>
                                    )}
                                    {!p.email && !p.phone && <span className="muted">Anonyme</span>}
                                </div>
                                <div className="prospect-meta">
                                    <span className="badge source-badge">{p.source}</span>
                                    <span className="badge action-badge">{p.last_action}</span>
                                    <span className="date-text">{formatDate(p.updated_at)}</span>
                                </div>
                            </div>

                            <div className="prospect-status">
                                <select
                                    value={p.status}
                                    onChange={(e) => updateStatus(p.id, e.target.value as ProspectStatus)}
                                    disabled={saving}
                                    className={`status-select ${p.status}`}
                                    aria-label="Changer le statut"
                                >
                                    {STATUS_OPTIONS.map(opt => (
                                        <option key={opt.value} value={opt.value}>{opt.label}</option>
                                    ))}
                                </select>
                            </div>

                            <div className="prospect-notes">
                                {editingNote === p.id ? (
                                    <div className="note-editor">
                                        <textarea
                                            value={noteText}
                                            onChange={(e) => setNoteText(e.target.value)}
                                            placeholder="Ajouter une note..."
                                            rows={2}
                                            aria-label="Note"
                                        />
                                        <div className="note-actions">
                                            <button className="btn-cancel" onClick={() => setEditingNote(null)}>
                                                Annuler
                                            </button>
                                            <button
                                                className="btn-save"
                                                onClick={() => saveNote(p.id)}
                                                disabled={saving}
                                            >
                                                {saving ? '...' : 'Sauver'}
                                            </button>
                                        </div>
                                    </div>
                                ) : (
                                    <div
                                        className="note-display"
                                        onClick={() => {
                                            setEditingNote(p.id);
                                            setNoteText(p.notes || '');
                                        }}
                                    >
                                        {p.notes ? (
                                            <span className="note-text">📝 {p.notes}</span>
                                        ) : (
                                            <span className="note-placeholder">+ Ajouter une note</span>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    ))
                )}
            </div>

            <style>{`
                .prospects-crm { max-width: 1200px; }
                
                .prospects-stats {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
                    gap: 12px;
                    margin-bottom: 24px;
                }
                .stat-card {
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    padding: 16px;
                    text-align: center;
                    cursor: pointer;
                    transition: all 0.2s;
                    border: 2px solid transparent;
                }
                .stat-card:hover { background: rgba(255,255,255,0.1); }
                .stat-card.to_contact { border-color: #ef4444; }
                .stat-card.contacted { border-color: #f59e0b; }
                .stat-card.converted { border-color: #22c55e; }
                .stat-value { display: block; font-size: 2rem; font-weight: bold; color: white; }
                .stat-label { display: block; font-size: 0.8rem; color: #aaa; margin-top: 4px; }

                .filter-bar {
                    display: flex;
                    gap: 12px;
                    margin-bottom: 20px;
                    flex-wrap: wrap;
                }
                .search-input {
                    flex: 1;
                    min-width: 200px;
                    padding: 12px 16px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 14px;
                }
                .filter-buttons { display: flex; gap: 8px; flex-wrap: wrap; }
                .filter-btn {
                    padding: 8px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 20px;
                    color: #aaa;
                    cursor: pointer;
                    font-size: 12px;
                    transition: all 0.2s;
                }
                .filter-btn:hover { background: rgba(255,255,255,0.1); }
                .filter-btn.active { background: #667eea; color: white; border-color: #667eea; }

                .prospects-list { display: flex; flex-direction: column; gap: 12px; }
                .prospect-card {
                    background: rgba(255,255,255,0.03);
                    border-radius: 12px;
                    padding: 16px;
                    border-left: 4px solid #666;
                    transition: all 0.2s;
                }
                .prospect-card:hover { background: rgba(255,255,255,0.05); }
                .prospect-card.status-to_contact { border-left-color: #ef4444; }
                .prospect-card.status-contacted { border-left-color: #f59e0b; }
                .prospect-card.status-converted { border-left-color: #22c55e; }
                .prospect-card.status-lost { border-left-color: #6b7280; }

                .prospect-main {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    flex-wrap: wrap;
                    gap: 12px;
                    margin-bottom: 12px;
                }
                .prospect-contact { display: flex; flex-direction: column; gap: 6px; }
                .contact-row { display: flex; align-items: center; gap: 8px; }
                .action-btn {
                    width: 28px;
                    height: 28px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 14px;
                    transition: all 0.2s;
                }
                .action-btn.whatsapp { background: #25d366; }
                .action-btn.email { background: #667eea; }
                .action-btn:hover { transform: scale(1.1); }

                .prospect-meta { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
                .badge { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 500; }
                .source-badge { background: rgba(102,126,234,0.2); color: #667eea; }
                .action-badge { background: rgba(245,158,11,0.2); color: #f59e0b; }
                .date-text { color: #666; font-size: 12px; }

                .prospect-status { margin-bottom: 12px; }
                .status-select {
                    padding: 8px 12px;
                    border-radius: 8px;
                    border: 1px solid rgba(255,255,255,0.2);
                    background: rgba(255,255,255,0.1);
                    color: white;
                    font-size: 13px;
                    cursor: pointer;
                    min-width: 150px;
                }
                .status-select.to_contact { border-color: #ef4444; }
                .status-select.contacted { border-color: #f59e0b; }
                .status-select.converted { border-color: #22c55e; }

                .prospect-notes { border-top: 1px solid rgba(255,255,255,0.1); padding-top: 12px; }
                .note-display { cursor: pointer; padding: 8px; border-radius: 6px; }
                .note-display:hover { background: rgba(255,255,255,0.05); }
                .note-text { color: #aaa; font-size: 13px; }
                .note-placeholder { color: #666; font-size: 12px; font-style: italic; }

                .note-editor textarea {
                    width: 100%;
                    padding: 10px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 13px;
                    resize: vertical;
                }
                .note-actions { display: flex; gap: 8px; margin-top: 8px; justify-content: flex-end; }
                .btn-cancel, .btn-save {
                    padding: 6px 14px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 12px;
                }
                .btn-cancel { background: rgba(255,255,255,0.1); color: white; }
                .btn-save { background: #22c55e; color: white; }
                .btn-save:disabled { opacity: 0.5; }

                @media (max-width: 768px) {
                    .prospects-stats { grid-template-columns: repeat(2, 1fr); }
                    .filter-bar { flex-direction: column; }
                    .search-input { min-width: 100%; }
                }
            `}</style>
        </div>
    );
}
