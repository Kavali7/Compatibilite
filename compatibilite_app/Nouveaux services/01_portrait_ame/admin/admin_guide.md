# Guide Panel Admin

## Service 01 : Portrait de l'Âme

Ce guide explique comment gérer le contenu du service "Portrait de l'Âme" via le panel admin React.

---

## 1. Page de Gestion des Profils Soul

### Emplacement
`admin/src/pages/SoulProfiles.tsx`

### Fonctionnalités Requises

1. **Liste des 14 profils** avec :
   - Code du profil (1A, 1B, ..., 7B)
   - Identité cosmique
   - Plage de dates
   - Statut actif/inactif

2. **Édition du contenu** :
   - Éditeur Markdown pour le contenu complet
   - Champs pour les métadonnées (affinités, conseils, etc.)

3. **Prévisualisation** :
   - Aperçu du rapport final avec personnalisation simulée

---

## 2. Structure de la Page

```tsx
// admin/src/pages/SoulProfiles.tsx

import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

interface SoulProfile {
  id: string;
  period_number: number;
  polarity: string;
  profile_code: string;
  cosmic_identity: string;
  date_start: string;
  date_end: string;
  full_content: string;
  is_active: boolean;
}

export default function SoulProfiles() {
  const [profiles, setProfiles] = useState<SoulProfile[]>([]);
  const [selectedProfile, setSelectedProfile] = useState<SoulProfile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchProfiles();
  }, []);

  const fetchProfiles = async () => {
    const { data, error } = await supabase
      .from('soul_profiles')
      .select('*')
      .order('period_number', { ascending: true })
      .order('polarity', { ascending: true });

    if (!error && data) {
      setProfiles(data);
    }
    setLoading(false);
  };

  const updateProfile = async (profile: SoulProfile) => {
    const { error } = await supabase
      .from('soul_profiles')
      .update({
        cosmic_identity: profile.cosmic_identity,
        full_content: profile.full_content,
        is_active: profile.is_active,
        updated_at: new Date().toISOString(),
      })
      .eq('id', profile.id);

    if (!error) {
      fetchProfiles();
      setSelectedProfile(null);
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">
        Gestion des Profils Soul
      </h1>
      
      {/* Grille des profils */}
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4 mb-8">
        {profiles.map((profile) => (
          <div
            key={profile.id}
            onClick={() => setSelectedProfile(profile)}
            className={`
              p-4 rounded-lg cursor-pointer border-2 transition-all
              ${profile.is_active ? 'border-green-500' : 'border-gray-300'}
              ${selectedProfile?.id === profile.id ? 'ring-2 ring-blue-500' : ''}
              hover:shadow-lg
            `}
          >
            <div className="text-xl font-bold text-center">
              {profile.profile_code}
            </div>
            <div className="text-sm text-center text-gray-600">
              {profile.cosmic_identity}
            </div>
            <div className="text-xs text-center text-gray-400 mt-1">
              {profile.date_start} → {profile.date_end}
            </div>
          </div>
        ))}
      </div>

      {/* Éditeur de profil */}
      {selectedProfile && (
        <ProfileEditor
          profile={selectedProfile}
          onSave={updateProfile}
          onCancel={() => setSelectedProfile(null)}
        />
      )}
    </div>
  );
}
```

---

## 3. Composant Éditeur de Profil

```tsx
// admin/src/components/ProfileEditor.tsx

import React, { useState } from 'react';
import ReactMarkdown from 'react-markdown';

interface ProfileEditorProps {
  profile: SoulProfile;
  onSave: (profile: SoulProfile) => void;
  onCancel: () => void;
}

export function ProfileEditor({ profile, onSave, onCancel }: ProfileEditorProps) {
  const [editedProfile, setEditedProfile] = useState(profile);
  const [showPreview, setShowPreview] = useState(false);

  return (
    <div className="bg-white rounded-lg shadow-lg p-6">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">
          Éditer: {profile.profile_code} - {profile.cosmic_identity}
        </h2>
        <div className="flex gap-2">
          <button
            onClick={() => setShowPreview(!showPreview)}
            className="px-4 py-2 bg-gray-200 rounded"
          >
            {showPreview ? 'Éditer' : 'Prévisualiser'}
          </button>
          <button
            onClick={() => onSave(editedProfile)}
            className="px-4 py-2 bg-blue-500 text-white rounded"
          >
            Enregistrer
          </button>
          <button
            onClick={onCancel}
            className="px-4 py-2 bg-gray-300 rounded"
          >
            Annuler
          </button>
        </div>
      </div>

      {/* Toggle actif/inactif */}
      <label className="flex items-center mb-4">
        <input
          type="checkbox"
          checked={editedProfile.is_active}
          onChange={(e) => setEditedProfile({
            ...editedProfile,
            is_active: e.target.checked,
          })}
          className="mr-2"
        />
        Profil actif
      </label>

      {/* Identité cosmique */}
      <div className="mb-4">
        <label className="block text-sm font-medium mb-1">
          Identité Cosmique
        </label>
        <input
          type="text"
          value={editedProfile.cosmic_identity}
          onChange={(e) => setEditedProfile({
            ...editedProfile,
            cosmic_identity: e.target.value,
          })}
          className="w-full border rounded p-2"
        />
      </div>

      {/* Contenu Markdown */}
      {showPreview ? (
        <div className="border rounded p-4 bg-gray-50 max-h-[600px] overflow-y-auto">
          <ReactMarkdown>
            {editedProfile.full_content
              .replace('[Prénom]', 'Marie')
              .replace('[date de naissance]', '15/04/1990')}
          </ReactMarkdown>
        </div>
      ) : (
        <div className="mb-4">
          <label className="block text-sm font-medium mb-1">
            Contenu du Rapport (Markdown)
          </label>
          <textarea
            value={editedProfile.full_content}
            onChange={(e) => setEditedProfile({
              ...editedProfile,
              full_content: e.target.value,
            })}
            className="w-full border rounded p-2 font-mono text-sm"
            rows={30}
          />
        </div>
      )}
    </div>
  );
}
```

---

## 4. Page des Statistiques d'Achats

### Fonctionnalités

- Nombre total d'achats
- Répartition par profil
- Revenus générés
- Tendances temporelles

```tsx
// admin/src/pages/SoulProfileStats.tsx

export default function SoulProfileStats() {
  // Statistiques par profil
  // Graphiques de ventes
  // Export des données
}
```

---

## 5. Navigation

Ajouter au menu de l'admin :

```tsx
// Dans le fichier de navigation
{
  title: 'Cycles de Vie',
  items: [
    { name: 'Profils Soul', path: '/soul-profiles', icon: StarIcon },
    { name: 'Statistiques Soul', path: '/soul-profile-stats', icon: ChartIcon },
    // Autres services à venir...
  ]
}
```

---

## 6. Permissions

Les profils Soul doivent être éditables uniquement par les administrateurs.

```sql
-- Ajouter une policy pour l'admin
CREATE POLICY "admin_manage_soul_profiles" ON soul_profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );
```

---

## 7. Import du Contenu

Pour importer le contenu des fichiers Markdown :

1. Ouvrir chaque fichier `content/periode_*.md`
2. Copier le contenu
3. Coller dans l'éditeur du profil correspondant
4. Enregistrer

Ou utiliser un script d'import automatique (voir `database/seed_content.sql`).

---

## 8. Checklist Admin

- [ ] Créer la page `SoulProfiles.tsx`
- [ ] Créer le composant `ProfileEditor.tsx`
- [ ] Ajouter au menu de navigation
- [ ] Importer les 14 profils
- [ ] Vérifier les permissions
- [ ] Créer la page de statistiques
