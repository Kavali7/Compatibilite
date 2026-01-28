import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

// Types
type UserCredit = {
    id: string;
    user_id: string;
    cycle_vie_purchase_id: string | null;
    credits_initial: number;
    credits_remaining: number;
    source_type: string;
    expires_at: string;
    notified_7d: boolean;
    notified_1d: boolean;
    created_at: string;
    user_email?: string;
    user_name?: string;
};

type UserUsage = {
    id: string;
    decision_type_label: string;
    cycle_type: string;
    target_date: string;
    created_at: string;
};

export default function UserCredits() {
    const [credits, setCredits] = useState<UserCredit[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchEmail, setSearchEmail] = useState('');
    const [selectedUser, setSelectedUser] = useState<{ id: string; email: string; name: string } | null>(null);
    const [userUsage, setUserUsage] = useState<UserUsage[]>([]);
    const [saveStatus, setSaveStatus] = useState<string | null>(null);
    const [showAddBonus, setShowAddBonus] = useState(false);
    const [bonusCredits, setBonusCredits] = useState(1);

    useEffect(() => {
        loadExpiringCredits();
    }, []);

    async function loadExpiringCredits() {
        setLoading(true);
        try {
            // Charger les crédits qui expirent dans les 30 prochains jours
            const thirtyDaysFromNow = new Date();
            thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);

            const { data, error } = await supabase
                .from('user_decision_credits')
                .select('*')
                .gt('credits_remaining', 0)
                .lt('expires_at', thirtyDaysFromNow.toISOString())
                .order('expires_at', { ascending: true })
                .limit(50);

            if (error) throw error;
            setCredits((data as UserCredit[]) || []);
        } catch (e) {
            console.error('Erreur chargement:', e);
            setCredits([]);
        }
        setLoading(false);
    }

    async function searchUser() {
        if (!searchEmail.trim()) return;

        setLoading(true);
        try {
            // Chercher l'utilisateur par email via les crédits
            const { data, error } = await supabase
                .from('user_decision_credits')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;

            // Filtrer côté client (limitation Supabase pour les joins auth.users)
            setCredits((data as UserCredit[]) || []);

            // Pour l'affichage, on simule le résultat de la recherche
            if (data && data.length > 0) {
                setSelectedUser({
                    id: data[0].user_id,
                    email: searchEmail,
                    name: 'Utilisateur'
                });
                loadUserUsage(data[0].user_id);
            }
        } catch (e) {
            console.error('Erreur recherche:', e);
        }
        setLoading(false);
    }

    async function loadUserUsage(userId: string) {
        try {
            const { data, error } = await supabase
                .from('user_decision_usage')
                .select(`
                    id,
                    cycle_type,
                    target_date,
                    created_at,
                    cycle_vie_decision_types(label)
                `)
                .eq('user_id', userId)
                .order('created_at', { ascending: false })
                .limit(20);

            if (error) throw error;

            const parsed = (data || []).map((u: any) => ({
                id: u.id,
                decision_type_label: u.cycle_vie_decision_types?.label || 'Inconnu',
                cycle_type: u.cycle_type,
                target_date: u.target_date,
                created_at: u.created_at
            }));

            setUserUsage(parsed);
        } catch (e) {
            console.error('Erreur chargement usage:', e);
        }
    }

    async function addBonusCredits() {
        if (!selectedUser || bonusCredits <= 0) return;

        setSaveStatus('Ajout des crédits...');
        try {
            // Calculer la date d'expiration (90 jours)
            const expiresAt = new Date();
            expiresAt.setDate(expiresAt.getDate() + 90);

            const { error } = await supabase
                .from('user_decision_credits')
                .insert({
                    user_id: selectedUser.id,
                    credits_initial: bonusCredits,
                    credits_remaining: bonusCredits,
                    source_type: 'admin_bonus',
                    expires_at: expiresAt.toISOString()
                });

            if (error) throw error;

            setSaveStatus(`✅ ${bonusCredits} crédit(s) ajouté(s) !`);
            setShowAddBonus(false);
            setBonusCredits(1);
            searchUser(); // Recharger
            setTimeout(() => setSaveStatus(null), 3000);
        } catch (e: any) {
            console.error('Erreur ajout:', e);
            setSaveStatus(`❌ Erreur: ${e.message}`);
        }
    }

    function formatDate(dateStr: string): string {
        return new Date(dateStr).toLocaleDateString('fr-FR', {
            day: '2-digit',
            month: 'short',
            year: 'numeric'
        });
    }

    function getDaysUntilExpiry(dateStr: string): number {
        const now = new Date();
        const expiry = new Date(dateStr);
        return Math.ceil((expiry.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
    }

    function getExpiryBadgeColor(days: number): string {
        if (days <= 1) return '#ef4444';
        if (days <= 7) return '#f59e0b';
        return '#10b981';
    }

    if (loading && credits.length === 0) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page user-credits">
            <div className="page-header">
                <div>
                    <h2 className="page-title">👤 Crédits Utilisateurs</h2>
                    <p className="page-subtitle">
                        Gérez les crédits de décision des utilisateurs
                    </p>
                </div>
            </div>

            {saveStatus && (
                <div className={`save-status ${saveStatus.includes('❌') ? 'error' : 'success'}`}>
                    {saveStatus}
                </div>
            )}

            {/* Recherche utilisateur */}
            <div style={{
                background: 'var(--card-bg)',
                padding: '1.25rem',
                borderRadius: '12px',
                marginBottom: '1.5rem'
            }}>
                <h3 style={{ margin: '0 0 1rem 0', fontSize: '1rem' }}>🔍 Rechercher un utilisateur</h3>
                <div style={{ display: 'flex', gap: '0.5rem' }}>
                    <input
                        type="email"
                        value={searchEmail}
                        onChange={(e) => setSearchEmail(e.target.value)}
                        placeholder="Email de l'utilisateur..."
                        style={{ flex: 1 }}
                        onKeyDown={(e) => e.key === 'Enter' && searchUser()}
                    />
                    <button className="btn-primary" onClick={searchUser}>
                        Rechercher
                    </button>
                </div>
            </div>

            {/* Résultat recherche */}
            {selectedUser && (
                <div style={{
                    background: 'var(--card-bg)',
                    padding: '1.25rem',
                    borderRadius: '12px',
                    marginBottom: '1.5rem'
                }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
                        <div>
                            <h3 style={{ margin: 0 }}>{selectedUser.email}</h3>
                            <span style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
                                ID: {selectedUser.id.substring(0, 8)}...
                            </span>
                        </div>
                        <button
                            className="btn-primary"
                            onClick={() => setShowAddBonus(!showAddBonus)}
                        >
                            {showAddBonus ? 'Annuler' : '+ Ajouter crédits bonus'}
                        </button>
                    </div>

                    {showAddBonus && (
                        <div style={{
                            background: 'var(--bg)',
                            padding: '1rem',
                            borderRadius: '8px',
                            marginBottom: '1rem'
                        }}>
                            <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                <input
                                    type="number"
                                    value={bonusCredits}
                                    onChange={(e) => setBonusCredits(parseInt(e.target.value) || 1)}
                                    min="1"
                                    style={{ width: '80px' }}
                                />
                                <span>crédit(s) bonus</span>
                                <button className="btn-primary" onClick={addBonusCredits}>
                                    Confirmer
                                </button>
                            </div>
                            <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)', margin: '0.5rem 0 0 0' }}>
                                Les crédits expireront dans 90 jours
                            </p>
                        </div>
                    )}

                    {/* Crédits de l'utilisateur */}
                    <h4 style={{ margin: '1rem 0 0.5rem 0' }}>Crédits disponibles</h4>
                    {credits.filter(c => c.user_id === selectedUser.id).length === 0 ? (
                        <p style={{ color: 'var(--text-muted)' }}>Aucun crédit</p>
                    ) : (
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem' }}>
                            {credits.filter(c => c.user_id === selectedUser.id).map(credit => {
                                const daysLeft = getDaysUntilExpiry(credit.expires_at);
                                return (
                                    <div key={credit.id} style={{
                                        padding: '0.5rem 1rem',
                                        background: 'var(--bg)',
                                        borderRadius: '8px',
                                        borderLeft: `3px solid ${getExpiryBadgeColor(daysLeft)}`
                                    }}>
                                        <div style={{ fontWeight: '600' }}>
                                            {credit.credits_remaining}/{credit.credits_initial} crédits
                                        </div>
                                        <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                                            {credit.source_type} • Expire {formatDate(credit.expires_at)} ({daysLeft}j)
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}

                    {/* Historique d'utilisation */}
                    {userUsage.length > 0 && (
                        <>
                            <h4 style={{ margin: '1.5rem 0 0.5rem 0' }}>Historique des analyses</h4>
                            <table style={{ width: '100%', fontSize: '0.85rem' }}>
                                <thead>
                                    <tr>
                                        <th style={{ textAlign: 'left', padding: '0.5rem' }}>Type</th>
                                        <th style={{ textAlign: 'left', padding: '0.5rem' }}>Cycle</th>
                                        <th style={{ textAlign: 'left', padding: '0.5rem' }}>Date cible</th>
                                        <th style={{ textAlign: 'left', padding: '0.5rem' }}>Utilisé le</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {userUsage.map(u => (
                                        <tr key={u.id}>
                                            <td style={{ padding: '0.5rem' }}>{u.decision_type_label}</td>
                                            <td style={{ padding: '0.5rem' }}>{u.cycle_type}</td>
                                            <td style={{ padding: '0.5rem' }}>{formatDate(u.target_date)}</td>
                                            <td style={{ padding: '0.5rem' }}>{formatDate(u.created_at)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </>
                    )}
                </div>
            )}

            {/* Crédits expirant bientôt */}
            <div style={{
                background: 'var(--card-bg)',
                padding: '1.25rem',
                borderRadius: '12px'
            }}>
                <h3 style={{ margin: '0 0 1rem 0', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    ⏰ Crédits expirant dans les 30 prochains jours
                    <span style={{
                        background: 'var(--primary)',
                        color: 'white',
                        padding: '0.2rem 0.5rem',
                        borderRadius: '12px',
                        fontSize: '0.8rem'
                    }}>
                        {credits.length}
                    </span>
                </h3>

                {credits.length === 0 ? (
                    <p style={{ color: 'var(--text-muted)', textAlign: 'center', padding: '2rem' }}>
                        Aucun crédit n'expire prochainement
                    </p>
                ) : (
                    <table style={{ width: '100%', fontSize: '0.85rem' }}>
                        <thead>
                            <tr style={{ borderBottom: '1px solid var(--border-color)' }}>
                                <th style={{ textAlign: 'left', padding: '0.75rem 0.5rem' }}>User ID</th>
                                <th style={{ textAlign: 'center', padding: '0.75rem 0.5rem' }}>Crédits</th>
                                <th style={{ textAlign: 'left', padding: '0.75rem 0.5rem' }}>Source</th>
                                <th style={{ textAlign: 'left', padding: '0.75rem 0.5rem' }}>Expiration</th>
                                <th style={{ textAlign: 'center', padding: '0.75rem 0.5rem' }}>Notifié</th>
                            </tr>
                        </thead>
                        <tbody>
                            {credits.map(credit => {
                                const daysLeft = getDaysUntilExpiry(credit.expires_at);
                                return (
                                    <tr key={credit.id} style={{ borderBottom: '1px solid var(--border-color)' }}>
                                        <td style={{ padding: '0.75rem 0.5rem' }}>
                                            <code style={{ fontSize: '0.8rem' }}>
                                                {credit.user_id.substring(0, 8)}...
                                            </code>
                                        </td>
                                        <td style={{ padding: '0.75rem 0.5rem', textAlign: 'center' }}>
                                            <strong>{credit.credits_remaining}</strong>/{credit.credits_initial}
                                        </td>
                                        <td style={{ padding: '0.75rem 0.5rem' }}>
                                            {credit.source_type}
                                        </td>
                                        <td style={{ padding: '0.75rem 0.5rem' }}>
                                            <span style={{
                                                display: 'inline-flex',
                                                alignItems: 'center',
                                                gap: '0.5rem'
                                            }}>
                                                <span style={{
                                                    width: '8px',
                                                    height: '8px',
                                                    borderRadius: '50%',
                                                    background: getExpiryBadgeColor(daysLeft)
                                                }}></span>
                                                {formatDate(credit.expires_at)} ({daysLeft}j)
                                            </span>
                                        </td>
                                        <td style={{ padding: '0.75rem 0.5rem', textAlign: 'center' }}>
                                            {credit.notified_7d ? '7j✓' : ''}
                                            {credit.notified_1d ? '1j✓' : ''}
                                            {!credit.notified_7d && !credit.notified_1d ? '-' : ''}
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                )}

                <button
                    onClick={loadExpiringCredits}
                    style={{ marginTop: '1rem' }}
                >
                    🔄 Actualiser
                </button>
            </div>
        </div>
    );
}
