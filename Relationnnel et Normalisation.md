# Relationnel :

## Relations :

### Tables :

**Logiciel**(#NomDeve: string , Nom: string, DateLancement: date) avec Nom UNIQUE

**Achat**(#NomLogiciel=>Logiciel.NomDeve,#Client=>Client.Telephone, #Date: date)

**Version**(#NomLogiciel=>Logiciel.NomDeve, #Numero: int, DateDisponibilite: date)

**OS**(#NomDevOS -> Logiciel.NomDeve);

**Programme**(#NomDevProg -> Logiciel.NomDeve, type enum = {Application,Jeu})

**SupporterOProg**(#OS ->OS.NomDevOS, #Programme -> Programme.NomDevProg)

**Plateforme**(#type : string)

**SuporterOPlat**( #NomDevOS -> OS.NomDevOS, #type ->Plateforme.type)

**ProgramType**(#type :string)

**EstDeType**(#type -> ProgramType.type, #Nom ->Programme.NomDevProg)

**Correctif**(#id : integer, date : date, idPatch : integer, instructionText : text, type :{Instruction,Patch}, responsable ->Employe.numEmploye, pdate->Probleme.date, pversion->Probleme.Logiciel, pnumVersion->Probleme.numVersion)

**Employe**( #numEmploye : integer, nom : string, prenom : string , poste : integer, dateNaissance : date)

**Client** (#telephone : integer, adresse : string, nom :string , prenom :string ,dateNaissance :date)

**Probleme**(#date : timestamp, #Logiciel ->Version.NomLogiciel, #numVersion ->Version.Numero. ,description : text)

**RemonterProbleme**(#client->Client.telephone, #dateProbleme->Probleme.date, #versionProbleme->Probleme.Logiciel, #numProbleme->Probleme.numVersion)

### Vue :

**vOS** = Jointure(Logiciel, OS, Logiciel.NomDeve= OS.NomDevOS)

**vProg** = Jointure(Logiciel, Programme, Logiciel.NomDeve=Programme.NomDevProg) 

**vApplication** = projection(Restriction(vProg, type = Application), NomDeve, Nom, date)

**vJeu** = projection(Restriction(vProg, type = Jeu), NomDeve, Nom, date)

**vPatch**=PROJECTION(RESTRICTION(Correctif, type=Patch), date,idPatch)

**vInstruction**=PROJECTION(RESTRICTION(Correctif,type=Instruction),date,instructionText)

**vPersonne**=UNION ( PROJECTION(Employe,nom,prenom, dateNaissance), PROJECTION(Client,nom,prenom,dateNaissance))

**vOSandProgramme** = UNION ( PROJECTION(OS, NomDeveOS), PROJECTION(Programme, NomDeveProg))       

*//Cette vue ous permet de visualiser la contrainte*

`INTERSECTION (PROJECTION(**OS**,NomDevOS), PROJECTION(**Programme**,NomDevProg)) = {}`

## Contraintes :

Tous les attributs sont NOT NULL

**Logiciel**.nom : clé

**Achat**.Date > **Logiciel**.DateLancement pour le même NomDeve

Projection(**Achat**, NomLogiciel) = Projection(**Logiciel**, NomDeve)

Projection(**Logiciel**, NomLogiciel) = Projection(**Version**, NomDeve)

INTERSECTION (PROJECTION(**OS**,NomDevOS), PROJECTION(**Programme**,NomDevProg)) = {}

Projection(**OS**,NomDevOS) = Projection(**SupporterOProg**,OS)

Projection(**Programme**,NomDevProg) = Projection(**SupporterOProg**, Programme)

Projection(**ProgrammeType**, Type) = Projection(**EstDeType**, type)

**Correctif**.idPatch UNIQUE

**Correctif**.idPatch NULL ABLE

**Correctif.**instructionText NULL ABLE

**Correctif**.type=Instruction AND **Correctif.**instructionText

**Correctif**.type=Patch AND **Correctif.**idPatch

NOT (**Correctif**.type=Instruction AND **Correctif.**idPatch)

NOT (**Correctif**.type=Patch AND instructionText)

# DF et Normalisation : 

**Logiciel** :

NomDeve-> Nom, DateLancement

Nom->NomDeve, DateLancement 

Possède une clé et attributs atomiques ->1NF 

Clé composée d'un seul attribut -> 2NF 


Seul l'attribut DateLancement n'appartient pas à une clé candidate mais il dépend directement de clé candidates (Nom et NomDeve) -> 3NF

**Client **:

Telephone -> Adresse, Nom, Prenom, DateNaissance

	

Possède une clé et attributs atomiques -> 1NF

Un seul attribut détermine tous les autres -> 3NF

**Achat** :

NomLogiciel -> {} 

Tel -> {} 

Date -> {} 

Relation toute clé -> 3NF

**Version** : 

NomLogiciel, Numero  ->  {DateDisponibilite} 

Possède une clé et attributs atomiques -> 1NF

Pas de sous-partie de la clé qui détermine un attribut non-clé -> 

2NF

Aucun attribut non clé ne dépend d’un autre attribut non clé -> 3NF

