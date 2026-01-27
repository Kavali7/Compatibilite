"""
Générateur de conseils de décision pour Cycles de Vie - CORRIGÉ
Structure réelle de la table:
- decision_type_id UUID (FK vers cycle_vie_decision_types)
- cycle_type VARCHAR ('personal', 'business', 'health', 'daily')
- period_number INT (1-7)
- advice_text TEXT
"""

# Types de décision avec leur catégorie
DECISION_TYPES = [
    ('location_immobilier', 'Location / Immobilier', 'immobilier'),
    ('achat_immobilier', 'Achat Immobilier', 'immobilier'),
    ('demenagement', 'Déménagement', 'immobilier'),
    ('achat_vehicule', 'Achat Véhicule', 'finance'),
    ('achat_important', 'Achat Important', 'finance'),
    ('demande_financement', 'Demande de Financement', 'finance'),
    ('recherche_argent', 'Recherche d\'Argent', 'finance'),
    ('investissement', 'Investissement', 'finance'),
    ('signature_contrat', 'Signature de Contrat', 'juridique'),
    ('lancement_business', 'Lancement Business', 'business'),
    ('partenariat', 'Partenariat / Association', 'business'),
    ('entretien_embauche', 'Entretien d\'Embauche', 'carriere'),
    ('demande_promotion', 'Demande de Promotion', 'carriere'),
    ('demission_changement', 'Démission / Changement', 'carriere'),
    ('voyage', 'Voyage', 'personnel'),
    ('mariage_engagement', 'Mariage / Engagement', 'personnel'),
    ('debut_relation', 'Début de Relation', 'personnel'),
    ('operation_medicale', 'Opération Médicale', 'sante'),
    ('debut_traitement', 'Début de Traitement', 'sante'),
    ('autre_decision', 'Autre Décision Importante', 'autre'),
]

# Périodes avec leur caractérisation pour le cycle PERSONAL
PERIODS = {
    1: {'name': 'Nouveaux Départs', 'energy': 'Énergie haute, idéal pour lancer des projets', 'tone': 'dynamique'},
    2: {'name': 'Croissance', 'energy': 'Développement des initiatives, construction', 'tone': 'constructif'},
    3: {'name': 'Succès', 'energy': 'Expansion sociale, faveurs et voyages', 'tone': 'expansif'},
    4: {'name': 'Stabilité', 'energy': 'Routine, attention aux détails, préservation', 'tone': 'stable'},
    5: {'name': 'Changement', 'energy': 'Adaptation, flexibilité et pivots potentiels', 'tone': 'adaptatif'},
    6: {'name': 'Récolte', 'energy': 'Moisson des efforts, responsabilités accrues', 'tone': 'productif'},
    7: {'name': 'Préparation', 'energy': 'Repos, introspection, bilan avant nouveau cycle', 'tone': 'contemplatif'},
}

def generate_advice(decision_code: str, category: str, period_num: int) -> str:
    period = PERIODS[period_num]
    period_name = period['name']
    tone = period['tone']
    
    # Templates par catégorie et ton de période
    advices = {
        'immobilier': {
            'dynamique': f"Cette période de {period_name} favorise les nouvelles initiatives immobilières. C'est le moment d'explorer de nouvelles options et de vous lancer avec confiance. Vérifiez néanmoins chaque détail avant de vous engager : l'enthousiasme ne doit pas remplacer la vigilance.",
            'constructif': f"Durant cette phase de {period_name}, vos projets immobiliers peuvent se développer harmonieusement. Consolidez vos recherches et affinez vos critères. La patience dans la préparation garantit de meilleures décisions.",
            'expansif': f"Cette période de {period_name} ouvre des portes et facilite les contacts. Les opportunités immobilières peuvent venir de votre réseau. Restez ouvert aux propositions tout en gardant vos critères essentiels.",
            'stable': f"Cette phase de {period_name} favorise les transactions sûres et prévisibles. Privilégiez les options bien établies aux aventures risquées. C'est le moment de sécuriser plutôt que d'innover.",
            'adaptatif': f"Durant cette période de {period_name}, restez flexible dans vos recherches immobilières. Les plans peuvent changer, et c'est normal. L'adaptabilité vous mènera vers des options inattendues mais intéressantes.",
            'productif': f"Cette phase de {period_name} vous permet de récolter les fruits de vos efforts précédents. Si vous avez bien préparé, c'est le moment de conclure. Finalisez vos projets en cours avec détermination.",
            'contemplatif': f"Cette période de {period_name} invite à la réflexion avant l'action. Prenez le temps d'évaluer vos véritables besoins immobiliers. Un temps de recul maintenant évite les regrets futurs."
        },
        'finance': {
            'dynamique': f"L'énergie de {period_name} favorise les initiatives financières audacieuses. C'est le moment de lancer de nouveaux projets d'investissement. Appuyez votre enthousiasme sur des analyses solides.",
            'constructif': f"Cette phase de {period_name} soutient la construction patiente de votre patrimoine. Évitez les gains rapides au profit d'une croissance stable. La discipline financière porte ses fruits.",
            'expansif': f"Durant cette période de {period_name}, les opportunités financières peuvent se multiplier. Votre réseau peut vous ouvrir des portes intéressantes. Évaluez chaque proposition avec discernement.",
            'stable': f"Cette phase de {period_name} favorise la gestion prudente de vos finances. Consolidez vos acquis plutôt que de prendre des risques. La sécurité financière se construit pas à pas.",
            'adaptatif': f"Durant cette période de {period_name}, restez flexible dans votre stratégie financière. Les conditions du marché peuvent changer, adaptez-vous. La souplesse est une force en période d'incertitude.",
            'productif': f"Cette phase de {period_name} permet de récolter les bénéfices de vos investissements. C'est le moment de concrétiser les gains potentiels. Ne laissez pas les opportunités mûries passer.",
            'contemplatif': f"Cette période de {period_name} invite à réfléchir à votre relation avec l'argent. Prenez du recul sur vos motivations financières. La clarté intérieure précède les bonnes décisions."
        },
        'juridique': {
            'dynamique': f"L'énergie de {period_name} renforce votre position dans les négociations contractuelles. C'est le moment de finaliser des accords. Faites relire chaque document par un expert avant de signer.",
            'constructif': f"Cette phase de {period_name} favorise les accords durables et équilibrés. Prenez le temps de bien comprendre chaque clause. Un contrat bien réfléchi évite les conflits futurs.",
            'expansif': f"Durant cette période de {period_name}, les conditions de négociation vous sont favorables. Vous pouvez obtenir des termes avantageux. Restez néanmoins attentif aux engagements à long terme.",
            'stable': f"Cette phase de {period_name} favorise les contrats à termes prévisibles et sécurisés. Privilégiez les accords clairs sans zones d'ombre. La simplicité contractuelle est une force.",
            'adaptatif': f"Durant cette période de {period_name}, intégrez des clauses de flexibilité dans vos accords. Les circonstances peuvent évoluer, prévoyez-le. Un contrat adaptable résiste mieux au temps.",
            'productif': f"Cette phase de {period_name} permet de conclure des négociations en cours. Finalisez les accords préparés avec détermination. C'est le moment de transformer les discussions en engagements.",
            'contemplatif': f"Cette période de {period_name} invite à la prudence contractuelle. Prenez le temps de lire et relire avant de signer. Une décision différée vaut mieux qu'un regret permanent."
        },
        'business': {
            'dynamique': f"L'énergie de {period_name} amplifie votre leadership entrepreneurial. C'est le moment de lancer des initiatives ambitieuses. Entourez-vous d'une équipe compétente pour maximiser vos chances.",
            'constructif': f"Cette phase de {period_name} favorise le développement progressif de votre activité. Consolidez vos acquis avant d'étendre votre portée. La croissance organique est plus durable.",
            'expansif': f"Durant cette période de {period_name}, votre réseau peut catalyser votre développement. Les partenariats stratégiques sont favorisés. Soyez ouvert aux collaborations inattendues.",
            'stable': f"Cette phase de {period_name} favorise la consolidation de votre activité. Renforcez vos processus et fidélisez vos clients. La stabilité opérationnelle précède l'expansion.",
            'adaptatif': f"Durant cette période de {period_name}, restez agile dans votre stratégie d'entreprise. Le marché évolue, adaptez votre offre. La flexibilité est un avantage compétitif.",
            'productif': f"Cette phase de {period_name} permet de concrétiser vos projets en résultats. C'est le moment de transformer les efforts en revenus. Concentrez-vous sur la finalisation.",
            'contemplatif': f"Cette période de {period_name} invite à la réflexion stratégique. Prenez du recul sur votre vision d'entreprise. Un bilan honnête prépare les succès futurs."
        },
        'carriere': {
            'dynamique': f"L'énergie de {period_name} amplifie votre visibilité professionnelle. C'est le moment d'affirmer votre valeur et de demander ce que vous méritez. Appuyez vos demandes sur des réalisations concrètes.",
            'constructif': f"Cette phase de {period_name} favorise le développement de vos compétences. Investissez dans votre formation et votre expertise. La compétence reconnue ouvre les portes.",
            'expansif': f"Durant cette période de {period_name}, votre réseau professionnel est un atout majeur. Les opportunités peuvent venir de contacts inattendus. Cultivez vos relations avec sincérité.",
            'stable': f"Cette phase de {period_name} favorise la consolidation de votre position. Renforcez votre expertise dans votre domaine. La stabilité professionnelle se construit sur la fiabilité.",
            'adaptatif': f"Durant cette période de {period_name}, soyez ouvert aux évolutions de carrière. Les changements peuvent être des opportunités déguisées. L'adaptabilité est une qualité recherchée.",
            'productif': f"Cette phase de {period_name} permet de récolter les fruits de vos efforts professionnels. C'est le moment de demander une promotion ou de finaliser un projet. N'attendez pas pour concrétiser.",
            'contemplatif': f"Cette période de {period_name} invite à réfléchir à vos aspirations profondes. Votre carrière correspond-elle à vos valeurs? La clarté intérieure guide les meilleurs choix."
        },
        'personnel': {
            'dynamique': f"L'énergie de {period_name} favorise les nouveaux engagements personnels. C'est le moment de commencer de nouvelles aventures relationnelles. Assurez-vous que vos proches partagent votre vision.",
            'constructif': f"Cette phase de {period_name} favorise la construction de relations durables. Investissez du temps dans les liens qui comptent vraiment. La qualité prime sur la quantité.",
            'expansif': f"Durant cette période de {period_name}, votre cercle social peut s'enrichir. Les rencontres significatives sont favorisées. Restez ouvert aux connexions authentiques.",
            'stable': f"Cette phase de {period_name} favorise la stabilité relationnelle. Renforcez les liens existants plutôt que d'en créer de nouveaux. La fidélité nourrit la confiance.",
            'adaptatif': f"Durant cette période de {period_name}, les relations peuvent évoluer. Acceptez les changements comme des opportunités de croissance. La flexibilité relationnelle est une force.",
            'productif': f"Cette phase de {period_name} permet de concrétiser vos engagements personnels. C'est le moment de passer à l'étape suivante dans vos relations. Transformez les intentions en actions.",
            'contemplatif': f"Cette période de {period_name} invite à la réflexion sur vos relations. Quelles connexions vous nourrissent vraiment? La clarté émotionnelle précède les bons choix."
        },
        'sante': {
            'dynamique': f"L'énergie de {period_name} soutient votre vitalité et vos initiatives de santé. C'est un bon moment pour commencer un nouveau régime ou traitement. Suivez les recommandations médicales avec discipline.",
            'constructif': f"Cette phase de {period_name} favorise les soins réguliers et progressifs. Construisez de bonnes habitudes de santé pas à pas. La constance est la clé du bien-être durable.",
            'expansif': f"Durant cette période de {period_name}, votre énergie vitale peut être élevée. Profitez-en pour explorer de nouvelles approches de bien-être. Restez à l'écoute de votre corps.",
            'stable': f"Cette phase de {period_name} favorise le maintien de votre équilibre de santé. Évitez les changements brusques dans vos habitudes. La stabilité corporelle se cultive au quotidien.",
            'adaptatif': f"Durant cette période de {period_name}, soyez attentif aux signaux de votre corps. Adaptez vos soins selon vos besoins réels. La flexibilité dans l'approche favorise le bien-être.",
            'productif': f"Cette phase de {period_name} peut voir les résultats de vos efforts de santé. C'est le moment de consolider les acquis. Maintenez les bonnes habitudes qui fonctionnent.",
            'contemplatif': f"Cette période de {period_name} invite à l'écoute profonde de votre corps. Prenez le temps du repos et de la récupération. La santé se nourrit aussi de pauses."
        },
        'autre': {
            'dynamique': f"L'énergie de {period_name} vous confère l'audace nécessaire pour les décisions importantes. Faites confiance à votre élan tout en vérifiant les détails. L'enthousiasme éclairé mène au succès.",
            'constructif': f"Cette phase de {period_name} favorise les décisions réfléchies et durables. Prenez le temps de peser chaque aspect avec soin. La patience dans le choix garantit la satisfaction.",
            'expansif': f"Durant cette période de {period_name}, les options peuvent se multiplier. Restez ouvert aux opportunités tout en gardant vos critères. L'abondance de choix demande du discernement.",
            'stable': f"Cette phase de {period_name} favorise les décisions sûres et prévisibles. Privilégiez les options éprouvées aux aventures risquées. La prudence est une forme de sagesse.",
            'adaptatif': f"Durant cette période de {period_name}, restez flexible dans votre approche. Les circonstances peuvent évoluer, adaptez-vous. La souplesse décisionnelle est une force.",
            'productif': f"Cette phase de {period_name} permet de concrétiser vos intentions. C'est le moment de transformer la réflexion en action. Ne laissez pas les opportunités mûries passer.",
            'contemplatif': f"Cette période de {period_name} invite à la réflexion avant l'engagement. Prenez le recul nécessaire pour voir clairement. Une décision différée vaut mieux qu'un choix précipité."
        }
    }
    
    cat_key = category if category in advices else 'autre'
    return advices[cat_key].get(tone, advices[cat_key]['dynamique'])

def generate_all_advices():
    """Génère toutes les combinaisons de conseils"""
    sql_output = []
    
    sql_output.append("-- ================================================")
    sql_output.append("-- MIGRATION CYCLES DE VIE - CONSEILS DE DÉCISION")
    sql_output.append("-- 140 entrées = 20 types × 7 périodes (cycle personal)")
    sql_output.append("-- Utilise les codes de cycle_vie_decision_types")
    sql_output.append("-- ================================================\n")
    
    # Pour chaque période (1-7)
    for period_num in range(1, 8):
        period_info = PERIODS[period_num]
        sql_output.append(f"\n-- ================================================")
        sql_output.append(f"-- PÉRIODE {period_num} - {period_info['name']}")
        sql_output.append(f"-- Énergie: {period_info['energy']}")
        sql_output.append(f"-- ================================================\n")
        
        sql_output.append("INSERT INTO cycle_vie_decision_advice (decision_type_id, cycle_type, period_number, favorability_score, advice_text)")
        sql_output.append("SELECT dt.id, 'personal', " + str(period_num) + ", ")
        
        # Score de favorabilité basé sur la période
        scores = {1: 85, 2: 75, 3: 90, 4: 60, 5: 65, 6: 80, 7: 50}
        sql_output.append(f"  {scores[period_num]},")
        
        sql_output.append("  CASE dt.code")
        
        for code, label, category in DECISION_TYPES:
            advice = generate_advice(code, category, period_num)
            advice_escaped = advice.replace("'", "''")
            sql_output.append(f"    WHEN '{code}' THEN '{advice_escaped}'")
        
        sql_output.append("    ELSE 'Conseil générique pour cette période.'")
        sql_output.append("  END")
        sql_output.append("FROM cycle_vie_decision_types dt")
        sql_output.append("WHERE dt.code IN (" + ", ".join([f"'{code}'" for code, _, _ in DECISION_TYPES]) + ")")
        sql_output.append("ON CONFLICT (decision_type_id, cycle_type, period_number)")
        sql_output.append("DO UPDATE SET advice_text = EXCLUDED.advice_text, favorability_score = EXCLUDED.favorability_score, updated_at = NOW();\n")
    
    return "\n".join(sql_output)

if __name__ == "__main__":
    sql = generate_all_advices()
    with open("migration_cycles_vie_advice_full.sql", "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"✅ Généré {len(DECISION_TYPES) * len(PERIODS)} conseils (20 types × 7 périodes)")
    print("📁 Fichier: migration_cycles_vie_advice_full.sql")
