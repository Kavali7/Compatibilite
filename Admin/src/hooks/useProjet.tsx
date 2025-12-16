import { useState, createContext, useContext, ReactNode } from 'react';

export type Projet = {
    id: string;
    slug: string;
    nom: string;
    actif: boolean;
};

const PROJETS: Projet[] = [
    { id: '1', slug: 'compatibilite', nom: 'La Compatibilité', actif: true },
    { id: '2', slug: 'cartographie', nom: 'Cartographie', actif: false },
    { id: '3', slug: 'ame-soeur', nom: 'Âme Sœur', actif: false },
];

type ProjetContextType = {
    projets: Projet[];
    currentProjet: Projet | null;
    setCurrentProjet: (p: Projet | null) => void;
};

const ProjetContext = createContext<ProjetContextType | null>(null);

export function ProjetProvider({ children }: { children: ReactNode }) {
    const [currentProjet, setCurrentProjet] = useState<Projet | null>(PROJETS[0]);

    return (
        <ProjetContext.Provider value={{ projets: PROJETS, currentProjet, setCurrentProjet }}>
            {children}
        </ProjetContext.Provider>
    );
}

export function useProjet() {
    const ctx = useContext(ProjetContext);
    if (!ctx) throw new Error('useProjet must be used within ProjetProvider');
    return ctx;
}
