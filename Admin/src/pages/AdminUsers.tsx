import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

type AdminRole = 'super_admin' | 'content_admin' | 'finance_admin' | 'viewer';

type AdminUser = {
    id: string;
    email: string;
    display_name: string;
    role: AdminRole;
    is_active: boolean;
    last_login: string | null;
    created_at: string;
};

const ROLE_OPTIONS: { value: AdminRole; label: string; description: string }[] = [
    { value: 'super_admin', label: '👑 Super Admin', description: 'Accès complet à toutes les fonctionnalités' },
    { value: 'content_admin', label: '📝 Admin Contenu', description: 'Gestion du contenu et des interprétations' },
    { value: 'finance_admin', label: '💰 Admin Finance', description: 'Gestion des paiements et tarifs' },
    { value: 'viewer', label: '👁️ Lecteur', description: 'Consultation uniquement, pas de modifications' },
];

export default function AdminUsers() {
    const [admins, setAdmins] = useState<AdminUser[]>([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [editingAdmin, setEditingAdmin] = useState<AdminUser | null>(null);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [tableExists, setTableExists] = useState(true);

    // Form state
    const [formEmail, setFormEmail] = useState('');
    const [formName, setFormName] = useState('');
    const [formRole, setFormRole] = useState<AdminRole>('viewer');
    const [formPassword, setFormPassword] = useState('');

    useEffect(() => {
        loadAdmins();
    }, []);

    async function loadAdmins() {
        setLoading(true);
        setError(null);
        try {
            const { data, error: fetchError } = await supabase
                .from('admin_users')
                .select('*')
                .order('created_at', { ascending: false });

            if (fetchError) {
                // Table might not exist
                if (fetchError.code === '42P01' || fetchError.message.includes('does not exist')) {
                    setTableExists(false);
                    setAdmins([]);
                } else {
                    throw fetchError;
                }
            } else {
                setAdmins(data || []);
                setTableExists(true);
            }
        } catch (e: any) {
            console.error('Error loading admins:', e);
            setError(e.message);
        }
        setLoading(false);
    }

    function openCreateModal() {
        setEditingAdmin(null);
        setFormEmail('');
        setFormName('');
        setFormRole('viewer');
        setFormPassword('');
        setShowModal(true);
    }

    function openEditModal(admin: AdminUser) {
        setEditingAdmin(admin);
        setFormEmail(admin.email);
        setFormName(admin.display_name);
        setFormRole(admin.role);
        setFormPassword('');
        setShowModal(true);
    }

    async function handleSave() {
        if (!formEmail || !formName) {
            setError('Email et nom requis');
            return;
        }

        setSaving(true);
        setError(null);

        try {
            if (editingAdmin) {
                // Update
                const updateData: Partial<AdminUser> = {
                    email: formEmail,
                    display_name: formName,
                    role: formRole,
                };

                const { error: updateError } = await supabase
                    .from('admin_users')
                    .update(updateData)
                    .eq('id', editingAdmin.id);

                if (updateError) throw updateError;
            } else {
                // Create
                const { error: insertError } = await supabase
                    .from('admin_users')
                    .insert({
                        email: formEmail,
                        display_name: formName,
                        role: formRole,
                        password_hash: formPassword, // In real app, hash this!
                        is_active: true,
                    });

                if (insertError) throw insertError;
            }

            setShowModal(false);
            loadAdmins();
        } catch (e: any) {
            console.error('Save error:', e);
            setError(e.message);
        }
        setSaving(false);
    }

    async function toggleActive(admin: AdminUser) {
        try {
            const { error: updateError } = await supabase
                .from('admin_users')
                .update({ is_active: !admin.is_active })
                .eq('id', admin.id);

            if (updateError) throw updateError;
            loadAdmins();
        } catch (e: any) {
            console.error('Toggle error:', e);
            setError(e.message);
        }
    }

    async function deleteAdmin(admin: AdminUser) {
        if (!confirm(`Supprimer l'admin "${admin.display_name}" ?`)) return;

        try {
            const { error: deleteError } = await supabase
                .from('admin_users')
                .delete()
                .eq('id', admin.id);

            if (deleteError) throw deleteError;
            loadAdmins();
        } catch (e: any) {
            console.error('Delete error:', e);
            setError(e.message);
        }
    }

    function formatDate(dateStr: string | null) {
        if (!dateStr) return 'Jamais';
        return new Date(dateStr).toLocaleString('fr-FR');
    }

    const getRoleInfo = (role: AdminRole) => ROLE_OPTIONS.find(r => r.value === role);

    if (loading) {
        return <div className="page-loading">Chargement...</div>;
    }

    return (
        <div className="page admin-users">
            <header className="page-header">
                <div>
                    <h2 className="page-title">👥 Gestion des Administrateurs</h2>
                    <p className="page-subtitle">Gérez les comptes et les rôles d'administration</p>
                </div>
                <button className="btn-primary" onClick={openCreateModal}>
                    + Nouvel Admin
                </button>
            </header>

            {error && <div className="error-banner">{error}</div>}

            {!tableExists && (
                <div className="setup-notice">
                    <h3>⚠️ Configuration requise</h3>
                    <p>La table <code>admin_users</code> n'existe pas encore. Créez-la avec ce SQL:</p>
                    <pre>{`CREATE TABLE admin_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255),
    role VARCHAR(50) DEFAULT 'viewer',
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insérer le premier admin
INSERT INTO admin_users (email, display_name, role) 
VALUES ('admin@growpeak.com', 'Super Admin', 'super_admin');`}</pre>
                    <button className="btn-primary" onClick={loadAdmins}>
                        🔄 Réessayer
                    </button>
                </div>
            )}

            {tableExists && (
                <>
                    {/* Role Legend */}
                    <div className="roles-legend">
                        {ROLE_OPTIONS.map(role => (
                            <div key={role.value} className={`role-card role-${role.value}`}>
                                <strong>{role.label}</strong>
                                <span>{role.description}</span>
                            </div>
                        ))}
                    </div>

                    {/* Admins List */}
                    <div className="admins-list">
                        {admins.length === 0 ? (
                            <div className="empty-state">
                                Aucun administrateur configuré
                            </div>
                        ) : (
                            admins.map(admin => (
                                <div key={admin.id} className={`admin-card ${!admin.is_active ? 'inactive' : ''}`}>
                                    <div className="admin-info">
                                        <div className="admin-name">
                                            {admin.display_name}
                                            {!admin.is_active && <span className="inactive-badge">Désactivé</span>}
                                        </div>
                                        <div className="admin-email">{admin.email}</div>
                                        <div className="admin-meta">
                                            <span className={`role-badge role-${admin.role}`}>
                                                {getRoleInfo(admin.role)?.label}
                                            </span>
                                            <span className="last-login">
                                                Dernière connexion: {formatDate(admin.last_login)}
                                            </span>
                                        </div>
                                    </div>
                                    <div className="admin-actions">
                                        <button className="btn-icon" onClick={() => openEditModal(admin)} title="Modifier">
                                            ✏️
                                        </button>
                                        <button
                                            className={`btn-icon ${admin.is_active ? 'active' : 'inactive'}`}
                                            onClick={() => toggleActive(admin)}
                                            title={admin.is_active ? 'Désactiver' : 'Activer'}
                                        >
                                            {admin.is_active ? '🔒' : '🔓'}
                                        </button>
                                        <button className="btn-icon danger" onClick={() => deleteAdmin(admin)} title="Supprimer">
                                            🗑️
                                        </button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                </>
            )}

            {/* Modal */}
            {showModal && (
                <div className="modal-overlay" onClick={() => setShowModal(false)}>
                    <div className="modal-content" onClick={e => e.stopPropagation()}>
                        <h3>{editingAdmin ? 'Modifier Admin' : 'Nouvel Admin'}</h3>

                        <div className="form-group">
                            <label htmlFor="admin-name">Nom</label>
                            <input
                                id="admin-name"
                                type="text"
                                value={formName}
                                onChange={e => setFormName(e.target.value)}
                                placeholder="Nom complet"
                            />
                        </div>

                        <div className="form-group">
                            <label htmlFor="admin-email">Email</label>
                            <input
                                id="admin-email"
                                type="email"
                                value={formEmail}
                                onChange={e => setFormEmail(e.target.value)}
                                placeholder="admin@example.com"
                            />
                        </div>

                        <div className="form-group">
                            <label htmlFor="admin-role">Rôle</label>
                            <select
                                id="admin-role"
                                value={formRole}
                                onChange={e => setFormRole(e.target.value as AdminRole)}
                            >
                                {ROLE_OPTIONS.map(role => (
                                    <option key={role.value} value={role.value}>
                                        {role.label}
                                    </option>
                                ))}
                            </select>
                        </div>

                        {!editingAdmin && (
                            <div className="form-group">
                                <label htmlFor="admin-password">Mot de passe</label>
                                <input
                                    id="admin-password"
                                    type="password"
                                    value={formPassword}
                                    onChange={e => setFormPassword(e.target.value)}
                                    placeholder="Mot de passe initial"
                                />
                            </div>
                        )}

                        <div className="modal-actions">
                            <button className="btn-cancel" onClick={() => setShowModal(false)}>
                                Annuler
                            </button>
                            <button className="btn-save" onClick={handleSave} disabled={saving}>
                                {saving ? 'Enregistrement...' : 'Enregistrer'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                .admin-users { max-width: 1000px; }

                .setup-notice {
                    background: rgba(245,158,11,0.1);
                    border: 1px solid #f59e0b;
                    border-radius: 12px;
                    padding: 24px;
                    margin-bottom: 24px;
                }
                .setup-notice h3 { margin: 0 0 12px 0; color: #f59e0b; }
                .setup-notice pre {
                    background: rgba(0,0,0,0.3);
                    padding: 16px;
                    border-radius: 8px;
                    overflow-x: auto;
                    font-size: 12px;
                    margin: 16px 0;
                }

                .roles-legend {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 12px;
                    margin-bottom: 24px;
                }
                .role-card {
                    padding: 12px 16px;
                    border-radius: 8px;
                    background: rgba(255,255,255,0.03);
                    border-left: 4px solid;
                    display: flex;
                    flex-direction: column;
                    gap: 4px;
                }
                .role-card strong { font-size: 14px; }
                .role-card span { font-size: 11px; color: #888; }
                .role-super_admin { border-color: #f59e0b; }
                .role-content_admin { border-color: #667eea; }
                .role-finance_admin { border-color: #22c55e; }
                .role-viewer { border-color: #6b7280; }

                .admins-list { display: flex; flex-direction: column; gap: 12px; }
                .admin-card {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    background: rgba(255,255,255,0.03);
                    border-radius: 12px;
                    padding: 16px 20px;
                    transition: all 0.2s;
                }
                .admin-card:hover { background: rgba(255,255,255,0.05); }
                .admin-card.inactive { opacity: 0.5; }

                .admin-info { flex: 1; }
                .admin-name { font-size: 16px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
                .inactive-badge {
                    font-size: 10px;
                    background: #ef4444;
                    color: white;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-weight: normal;
                }
                .admin-email { font-size: 13px; color: #888; margin: 4px 0 8px 0; }
                .admin-meta { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
                .role-badge {
                    font-size: 11px;
                    padding: 4px 12px;
                    border-radius: 12px;
                    font-weight: 500;
                }
                .role-badge.role-super_admin { background: rgba(245,158,11,0.2); color: #f59e0b; }
                .role-badge.role-content_admin { background: rgba(102,126,234,0.2); color: #667eea; }
                .role-badge.role-finance_admin { background: rgba(34,197,94,0.2); color: #22c55e; }
                .role-badge.role-viewer { background: rgba(107,114,128,0.2); color: #9ca3af; }
                .last-login { font-size: 11px; color: #666; }

                .admin-actions { display: flex; gap: 8px; }
                .btn-icon {
                    width: 36px;
                    height: 36px;
                    border: none;
                    border-radius: 8px;
                    background: rgba(255,255,255,0.1);
                    cursor: pointer;
                    font-size: 16px;
                    transition: all 0.2s;
                }
                .btn-icon:hover { background: rgba(255,255,255,0.2); }
                .btn-icon.danger:hover { background: rgba(239,68,68,0.3); }

                .modal-overlay {
                    position: fixed;
                    top: 0; left: 0; right: 0; bottom: 0;
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
                    max-width: 450px;
                    border: 1px solid rgba(255,255,255,0.1);
                }
                .modal-content h3 { margin: 0 0 20px 0; }

                .form-group { margin-bottom: 16px; }
                .form-group label { display: block; margin-bottom: 6px; font-size: 13px; color: #aaa; }
                .form-group input, .form-group select {
                    width: 100%;
                    padding: 12px;
                    background: rgba(255,255,255,0.1);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 8px;
                    color: white;
                    font-size: 14px;
                }

                .modal-actions { display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px; }
                .btn-cancel, .btn-save {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-size: 14px;
                }
                .btn-cancel { background: rgba(255,255,255,0.1); color: white; }
                .btn-save { background: #667eea; color: white; }
                .btn-save:disabled { opacity: 0.5; }

                .error-banner {
                    background: rgba(239,68,68,0.2);
                    border: 1px solid #ef4444;
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    color: #ef4444;
                }

                @media (max-width: 768px) {
                    .admin-card { flex-direction: column; align-items: flex-start; gap: 12px; }
                    .admin-actions { width: 100%; justify-content: flex-end; }
                }
            `}</style>
        </div>
    );
}
