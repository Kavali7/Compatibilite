import { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';

type User = {
    id: string;
    email: string;
    name: string | null;
    phone: string | null;
    created_at: string;
    has_paid: boolean;
    purchase_type: string | null;
    payment_status: string | null;
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

type GrantModalState = {
    userId: string;
    userName: string;
    service: string;
    duration: number; // days for subscription, count for credits
};

export default function Users() {
    const [users, setUsers] = useState<User[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'paid' | 'unpaid'>('all');
    const [searchTerm, setSearchTerm] = useState('');
    const [grantModal, setGrantModal] = useState<GrantModalState | null>(null);
    const [granting, setGranting] = useState(false);

    useEffect(() => {
        loadUsers();
    }, []);

    async function loadUsers() {
        setLoading(true);
        try {
            // Get all users from the custom users table
            const { data: usersData, error: usersError } = await supabase
                .from('users')
                .select('*')
                .order('created_at', { ascending: false });

            if (usersError) throw usersError;

            // Get all successful payments to determine who has paid
            const { data: paymentsData, error: paymentsError } = await supabase
                .from('payments')
                .select('user_id, plan_type, status')
                .eq('status', 'success');

            if (paymentsError) throw paymentsError;

            // Create a map of user_id to payment info
            const paidUsers = new Map<string, { plan_type: string; status: string }>();
            paymentsData?.forEach((p) => {
                if (p.user_id && !paidUsers.has(p.user_id)) {
                    paidUsers.set(p.user_id, { plan_type: p.plan_type, status: p.status });
                }
            });

            // Combine user data with payment info
            const enrichedUsers: User[] = (usersData || []).map((u) => {
                const paymentInfo = paidUsers.get(u.id);
                return {
                    id: u.id,
                    email: u.email || '',
                    name: u.name || null,
                    phone: u.phone || null,
                    created_at: u.created_at,
                    has_paid: !!paymentInfo,
                    purchase_type: paymentInfo?.plan_type || null,
                    payment_status: paymentInfo?.status || null,
                };
            });

            setUsers(enrichedUsers);
        } catch (e) {
            console.error('Users load error:', e);
            setUsers([]);
        }
        setLoading(false);
    }

    function openGrantModal(user: User) {
        setGrantModal({
            userId: user.id,
            userName: user.name || user.email,
            service: 'consultation',
            duration: 365, // default 1 year
        });
    }

    async function executeGrantAccess() {
        if (!grantModal) return;
        setGranting(true);

        try {
            const serviceInfo = GRANT_SERVICES.find(s => s.id === grantModal.service);

            if (grantModal.service === 'decision_credits') {
                // Insert into user_decision_credits table
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
                // Create a payment record for all other services
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

    const filteredUsers = users.filter((u) => {
        // Filter by paid/unpaid
        if (filter === 'paid' && !u.has_paid) return false;
        if (filter === 'unpaid' && u.has_paid) return false;

        // Filter by search term
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
        paid: users.filter(u => u.has_paid).length,
        unpaid: users.filter(u => !u.has_paid).length,
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
                        Table: <code>users</code> • {users.length} utilisateurs
                    </p>
                </div>
            </div>

            <div className="users-summary">
                <div className="summary-stat">
                    <span className="stat-value">{stats.total}</span>
                    <span className="stat-label">Total</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.paid}</span>
                    <span className="stat-label">Ont payé</span>
                </div>
                <div className="summary-stat">
                    <span className="stat-value">{stats.unpaid}</span>
                    <span className="stat-label">Pas de paiement</span>
                </div>
            </div>

            <div className="filter-bar">
                <button
                    className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
                    onClick={() => setFilter('all')}
                >
                    Tous ({stats.total})
                </button>
                <button
                    className={`filter-btn ${filter === 'paid' ? 'active' : ''}`}
                    onClick={() => setFilter('paid')}
                >
                    ✅ Ont payé ({stats.paid})
                </button>
                <button
                    className={`filter-btn ${filter === 'unpaid' ? 'active' : ''}`}
                    onClick={() => setFilter('unpaid')}
                >
                    ❌ Pas de paiement ({stats.unpaid})
                </button>
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
                        <div key={user.id} className="user-card">
                            <div className="user-info">
                                <div className="user-name">
                                    {user.name || 'Sans nom'}
                                    {user.has_paid && (
                                        <span className="badge badge-success">Payé</span>
                                    )}
                                </div>
                                <div className="user-details">
                                    📧 {user.email}
                                    {user.phone && ` • 📱 ${user.phone}`}
                                </div>
                                <div className="user-meta">
                                    Inscrit le {new Date(user.created_at).toLocaleDateString('fr-FR')}
                                    {user.purchase_type && ` • Produit: ${user.purchase_type}`}
                                </div>
                            </div>
                            <div className="user-actions">
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
                                    📧 Contacter
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
                                    min="1"
                                    max="100"
                                    className="modal-input"
                                />
                            </div>
                        )}

                        <div className="modal-info">
                            <p>ℹ️ Cette action créera un enregistrement de paiement manuel avec montant 0 FCFA.</p>
                        </div>

                        <div className="modal-actions">
                            <button
                                className="btn-cancel"
                                onClick={() => setGrantModal(null)}
                                disabled={granting}
                            >
                                Annuler
                            </button>
                            <button
                                className="btn-confirm"
                                onClick={executeGrantAccess}
                                disabled={granting}
                            >
                                {granting ? 'En cours...' : '✅ Confirmer'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                .users-summary {
                    display: flex;
                    gap: 20px;
                    margin-bottom: 20px;
                }
                .summary-stat {
                    background: rgba(255,255,255,0.05);
                    padding: 20px 30px;
                    border-radius: 12px;
                    text-align: center;
                }
                .stat-value {
                    font-size: 32px;
                    font-weight: bold;
                    color: #667eea;
                    display: block;
                }
                .stat-label {
                    font-size: 14px;
                    color: #aaa;
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
                }
                .filter-btn:hover {
                    background: rgba(255,255,255,0.1);
                }
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
                .search-input:focus {
                    outline: none;
                    border-color: #667eea;
                }
                .users-list {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }
                .user-card {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 16px 20px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 12px;
                    gap: 20px;
                }
                .user-info {
                    flex: 1;
                }
                .user-name {
                    font-size: 16px;
                    font-weight: 600;
                    color: white;
                    margin-bottom: 4px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }
                .badge {
                    font-size: 10px;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-weight: 600;
                }
                .badge-success {
                    background: #22c55e;
                    color: white;
                }
                .user-details {
                    font-size: 14px;
                    color: #aaa;
                    margin-bottom: 4px;
                }
                .user-meta {
                    font-size: 12px;
                    color: #666;
                }
                .user-actions {
                    display: flex;
                    gap: 8px;
                }
                .btn-grant {
                    padding: 8px 16px;
                    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                    border: none;
                    border-radius: 8px;
                    color: white;
                    cursor: pointer;
                    font-size: 12px;
                    transition: all 0.2s;
                }
                .btn-grant:hover {
                    transform: scale(1.05);
                }
                .btn-contact {
                    padding: 8px 16px;
                    background: rgba(255,255,255,0.1);
                    border: none;
                    border-radius: 8px;
                    color: white;
                    cursor: pointer;
                    font-size: 12px;
                    text-decoration: none;
                    transition: all 0.2s;
                }
                .btn-contact:hover {
                    background: rgba(255,255,255,0.2);
                }
                .empty-state {
                    padding: 40px;
                    text-align: center;
                    color: #666;
                }
                .modal-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0,0,0,0.7);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                }
                .modal-content {
                    background: #1a1a2e;
                    border-radius: 16px;
                    padding: 24px;
                    width: 90%;
                    max-width: 400px;
                    border: 1px solid rgba(255,255,255,0.1);
                }
                .modal-content h3 {
                    margin: 0 0 8px 0;
                    font-size: 20px;
                }
                .modal-user {
                    color: #888;
                    margin: 0 0 20px 0;
                }
                .modal-field {
                    margin-bottom: 16px;
                }
                .modal-field label {
                    display: block;
                    margin-bottom: 6px;
                    color: #aaa;
                    font-size: 14px;
                }
                .modal-select, .modal-input {
                    width: 100%;
                    padding: 12px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 14px;
                }
                .modal-info {
                    background: rgba(102,126,234,0.1);
                    border: 1px solid rgba(102,126,234,0.3);
                    border-radius: 8px;
                    padding: 12px;
                    margin: 16px 0;
                }
                .modal-info p {
                    margin: 0;
                    font-size: 13px;
                    color: #888;
                }
                .modal-actions {
                    display: flex;
                    gap: 12px;
                    margin-top: 20px;
                }
                .btn-cancel {
                    flex: 1;
                    padding: 12px;
                    background: rgba(255,255,255,0.1);
                    border: none;
                    border-radius: 8px;
                    color: white;
                    cursor: pointer;
                }
                .btn-confirm {
                    flex: 1;
                    padding: 12px;
                    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                    border: none;
                    border-radius: 8px;
                    color: white;
                    cursor: pointer;
                    font-weight: 600;
                }
                .btn-confirm:disabled, .btn-cancel:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }
            `}</style>
        </div>
    );
}
