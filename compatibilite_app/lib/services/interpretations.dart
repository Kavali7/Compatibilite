const Map<int, String> baseNumberMeanings = {
  1:
      'Leadership naturel, aime ouvrir la voie. Energie directe, agit vite. Cherche autonomie et initiative. Peut confondre vitesse et precipitation. Tendance a vouloir tout controler. Besoin d apprendre a deleguer. Courageux face aux defis. Peut etre irritable si on le freine. Progresse quand il pose un rythme stable. Conseil: ecouter les autres et laisser de la place.',
  2:
      'Sens du lien et de l harmonie. Empathique, saisit les nuances et relie les points de vue. Diplomate, favorise la cooperation. Peut se taire pour eviter le conflit. Risque de dependance affective. Besoin d affirmer clairement ses besoins. Peut ruminer les critiques. Trouve sa force dans la complementarite. Stabilise la relation par l ecoute reciproque. Conseil: fixer des limites et prendre des decisions.',
  3:
      'Expression vive et joie communicative. Sociable, relie les gens et aime jouer avec les idees. Creativite intuitive et humour. Peut se disperser s il s ennuie. Cherche la stimulation et la nouveaute. Besoin de discipline pour terminer. Sensible aux retours, peut douter sans feedback. Apprend a ecouter autant qu a parler. La joie est sa ressource pour avancer. Conseil: canaliser l energie dans un projet concret.',
  4:
      'Construction et stabilite. Pragmatique, methodique, avance pas a pas. Besoin de cadre et de plan. Fiable et rassurant, mais peut devenir rigide. Le changement brusque peut le bloquer. Apprend a garder de la souplesse. Excele sur le long terme et dans l organisation. Peut se fatiguer en portant tout seul. Valorise l utilite et le concret. Conseil: alterner effort et pauses, deleguer quand c est possible.',
  5:
      'Liberte et mouvement. Curiosite forte, aime explorer et changer. Energie adaptable, pense vite. Peut s ennuyer ou partir trop vite. Goût du risque, besoin de garde-fous. Souple et malin pour contourner les obstacles. Peut sembler instable s il ne finit pas. Apprend a choisir des changements alignes. Aime surprendre et etre surprendre. Conseil: fixer quelques priorites et tenir jusqu au bout.',
  6:
      'Harmonie et service. Protecteur, soigne le lien, recherche un foyer paisible. Sens du beau et du confort. Peut se sur-responsabiliser. Tendance au perfectionnisme relationnel. Besoin de poser des limites pour ne pas se vider. Aime rassembler et apaiser. Peut culpabiliser pour les autres. Besoin d etre soutenu autant qu il soutient. Conseil: partager la charge et garder du temps pour soi.',
  7:
      'Introspection et quete de sens. Analyse, observe, cherche la verite. Besoin de solitude pour integrer. Peut paraitre distant ou secret. Intuition fine, mais scepticisme possible. Apprend a partager ses ressentis. Observe avant d agir, trouve des solutions subtiles. Se ressource dans la nature ou l etude. Peut s isoler s il ne communique pas. Conseil: alterner retrait et echange, ouvrir ses conclusions.',
  8:
      'Pouvoir et realisation. Vision strategique, aime diriger et impacter. Sens du concret et des ressources. Peut devenir controleur ou trop exigeant. Besoin de reconnaissance et de resultats visibles. Apprend a deleguer et a faire confiance. Gere bien la matiere quand il reste aligne et etique. Risque d epuisement par surengagement. La mesure est sa force. Conseil: equilibrer ambition et respect du rythme commun.',
  9:
      'Idealiste et humaniste. Altruiste, ouvert aux cultures et aux differents points de vue. Sens du collectif et de l universel. Peut vouloir sauver tout le monde. Risque de dispersion et de flou pratique. Besoin de limites pour se proteger. Vision large, sensibilite aux injustices. Emotif et empathique, se recharge dans la creativite ou le voyage. Apprend a finir et a trier. Conseil: garder un socle personnel clair avant de se donner.',
  11:
      'Intuition haute et inspiration. Hyper sensible aux ambiances. Vision fine, creativite spirituelle. Peut etre anxieux ou surexcite. Besoin d ancrage et de routines pour se stabiliser. Capte ce qui n est pas dit. Risque de surcharge mentale. Apprend a filtrer l essentiel. Quand aligne, guide naturellement et inspire. Conseil: ritualiser l ancrage (respiration, corps) pour clarifier ses choix.',
  22:
      'Maitre batisseur: capacite a realiser grand en restant pragmatique. Vision d architecte, aime structurer et durer. Peut se sentir ecrase par la charge. Besoin de decouper en etapes et de s entourer. Equilibre materiel et sens. Peut osciller entre doute et puissance. Apprend a collaborer pour tenir la longueur. Quand aligne, concreti se des projets solides. Conseil: poser des fondations avant d accelerer.',
  33:
      'Service et inspiration elevee. Souhaite aider largement, vibration altruiste. Peut se sur-responsabiliser ou viser le parfait. Besoin de joie simple pour durer. Sens artistique et empathie forte. Peut oublier ses propres besoins en aidant. Apprend a mettre des limites saines. Guide en montrant l exemple. Trouve sa force dans la compassion et l humour. Conseil: prendre soin de soi avant de servir les autres.',
};

const Map<int, String> nameNumberMeanings = {
  1:
      'On te percoit comme moteur et initiateur. Communication directe, energie qui pousse en avant. Inspire par ton courage et ta franchise. Peut sembler pressant si tu ne temporises pas. Ta confiance rassure quand elle reste ouverte. Risque d intimider les plus calmes. Apprend a expliquer le pourquoi de tes choix. Les autres suivent tes impulsions si tu inclus leurs idees. Ta presence donne de l elan aux projets. Conseil: laisser de l espace et inviter le feedback.',
  2:
      'Image conciliante et relationnelle. On vient vers toi pour mediatier ou apaiser. Empathie appreciee, tu remarques les details. Risque de t effacer pour garder la paix. Parfois hesitant si tu attends trop l accord de tous. Ta douceur facilite la cooperation. Apprend a nommer tes envies sans crainte du conflit. Tu rassures par ta constance dans le lien. Conseil: poser tes limites clairement et plus tot.',
  3:
      'Expression vive, humour et legerete percue. On attend de toi des idees et de l ambiance. Charme social, facilite a briser la glace. Risque de dispersion si tu multiplies les pistes. Parfois pris moins au serieux si tu ne cadres pas. Ta creativite motive le groupe. Apprend a conclure ce que tu lances. Les autres comptent sur ta capacite a communiquer. Conseil: annoncer tes priorites et tenir le cap.',
  4:
      'Image serieuse et fiable. On te voit comme quelqu un de solide et organise. Ta regularite rassure. Risque d etre percu rigide si tu refuses l imprevu. Tu inspires confiance pour les projets longs. Apprend a montrer ta flexibilite. Ta presence structure les equipes. Parfois trop exigeant sur les procedures. Conseil: garder une marge de souplesse et celebrer les progres.',
  5:
      'On te voit mobile, curieux, adaptable. Energie qui dynamise et apporte du neuf. Tu sais rebondir et improviser. Peut paraitre instable si tu changes souvent d avis. Ta vivacite amuse et motive. Apprend a clarifier tes engagements. Tu ouvres les possibles et encourages le courage. Risque de survoler les sujets. Conseil: choisir quelques axes clairs pour canaliser ton mouvement.',
  6:
      'Image protectrice et bienveillante. On te reconnait pour ton sens du soin et de l esthetique. Tu rassembles et apaises. Risque de paraitre paternaliste si tu imposes ton idee du bien. Tu portes beaucoup pour les autres. Apprend a demander de l aide. Ta presence rend l ambiance plus douce. Conseil: partager la charge et valider que chacun veut ton soutien.',
  7:
      'Aura d analyste et de profondeur. On te percoit comme observateur et fin lecteur des situations. Parfois mysterieux ou distant. Ta reflexion inspire confiance aux moments critiques. Risque d isolement si tu ne partages pas tes conclusions. Les autres viennent chercher ton regard lucide. Apprend a formuler simplement tes ressentis. Conseil: donner un peu plus d acces a ton monde interieur.',
  8:
      'Image de decideur et d impact. On te sent capable de trancher et de porter des objectifs. Charisme quand tu restes juste. Peut paraitre autoritaire si tu n ecoutes pas. Ta vision strategique rassure sur les resultats. Risque de tension avec ceux qui craignent le controle. Apprend a negocier sans perdre ta direction. Conseil: expliciter tes criteres et reconnaitre les apports des autres.',
  9:
      'Image altruiste et ouverte. On te voit comme genereux, inspire par de grandes causes. Tu offres une vision large et empathique. Risque de te disperser ou de manquer de limites. Ta chaleur rassemble, mais tu peux t oublier. Apprend a poser un cadre pour durer. Les autres apprecient ta tolerance. Conseil: proteger ton energie et clarifier ce que tu acceptes vraiment.',
  11:
      'Presence intuitive et inspiree percue par les autres. Aura sensible, tu captes vite les ambiances. On vient chercher ta finesse, mais tu peux paraitre volatil. Risque de surcharge si tu laisses tout entrer. Apprend a proteger ton espace et a canaliser ton message. Quand ancre, tu motives par ton clair ressenti. Ta sensibilite eleve le niveau de confiance. Conseil: filtrer, respirer, choisir tes contextes.',
  22:
      'On te voit comme batisseur ou organisateur solide. Vision long terme perceptible, meme si tu doutes parfois. Les autres comptent sur ta capacite a structurer. Risque de pression si tu portes trop. Apprend a deleguer et a decouper. Ta parole pèse quand elle est simple et concrete. Tu rassures par ta coherence entre idee et action. Conseil: clarifier les priorites et partager le plan.',
  33:
      'Image chaleureuse et upliftante. Tu motives, apaises, inspires. Risque de te sur-responsabiliser pour tous. Sens artistique et empathie visible. Apprend a dire non pour te preserver. Ta generosite est d autant plus forte quand tu gardes ton energie. Les autres te voient comme soutien fiable. Conseil: prendre soin de toi avant de servir pour durer.',
};

const Map<int, String> coupleMeanings = {
  1: '''
Votre rencontre n’a rien d’un hasard. C’est celle de deux flammes au tempérament ardent, 
deux êtres nés pour avancer, créer, rayonner et inspirer. Vous ne vous êtes pas trouvés pour 
vivre une relation calme ou sans relief — vous vous êtes trouvés pour grandir ensemble, pour 
apprendre à aimer sans dominer, pour comprendre que la véritable puissance n’est pas dans 
le contrôle, mais dans la reconnaissance de l’autre. 
Dans ce lien, chacun porte une lumière forte, presque solaire. Vous éclairez le monde autour 
de vous, mais parfois, vos feux se heurtent. Il y a des jours où vos énergies s’affrontent 
comme deux tempêtes cherchant à avoir raison du vent. Et pourtant, derrière chaque conflit 
se cache une vérité plus profonde : celle de deux âmes qui se testent, qui cherchent à 
s’assurer qu’elles peuvent avancer côte à côte sans se perdre. 
Ce couple est un miroir : l’un reflète à l’autre ses forces, mais aussi ses zones d’ombre. Vous 
ne pouvez pas vous cacher longtemps l’un de l’autre. Là où l’un veut diriger, l’autre apprend à 
lâcher prise. Là où l’un veut briller, l’autre apprend la douceur. Ce lien vous enseigne que la 
passion n’est pas toujours paisible, mais qu’elle peut devenir un feu sacré si elle est nourrie 
de respect et de bienveillance. 
Votre mission commune n’est pas de vous dompter, mais de vous accorder. Comme deux 
instruments puissants, vous devez trouver la juste fréquence qui permet à vos âmes de jouer 
ensemble, sans fausse note. Lorsque vous cessez de rivaliser pour simplement collaborer, 
quelque chose de magique se produit : vos forces s’unissent, vos projets prennent vie, et 
votre amour devient créateur. 
Mais rappelez-vous : l’amour véritable ne cherche pas à gagner. Il apprend, il écoute, il 
s’incline quand il le faut, non par faiblesse mais par sagesse. Dans cette union, il vous sera 
souvent demandé de choisir entre avoir raison et être en paix. Choisissez la paix. Car c’est 
elle qui donnera à votre passion la profondeur dont elle a besoin pour durer. 
Si vous acceptez ce chemin avec patience et conscience, cette relation, intense et parfois 
déroutante, peut devenir l’un des plus grands moteurs de votre évolution spirituelle. 
Ensemble, vous pouvez apprendre à aimer sans vouloir posséder, à briller sans éclipser, à 
avancer sans écraser. Et quand cet équilibre sera trouvé, rien ni personne ne pourra éteindre 
la lumière que vous ferez rayonner à deux. ''',
  2: '''
Votre union est une danse douce entre deux âmes qui se reconnaissent avant même de se 
comprendre. Ce lien parle d’équilibre, de soutien et de tendresse. C’est une relation où 
l’amour ne cherche pas à briller plus fort que l’autre, mais à respirer ensemble, à créer une 
mélodie commune. Vous êtes les miroirs bienveillants d’une même lumière — celle de la 
sensibilité, de la compréhension et de la douceur partagée. 
Dans cette relation, l’union se tisse naturellement. Chacun sent intuitivement la place qu’il 
doit occuper pour que le lien reste fluide et paisible. L’un peut être la force tranquille, le 
refuge silencieux ; l’autre, la voix, le souffle, la présence visible qui attire et inspire. Ce n’est 
pas un déséquilibre, mais une forme sacrée de complémentarité. L’un nourrit, l’autre 
rayonne. L’un veille, l’autre avance. Ensemble, vous formez un tout harmonieux, un équilibre 
subtil entre l’ombre et la lumière. 
Ce lien a quelque chose de profondément fertile — pas seulement au sens matériel, mais 
aussi au niveau symbolique et spirituel. Il porte en lui la promesse de création : un foyer, un 
projet, une œuvre, une vie à deux qui prend racine dans la complicité et la confiance. 
Lorsque deux âmes comme les vôtres se rencontrent, elles donnent naissance à quelque 
chose de plus grand qu’elles. Ce n’est plus “toi” et “moi”, mais “nous”, une entité nouvelle, 
douce et puissante à la fois. 
Votre relation enseigne la patience, l’écoute, la réceptivité. C’est un amour qui ne se 
construit pas dans le bruit, mais dans le murmure, dans les gestes discrets, dans ces silences 
pleins de présence où le cœur parle mieux que les mots. Ce lien a besoin de respect, de 
tendresse et d’un rythme calme — il se nourrit d’attention sincère, de douceur, de gestes 
quotidiens qui disent “je te vois, je t’entends, je suis là.” 
Mais attention : dans cette union, il ne faut pas que l’un s’efface totalement pour que l’autre 
brille. Le véritable équilibre naît lorsque chacun se sent libre d’exister pleinement, sans 
craindre de prendre sa place. L’amour véritable ne demande pas de se cacher, il invite à se 
révéler ensemble. Si vous veillez à préserver cette égalité subtile entre donner et recevoir, 
votre lien deviendra un véritable sanctuaire — un lieu d’apaisement, de complicité et 
d’évolution spirituelle. 
Vous portez ensemble une énergie maternelle et protectrice, celle qui enveloppe, qui guérit, 
qui prend soin. Votre amour peut devenir un espace sacré, un berceau de paix où tout ce qui 
est fragile trouve refuge et croissance. Ce lien est une invitation à construire, à veiller, à 
aimer avec douceur — non pas dans la passion destructrice, mais dans la paix fertile. 
Ce n’est pas une relation faite pour le tumulte, mais pour l’ancrage. Vous êtes là pour 
apprendre l’un de l’autre ce que signifie “être deux” sans perdre le “un”. Si vous marchez 
dans cette conscience, votre union deviendra un temple silencieux où l’amour, au lieu de 
s’épuiser, se renouvelle chaque jour.''',
  3: '''
Cette relation porte la vibration de l’engagement véritable, celui qui ne se limite pas aux 
paroles, mais qui se traduit par des actes concrets, des choix alignés, et une volonté 
profonde de bâtir quelque chose de solide à deux. Vous n’êtes pas seulement deux cœurs qui 
s’attirent : vous êtes deux bâtisseurs d’un même rêve, deux âmes qui ont compris que 
l’amour se cultive dans la durée, par la constance, la loyauté et la co-création. 
Ce lien parle d’évolution et d’ancrage. Il ne s’agit pas d’un amour éphémère ou d’une passion 
passagère, mais d’une union qui cherche naturellement à se structurer, à s’enraciner dans la 
matière. Ensemble, vous donnez forme à vos sentiments : une maison, un engagement 
officiel, un projet partagé, un futur planifié. Il y a dans votre duo une grande maturité 
émotionnelle, une envie de “faire les choses bien”, de transformer la relation en un espace 
où chacun se sent à la fois libre et lié. 
C’est une union où la complicité intellectuelle et affective joue un rôle essentiel. Vous avez 
besoin de sentir que l’autre avance, que chacun grandit, que les rêves de l’un nourrissent 
ceux de l’autre. L’amour n’est pas vécu ici comme une fusion, mais comme une alliance 
consciente : deux âmes autonomes qui choisissent, chaque jour, de marcher ensemble. 
Ce lien vous enseigne l’art de l’équilibre entre indépendance et union. Il rappelle que l’amour 
le plus fort n’est pas celui qui retient, mais celui qui encourage, qui inspire, qui donne la force 
d’avancer. Chacun de vous a besoin d’espace pour s’épanouir individuellement, mais c’est en 
unissant vos énergies que la magie opère. Ensemble, vous devenez un centre de création : 
tout ce que vous décidez de construire à deux est promis à la croissance. 
Votre amour a le potentiel d’être une fondation solide — un pilier sur lequel d’autres vies, 
d’autres rêves pourront s’appuyer. Il invite à l’engagement sincère, à la fidélité, au respect 
des promesses et des valeurs communes. Il pousse à officialiser ce qui est ressenti, à donner 
une forme visible à ce qui, jusque-là, n’existait que dans le cœur. Ce n’est pas un hasard si ce 
lien évoque souvent l’idée de mariage, d’alliance ou de projet durable : il porte la vibration 
du “oui”, celle du choix mutuel et conscient. 
Sur le plan spirituel, ce couple incarne la beauté de l’amour responsable — un amour qui 
n’est pas seulement émotion, mais aussi intention. Vous êtes appelés à montrer, par votre 
union, que la passion peut rimer avec stabilité, que la liberté peut cohabiter avec la fidélité, 
et que la croissance personnelle ne s’oppose pas à la vie à deux. 
Lorsque ce lien est nourri par la confiance et la gratitude, il devient un espace sacré de 
manifestation. Ensemble, vous pouvez attirer la prospérité, la reconnaissance, et une 
abondance affective durable. Votre mission commune est de créer, d’officialiser, de laisser 
une empreinte. Votre amour, s’il est entretenu avec sincérité et respect, peut devenir un 
modèle : celui d’un couple qui transforme ses sentiments en œuvre vivante, un amour qui ne 
reste pas dans les mots, mais qui se construit, jour après jour, dans la matière. 
''',
  4: '''
Votre relation est une œuvre patiente, un édifice bâti pierre après pierre, dans le respect du 
temps et de la matière. Ce n’est pas un feu de paille, ni une aventure incertaine : c’est une 
alliance solide, enracinée dans le réel, où chaque geste compte, où chaque engagement est 
une promesse tenue. Vous n’êtes pas venus vous consumer l’un dans l’autre, mais bâtir 
ensemble un monde à votre image — un lieu où l’amour devient concret, où les rêves se 
transforment en fondations. 
Dans ce lien, la fidélité, la loyauté et la constance sont des valeurs sacrées. Vous cherchez la 
sécurité, non pas comme une prison, mais comme un espace où le cœur peut se poser. Ce 
que vous construisez ensemble n’est pas seulement matériel — maison, entreprise, foyer — 
mais aussi intérieur. Vous élevez, brique après brique, un temple invisible où l’amour trouve 
refuge, où la confiance se consolide, où la paix s’installe. 
Votre union porte la vibration des bâtisseurs : vous aimez voir vos efforts prendre forme, 
sentir que vos projets se concrétisent, savoir que votre relation repose sur des bases solides. 
Rien n’est laissé au hasard, tout se prépare, se planifie, se soigne. Vous avez besoin de 
stabilité, de clarté, de sécurité émotionnelle et matérielle. Et c’est dans cette rigueur 
partagée que naît votre bonheur. 
Ce lien vous enseigne que l’amour véritable n’est pas qu’émotion, mais aussi responsabilité. Il 
demande des choix conscients, des efforts réciproques, et une vision commune. Ensemble, 
vous êtes appelés à créer quelque chose qui dure — un foyer, une œuvre, une activité, un 
héritage peut-être — mais toujours avec la même intention : bâtir pour que cela reste. 
Il peut arriver que ce couple semble parfois manquer de légèreté, car l’un comme l’autre 
avez à cœur de bien faire, de prévoir, de protéger. Pourtant, derrière cette apparente rigueur 
se cache un profond besoin d’harmonie, de sérénité et de sécurité affective. Votre amour se 
déploie lentement, mais sûrement, comme un arbre dont les racines plongent profondément 
dans la terre avant de s’élancer vers le ciel. 
Sur le plan spirituel, votre union incarne la force tranquille de ceux qui ne fuient pas les 
épreuves, mais qui les transforment en fondations. Chaque défi rencontré ensemble devient 
une nouvelle poutre qui renforce la structure. Chaque projet mené à deux élève un mur 
supplémentaire dans votre maison intérieure. Vous êtes des bâtisseurs d’amour — des êtres 
qui comprennent que la solidité d’un lien se mesure non pas à son éclat, mais à sa constance 
dans le temps. 
Ce lien vous invite à la patience, à la coopération, à la mise en commun des forces. L’amour 
ici ne se dit pas seulement avec des mots doux, mais avec des gestes, des projets, des choix 
de vie. Vous êtes faits pour avancer côte à côte, comme deux artisans façonnant leur 
destinée. Ensemble, vous pouvez créer un foyer où l’abondance, la sécurité et la paix se 
rencontrent. 
Lorsque vous marchez dans cette énergie, votre couple devient un pilier — un repère pour 
ceux qui doutent encore que l’amour puisse être stable, durable et profond. Vous êtes la 
preuve vivante que l’on peut aimer sans se perdre, construire sans s’épuiser, s’engager sans 
s’enchaîner. Votre amour n’est pas un mirage, c’est une maison. Et chaque jour, par vos choix, 
vos efforts et votre fidélité, vous en posez les pierres les plus précieuses.''',
  5: '''
Cette relation porte le souffle du vent : imprévisible, vivante, intense et mouvante. Elle ne se 
laisse pas enfermer dans les cadres traditionnels ni dans les promesses trop rigides. Elle parle 
avant tout de découverte — de soi, de l’autre, du monde, et de ce que signifie vraiment 
aimer sans posséder. Vous êtes deux esprits curieux, attirés par la nouveauté, par l’aventure, 
par tout ce qui fait vibrer le présent. Ensemble, vous expérimentez un amour qui respire, qui 
se réinvente à chaque instant. 
Ce lien enseigne la liberté. Il ne promet pas toujours la stabilité, mais il offre une croissance 
intérieure précieuse. Il pousse à lâcher prise sur la peur de perdre, sur le besoin de contrôler. 
Dans cette relation, l’attachement se transforme en confiance, et la jalousie en 
compréhension. Aimer ici, c’est accepter que l’autre soit un être complet, avec ses désirs, ses 
espaces, ses chemins parfois différents. C’est apprendre à aimer sans enfermer. 
Il y a entre vous une alchimie vive, spontanée, presque électrisante. Vous pouvez rire 
ensemble, vous surprendre, explorer de nouvelles facettes de la vie et de vous-mêmes. C’est 
une relation qui réveille, qui secoue, qui sort des habitudes. Rien n’y est figé, tout est 
mouvement. Mais cette vitalité, si elle n’est pas accompagnée d’un ancrage émotionnel 
solide, peut aussi devenir épuisante. Le risque ici, c’est de chercher toujours plus de 
sensations au lieu de construire une sécurité commune. 
Sur le plan spirituel, cette union est une initiation. Elle apprend la confiance absolue — en 
soi, en l’autre, en la vie. Elle invite à aimer dans la transparence, sans masques ni attentes, à 
s’offrir dans le moment présent sans exiger de garanties. Ce lien te montre que l’amour peut 
être un espace de respiration, pas une prison. Mais il t’apprend aussi que la liberté n’a de 
sens que si elle est habitée par le respect et la sincérité. 
Ce couple est fait pour ceux qui n’ont pas peur du changement, de l’inconnu, de la vérité des 
émotions. C’est un amour qui demande du courage : celui de ne pas s’accrocher quand les 
chemins divergent, mais aussi celui de rester quand le cœur le réclame vraiment. Si vous 
parvenez à trouver cet équilibre fragile entre indépendance et loyauté, ce lien peut devenir 
un espace d’évolution spirituelle puissant, où chacun apprend à s’aimer lui-même à travers 
l’autre. 
Ce n’est pas une relation de routine, mais de réveil. Elle est là pour casser les schémas, pour 
t’apprendre à aimer sans peur, pour t’enseigner la fluidité. Parfois, elle ne dure pas dans le 
temps, mais elle marque à jamais — comme un vent qui passe, mais laisse derrière lui un ciel 
plus clair. Et même si le lien devait évoluer ou se transformer, il aura accompli son rôle : 
t’avoir aidé à comprendre que l’amour n’est pas une cage, mais un espace où l’âme apprend 
à danser librement.''',
  6: '''
Couple 6 - Amour protecteur.
Cette union est une quête d’équilibre, une recherche constante d’harmonie entre le don de 
soi et le respect de ses propres besoins. Vous êtes deux âmes sensibles, guidées par le désir 
d’aimer pleinement, de faire du bien, d’apporter beauté et paix à l’autre. Ce lien est empreint 
de douceur et d’un profond besoin de se sentir compris, entouré, aimé avec délicatesse. Il 
parle d’amour véritable, mais aussi des défis qu’il comporte : celui d’aimer sans se perdre, de 
donner sans s’oublier. 
Dans cette relation, il existe une grande force de création — artistique, émotionnelle, 
spirituelle. Ensemble, vous pouvez transformer votre lien en œuvre vivante : un couple 
inspirant, tourné vers la beauté, la sensibilité, la recherche de sens. Vous avez la capacité de 
sublimer vos émotions, de faire de votre amour un espace d’expression et de croissance. 
Mais pour que cela perdure, chacun doit pouvoir respirer, exister, suivre sa propre voie 
intérieure sans craindre de décevoir l’autre. 
Souvent, dans ce type de lien, l’un prend le rôle du soutien, du refuge, tandis que l’autre 
devient le rêveur, le créateur, celui qui brille à travers l’énergie reçue. Mais si cet échange 
devient déséquilibré, l’amour peut se transformer en dépendance subtile. L’un se nourrit de 
l’admiration de l’autre, pendant que celui qui donne trop finit par s’épuiser. Ce lien vous 
enseigne donc une grande leçon spirituelle : celle de l’amour conscient, équilibré, 
réciproque. 
Votre défi est d’apprendre à dire “oui” sans vous renier, et “non” sans blesser. À écouter, 
mais aussi à parler. À donner, mais aussi à recevoir. Ce n’est qu’en maintenant cette 
circulation équilibrée de l’énergie que la relation pourra s’épanouir. Si le dialogue est ouvert, 
si chacun ose exprimer ses doutes, ses désirs, ses peurs sans craindre le jugement, alors le 
lien devient profondément guérisseur. 
Spirituellement, ce couple est une école du cœur. Il enseigne la compassion, la tendresse, 
mais aussi la fermeté intérieure. Il pousse à faire des choix clairs, à prendre des décisions 
alignées, à ne pas se réfugier dans le rêve ou la peur de blesser. Vous êtes appelés à devenir 
des partenaires conscients, capables d’aimer dans la vérité plutôt que dans le sacrifice. 
Si l’équilibre est trouvé, ce lien devient un véritable sanctuaire émotionnel — un lieu d’amour 
doux, de compréhension mutuelle, d’inspiration réciproque. Ensemble, vous pouvez incarner 
un amour raffiné, spirituel, presque artistique, où chaque mot, chaque regard, chaque geste 
devient un acte de beauté. 
Mais si les non-dits s’accumulent, si l’un se tait pour ne pas troubler la paix apparente, alors 
le lien peut lentement s’étouffer. L’amour, ici, a besoin de sincérité comme une fleur a besoin 
de lumière. Il faut parler avant que le silence ne prenne la place de la complicité. Il faut 
choisir avant que la peur ne décide à votre place. 
En vérité, cette relation est un miroir : elle reflète votre capacité à aimer juste, à vivre l’union 
dans la clarté. Si vous réussissez à harmoniser vos désirs, à conjuguer liberté et affection, 
votre lien deviendra un chant d’équilibre — un amour mature, apaisé, créatif, capable 
d’éclairer bien au-delà de vous deux.''',
  7: '''
Votre lien amoureux est de ceux qui échappent aux schémas habituels. Il y a dans votre 
histoire une touche de mystère, un souffle presque magique qui dépasse la simple logique 
des rencontres. Vous ne vous êtes peut-être pas cherchés, mais quelque chose — une force 
invisible, un élan du destin — vous a rapprochés. Dès le départ, cette relation a pu sembler 
improbable, voire inattendue, et pourtant, elle porte en elle une profondeur rare. Elle vous 
invite à explorer des territoires intérieurs, à vous questionner, à évoluer ensemble 
spirituellement autant qu’émotionnellement. 
Votre amour n’est pas figé : il se renouvelle, il surprend, il interroge. C’est un lien qui ne 
supporte pas la routine ni la superficialité. Vous avez besoin d’être nourris intellectuellement 
et spirituellement par votre partenaire. Il y a cette envie de comprendre l’autre, de sonder 
son âme, d’aller au-delà des apparences. Mais cette quête de sens peut parfois devenir 
exigeante : trop d’analyses, trop de doutes, et vous risquez de vous perdre dans vos 
réflexions au lieu de simplement vivre le moment présent. 
Votre couple est une aventure intérieure autant qu’une histoire d’amour. Vous apprenez 
ensemble à faire confiance à la vie, à accueillir les surprises qu’elle place sur votre chemin. 
Car oui, les surprises seront nombreuses : certaines réjouissantes, d’autres plus 
déstabilisantes. L’un de vous peut être amené à évoluer rapidement, à se transformer, à 
chercher sa voie ailleurs — et l’autre devra alors apprendre à accompagner sans retenir. La 
clé, ici, c’est la liberté dans la fidélité du cœur : se laisser mutuellement grandir sans se 
craindre ni se juger. 
Ce lien vous enseigne que rien n’est jamais acquis, mais que tout peut toujours renaître. 
Même après les doutes, les remises en question ou les silences, quelque chose vous ramène 
l’un vers l’autre — comme si une part de votre âme reconnaissait que c’est dans cette 
relation que vous apprenez le plus sur l’amour véritable. Votre mission commune n’est pas 
seulement d’aimer, mais d’éveiller la conscience de l’amour, celui qui transcende les peurs, 
les distances et le temps.''',
  8: '''
Votre relation repose sur des fondations solides, ancrées dans la réalité concrète de la vie. 
Vous êtes deux âmes qui ne se contentent pas de rêver l’amour, mais qui le bâtissent pierre 
après pierre. Dans votre union, l’amour prend la forme d’un projet commun, d’un foyer à 
construire, d’une réussite à partager. Vous trouvez votre équilibre dans la stabilité, la sécurité 
et la prospérité, comme si votre bonheur passait par la création d’un monde à votre image — 
ordonné, élégant, et rempli de signes tangibles de réussite. 
Vous avancez main dans la main avec une même ambition : celle de bâtir quelque chose de 
durable. Ce lien vous pousse à unir vos forces, à conjuguer vos talents pour que la relation 
devienne un véritable empire d’amour et de travail. Vous pouvez être ce couple qui, 
ensemble, transforme les rêves en réalité. Vous savez que le confort matériel n’est pas 
superficiel lorsqu’il devient le reflet de la paix intérieure et du respect mutuel. Votre amour 
est fait pour s’enraciner, pour grandir dans la durée, avec la vision claire d’un avenir solide et 
structuré. 
Mais cette quête de réussite peut aussi devenir une épreuve : à force de vouloir tout 
stabiliser, tout maîtriser, on risque parfois d’oublier la tendresse spontanée, la douceur de 
l’instant. Votre défi, c’est d’apprendre à équilibrer le “faire” et “l’être” — ne pas confondre 
amour et performance, ni sécurité et contrôle. Car l’abondance matérielle, aussi belle soit
elle, ne remplace jamais la chaleur d’un regard ou la sincérité d’une main tendue. 
Dans votre histoire, la véritable richesse ne réside pas dans ce que vous possédez, mais dans 
la force de votre alliance. Vous êtes là pour apprendre que la réussite la plus noble est celle 
que l’on partage. Ensemble, vous avez la capacité de manifester l’amour dans sa forme la 
plus concrète : un amour qui construit, qui protège, qui rassure, mais qui sait aussi vibrer et 
célébrer la vie. 
Si vous cultivez la gratitude au même titre que vos ambitions, alors votre union deviendra un 
véritable temple de prospérité et d’harmonie — un lieu où l’amour et la réussite ne 
s’opposent pas, mais se nourrissent mutuellement.''',
  9: '''
Votre relation est une rencontre d’âmes anciennes, deux êtres qui se reconnaissent au-delà 
du visible, comme s’ils s’étaient déjà croisés dans d’autres vies. Ensemble, vous formez un 
couple empreint d’humanité, de sensibilité et d’ouverture au monde. Vous ne vous contentez 
pas d’aimer pour vous-mêmes : votre amour cherche à s’étendre, à inspirer, à aider, à offrir. Il 
a une vibration universelle, presque spirituelle, comme si votre union avait une mission plus 
grande que le simple bonheur à deux. 
Vous êtes deux âmes capables d’une immense compassion, animées par une soif de 
découverte et un désir de liberté. Votre relation ne se limite pas à un cadre : elle se nourrit 
du mouvement, des voyages, de l’art, des rencontres, de la beauté du monde sous toutes ses 
formes. Ensemble, vous explorez, vous apprenez, vous rêvez. C’est un amour qui ne 
s’enferme pas, mais qui s’élargit à mesure que vous évoluez. Vous pouvez être ces 
partenaires qui se soutiennent dans leurs élans créatifs ou humanitaires, qui trouvent du 
sens dans l’idée de construire quelque chose de bien au-delà d’eux-mêmes. 
Mais cette profondeur d’âme a parfois son revers : votre couple peut connaître des périodes 
de flou, d’instabilité ou de transition. Comme deux êtres en perpétuelle métamorphose, 
vous devez apprendre à accepter les cycles de la vie — les hauts, les bas, les moments de 
distance et de renaissance. Dans votre union, rien n’est figé : tout se transforme, tout renaît. 
Les défis matériels, parfois, testeront votre solidité, mais ils ne seront jamais une fin. Au 
contraire, ils vous inviteront à vous recentrer sur l’essentiel, à vous réinventer, à consolider 
votre lien sur des bases plus profondes. 
Votre histoire a aussi une dimension familiale et protectrice. L’énergie qui vous unit appelle 
souvent à la création d’un cocon — qu’il s’agisse d’un foyer, d’une famille, ou d’un projet 
commun tourné vers le soin et la transmission. Vous êtes faits pour bâtir ensemble un espace 
où l’amour sert de refuge et de lumière. 
En vérité, votre relation vous enseigne la beauté du don : donner sans attendre, aimer sans 
posséder, pardonner sans rancune. Vous avancez sur un chemin d’amour évolutif, où chaque 
épreuve devient une initiation et chaque renaissance, une victoire partagée. 
Lorsque vous parvenez à unir vos rêves à une base stable et harmonieuse, votre couple 
devient un phare — un amour rare, inspirant, capable d’éclairer non seulement vos vies, mais 
aussi celles de ceux qui croisent votre route.''',
  11:
      'Grande sensibilite et intuition commune. Vibration inspiree qui peut guider et apaiser. Risque de stress ou de surcharge emotionnelle. Besoin d ancrage et de mots simples pour rester alignes. Conseil: ritualiser l apaisement et choisir quelques intentions claires.',
  22:
      'Puissance de construction a deux. Vision ambitieuse et capacite a structurer sur la duree. Risque de pression et de controle. Besoin de decouper, de se relayer et de garder l etique. Conseil: clarifier les roles et celebrer chaque jalon.',
  33:
      'Chaleur, service et inspiration elevee. Envie d aider et de motiver ensemble. Risque de sur-responsabilisation ou d ideal trop lourd. Besoin de limites et de joie simple. Conseil: proteger l energie avant d aider, et garder du temps ludique.',
};

const Map<int, String> coupleDeepMeanings = {
  1: '''
Couple 1 - Feu sacre et leadership.
Deux flammes ardentes, relation intense faite pour grandir et apprendre a aimer sans dominer.
Forces: elan, vision, courage, capacite a initier et inspirer.
Vigilances: rivalite, ego, decisions unilaterales, fatigue si tout repose sur le controle.
Conseil: choisir la collaboration, poser un rythme commun, celebrer sans eclipser l autre.''',
  2: '''
Couple 2 - Douceur, soutien, harmonie.
Danse calme entre deux ames sensibles, lien fertile qui nourrit et protege.
Forces: ecoute, tendresse, complementarite naturelle, securite emotionnelle.
Vigilances: s effacer pour eviter le conflit, fusion qui epuise, non-dits qui s accumulent.
Conseil: dire ses besoins avec douceur, garder des espaces personnels, laisser un peu de tension constructive pour rester vrais.''',
  3: '''
Couple 3 - Engagement et co-creation.
Union qui veut batir, officialiser, donner forme a un reve commun.
Forces: maturite, loyautes, envie de planifier et d ancrer dans la matiere.
Vigilances: routine, surcharge, rigidite si tout est controle.
Conseil: equilibrer structure et inspiration, alterner projets concrets et joies simples pour garder le coeur vivant.''',
  4: '''
Couple 4 - Batisseurs stables.
Alliance patiente qui pose des fondations solides et rassurantes.
Forces: fiabilite, endurance, foyer solide, capacite a durer.
Vigilances: ennui, rigidite, vouloir tout securiser jusqu a s oublier.
Conseil: injecter du jeu et de la souplesse, revisiter les routines, laisser entrer un souffle neuf sans perdre le socle.''',
  5: '''
Couple 5 - Liberte et aventure.
Souffle de mouvement, curiosite, envie d explorer ensemble.
Forces: adaptabilite, energie, rebond, experiences qui font grandir.
Vigilances: instabilite, dispersion, peur d engagement, flou des regles.
Conseil: poser quelques bornes claires, garder un port d attache, choisir les changements qui servent vraiment le duo.''',
  6: '''
Couple 6 - Amour protecteur.
Energie de foyer, de soin, de beaute partagee, coeur tourne vers l harmonie.
Forces: chaleur, responsabilite, soutien constant, envie d embellir la vie.
Vigilances: sur-responsabilisation, perfectionnisme relationnel, oubli de soi.
Conseil: repartir les charges, poser des limites saines, nourrir autant le couple que soi pour que l amour reste leger.''',
  7: '''
Couple 7 - Lien mystique et evolutif.
Relation atypique guidee par la quete de sens et l intuition.
Forces: profondeur, clairvoyance, capacite a renaitre apres chaque questionnement.
Vigilances: distances, rythmes decales, isolement ou doutes excessifs.
Conseil: parler des besoins de solitude, accueillir les metamorphoses, faire confiance au lien meme quand il change de forme.''',
  8: '''
Couple 8 - Pouvoir et prosperite.
Deux ambitieux qui veulent batir et laisser une empreinte.
Forces: vision claire, organisation, gestion des ressources, impact concret.
Vigilances: rapports de force, controle, oublier la tendresse au profit de la performance.
Conseil: clarifier roles et valeurs, transparence sur l argent et le pouvoir, nourrir la douceur autant que la reussite.''',
  9: '''
Couple 9 - Union humaniste et universelle.
Deux ames ouvertes, artistes ou voyageurs, amour qui deborde vers le monde.
Forces: compassion, ideal, creativite, inspiration protectrice.
Vigilances: flou concret, sur-sacrifice, se perdre dans les causes exterieures.
Conseil: garder un socle stable, fixer des limites a ce que vous donnez, revenir souvent au foyer du couple pour recharger.''',
  11: '''
Forces: intuition partagee, sensibilite elevee, perception fine des ambiances. Grande creativite, inspiration spirituelle ou artistique. Capacite a apaiser et a guider avec douceur.
Forces: antennes ouvertes pour capter les nuances, empathie forte. Quand l energie est ancree, la relation rayonne de serenite.
Sensibles: surcharge sensorielle, stress, dispersion si trop de signaux. Risque d implicite excessif, malentendus si rien n est dit.
Sensibles: fatigue si on porte les emotions des autres, pression de bien faire, difficulte a s ancrer dans le concret.
Defis: ancrer, filtrer, ralentir. Mettre des mots simples sur ce que l on ressent. Eviter de tout prendre en charge.
Defis: choisir quelques priorites, dire non a ce qui epuise, ritualiser l apaisement (respiration, marche, pause ecrans).
Pistes: moments de silence puis partage bref, intentions claires chaque matin, limites sur les sollicitations. Se relayer pour proteger l energie du duo.
Pistes: utiliser l humour pour relacher la pression, debriefer les ressentis en fin de journee, garder un ancrage corporel (respirer, bouger).
Conseil du jour: 10 minutes de calme a deux, chacun nomme un ressenti et une intention. Refuser une demande qui surcharge, et faire une micro-action apaisante ensemble.
Conseil du jour: simplifier un plan, ecrire trois phrases claires pour se synchroniser, puis prendre un moment de gratitude.''',
  22: '''
Forces: maitre batisseur a deux: vision ambitieuse, structure solide, endurance. Grande capacite a federer et a materialiser des projets importants.
Forces: equilibre entre pragmatisme et vue d ensemble. Resilience, sens de l utilite, alignement possible sur une mission commune.
Sensibles: pression, perfectionnisme, surcharge de travail. Rapports de force si la gouvernance n est pas claire. Risque d oublier le couple dans la performance.
Sensibles: fatigue silencieuse, tension si l etique diverge, controle excessif. Difficultes a s arreter quand il faudrait.
Defis: decouper les objectifs, se relayer, proteger le lien. Mettre l etique au centre. Maintenir du temps pour le plaisir et la recuperation.
Defis: clarifier qui decide quoi, separer temps projet et temps affectif, accepter l imperfection pour durer.
Pistes: check-ins planifies, jalons petits et celebres, delegation. Revisiter la vision chaque mois pour verifier l alignement.
Pistes: definir un cadre pour l argent et les decisions, reconnaitre les apports de chacun, poser des pauses obligatoires.
Conseil du jour: boucler une etape simple, puis couper pour un moment leger. Rappeler vos valeurs avant une decision sensible.
Conseil du jour: remercier l autre pour une contribution, poser une limite claire sur un point de surcharge, respirer avant de relancer un chantier.''',
  33: '''
Forces: service et inspiration elevee partagee. Chaleur, empathie, capacite a encourager et a apaiser. Rayonnement positif sur l entourage.
Forces: creativite, sens artistique ou symbolique, envie d aider largement. Quand l energie est preservee, la relation elevante.
Sensibles: sur-responsabilisation, ideal trop haut, fatigue ou frustration si l aide n est pas recue. Risque de culpabiliser en disant non.
Sensibles: oubli de soi, confusion entre soutien et sacrifice, pression pour etre parfait. Epuisement si on prend tout en charge.
Defis: poser des limites, proteger l energie, faire moins mais mieux. Garder la joie simple et le plaisir a deux.
Defis: accepter de deleguer, verifier que chacun veut ou peut etre aide, distinguer ce qui est possible de ce qui ne l est pas.
Pistes: se relayer dans le soin, ritualiser du repos, dire non sans culpabilite. Garder un noyau de plaisirs simples et creatifs.
Pistes: demander avant d aider, clarifier les attentes, choisir quelques causes seulement. Creer du temps ludique pour nourrir le lien.
Conseil du jour: choisir un geste d entraide limite et consentie, puis s offrir un moment regenerant (jeu, art, pause). Dire une appreciation et un besoin personnel.
Conseil du jour: simplifier un engagement, respirer ensemble, partager un moment creatif pour relancer la joie.''',
};

const Map<int, String> coupleDailyActions = {
  1:
      'Impulsez ensemble: choisissez une decision rapide a deux, meme modeste. Verifiez que le rythme convient aux deux. Agissez puis appreciez le resultat. Ne cherchez pas la perfection, mais l elan commun.',
  2:
      'Liez et ecoutez: privilegiez le dialogue, la co-decision, un geste d apaisement. Ne tranchez pas seul. Reformulez ce que l autre dit. Terminez par un accord clair, meme petit.',
  3:
      'Exprimez et clarifiez: partagez idees et envies, mais concluez. Evitez l ironie, dites un compliment precis. Finissez une discussion en suspens. Creer quelque chose ensemble renforce le lien.',
  4:
      'Structurez: rangez, planifiez, mettez un cadre simple. Definissez qui fait quoi aujourd hui. Une petite organisation commune diminue le stress. Ajoutez un moment detente apres l effort.',
  5:
      'Bougez avec souplesse: testez une nouveaute ensemble, mais gardez un port d attache. Si un imprevu arrive, adaptez sans tout bousculer. Debrief rapide pour rester alignes.',
  6:
      'Prenez soin: demandez explicitement le type de soutien souhaite. Repartissez une tache. Offrez-vous un moment cocon. Valorisez l effort de l autre, meme petit.',
  7:
      'Recul et partage: accordez-vous un temps calme ou une courte meditation. Puis partagez un ressenti cle en quelques phrases simples. Laissez de l espace sans fuir la connexion.',
  8:
      'Impact et integrite: reglez un sujet materiel ou financier avec transparence. Posez des criteres justes, ecoutez l avis de l autre. Concluez par un accord et un geste de detente.',
  9:
      'Cloturez et allegez: terminez un dossier ou un malentendu. Faites un geste de generosite ou de pardon. Liberez l energie avant de repartir sur du neuf.',
  11:
      'Apaiser et clarifier: reduire les stimuli, formuler en mots simples, proteger l energie du duo. Choisir une intention claire et une micro-action qui calme.',
  22:
      'Structurer avec douceur: decouper un sujet important en une etape realisable, valider la decision ensemble, puis s accorder une pause pour preserver le lien.',
  33:
      'Servir sans se vider: choisir un seul geste d aide consentie, dire non au reste. Se garder un moment joyeux ou creatif pour recharger.',
};

const Map<int, String> personalYearMeanings = {
  1:
      'Debut de cycle: lancer, planter, oser. Tout n est pas visible, patience. Bon pour initier des projets ou des rencontres. Eviter de tout forcer en meme temps. Clarifier un cap et avancer pas a pas. Energie de premiere impulsion a nourrir.',
  2:
      'Cooperation et ajustement. Rythme plus lent, gestation. Relations et duos au centre. Ne pas precipiter, laisser murir. Apprendre a dire ce que l on ressent. La patience ouvre des portes discrètes.',
  3:
      'Expression, reseaux, joie. Visibilite accrue, opportunites sociales. Creativite mise en avant. Risque de dispersion: prioriser quelques objectifs. Communiquer avec legerete et clarté. Profiter pour montrer son travail.',
  4:
      'Structure et travail. On consolide, on pose des fondations. Routines et methodes a installer. Patience face aux retards possibles. Risque de rigidite: garder une marge de jeu. Les efforts constants payent sur la duree.',
  5:
      'Changements et mobilite. Opportunites, voyages, virages. Besoin de souplesse et de garde-fous. Ne pas tout bousculer sans plan. Explorer, tester, ajuster. Rester connecte a ce qui fait sens.',
  6:
      'Responsabilites, famille, engagements. Bon pour officialiser, soigner, reparer. Risque de surcharge si l on veut tout porter. S appuyer sur le soutien proche. Equilibrer devoir et plaisir. L harmonisation passe par des choix clairs.',
  7:
      'Introspection, etude, tri. Rythme plus calme, on decante. Besoin de sens et de recul. Eviter de se juger si les resultats tardent. Clarifier ses priorites interieures. La qualite prime sur la quantite.',
  8:
      'Realisation et impact. Questions materielle et pouvoir mises en avant. Negocier, affirmer, agir avec etique. Risque de tension si on force trop. Structurer ses objectifs et mesurer les efforts. L alignement attire les ressources.',
  9:
      'Cloture et detachement. Faire des bilans, ranger, laisser partir. Ne pas lancer un enorme cycle sans avoir nettoye. Emotionnel en mouvement, besoin de bienveillance. Honorer ce qui se termine et preparer la suite. Ouvrir un espace pour l apres.',
};

const Map<int, String> kabbalahMeanings = {
  1:
      'Progression patiente et montee en puissance. Tests de constance. Chaque pas consolide le suivant. Confiance en soi a renforcer par l action. La volonte calme est la cle.',
  2:
      'Expansion relationnelle. Ouvrir aux partenariats et a l ecoute. Eviter l indecision par clarte d intentions. La cooperation apporte de la chance. L accueil de l autre est un levier.',
  3:
      'Flux d amour et d emotions. Communication et expression attirent du soutien. Veiller a ne pas tout prendre a la legere. Clarifier ce que l on ressent. La chaleur relationnelle ouvre des portes.',
  4:
      'Obstacles a franchir, chance variable. La patience et la discipline finissent par payer. Apprendre a perseverer sans rigidite. Chaque obstacle structure davantage. La methode est ton appui.',
  5:
      'Creation et energie changeante. Canaliser pour eviter la dispersion. Opportunites quand on reste ouvert et prudent. Ne pas confondre vitesse et imprudence. L audace marche mieux avec un plan.',
  6:
      'Recolte et stabilisation. Consolider, savourer, securiser. Partager ce qui est acquis. Attention a la charge mentale. La gratitude alimente la suite.',
  7:
      'Esprit, conscience, intuition. Le recul apporte des solutions subtiles. Besoin de silence ou de nature. Ne pas se couper du monde. La sagesse vient du temps pris pour comprendre.',
  8:
      'Impulsion et initiative avec impact. Agir avec integrite pour eviter les tensions. Energie puissante qui demande du discernement. L organisation augmente la portee. Eviter le rapport de force inutile.',
  9:
      'Fortune, rayonnement, partage. Donner pour recevoir en retour. Risque de dispersion, rester centre. La generosite attire les appuis. Canaliser l expansion par des objectifs clairs.',
};

const Map<int, String> personalDayHints = {
  1: 'Impulsion: initier une action, poser un premier pas. Agir avec courage sans brusquer.',
  2: 'Partenariat: cooperer, ecouter, negocier en douceur. Chercher l accord gagnant-gagnant.',
  3: 'Expression: communiquer, creer, partager un message. Miser sur la legerete et la clarte.',
  4: 'Structure: organiser, planifier, avancer methodiquement. Verifier les details utiles.',
  5: 'Mouvement: rester souple, accueillir un changement. Tester avant de s engager.',
  6: 'Soutien: prendre soin des proches et de soi. Repartir les responsabilites pour eviter la charge.',
  7: 'Recul: observer, analyser, mediter avant d agir. Laisser de l espace a l intuition.',
  8: 'Impact: affirmer, negocier, traiter une question materielle. Garder l etique en priorite.',
  9: 'Cloture: finir, partager, faire un geste de generosite. Laisser partir ce qui doit se clore.',
};
