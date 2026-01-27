-- ================================================
-- MIGRATION CYCLES DE VIE - CONSEILS DE DÉCISION
-- 280 entrées = 20 types × 14 périodes Soul Cycle
-- Formule: Affirmation + Encouragement + Sagesse
-- ================================================

-- ================================================
-- PÉRIODE 1A - Le Guerrier Noble (22 mars - 17 avril)
-- Énergie: Leadership, noblesse, ambition
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
-- Immobilier
('location_immobilier', 1, 'A', 'Cette période amplifie votre présence et votre pouvoir de négociation. C''est un moment idéal pour visiter des biens et impressionner les propriétaires par votre assurance. Veillez toutefois à lire chaque clause avec attention : votre charisme ne doit pas masquer les détails importants du contrat.'),

('achat_immobilier', 1, 'A', 'L''énergie du Guerrier Noble soutient les acquisitions majeures. Votre capacité à prendre des décisions audacieuses est à son apogée, favorisant les négociations ambitieuses. Assurez-vous cependant que l''investissement correspond à vos moyens réels et non à votre seule ambition.'),

('demenagement', 1, 'A', 'Les astres favorisent les nouveaux départs et les installations dans des lieux qui reflètent votre statut. C''est le moment de vous établir dans un environnement à la hauteur de vos aspirations. Organisez minutieusement la logistique : votre enthousiasme ne doit pas précipiter les étapes.'),

-- Finance
('achat_vehicule', 1, 'A', 'Cette période vous pousse vers des choix qui reflètent votre personnalité de leader. L''achat d''un véhicule maintenant bénéficie de votre assurance naturelle en négociation. Restez attentif au rapport qualité-prix : le prestige ne doit pas primer sur la praticité.'),

('achat_important', 1, 'A', 'Votre discernement est aiguisé pour les acquisitions significatives. L''énergie ambiante soutient les achats qui améliorent votre quotidien de manière durable. Comparez plusieurs options avant de trancher : votre première impression, bien que souvent juste, mérite vérification.'),

('demande_financement', 1, 'A', 'Votre charisme naturel impressionne les institutions et les décideurs. C''est un excellent moment pour présenter un dossier de financement avec conviction. Préparez néanmoins des arguments chiffrés solides : votre assurance doit être soutenue par des faits concrets.'),

('recherche_argent', 1, 'A', 'Les énergies du Guerrier Noble attirent les opportunités financières vers vous. Votre magnétisme peut ouvrir des portes inattendues. Évaluez chaque proposition avec lucidité : toutes les opportunités qui se présentent ne sont pas nécessairement alignées avec vos valeurs.'),

('investissement', 1, 'A', 'Cette période favorise les placements audacieux mais réfléchis. Votre intuition financière est particulièrement affûtée pour repérer les bonnes affaires. Diversifiez vos investissements et ne mettez pas tous vos moyens dans une seule direction, aussi prometteuse soit-elle.'),

-- Juridique
('signature_contrat', 1, 'A', 'L''énergie de leadership renforce votre position dans toute négociation contractuelle. C''est le moment de finaliser des accords qui vous placent en position favorable. Faites relire le contrat par un expert : votre confiance ne doit pas vous faire négliger les subtilités juridiques.'),

-- Business
('lancement_business', 1, 'A', 'Les énergies cosmiques sont parfaitement alignées pour entreprendre avec audace. Votre vision de leader trouve un écho favorable dans l''univers. Entourez-vous de collaborateurs compétents : même le plus grand général a besoin d''une armée bien formée.'),

('partenariat', 1, 'A', 'Votre présence charismatique attire naturellement des partenaires de qualité. C''est le moment de conclure des alliances stratégiques durables. Assurez-vous que les rôles et responsabilités sont clairement définis : le respect mutuel se construit sur des bases limpides.'),

-- Carrière
('entretien_embauche', 1, 'A', 'Votre aura de leader naturel vous distingue parmi les candidats. Les recruteurs perçoivent votre potentiel de commandement et d''initiative. Restez humble dans votre présentation : la vraie noblesse se manifeste dans l''écoute autant que dans l''affirmation.'),

('demande_promotion', 1, 'A', 'L''univers soutient votre ascension professionnelle. C''est le moment de demander la reconnaissance que vous méritez avec assurance. Appuyez votre demande sur des réalisations concrètes : votre légitimité doit être évidente pour tous.'),

('demission_changement', 1, 'A', 'Les énergies favorisent les transitions vers des positions plus élevées. Si vous sentez que vous avez atteint les limites de votre poste actuel, partez avec dignité. Préparez votre succession : un vrai leader veille à ce que son départ ne crée pas de chaos.'),

-- Personnel
('voyage', 1, 'A', 'Cette période est propice aux voyages qui élèvent l''esprit et étendent vos horizons. Les déplacements entrepris maintenant peuvent avoir des répercussions positives durables. Planifiez les aspects pratiques avec soin : l''aventure est plus agréable quand la logistique est maîtrisée.'),

('mariage_engagement', 1, 'A', 'Votre énergie de Guerrier Noble apporte force et détermination à vos engagements sentimentaux. C''est un moment puissant pour officialiser une union. Assurez-vous que votre partenaire partage vos aspirations profondes : une alliance durable se construit sur des valeurs communes.'),

('debut_relation', 1, 'A', 'Les rencontres de cette période ont le potentiel de devenir significatives. Votre charisme attire naturellement des personnes de qualité. Prenez le temps de connaître l''autre au-delà de la première impression : la noblesse du cœur ne se révèle que progressivement.'),

-- Santé
('operation_medicale', 1, 'A', 'Les énergies soutiennent votre capacité de récupération et votre force vitale. C''est un moment favorable pour les interventions planifiées. Suivez scrupuleusement les recommandations médicales : votre courage ne doit pas vous faire sous-estimer l''importance du repos.'),

('debut_traitement', 1, 'A', 'Votre détermination naturelle renforce l''efficacité de tout nouveau traitement. Abordez ce parcours de soin avec la conviction d''un guerrier. Restez patient et discipliné : les plus grandes victoires se remportent étape par étape.'),

-- Autre
('autre_decision', 1, 'A', 'L''énergie du Guerrier Noble vous confère le discernement et l''audace nécessaires pour trancher. Faites confiance à votre leadership intérieur tout en restant ouvert aux conseils avisés. Vérifiez que votre décision sert vos intérêts à long terme, pas seulement votre ego du moment.')

ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity) 
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();

-- ================================================
-- PÉRIODE 1B - L'Artiste Déterminé (17 avril - 12 mai)
-- Énergie: Raffinement, subtilité, patience, talents artistiques
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 1, 'B', 'Votre sens esthétique est particulièrement aiguisé en cette période. Vous percevrez intuitivement si un lieu correspond à votre âme. Ne vous précipitez pas : la patience de l''Artiste Déterminé vous mènera vers l''endroit parfait.'),

('achat_immobilier', 1, 'B', 'Cette période favorise les acquisitions réfléchies plutôt qu''impulsives. Votre œil d''artiste repère les détails que d''autres négligent. Prenez le temps de visiter plusieurs fois avant de vous engager : la beauté vraie se révèle dans la durée.'),

('demenagement', 1, 'B', 'L''énergie ambiante soutient les transitions harmonieuses vers des environnements qui nourrissent votre créativité. Organisez votre déménagement avec soin et attention aux détails. Chaque objet mérite sa place : prenez le temps de créer un espace qui vous ressemble.'),

('achat_vehicule', 1, 'B', 'Votre goût raffiné vous guide vers des choix alliant esthétique et fonctionnalité. C''est le moment d''opter pour un véhicule qui reflète votre sens du beau. Vérifiez les aspects techniques avec autant d''attention que l''apparence : la forme doit servir la fonction.'),

('achat_important', 1, 'B', 'L''influence de l''Artiste Déterminé favorise les achats durables et de qualité. Privilégiez la beauté intemporelle aux tendances éphémères. Investissez dans des objets qui vous inspireront longtemps : la vraie valeur réside dans la satisfaction durable.'),

('demande_financement', 1, 'B', 'Votre approche subtile et patiente peut séduire les financeurs qui apprécient la maturité. Présentez votre dossier avec élégance et précision. Montrez que vous avez réfléchi à chaque aspect : la profondeur de votre préparation parlera pour vous.'),

('recherche_argent', 1, 'B', 'Les opportunités financières de cette période viennent par des voies détournées mais sûres. Cultivez vos réseaux avec patience et sincérité. Ne forcez rien : les bonnes sources de revenus se révèlent à ceux qui savent attendre.'),

('investissement', 1, 'B', 'Votre intuition artistique peut révéler des opportunités d''investissement originales. Faites confiance à votre sens de la valeur intrinsèque. Évitez les spéculations rapides : votre force réside dans la vision à long terme.'),

('signature_contrat', 1, 'B', 'Cette période favorise les accords conclus avec soin et attention aux détails. Votre patience naturelle vous protège des engagements précipités. Relisez chaque terme avec votre sensibilité d''artiste : les nuances comptent autant que les grandes lignes.'),

('lancement_business', 1, 'B', 'L''énergie de l''Artiste Déterminé soutient les projets créatifs et originaux. Votre vision unique peut conquérir un marché de niche. Construisez votre entreprise comme une œuvre d''art : avec patience, passion et souci du détail.'),

('partenariat', 1, 'B', 'Votre raffinement naturel attire des collaborateurs partageant vos standards de qualité. C''est le moment de tisser des liens basés sur des valeurs esthétiques communes. Assurez-vous que vos partenaires comprennent votre vision : la création partagée exige une harmonie profonde.'),

('entretien_embauche', 1, 'B', 'Votre présentation soignée et votre approche subtile impressionnent favorablement. Les recruteurs perçoivent votre profondeur au-delà de la surface. Montrez votre détermination derrière votre gentillesse : la douceur n''exclut pas la force.'),

('demande_promotion', 1, 'B', 'Abordez cette demande avec la patience stratégique qui vous caractérise. Laissez votre travail parler de lui-même avant de vous exprimer. Le moment venu, exposez vos mérites avec élégance : la vraie valeur n''a pas besoin de crier pour être reconnue.'),

('demission_changement', 1, 'B', 'Si un changement s''impose, effectuez-le avec la grâce qui vous définit. Préparez votre transition méticuleusement et partez sans rancœur. La porte que vous fermez avec élégance pourra se rouvrir quand vous le souhaiterez.'),

('voyage', 1, 'B', 'Cette période favorise les voyages culturels enrichissant votre sensibilité artistique. Explorez des destinations qui nourrissent votre âme et stimulent votre créativité. Planifiez votre itinéraire avec soin tout en laissant place aux découvertes spontanées.'),

('mariage_engagement', 1, 'B', 'L''énergie ambiante bénit les unions fondées sur une appréciation mutuelle de la beauté et de l''harmonie. C''est un moment propice pour sceller un engagement raffiné. Assurez-vous que votre partenaire partage votre vision de la vie : l''amour vrai est aussi une œuvre d''art.'),

('debut_relation', 1, 'B', 'Les rencontres de cette période peuvent révéler des affinités profondes. Votre patience vous permet de découvrir l''autre au-delà des apparences. Ne précipitez pas l''intimité : les plus belles relations se construisent comme des chefs-d''œuvre, couche après couche.'),

('operation_medicale', 1, 'B', 'Votre nature patiente favorise une préparation sereine et une récupération harmonieuse. Abordez cette intervention avec confiance et sans précipitation. Suivez les conseils médicaux avec la discipline d''un artiste perfectionnant son art.'),

('debut_traitement', 1, 'B', 'Votre détermination subtile mais tenace soutient l''efficacité de tout nouveau traitement. Intégrez ce parcours de soin dans votre routine avec constance. La guérison, comme la création, demande patience et persévérance.'),

('autre_decision', 1, 'B', 'L''Artiste Déterminé en vous sait que les meilleures décisions mûrissent avec le temps. Prenez le recul nécessaire pour voir la situation sous tous ses angles. Votre choix sera d''autant plus solide qu''il aura été réfléchi avec soin.')

ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity) 
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();
-- ================================================
-- PÉRIODE 2A - L'Esprit Vif (13 mai - 8 juin)
-- Énergie: Voyage, changement, intellect rapide, mains habiles
-- ================================================

INSERT INTO cycle_vie_decision_advice (decision_type_code, soul_period_number, soul_period_polarity, advice_content)
VALUES
('location_immobilier', 2, 'A', 'Votre esprit vif vous permet d''évaluer rapidement plusieurs options. Cette période favorise les visites multiples et les comparaisons efficaces. Notez vos impressions immédiatement : votre première intuition est souvent la bonne.'),
('achat_immobilier', 2, 'A', 'L''énergie du Voyageur soutient les acquisitions qui facilitent la mobilité ou offrent de la flexibilité. Considérez la revente future autant que l''usage présent. Un bien qui peut évoluer avec vous sera un meilleur investissement.'),
('demenagement', 2, 'A', 'C''est une période idéale pour les changements de lieu. Votre adaptabilité naturelle rend la transition fluide et même excitante. Organisez-vous bien car votre tendance à l''éparpillement pourrait compliquer la logistique.'),
('achat_vehicule', 2, 'A', 'Votre intellect rapide analyse efficacement les options disponibles. Privilégiez un véhicule polyvalent adapté à votre style de vie dynamique. Testez plusieurs modèles : votre corps saura lequel vous convient vraiment.'),
('achat_important', 2, 'A', 'Vos mains habiles apprécient les objets de qualité et bien conçus. Cette période favorise les achats pratiques et multifonctionnels. Évitez les gadgets éphémères : investissez dans ce qui vous servira longtemps.'),
('demande_financement', 2, 'A', 'Votre éloquence naturelle et votre esprit vif impressionnent les décideurs. Présentez votre dossier avec dynamisme et clarté. Préparez des réponses aux questions difficiles : votre agilité mentale sera votre meilleur atout.'),
('recherche_argent', 2, 'A', 'Le Voyageur attire les opportunités par ses multiples connexions. Activez votre réseau et explorez des pistes variées. Ne vous dispersez pas trop : concentrez votre énergie sur les sources les plus prometteuses.'),
('investissement', 2, 'A', 'Votre capacité à jongler avec plusieurs idées peut révéler des investissements innovants. Diversifiez intelligemment votre portefeuille. Méfiez-vous des opportunités trop volatiles : votre nature changeante a besoin de placements stables pour l''équilibrer.'),
('signature_contrat', 2, 'A', 'Votre intellect perçant repère rapidement les clauses problématiques. C''est un bon moment pour négocier des termes flexibles. Prenez néanmoins le temps de tout lire : votre rapidité ne doit pas devenir précipitation.'),
('lancement_business', 2, 'A', 'L''énergie du Voyageur favorise les entreprises agiles et innovantes. Votre capacité à pivoter rapidement est un avantage compétitif. Structurez votre vision : même les projets flexibles ont besoin de fondations solides.'),
('partenariat', 2, 'A', 'Votre réseau étendu offre de nombreuses possibilités de collaboration. Les partenaires complémentaires à votre dynamisme sont idéaux. Clarifiez les attentes dès le départ : votre style changeant peut déstabiliser des collaborateurs plus statiques.'),
('entretien_embauche', 2, 'A', 'Votre vivacité d''esprit et votre éloquence naturelle captiveront les recruteurs. Montrez votre polyvalence et votre capacité d''adaptation. Démontrez aussi votre constance : rassurez sur votre capacité à vous engager durablement.'),
('demande_promotion', 2, 'A', 'Votre esprit vif vous a probablement permis d''exceller dans de nombreux domaines. C''est le moment de valoriser cette polyvalence. Présentez des résultats concrets : votre agilité doit être soutenue par des accomplissements mesurables.'),
('demission_changement', 2, 'A', 'Le Voyageur en vous est naturellement attiré par les nouveaux horizons. Si le changement vous appelle, suivez cette impulsion. Assurez une transition professionnelle : ne brûlez pas les ponts que vous pourriez vouloir retraverser.'),
('voyage', 2, 'A', 'Cette période est parfaitement alignée avec les déplacements et les explorations. C''est LE moment pour partir à l''aventure. Planifiez les grandes lignes mais laissez place à l''improvisation : les meilleures découvertes sont souvent inattendues.'),
('mariage_engagement', 2, 'A', 'Votre nature voyageuse demande un partenaire qui accepte votre besoin de variété. Engagez-vous avec quelqu''un qui peut évoluer à vos côtés. Discutez de vos visions respectives de la liberté et de l''engagement : l''harmonie vient de la clarté.'),
('debut_relation', 2, 'A', 'Les rencontres de cette période peuvent être stimulantes et enrichissantes. Votre charme communicatif attire naturellement. Prenez le temps de dépasser le stade de la conversation brillante : la profondeur émotionnelle compte aussi.'),
('operation_medicale', 2, 'A', 'Votre adaptabilité favorise une récupération rapide. Abordez l''intervention avec curiosité plutôt qu''anxiété. Suivez les protocoles médicaux même s''ils vous semblent contraignants : la discipline accélère la guérison.'),
('debut_traitement', 2, 'A', 'Votre esprit analytique comprendra rapidement les enjeux de votre traitement. Posez toutes vos questions aux professionnels de santé. Tenez un journal de vos progrès : cela maintiendra votre motivation et aidera votre suivi.'),
('autre_decision', 2, 'A', 'L''Esprit Vif en vous peut envisager simultanément plusieurs options. Listez les pour et les contre avec méthode. Une fois votre décision prise, engagez-vous pleinement : l''hésitation permanente est l''ennemi du Voyageur.')
ON CONFLICT (decision_type_code, soul_period_number, soul_period_polarity) 
DO UPDATE SET advice_content = EXCLUDED.advice_content, updated_at = NOW();
