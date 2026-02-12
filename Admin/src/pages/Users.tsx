import { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';

type AuthUser = {
    id: string;
    email: string;
    name: string | null;
    phone: string | null;
    created_at: string;
    last_sign_in_at: string | null;
    purchase_count: number;
    total_spent: number;
    services_used: string[];
};

// All available services for Grant Access
const GRANT_SERVICES = [
    { id: 'consultation', label: '💑 Compatibilité (Rapport)', type: 'one-time' },
    { id: 'portrait_ame', label: '✨ Portrait de l\'Âme', type: 'one-time' },
    { id: 'life_phase_report', label: '🔄 Phases de Vie', type: 'one-time' },
    { id: 'personal_cycle_annual', label: '🔄 Cycle Personnel (Annuel)', type: 'subscription' },
    { id: 'business_cycle_annual', label: '💼 Cycle Business (Annuel)', type: 'subscription' },
    { id: 'health_cycle_annual', label: '🏥 Cycle Santé (Annuel)', type: 'subscription' },
    { id: 'lunar_timing_monthly', label: '🌙 Timing Lunaire (Mensuel)', type: 'subscription' },
    { id: 'daily_guide_day', label: '⏰ Guide Horaire (Jour)', type: 'duration' },
    { id: 'decision_credits', label: '💡 Crédits Décision', type: 'credits' },
    { id: 'annee', label: '📆 Prévision Annuelle', type: 'one-time' },
    { id: 'mois', label: '📅 Prévision Mensuelle', type: 'one-time' },
    { id: 'jour', label: '📌 Prévision Journalière', type: 'one-time' },
] as const;

const SERVICE_LABELS: Record<string, string> = {
    'consultation': '💑 Compatibilité',
    'portrait_ame': '✨ Portrait Âme',
    'annee': '📆 Prévision An',
    'mois': '📅 Prévision Mois',
    'jour': '📌 Prévision Jour',
    'personal_cycle_annual': '🔄 Cycle Perso',
    'business_cycle_annual': '💼 Cycle Business',
    'health_cycle_annual': '🏥 Cycle Santé',
    'daily_guide_day': '⏰ Guide Horaire',
    'decision_credits': '💡 Crédits',
    'life_phase_report': '🔄 Phases Vie',
    'lunar_timing_monthly': '🌙 Timing Lunaire',
};

type GrantModalState = {
    userId: string;
    userName: string;
    service: string;
    duration: number;
};

export default function Users() {
    const [users, setUsers] = useState<AuthUser[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filter, setFilter] = useState<'all' | 'paid' | 'unpaid' | 'recent'>('all');
    const [searchTerm, setSearchTerm] = useState('');
    const [grantModal, setGrantModal] = useState<GrantModalState | null>(null);
    const [granting, setGranting] = useState(false);
    const [selectedUser, setSelectedUser] = useState<AuthUser | null>(null);

    useEffect(() => {
        loadUsers();
    }, []);

    async function loadUsers() {
        setLoading(true);
        setError(null);
        try {
            // 1. List all auth users via admin API
            const { data: authData, error: authError } = await supabase.auth.admin.listUsers({
                perPage: 1000,
            });

            if (authError) throw authError;

            const authUsers = authData?.users || [];

            // 2. Get all payments to enrich user data
            const { data: paymentsData } = await supabase
                .from('payments')
                .select('user_id, plan_type, amount_fcfa, status')
                .eq('status', 'success');

            // Build per-user payment stats
            const userPaymentStats = new Map<string, { count: number; total: number; services: Set<string> }>();
            paymentsData?.forEach((p) => {
                if (!p.user_id) return;
                const stats = userPaymentStats.get(p.user_id) || { count: 0, total: 0, services: new Set<string>() };
                stats.count++;
                stats.total += p.amount_fcfa || 0;
                stats.services.add(p.plan_type);
                userPaymentStats.set(p.user_id, stats);
            });

            // 3. Combine auth users with payment stats
            const enrichedUsers: AuthUser[] = authUsers.map((u) => {
                const payStats = userPaymentStats.get(u.id);
                return {
                    id: u.id,
                    email: u.email || '',
                    name: u.user_metadata?.name || u.user_metadata?.display_name || null,
                    phone: u.phone || u.user_metadata?.phone || null,
                    created_at: u.created_at,
                    last_sign_in_at: u.last_sign_in_at || null,
                    purchase_count: payStats?.count || 0,
                    total_spent: payStats?.total || 0,
                    services_used: payStats ? Array.from(payStats.services) : [],
                };
            });

            // Sort by creation date (most recent first)
            enrichedUsers.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

            setUsers(enrichedUsers);
        } catch (e: any) {
            console.error('Users load error:', e);
            setError(e.message || 'Erreur au chargement des utilisateurs');

            // Fallback: try loading from users table
            try {
                const { data: fallbackData } = await supabase
                    .from('users')
                    .select('*')
                    .order('created_at', { ascending: false });

                if (fallbackData && fallbackData.length > 0) {
                    const fallbackUsers: AuthUser[] = fallbackData.map((u: any) => ({
                        id: u.id,
                        email: u.email || '',
                        name: u.name || u.display_name || null,
                        phone: u.phone || null,
                        created_at: u.created_at,
                        last_sign_in_at: null,
                        purchase_count: 0,
                        total_spent: 0,
                        services_used: [],
                    }));
                    setUsers(fallbackUsers);
                    setError('⚠️ Mode dégradé: données depuis la table users (auth.admin non disponible)');
                }
            } catch {
                // Fallback also failed
            }
        }
        setLoading(false);
    }

    function openGrantModal(user: AuthUser) {
        setGrantModal({
            userId: user.id,
            userName: user.name || user.email,
            service: 'consultation',
            duration: 365,
        });
    }

    async function executeGrantAccess() {
        if (!grantModal) return;
        setGranting(true);

        try {
            const serviceInfo = GRANT_SERVICES.find(s => s.id === grantModal.service);

            if (grantModal.service === 'decision_credits') {
                const expiresAt = new Date();
                expiresAt.setFullYear(expiresAt.getFullYear() + 1);
                const { error } = await supabase
                    .from('user_decision_credits')
                    .insert({
                        user_id: grantModal.userId,
                        credits_initial: grantModal.duration,
                        credits_remaining: grantModal.duration,
                        source_type: 'manual_grant',
                        expires_at: expiresAt.toISOString(),
                    });
                if (error) throw error;
            } else {
                const { error } = await supabase
                    .from('payments')
                    .insert({
                        user_id: grantModal.userId,
                        transaction_id: `MANUAL_${Date.now()}`,
                        amount_fcfa: 0,
                        payment_method: 'manual',
                        status: 'success',
                        plan_type: grantModal.service,
                        notes: `Accès manuel accordé (${serviceInfo?.label || grantModal.service})`,
                    });
                if (error) throw error;
            }

            alert(`✅ Accès accordé: ${serviceInfo?.label}`);
            setGrantModal(null);
            loadUsers();
        } catch (e: any) {
            console.error('Grant access error:', e);
            alert(`❌ Erreur: ${e.message}`);
        }
        setGranting(false);
    }

    function formatDate(dateStr: string) {
        return new Date(dateStr).toLocaleDateString('fr-FR', {
            day: '2-digit', month: '2-digit', year: 'numeric',
        });
    }

    function formatDateTime(dateStr: string | null) {
        if (!dateStr) return 'Jamais';
        const d = new Date(dateStr);
        const now = new Date();
        const diff = now.getTime() - d.getTime();
        const hours = Math.floor(diff / 3600000);
        if (hours < 1) return 'Il y a quelques minutes';
        if (hours < 24) return `Il y a ${hours}h`;
        const days = Math.floor(hours / 24);
        if (days < 7) return `Il y a ${days}j`;
        return d.toLocaleDateString('fr-FR');
    }

    const isRecent = (dateStr: string) => {
        const d = new Date(dateStr);
        const now = new Date();
        return (now.getTime() - d.getTime()) < 7 * 24 * 3600 * 1000; // 7 days
    };

    const filteredUsers = users.filter((u) => {
        if (filter === 'paid' && u.purchase_count === 0) return false;
        if (filter === 'unpaid' && u.purchase_count > 0) return false;
        if (filter === 'recent' && !isRecent(u.created_at)) return false;

        if (searchTerm) {
            const term = searchTerm.toLowerCase();
            return (
                u.email.toLowerCase().includes(term) ||
                (u.name?.toLowerCase().includes(term) ?? false) ||
                (u.phone?.includes(term) ?? false)
            );
        }

        return true;
    });

    const stats = {
        total: users.length,
        paid: users.filter(u => u.purchase_count > 0).length,
        unpaid: users.filter(u => u.purchase_count === 0).length,
        recent: users.filter(u => isRecent(u.created_at)).length,
        totalRevenue: users.reduce((sum, u) => sum + u.total_spent, 0),
    };

    if (loading) {
        return <div className="page-loading">Chargement des utilisateurs...</div>;
    }

    return (
        <div className="page users">
            <div className="page-header">
                <div>
                    <h2 className="page-title">👥 Utilisateurs</h2>
                    <p className="page-subtitle">
                        Source: <code>auth.users</code> • {users.length} utilisateurs inscrits
                    </p>
                </div>
                <button className="btn-primary" onClick={loadUsers}>🔄 Rafraîchir</button>
            </div>

            {error && (
                <div className="error-banner">
                    {error}
                </div>
            )}

            <div className="users-summary">
                <div className="summary-stat summary-stat--clickable" onClick={() => setFilter('all')}>
                    <span className="stat-value">{stats.total}</span>
                    <span className="stat-label">Total Inscrits</span>
                </div>
                <div className="summary-stat summary-stat--clickable" onClick={() => setFilter('paid')}>
                    <span className="stat-value">{stats.paid}</span>
                    <span className="stat-label">Ont payé</span>
                </div>
                <div className="summary-stat summary-stat--clickable" onClick={() => setFilter('unpaid')}>
                    <span className="stat-value">{stats.unpaid}</span>
                    <span className="stat-label">Sans achat</span>
                </div>
                <div className="summary-stat summary-stat--clickable" onClick={() => setFilter('recent')}>
                    <span className="stat-value">{stats.recent}</span>
                    <span className="stat-label">7 derniers jours</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.totalRevenue.toLocaleString('fr-FR')}</span>
                    <span className="stat-label">FCFA Total</span>
                </div>
            </div>

            <div className="filter-bar">
                {(['all', 'paid', 'unpaid', 'recent'] as const).map(f => (
                    <button
                        key={f}
                        className={`filter-btn ${filter === f ? 'active' : ''}`}
                        onClick={() => setFilter(f)}
                    >
                        {f === 'all' ? `Tous (${stats.total})` :
                            f === 'paid' ? `✅ Payeurs (${stats.paid})` :
                                f === 'unpaid' ? `🆓 Sans achat (${stats.unpaid})` :
                                    `🆕 Récents (${stats.recent})`}
                    </button>
                ))}
                <input
                    type="text"
                    placeholder="🔍 Rechercher (email, nom, téléphone)..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="search-input"
                />
            </div>

            <div className="users-list">
                {filteredUsers.length === 0 ? (
                    <div className="empty-state">Aucun utilisateur trouvé</div>
                ) : (
                    filteredUsers.map((user) => (
                        <div key={user.id} className="user-card" onClick={() => setSelectedUser(selectedUser?.id === user.id ? null : user)}>
                            <div className="user-info">
                                <div className="user-name">
                                    {user.name || 'Sans nom'}
                                    {user.purchase_count > 0 && (
                                        <span className="badge badge-success">💰 {user.purchase_count} achat{user.purchase_count > 1 ? 's' : ''}</span>
                                    )}
                                    {isRecent(user.created_at) && (
                                        <span className="badge badge-new">🆕 Nouveau</span>
                                    )}
                                </div>
                                <div className="user-details">
                                    📧 {user.email}
                                    {user.phone && ` • 📱 ${user.phone}`}
                                </div>
                                <div className="user-meta">
                                    Inscrit le {formatDate(user.created_at)}
                                    {' • '} Dernière connexion: {formatDateTime(user.last_sign_in_at)}
                                    {user.total_spent > 0 && ` • 💰 ${user.total_spent.toLocaleString('fr-FR')} FCFA`}
                                </div>
                                {selectedUser?.id === user.id && user.services_used.length > 0 && (
                                    <div className="user-services">
                                        <strong>Services achetés:</strong>{' '}
                                        {user.services_used.map(s => SERVICE_LABELS[s] || s).join(', ')}
                                    </div>
                                )}
                            </div>
                            <div className="user-actions" onClick={e => e.stopPropagation()}>
                                <button
                                    className="btn-grant"
                                    onClick={() => openGrantModal(user)}
                                    title="Donner accès manuellement à un service"
                                >
                                    🔓 Donner accès
                                </button>
                                <a
                                    href={`mailto:${user.email}`}
                                    className="btn-contact"
                                    title="Envoyer un email"
                                >
                                    📧
                                </a>
                            </div>
                        </div>
                    ))
                )}
            </div>

            {/* Grant Access Modal */}
            {grantModal && (
                <div className="modal-overlay" onClick={() => setGrantModal(null)}>
                    <div className="modal-content" onClick={e => e.stopPropagation()}>
                        <h3>🔓 Accorder l'accès</h3>
                        <p className="modal-user">Pour: <strong>{grantModal.userName}</strong></p>
                        <div className="modal-field">
                            <label htmlFor="service-select">Service</label>
                            <select
                                id="service-select"
                                value={grantModal.service}
                                onChange={e => setGrantModal({ ...grantModal, service: e.target.value })}
                                className="modal-select"
                            >
                                {GRANT_SERVICES.map(s => (
                                    <option key={s.id} value={s.id}>{s.label}</option>
                                ))}
                            </select>
                        </div>
                        {grantModal.service === 'decision_credits' && (
                            <div className="modal-field">
                                <label htmlFor="credits-input">Nombre de crédits</label>
                                <input
                                    id="credits-input"
                                    type="number"
                                    value={grantModal.duration}
                                    onChange={e => setGrantModal({ ...grantModal, duration: parseInt(e.target.value) || 5 })}
                                    min="1" max="100"
                                    className="modal-input"
                                />
                            </div>
                        )}
                        <div className="modal-info">
                            <p>ℹ️ Cette action créera un enregistrement de paiement manuel avec montant 0 FCFA.</p>
                        </div>
                        <div className="modal-actions">
                            <button className="btn-cancel" onClick={() => setGrantModal(null)} disabled={granting}>
                                Annuler
                            </button>
                            <button className="btn-confirm" onClick={executeGrantAccess} disabled={granting}>
                                {granting ? 'En cours...' : '✅ Confirmer'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                .users-summary {
                    display: flex;
                    gap: 12px;
                    margin-bottom: 20px;
                    flex-wrap: wrap;
                }
                .summary-stat {
                    background: rgba(255,255,255,0.05);
                    padding: 16px 24px;
                    border-radius: 12px;
                    text-align: center;
                    flex: 1;
                    min-width: 120px;
                    transition: all 0.2s;
                }
                .summary-stat:hover {
                    background: rgba(255,255,255,0.1);
                }
                .stat-value {
                    font-size: 28px;
                    font-weight: bold;
                    color: #667eea;
                    display: block;
                }
                .stat-label {
                    font-size: 12px;
                    color: #aaa;
                    margin-top: 4px;
                }
                .filter-bar {
                    display: flex;
                    gap: 12px;
                    margin-bottom: 20px;
                    flex-wrap: wrap;
                    align-items: center;
                }
                .filter-btn {
                    padding: 8px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 20px;
                    color: #aaa;
                    cursor: pointer;
                    transition: all 0.2s;
                    font-size: 13px;
                }
                .filter-btn:hover { background: rgba(255,255,255,0.1); }
                .filter-btn.active {
                    background: linear-gradient(135deg, #667eea 0%, #9f7aea 100%);
                    border-color: transparent;
                    color: white;
                }
                .search-input {
                    flex: 1;
                    min-width: 200px;
                    padding: 10px 16px;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 20px;
                    color: white;
                    font-size: 14px;
                }
                .search-input:focus { outline: none; border-color: #667eea; }
                .users-list {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .user-card {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 14px 20px;
                    background: rgba(255,255,255,0.03);
                    border-radius: 12px;
                    gap: 16px;
                    cursor: pointer;
                    transition: all 0.2s;
                    border: 1px solid transparent;
                }
                .user-card:hover {
                    background: rgba(255,255,255,0.06);
                    border-color: rgba(255,255,255,0.1);
                }
                .user-info { flex: 1; }
                .user-name {
                    font-size: 15px;
                    font-weight: 600;
                    color: white;
                    margin-bottom: 4px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    flex-wrap: wrap;
                }
                .badge {
                    font-size: 10px;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-weight: 600;
                }
                .badge-success { background: #22c55e; color: white; }
                .badge-new { background: #667eea; color: white; }
                .user-details {
                    font-size: 13px;
                    color: #aaa;
                    margin-bottom: 4px;
                }
                .user-meta { font-size: 12px; color: #666; }
                .user-services {
                    margin-top: 8px;
                    padding: 8px 12px;
                    background: rgba(102,126,234,0.1);
                    border-radius: 8px;
                    font-size: 12px;
                    color: #aaa;
                }
                .user-actions { display: flex; gap: 8px; }
                .btn-grant {
                    padding: 8px 14px;
                    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                    border: none; border-radius: 8px; color: white;
                    cursor: pointer; font-size: 12px; transition: all 0.2s;
                }
                .btn-grant:hover { transform: scale(1.05); }
                .btn-contact {
                    padding: 8px 12px;
                    background: rgba(255,255,255,0.1);
                    border: none; border-radius: 8px; color: white;
                    cursor: pointer; font-size: 14px; text-decoration: none;
                    transition: all 0.2s; display: flex; align-items: center;
                }
                .btn-contact:hover { background: rgba(255,255,255,0.2); }
                .empty-state { padding: 40px; text-align: center; color: #666; }
                .modal-overlay {
                    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
                    background: rgba(0,0,0,0.7); display: flex;
                    align-items: center; justify-content: center; z-index: 1000;
                }
                .modal-content {
                    background: #1a1a2e; border-radius: 16px; padding: 24px;
                    width: 90%; max-width: 400px; border: 1px solid rgba(255,255,255,0.1);
                }
                .modal-content h3 { margin: 0 0 8px 0; font-size: 20px; }
                .modal-user { color: #888; margin: 0 0 20px 0; }
                .modal-field { margin-bottom: 16px; }
                .modal-field label {
                    display: block; margin-bottom: 6px; color: #aaa; font-size: 14px;
                }
                .modal-select, .modal-input {
                    width: 100%; padding: 12px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px; color: white; font-size: 14px;
                }
                .modal-info {
                    background: rgba(102,126,234,0.1);
                    border: 1px solid rgba(102,126,234,0.3);
                    border-radius: 8px; padding: 12px; margin: 16px 0;
                }
                .modal-info p { margin: 0; font-size: 13px; color: #888; }
                .modal-actions { display: flex; gap: 12px; margin-top: 20px; }
                .btn-cancel {
                    flex: 1; padding: 12px; background: rgba(255,255,255,0.1);
                    border: none; border-radius: 8px; color: white; cursor: pointer;
                }
                .btn-confirm {
                    flex: 1; padding: 12px;
                    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                    border: none; border-radius: 8px; color: white;
                    cursor: pointer; font-weight: 600;
                }
                .btn-confirm:disabled, .btn-cancel:disabled {
                    opacity: 0.5; cursor: not-allowed;
                }
            `}</style>
        </div>
    );
}
