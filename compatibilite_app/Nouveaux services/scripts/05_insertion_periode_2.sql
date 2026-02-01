-- ═══════════════════════════════════════════════════════════════════════════
-- 05_insertion_periode_2.sql - Portrait de l'Âme (Périodes 2A et 2B)
-- Exécuter APRÈS 03_recreation_table_soul_periods.sql
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO cycle_vie_soul_periods (
    period_number, polarity, date_start, date_end, period_name, period_title,
    description_general, traits_positifs, traits_vigilance, professions_favorables,
    sante_vigilance, pays_affinites, conseils, message_cosmique, is_active
) VALUES 
-- PÉRIODE 2A
(2, 'A', '04-20', '05-20', 'Les Voyageurs', 'L''Âme Voyageuse Curieuse',
E'Vous êtes marqué(e) d''une curiosité intellectuelle profonde et d''un désir insatiable de comprendre le monde. Votre âme est celle d''un voyageur éternel — non pas seulement au sens géographique, mais aussi dans le voyage de l''esprit.\n\nL''amour du voyage est ancré profondément en vous. Cette envie n''est pas un simple désir de vacances : c''est un appel cosmique à l''exploration, à la découverte de nouveaux horizons et de nouvelles perspectives.\n\nVous possédez une capacité remarquable à vous adapter à différents environnements et à communiquer avec des personnes de tous horizons. Cette versatilité est l''un de vos plus grands atouts.',
E'**La Curiosité Intellectuelle**\nVotre esprit est toujours en quête de nouvelles connaissances. Aucun sujet ne vous est étranger.\n\n**L''Adaptabilité Remarquable**\nVous vous ajustez facilement à de nouveaux environnements et situations.\n\n**Le Don de Communication**\nVous savez vous faire comprendre de tous et établir des ponts entre les cultures.\n\n**L''Esprit d''Aventure**\nVous n''avez pas peur de l''inconnu — au contraire, il vous attire.',
E'**L''Instabilité Potentielle**\nVotre besoin de changement peut parfois vous empêcher de vous enraciner là où c''est nécessaire.\n\n**La Difficulté à Approfondir**\nVotre curiosité pour tout peut vous disperser. Apprenez à aller en profondeur dans quelques domaines choisis.',
E'**Les Métiers du Voyage**\n• Guide touristique ou agent de voyages\n• Correspondant(e) à l''étranger\n• Commercial(e) international(e)\n• Pilote ou personnel navigant\n\n**Les Métiers de la Communication**\n• Journaliste ou reporter\n• Traducteur/Traductrice\n• Professeur de langues\n• Diplomate ou attaché culturel',
E'• Troubles digestifs liés au changement constant d''alimentation\n• Problèmes nerveux dus à l''agitation mentale\n• Fatigue due aux voyages fréquents',
E'Votre âme résonne avec :\n• L''Atlantide (symboliquement)\n• L''Égypte et ses mystères\n• L''Inde et sa diversité\n• Le Japon et sa dualité tradition/modernité',
E'1. **Honorez Votre Besoin de Changement** — Ce n''est pas un défaut mais une caractéristique de votre âme.\n2. **Choisissez Vos Compagnies avec Soin** — Entourez-vous de personnes qui élèvent votre esprit.\n3. **Cultivez Deux Domaines** — Permettez-vous d''avoir plusieurs centres d''intérêt simultanés.\n4. **Gardez du Temps pour la Méditation** — Votre esprit actif a besoin de moments de calme.',
E'Vous êtes venu(e) dans cette vie pour explorer toutes les facettes de l''existence humaine. Votre mission n''est pas de vous fixer, mais de collecter des expériences et des sagesses pour les partager. Vous êtes un pont entre les mondes, un messager entre les cultures.',
true),

-- PÉRIODE 2B
(2, 'B', '04-20', '05-20', 'Les Intuitifs', 'L''Âme Intuitive Studieuse',
E'Vous partagez avec vos proches cosmiques l''amour du savoir et de la découverte, mais votre approche est différente. Là où d''autres voyagent physiquement, vous voyagez dans les livres, les idées et les concepts.\n\nVous possédez une capacité intuitive remarquable pour percevoir les vérités cachées. Cette faculté, combinée à votre amour de l''étude, fait de vous un(e) chercheur(se) né(e).\n\nVotre mémoire est exceptionnelle, et vous avez la capacité de relier des informations apparemment disparates en un tout cohérent.',
E'**L''Intuition Aiguisée**\nVous percevez ce qui échappe aux autres. Vos pressentiments sont souvent justes.\n\n**La Mémoire Exceptionnelle**\nLes informations s''ancrent durablement dans votre esprit.\n\n**La Capacité de Synthèse**\nVous savez relier des éléments disparates pour en faire un ensemble cohérent.\n\n**L''Amour de l''Étude**\nL''apprentissage n''est pas une corvée pour vous, c''est un plaisir.',
E'**La Tendance à l''Isolement**\nVotre préférence pour l''étude peut vous éloigner des interactions sociales nécessaires.\n\n**L''Intellectualisation Excessive**\nVous pouvez parfois rationaliser ce qui devrait être simplement ressenti.',
E'**Les Métiers de la Recherche**\n• Chercheur(se) académique\n• Historien(ne) ou archéologue\n• Écrivain(e) ou essayiste\n• Bibliothécaire ou archiviste\n\n**Les Métiers de l''Enseignement**\n• Professeur universitaire\n• Formateur(trice) spécialisé(e)\n• Conférencier(ère)\n• Auteur de manuels',
E'• Troubles digestifs liés à la sédentarité\n• Problèmes de vue (lecture intensive)\n• Troubles du sommeil (esprit trop actif)',
E'Comme vos proches cosmiques :\n• L''Égypte et ses bibliothèques anciennes\n• L''Inde et ses textes sacrés\n• Le Japon et sa culture de l''étude',
E'1. **Faites Confiance à Votre Intuition** — Elle ne vous trompe presque jamais.\n2. **Choisissez Un ou Deux Domaines d''Excellence** — La profondeur plutôt que la largeur.\n3. **Partagez Vos Connaissances** — Elles prennent de la valeur en étant transmises.\n4. **Maintenez des Liens Humains** — Le savoir s''enrichit par l''échange.',
E'Vous êtes venu(e) dans cette vie pour être un phare de connaissance et de sagesse. Vos dons de perception et d''anticipation sont rares et précieux. Utilisez-les pour guider les autres et éclairer les chemins obscurs.',
true);

SELECT '✅ PÉRIODE 2 (2A + 2B) INSÉRÉE' as status;
SELECT period_number, polarity, period_name, LENGTH(conseils) as conseils_len FROM cycle_vie_soul_periods WHERE period_number = 2;
