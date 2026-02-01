-- ═══════════════════════════════════════════════════════════════════════════
-- 06_insertion_periode_3.sql - Portrait de l'Âme (Périodes 3A et 3B)
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO cycle_vie_soul_periods (
    period_number, polarity, date_start, date_end, period_name, period_title,
    description_general, traits_positifs, traits_vigilance, professions_favorables,
    sante_vigilance, pays_affinites, conseils, message_cosmique, is_active
) VALUES 
-- PÉRIODE 3A
(3, 'A', '05-21', '06-21', 'Les Conquérants', 'L''Âme Conquérante Ardente',
E'Vous êtes né(e) sous le signe du feu intérieur. Une énergie brûlante coule dans vos veines, vous poussant sans cesse vers l''avant, vers de nouvelles conquêtes, vers de nouveaux sommets.\n\nCette ardeur n''est pas simplement de l''ambition — c''est une force vitale qui vous distingue de la masse. Là où d''autres hésitent, vous foncez. Là où d''autres voient des obstacles, vous voyez des défis à relever.\n\nVotre âme a traversé des vies de guerrier(ère), de pionnier(ère), de conquérant(e). Ces mémoires cosmiques vous donnent un courage naturel et une capacité à affronter l''adversité que beaucoup envient.',
E'**Le Courage Inébranlable**\nVous n''avez pas peur de prendre des risques. Cette audace vous ouvre des portes fermées aux autres.\n\n**L''Énergie Débordante**\nVous possédez des réserves d''énergie que d''autres ne peuvent qu''imaginer.\n\n**La Capacité d''Initiative**\nVous êtes souvent le/la premier(ère) à agir, à proposer, à vous lancer.\n\n**La Résilience Naturelle**\nLes échecs vous ralentissent rarement longtemps. Vous rebondissez avec force.',
E'**L''Impulsivité**\nVotre ardeur peut parfois vous pousser à agir avant de réfléchir. Apprenez à canaliser cette énergie.\n\n**La Tendance à l''Épuisement**\nVous brûlez vite et fort. Apprenez à ménager vos forces pour les batailles importantes.',
E'**Les Métiers de l''Action**\n• Entrepreneur(se) ou fondateur(trice)\n• Athlète professionnel(le) ou coach\n• Militaire ou pompier\n• Chirurgien(ne) ou urgentiste\n\n**Les Métiers de la Conquête**\n• Commercial(e) de haut niveau\n• Explorateur(trice) ou aventurier(ère)\n• Journaliste de terrain\n• Négociateur(trice)',
E'• Blessures accidentelles (prudence !)\n• Fièvres intenses — Votre constitution ardente peut s''enflammer\n• Tension artérielle — À surveiller régulièrement\n• Attention au surmenage et à l''excès alimentaire, surtout de viande',
E'Votre âme résonne avec :\n• L''Arabie et le désert\n• Jérusalem et les terres saintes\n• L''Allemagne et son histoire de guerriers\n• Les terres du Nord européen',
E'1. **Canalisez Votre Énergie** — Choisissez des batailles dignes de vous.\n2. **Cultivez l''Humilité** — Vos victoires parlent d''elles-mêmes sans que vous ayez besoin de le faire.\n3. **Protégez Votre Corps** — Ce véhicule ardent a besoin d''attention et de repos.\n4. **Choisissez Vos Causes** — Votre énergie est trop précieuse pour être gaspillée.',
E'Vous êtes venu(e) dans cette vie pour repousser les frontières du possible. Votre mission est de montrer aux autres que les obstacles ne sont que des illusions, que la volonté humaine peut tout surmonter. Mais n''oubliez jamais que la plus grande victoire est celle sur soi-même.',
true),

-- PÉRIODE 3B
(3, 'B', '05-21', '06-21', 'Les Souverains Magnifiques', 'L''Âme Souveraine Royale',
E'Vous partagez le feu intérieur de vos proches cosmiques, mais il brûle en vous d''une façon différente — plus maîtrisée, plus royale, plus magnifique. Là où certains conquièrent par la force brute, vous conquérez par le charisme et la présence.\n\nVotre âme porte les traces de vies passées où vous avez occupé des trônes, dirigé des royaumes, influencé le cours de l''histoire. Cette mémoire cosmique vous confère une dignité naturelle et une capacité de leadership qui impressionne.\n\nVous n''avez pas besoin de lever la voix pour être entendu(e). Votre présence seule commande le respect.',
E'**Le Charisme Royal**\nVotre simple présence impose le respect et l''admiration.\n\n**La Générosité du Cœur**\nComme les grands souverains, vous savez donner généreusement.\n\n**La Vision à Long Terme**\nVous pensez en termes de générations, pas en termes de jours.\n\n**La Capacité à Inspirer**\nLes autres vous suivent naturellement, attirés par votre lumière intérieure.',
E'**L''Orgueil Royal**\nAttention à ne pas confondre dignité et arrogance. La vraie royauté est humble.\n\n**L''Attachement aux Apparences**\nVotre réputation compte beaucoup pour vous — parfois trop. Apprenez à laisser aller le regard des autres.',
E'**Les Métiers de Pouvoir**\n• Dirigeant(e) d''entreprise ou CEO\n• Politique ou gouvernant\n• Magistrat(e) ou juge\n• Président(e) d''association\n\n**Les Métiers d''Influence**\n• Producteur(trice) ou mécène\n• Directeur(trice) de fondation\n• Ambassadeur(trice)\n• Grand(e) éditeur(trice)',
E'• Mêmes vigilances que vos proches cosmiques\n• Problèmes biliaires et fièvres\n• Mais avec une attention particulière à l''équilibre alimentaire\n• Évitez les excès de viande et d''aliments épicés',
E'Comme vos proches cosmiques :\n• L''Arabie ancestrale\n• Jérusalem la sacrée\n• L''Allemagne et ses cours royales\n• Toute terre qui a connu de grands règnes',
E'1. **Donnez à Vos Enfants Toute l''Éducation Possible** — Ils sont appelés à de hautes destinées.\n2. **Cultivez l''Humilité dans la Grandeur** — Les plus grands souverains sont ceux qui servent.\n3. **Protégez Votre Réputation avec Sagesse** — Mais sans devenir prisonnier des apparences.\n4. **Entourez-Vous de Conseillers Honnêtes** — Les flatteurs sont le danger des puissants.',
E'Vous êtes venu(e) dans cette vie pour régner — non pas par la tyrannie, mais par l''exemple. Votre mission est d''élever tous ceux qui vous entourent, de créer un royaume de justice et de beauté partout où vous passez. Rappelez-vous : la vraie royauté se mesure au bonheur qu''elle apporte à ses sujets.',
true);

SELECT '✅ PÉRIODE 3 (3A + 3B) INSÉRÉE' as status;
