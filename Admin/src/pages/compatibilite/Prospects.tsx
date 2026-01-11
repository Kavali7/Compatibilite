import { useEffect, useState } from 'react';
import { supabase } from '../../supabaseClient';

type Prospect = {
    id: string;
    email: string | null;
    phone: string | null;
    source: string;
    last_action: string;
    status: string;
    captured_at: string;
    updated_at: string;
};

export default function Prospects() {
    const [prospects, setProspects] = useState<Prospect[]>([]);
    const [loading, setLoading] = useState(true);

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

    function formatDate(dateStr: string) {
        return new Date(dateStr).toLocaleString('fr-FR');
    }

    return (
        <div className="page prospects">
            <h2 className="page-title">🎯 Prospects & Relances</h2>
            <p className="page-subtitle">Utilisateurs identifiés à recontacter (abandons, erreurs, etc.)</p>

            {loading ? (
                <div className="loading">Chargement...</div>
            ) : (
                <div className="table-container">
                    <table className="data-table">
                        <thead>
                            <tr>
                                <th>Date (Dernière action)</th>
                                <th>Contact</th>
                                <th>Dernière Action</th>
                                <th>Source</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {prospects.length === 0 ? (
                                <tr>
                                    <td colSpan={6} className="empty-cell">Aucun prospect enregistré.</td>
                                </tr>
                            ) : (
                                prospects.map((p) => (
                                    <tr key={p.id}>
                                        <td>{formatDate(p.updated_at)}</td>
                                        <td>
                                            <div className="contact-info">
                                                {p.email && <div>✉️ {p.email}</div>}
                                                {p.phone && <div>📞 {p.phone}</div>}
                                                {!p.email && !p.phone && <span className="muted">Anonyme</span>}
                                            </div>
                                        </td>
                                        <td><span className="badge action-badge">{p.last_action}</span></td>
                                        <td>{p.source}</td>
                                        <td>
                                            <span className={`status-badge ${p.status}`}>
                                                {p.status}
                                            </span>
                                        </td>
                                        <td>
                                            <button className="btn-small" onClick={() => alert('Fonctionnalité SMS/Whatsapp à venir !')}>
                                                Relancer
                                            </button>
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
            )}

            <style>{`
                .contact-info { display: flex; flex-direction: column; gap: 4px; }
                .badge.action-badge { background: #e0f2fe; color: #0284c7; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; }
                .status-badge { padding: 4px 8px; border-radius: 4px; font-weight: 500; font-size: 0.85em; }
                .status-badge.to_contact { background: #fee2e2; color: #991b1b; }
                .status-badge.contacted { background: #fef08a; color: #854d0e; }
                .status-badge.converted { background: #dcfce7; color: #166534; }
                .btn-small { padding: 4px 8px; font-size: 0.8em; cursor: pointer; }
            `}</style>
        </div>
    );
}
