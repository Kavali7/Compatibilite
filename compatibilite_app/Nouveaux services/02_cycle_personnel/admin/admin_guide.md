# Guide Admin - Cycle Annuel Personnel

## Service 02 : Cycle Personnel

### Pages à Créer

1. **PersonalCyclePeriods** - Gestion des 7 périodes
2. **PersonalCycleSubscriptions** - Gestion des abonnements
3. **PersonalCycleStats** - Statistiques

### Page Liste des Périodes

```tsx
// admin/src/pages/PersonalCyclePeriods.tsx

export default function PersonalCyclePeriods() {
  const [periods, setPeriods] = useState([]);

  useEffect(() => {
    fetchPeriods();
  }, []);

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">
        Périodes du Cycle Personnel
      </h1>
      
      <div className="grid grid-cols-7 gap-4">
        {periods.map((period) => (
          <PeriodCard 
            key={period.id} 
            period={period}
            onEdit={() => setSelectedPeriod(period)}
          />
        ))}
      </div>
    </div>
  );
}
```

### Éditeur de Période

```tsx
function PeriodEditor({ period, onSave }) {
  const [content, setContent] = useState(period.full_content);
  
  return (
    <div className="bg-white rounded-lg p-6 shadow">
      <h2>{period.period_name}</h2>
      
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label>Nom de la période</label>
          <input value={period.period_name} />
        </div>
        <div>
          <label>Thème central</label>
          <input value={period.theme_central} />
        </div>
      </div>
      
      <div className="mt-4">
        <label>Affirmation</label>
        <input value={period.affirmation} />
      </div>
      
      <div className="mt-4">
        <label>Contenu (Markdown)</label>
        <textarea 
          rows={20}
          value={content}
          onChange={(e) => setContent(e.target.value)}
        />
      </div>
      
      <button onClick={() => onSave({...period, full_content: content})}>
        Enregistrer
      </button>
    </div>
  );
}
```

### Page Abonnements

```tsx
export default function PersonalCycleSubscriptions() {
  return (
    <div className="p-6">
      <h1>Abonnements Cycle Personnel</h1>
      
      <table>
        <thead>
          <tr>
            <th>Utilisateur</th>
            <th>Date naissance</th>
            <th>Début</th>
            <th>Fin</th>
            <th>Statut</th>
          </tr>
        </thead>
        <tbody>
          {/* Liste des abonnements */}
        </tbody>
      </table>
    </div>
  );
}
```

### Checklist Admin

- [ ] Page PersonalCyclePeriods
- [ ] Éditeur de période avec Markdown
- [ ] Page PersonalCycleSubscriptions
- [ ] Statistiques d'usage
- [ ] Import du contenu des 7 périodes
