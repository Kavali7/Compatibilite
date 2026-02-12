import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type Prospect = {
    id: string;
    email: string;
    name: string | null;
    phone: string | null;
    created_at: string;
    last_sign_in_at: string | null;
    days_since_signup: number;
    status: 'new' | 'warm' | 'contacted' | 'lost';
    notes: string;
};

const STATUS_OPTIONS = [
    { value: 'new', label: '🆕 Nouveau', color: '#667eea' },
    { value: 'warm', label: '🔥 Chaud', color: '#f59e0b' },
    { value: 'contacted', label: '📞 Contacté', color: '#22c55e' },
    { value: 'lost', label: '💤 Perdu', color: '#ef4444' },
] as const;

export default function Prospects() {
    const [prospects, setProspects] = useState<Prospect[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filterStatus, setFilterStatus] = useState<string>('');
    const [searchTerm, setSearchTerm] = useState('');
    const [localNotes, setLocalNotes] = useState<Record<string, string>>({});
    const [localStatuses, setLocalStatuses] = useState<Record<string, string>>({});

    useEffect(() => {
        loadProspects();
    }, []);

    async function loadProspects() {
        setLoading(true);
        setError(null);

        try {
            // 1. Get all auth users
            const { data: authData, error: authError } = await supabase.auth.admin.listUsers({
                perPage: 1000,
            });

            if (authError) throw authError;
            const authUsers = authData?.users || [];

            // 2. Get all successful payments to identify paying users
            const { data: paymentsData } = await supabase
                .from('payments')
                .select('user_id')
                .eq('status', 'success');

            const payingUserIds = new Set(paymentsData?.map(p => p.user_id) || []);

            // 3. Filter to non-paying users (= prospects)
            const now = new Date();

            const prospectUsers: Prospect[] = authUsers
                .filter(u => !payingUserIds.has(u.id))
                .map(u => {
                    const createdAt = new Date(u.created_at);
                    const daysSinceSignup = Math.floor((now.getTime() - createdAt.getTime()) / (1000 * 60 * 60 * 24));

                    // Load saved CRM data from localStorage
                    const savedStatus = localStorage.getItem(`prospect_status_${u.id}`);
                    const savedNotes = localStorage.getItem(`prospect_notes_${u.id}`);

                    let status: 'new' | 'warm' | 'contacted' | 'lost' = 'new';
                    if (savedStatus) {
                        status = savedStatus as any;
                    } else if (daysSinceSignup <= 3) {
                        status = 'new';
                    } else if (daysSinceSignup <= 14) {
                        status = 'warm';
                    } else {
                        status = 'lost';
                    }

                    return {
                        id: u.id,
                        email: u.email || '',
                        name: u.user_metadata?.name || u.user_metadata?.display_name || null,
                        phone: u.phone || u.user_metadata?.phone || null,
                        created_at: u.created_at,
                        last_sign_in_at: u.last_sign_in_at || null,
                        days_since_signup: daysSinceSignup,
                        status,
                        notes: savedNotes || '',
                    };
                })
                .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

            setProspects(prospectUsers);

            // Initialize local state
            const notes: Record<string, string> = {};
            const statuses: Record<string, string> = {};
            prospectUsers.forEach(p => {
                notes[p.id] = p.notes;
                statuses[p.id] = p.status;
            });
            setLocalNotes(notes);
            setLocalStatuses(statuses);

        } catch (e: any) {
            console.error('Prospects load error:', e);
            setError(e.message || 'Erreur au chargement');
        }
        setLoading(false);
    }

    function updateStatus(prospectId: string, newStatus: string) {
        localStorage.setItem(`prospect_status_${prospectId}`, newStatus);
        setLocalStatuses(prev => ({ ...prev, [prospectId]: newStatus }));
        setProspects(prev => prev.map(p =>
            p.id === prospectId ? { ...p, status: newStatus as any } : p
        ));
    }

    function saveNote(prospectId: string) {
        const note = localNotes[prospectId] || '';
        localStorage.setItem(`prospect_notes_${prospectId}`, note);
        setProspects(prev => prev.map(p =>
            p.id === prospectId ? { ...p, notes: note } : p
        ));
    }

    const filteredProspects = prospects.filter(p => {
        if (filterStatus && p.status !== filterStatus) return false;
        if (searchTerm) {
            const term = searchTerm.toLowerCase();
            return (
                p.email.toLowerCase().includes(term) ||
                (p.name?.toLowerCase().includes(term) ?? false)
            );
        }
        return true;
    });

    const stats = {
        total: prospects.length,
        new: prospects.filter(p => p.status === 'new').length,
        warm: prospects.filter(p => p.status === 'warm').length,
        contacted: prospects.filter(p => p.status === 'contacted').length,
        lost: prospects.filter(p => p.status === 'lost').length,
    };

    function formatDate(dateStr: string) {
        return new Date(dateStr).toLocaleDateString('fr-FR', {
            day: '2-digit', month: '2-digit', year: 'numeric',
        });
    }

    function getStatusInfo(status: string) {
        return STATUS_OPTIONS.find(s => s.value === status) || STATUS_OPTIONS[0];
    }

    if (loading) {
        return <div className="loading-message">Chargement des prospects...</div>;
    }

    return (
        <div className="page prospects-crm">
            <div className="page-header">
                <div>
                    <h2 className="page-title">🎯 Prospects (CRM)</h2>
                    <p className="page-subtitle">
                        Utilisateurs inscrits sans achat — {stats.total} prospects
                    </p>
                </div>
                <button className="btn-primary" onClick={loadProspects}>🔄 Rafraîchir</button>
            </div>

            {error && (
                <div className="error-banner">{error}</div>
            )}

            {/* Pipeline overview */}
            <div className="stat-grid">
                {STATUS_OPTIONS.map(s => {
                    const count = stats[s.value as keyof typeof stats] as number;
                    return (
                        <div
                            key={s.value}
                            onClick={() => setFilterStatus(filterStatus === s.value ? '' : s.value)}
                            className={`stat-card${filterStatus === s.value ? ` stat-card--active stat-card--active-${s.value}` : ''}`}
                        >
                            <div className={`stat-card__value stat-card__value--${s.value}`}>{count}</div>
                            <div className="stat-card__label">{s.label}</div>
                        </div>
                    );
                })}
            </div>

            {/* Search */}
            <input
                type="text"
                placeholder="🔍 Rechercher un prospect..."
                value={searchTerm}
                onChange={e => setSearchTerm(e.target.value)}
                className="search-input"
                title="Rechercher un prospect par nom ou email"
            />

            {/* Prospects list */}
            <div className="prospect-list">
                {filteredProspects.length === 0 ? (
                    <div className="empty-state">
                        {prospects.length === 0 ? '🎉 Tous vos utilisateurs ont fait un achat !' : 'Aucun prospect trouvé pour ce filtre'}
                    </div>
                ) : (
                    filteredProspects.map(prospect => {
                        const statusInfo = getStatusInfo(localStatuses[prospect.id] || prospect.status);
                        return (
                            <div key={prospect.id} className={`prospect-card prospect-card--${localStatuses[prospect.id] || prospect.status}`}>
                                <div className="prospect-card__body">
                                    <div className="prospect-card__info">
                                        <div className="prospect-card__name">
                                            {prospect.name || 'Sans nom'}
                                            <span
                                                className={`prospect-status-badge prospect-status-badge--${localStatuses[prospect.id] || prospect.status}`}
                                            >
                                                {statusInfo.label}
                                            </span>
                                        </div>
                                        <div className="prospect-card__contact">
                                            📧 {prospect.email}
                                            {prospect.phone && ` • 📱 ${prospect.phone}`}
                                        </div>
                                        <div className="prospect-card__meta">
                                            Inscrit le {formatDate(prospect.created_at)}
                                            {' • '} {prospect.days_since_signup} jour{prospect.days_since_signup > 1 ? 's' : ''} depuis inscription
                                        </div>
                                    </div>
                                    <div className="prospect-card__actions">
                                        <select
                                            value={localStatuses[prospect.id] || prospect.status}
                                            onChange={e => updateStatus(prospect.id, e.target.value)}
                                            className="prospect-select"
                                            title="Statut du prospect"
                                        >
                                            {STATUS_OPTIONS.map(s => (
                                                <option key={s.value} value={s.value}>{s.label}</option>
                                            ))}
                                        </select>
                                        <a
                                            href={`mailto:${prospect.email}?subject=Découvrez nos services Kbal&body=Bonjour ${prospect.name || ''},`}
                                            onClick={() => updateStatus(prospect.id, 'contacted')}
                                            className="prospect-btn prospect-btn--email"
                                        >
                                            📧 Email
                                        </a>
                                        {prospect.phone && (
                                            <a
                                                href={`https://wa.me/${prospect.phone.replace(/\s/g, '')}`}
                                                target="_blank" rel="noopener noreferrer"
                                                onClick={() => updateStatus(prospect.id, 'contacted')}
                                                className="prospect-btn prospect-btn--whatsapp"
                                            >
                                                💬 WhatsApp
                                            </a>
                                        )}
                                    </div>
                                </div>

                                {/* Notes */}
                                <div className="prospect-notes">
                                    <input
                                        type="text"
                                        placeholder="Ajouter une note..."
                                        value={localNotes[prospect.id] || ''}
                                        onChange={e => setLocalNotes(prev => ({ ...prev, [prospect.id]: e.target.value }))}
                                        onBlur={() => saveNote(prospect.id)}
                                        onKeyDown={e => e.key === 'Enter' && saveNote(prospect.id)}
                                        className="prospect-notes__input"
                                        title="Notes sur le prospect"
                                    />
                                </div>
                            </div>
                        );
                    })
                )}
            </div>
        </div>
    );
}
