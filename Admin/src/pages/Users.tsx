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

export default function Users() {
    const [users, setUsers] = useState<User[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'paid' | 'unpaid'>('all');
    const [searchTerm, setSearchTerm] = useState('');

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

    async function grantAccess(userId: string) {
        if (!confirm('Donner accès manuellement à cet utilisateur ? (Créer un paiement "success")')) return;

        try {
            // Create a manual payment record
            const { error } = await supabase
                .from('payments')
                .insert({
                    user_id: userId,
                    transaction_id: `MANUAL_${Date.now()}`,
                    amount_fcfa: 0,
                    payment_method: 'manual',
                    status: 'success',
                    plan_type: 'consultation',
                });

            if (error) throw error;
            alert('✅ Accès accordé avec succès !');
            loadUsers();
        } catch (e: any) {
            console.error('Grant access error:', e);
            alert(`❌ Erreur: ${e.message}`);
        }
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
                                {!user.has_paid && (
                                    <button
                                        className="btn-grant"
                                        onClick={() => grantAccess(user.id)}
                                        title="Donner accès manuellement"
                                    >
                                        🔓 Donner accès
                                    </button>
                                )}
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
            `}</style>
        </div>
    );
}
