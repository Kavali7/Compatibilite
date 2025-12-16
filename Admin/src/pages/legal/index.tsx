import { useState } from 'react';
import { LEGAL_CONTENT, type LegalPage } from '../../data/legal-content';

export default function LegalIndex() {
    const [selectedPage, setSelectedPage] = useState<LegalPage | null>(null);

    const pages = Object.entries(LEGAL_CONTENT);

    if (selectedPage) {
        return (
            <div className="page legal-detail">
                <button className="back-btn" onClick={() => setSelectedPage(null)}>
                    ← Retour
                </button>
                <h2 className="page-title">{selectedPage.titre}</h2>
                <div className="legal-content">
                    {selectedPage.contenu.split('\n\n').map((para, i) => (
                        <p key={i}>{para}</p>
                    ))}
                </div>
            </div>
        );
    }

    return (
        <div className="page legal">
            <h2 className="page-title">Pages Légales</h2>
            <p className="page-subtitle">
                Ces pages sont partagées entre toutes les applications Growpeak.
            </p>

            <div className="legal-grid">
                {pages.map(([slug, page]) => (
                    <div
                        key={slug}
                        className="legal-card"
                        onClick={() => setSelectedPage(page)}
                    >
                        <h3>{page.titre}</h3>
                        <p className="muted">{page.contenu.substring(0, 100)}...</p>
                    </div>
                ))}
            </div>
        </div>
    );
}
