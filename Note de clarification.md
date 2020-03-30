
# Note de clarification projet Pear

## Contexte du projet
                        
Dans le cadre de l'UV NF17, nous sommes amenés à mettre en place une base de données pour l'entreprise Pear qui concentre ses activités sur le développement de logiciels.       

### Acteurs du projet

Maîtrise d'ouvrage : M. Lussier, représentant de Pear

Maîtrise d'oeuvre :
    
- Théophane Durand
- Charlotte Fromont
- Likang Shen
- Félix Poullet-Pagès
- Audrey Combary
    

### Références du projet   


- Cahier des charges : https://librecours.net/exercice/projet/pear.xhtml?part=3w
- Définition des contraintes : https://librecours.net/exercice/projet/cadre.xhtml?part=3w
- Définition des livrables attendus : https://librecours.net/exercice/projet/livrables.xhtml?part=3w

### Objet du projet


Ce projet a pour but d'aider l'entreprise Pear à mettre en place une base de données afin d'avoir un suivi sur les versions des logiciels ainsi que de la leur maintenance corrective. Il s'agit donc de créer une structure de données référençant des informations ciblées concernant l'entreprise et lui permettre une meilleure efficacité.

La phase de formalisation du projet a été menée avec le maître d'ouvrages.

L'implémentation de cette de base de données doit donc pouvoir permettre une mise à jour des données concernant les logiciels crées par l'entreprise.

### Synthèse des livrables attendus :


- Note de clarification du projet         
- Modèle Conceptuel de Données         (MCD)         
- Modèle Logique de Données         (MLD)         
- Base de données relationnelle  avec ses principales requêtes SQL et des données de test         



### Objets principaux de la base de données
Les principaux objets manipulés par la base de données sont les suivants :

- Logiciel        
- Personne     (Clients et Employés) 
- Plateforme      
- Problème   

### Description des logiciels :
    
- Un logiciel a un nom de développement unique (ex: Tigris, Cachalot), un nom unique (ex : Sentence, MightyPoint) et une date de lancement. 
- La date de lancement d'un logiciel correspond à la date de début de développement.
- Un logiciel est soit un OS, soit une application, soit un jeu. Il ne peut pas être dans deux catégories à la fois.
- Les OS supportent au moins une plateforme et peuvent en supporter plusieurs parmi les suivantes : Smartphone, PC, Tablette, Serveur. D'autres plateformes peuvent être ajoutées par la suite.
- Une plateforme est supporté par au moins un OS et peut être supportée par plusieurs.
- Pour les applications et les jeux, supportent un ou plusieurs OS. Un OS n'a pas nécessairement d'application et peut en avoir plusieurs.
- On veut également stocker le type des applications (traitement de texte, modélisation mathématique, etc.) et le type des jeux (plates-formes, FPS, etc.).
- Une application ou un jeu peut avoir plusieurs type.
- Les logiciels sont composés de une ou plusieurs versions, avec un numéro de version et une date de mise à disponibilité pour chacune.


### Gestion des Problèmes :
   La base de données doit également recenser les problèmes détectés sur les différentes versions de chaque logiciel. On crée donc une classe problème, composée de la date à laquelle le problème est détecté et de la description du problème. Il peut y avoir plusieurs problèmes par version mais chaque problème concerne une version en particulier. Un problème n'a pas nécessaire de correctif. Pour les problèmes dont une solution existe, un ou plusieurs correctifs sont appliqués à une certaine date. Il existe deux types de correctifs, d'où la création de deux classes différentes : une classe pour les patchs correctifs, identifiés par un identifiant unique et une classe pour les correctifs sous la forme d'instruction textuelles, identifiés par une description.

### Gestion des clients et employés :
    
Finalement, on veut savoir qui a remonté les problèmes et qui était responsable des correctifs. Les problèmes sont forcément remontés par des clients, pour lesquels on a un nom, un prénom, une date de naissance, une adresse et un numéro de téléphone.  On assume que deux clients différents peuvent avoir la même adresse. On stocke également quels logiciels sont achetés par ses clients et à quelle date. Donc on assume aussi qu'un client à nécessairement acheté un logiciel et qu'il peut acheter plusieurs fois le même logiciel. Les employés sont identifiés par un nom, un prénom, une date de naissance et un numéro de poste. Par ailleurs, deux employeurs peuvent avoir le même numéro de poste. Enfin, un employé ne peut jamais être un client et de même un client ne peux pas être un employé.. Pour simplifier les attributs,  la classe employé et la classe client héritent de la classe personne abstraite.

### Requêtes :
Pear est intéressé par différentes requêtes, comme le nombre de problèmes non corrigés pour chaque version de ses logiciels, quelles applications tournant sur tablettes ont eu plus d'un correctif, ou quels clients ont remonté des problèmes sur des logiciels qu'ils ne possèdent pas.


