-- =============================================
-- SEED DATA: Portrait de l'Âme (14 profils)
-- Service 01 - Cycles de Vie
-- =============================================
-- NOTE: Le contenu complet est dans les fichiers content/*.md
-- Ce script insère les métadonnées et références

INSERT INTO soul_profiles (
    period_number, polarity, cosmic_identity,
    date_start, date_end, full_content,
    affinites_geo, vigilance_sante, conseils
) VALUES
-- Période 1A
(1, 'A', 'L''Âme Souveraine',
 '03-22', '04-17',
 '-- VOIR content/periode_1A.md --',
 ARRAY['Chaldée', 'Phénicie', 'Italie', 'Sicile', 'Suisse', 'Écosse'],
 ARRAY['Affections du cœur', 'Fatigue cérébrale', 'Sensibilité oculaire', 'États fébriles'],
 ARRAY['Embrassez votre aspiration naturelle', 'Cultivez la patience', 'Équilibrez pouvoir et humilité', 'Protégez votre cœur']),

-- Période 1B
(1, 'B', 'L''Âme Artiste Raffinée',
 '04-18', '05-12',
 '-- VOIR content/periode_1B.md --',
 ARRAY['Italie', 'Sicile', 'Suisse', 'Écosse', 'Chaldée', 'Phénicie'],
 ARRAY['Affections du cœur', 'Fatigue cérébrale', 'Sensibilité oculaire', 'États fébriles'],
 ARRAY['Cultivez votre art', 'Affirmez-vous avec grâce', 'Transformez l''obstination en persévérance', 'Entourez-vous de beauté']),

-- Période 2A
(2, 'A', 'L''Âme Voyageuse Intellectuelle',
 '05-13', '06-08',
 '-- VOIR content/periode_2A.md --',
 ARRAY['Norvège', 'Danemark', 'Pays-Bas', 'Belgique'],
 ARRAY['Problèmes de vessie', 'Conditions rhumatismales', 'Rhumes et toux', 'Troubles de l''estomac', 'Fatigue oculaire'],
 ARRAY['Honorez votre besoin de changement', 'Choisissez vos compagnies avec soin', 'Cultivez deux domaines', 'Gardez du temps pour la méditation']),

-- Période 2B
(2, 'B', 'L''Âme Intuitive Lumineuse',
 '06-09', '07-03',
 '-- VOIR content/periode_2B.md --',
 ARRAY['Norvège', 'Danemark', 'Pays-Bas', 'Belgique'],
 ARRAY['Problèmes de vessie', 'Conditions rhumatismales', 'Rhumes et toux', 'Troubles de l''estomac', 'Fatigue oculaire'],
 ARRAY['Faites confiance à votre intuition', 'Choisissez un ou deux domaines d''excellence', 'Partagez vos connaissances', 'Maintenez des liens humains']),

-- Période 3A
(3, 'A', 'L''Âme Conquérante Audacieuse',
 '07-04', '07-31',
 '-- VOIR content/periode_3A.md --',
 ARRAY['Lombardie', 'Bavière', 'Nord de la France', 'Paris'],
 ARRAY['Maladies du sang', 'Problèmes biliaires', 'Fièvres intenses', 'Tension artérielle'],
 ARRAY['Canalisez votre énergie', 'Cultivez l''humilité', 'Protégez votre corps', 'Choisissez vos causes']),

-- Période 3B
(3, 'B', 'L''Âme Souveraine Royale',
 '08-01', '08-24',
 '-- VOIR content/periode_3B.md --',
 ARRAY['Lombardie', 'Bavière', 'Nord de la France', 'Paris'],
 ARRAY['Maladies du sang', 'Problèmes biliaires', 'Fièvres', 'Équilibre alimentaire'],
 ARRAY['Donnez à vos enfants toute l''éducation possible', 'Cultivez l''humilité dans la grandeur', 'Protégez votre réputation', 'Entourez-vous de conseillers honnêtes']),

-- Période 4A
(4, 'A', 'L''Âme Sage Érudite',
 '08-25', '09-20',
 '-- VOIR content/periode_4A.md --',
 ARRAY['Flandre', 'Égypte', 'Inde', 'Sud de la France'],
 ARRAY['Vertiges', 'Fatigues cérébrales', 'Imperfections d''élocution', 'Enrouement', 'Rhumes de tête'],
 ARRAY['Canalisez votre imagination', 'Partagez votre savoir', 'Équilibrez l''intellectuel et le pratique', 'Protégez votre système nerveux']),

-- Période 4B
(4, 'B', 'L''Âme de l''Équilibre Harmonieux',
 '09-21', '10-15',
 '-- VOIR content/periode_4B.md --',
 ARRAY['Flandre', 'Égypte', 'Inde', 'Sud de la France'],
 ARRAY['Vertiges', 'Fatigues cérébrales', 'Difficultés d''élocution', 'Rhumes'],
 ARRAY['Acceptez que l''équilibre parfait n''existe pas', 'Osez prendre position', 'Créez de la beauté autour de vous', 'Guidez les enfants et les jeunes']),

-- Période 5A
(5, 'A', 'L''Âme Guerrière Passionnée',
 '10-16', '11-11',
 '-- VOIR content/periode_5A.md --',
 ARRAY['Babylone', 'Perse', 'Égypte', 'Palestine', 'Chine', 'Japon'],
 ARRAY['Inflammations', 'Conditions sanguines', 'Maladies de peau', 'Rhumatismes', 'Angine', 'Fièvres'],
 ARRAY['Choisissez vos batailles', 'Prenez soin de vous', 'Célébrez vos victoires', 'Acceptez de l''aide']),

-- Période 5B
(5, 'B', 'L''Âme Généreuse et Juste',
 '11-12', '12-07',
 '-- VOIR content/periode_5B.md --',
 ARRAY['Perse', 'Égypte', 'Palestine', 'Chine', 'Japon'],
 ARRAY['Inflammations', 'Conditions sanguines', 'Maladies de peau', 'Risques cardiovasculaires'],
 ARRAY['Restez fidèle à vos principes', 'Célébrez les petites victoires', 'Entourez-vous de personnes intègres', 'Prenez soin de votre santé']),

-- Période 6A
(6, 'A', 'L''Âme Stratège Patiente',
 '12-08', '01-03',
 '-- VOIR content/periode_6A.md --',
 ARRAY['Grèce', 'Inde', 'Cuba', 'Antilles', 'Amérique du Sud', 'Palestine'],
 ARRAY['Problèmes de genoux', 'Désordres intestinaux', 'Éruptions cutanées', 'Mélancolie', 'Accidents'],
 ARRAY['Gardez de la flexibilité', 'Investissez dans les relations', 'Célébrez les étapes', 'Prenez soin de votre mental']),

-- Période 6B
(6, 'B', 'L''Âme Ambitieuse Méthodique',
 '01-04', '01-29',
 '-- VOIR content/periode_6B.md --',
 ARRAY['Grèce', 'Inde', 'Cuba', 'Amérique du Sud', 'Proche-Orient'],
 ARRAY['Problèmes articulaires', 'Désordres digestifs', 'États mélancoliques', 'Risques de chutes'],
 ARRAY['Cultivez la chaleur humaine', 'Acceptez l''incertitude', 'Partagez vos découvertes', 'Surveillez votre moral']),

-- Période 7A
(7, 'A', 'L''Âme Humaniste Visionnaire',
 '01-30', '02-26',
 '-- VOIR content/periode_7A.md --',
 ARRAY['Angleterre', 'Allemagne', 'Grandes métropoles internationales'],
 ARRAY['Problèmes circulatoires', 'Affections nerveuses', 'Sensibilité aux environnements', 'Épuisement'],
 ARRAY['Choisissez un combat principal', 'Ancrez-vous dans le concret', 'Protégez votre énergie', 'Entourez-vous de réalistes']),

-- Période 7B
(7, 'B', 'L''Âme Mystique Intuitive',
 '02-27', '03-21',
 '-- VOIR content/periode_7B.md --',
 ARRAY['Lieux de pèlerinage', 'Sites sacrés antiques', 'Montagnes', 'Déserts'],
 ARRAY['Problèmes circulatoires', 'Affections nerveuses', 'Sensibilité environnementale'],
 ARRAY['Honorez votre nature mystique', 'Développez des pratiques de protection', 'Gardez un pied dans le monde matériel', 'Trouvez votre communauté']);

-- =============================================
-- NOTE IMPORTANTE POUR L'IMPLÉMENTATION
-- =============================================
-- 
-- Le champ 'full_content' doit être rempli avec le contenu 
-- complet des fichiers content/periode_*.md
-- 
-- Vous pouvez le faire manuellement ou via un script qui 
-- lit les fichiers et met à jour la base de données.
--
-- Exemple de mise à jour:
-- UPDATE soul_profiles 
-- SET full_content = '[CONTENU DU FICHIER]'
-- WHERE period_number = 1 AND polarity = 'A';
-- =============================================
