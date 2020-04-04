DROP TRIGGER IF EXISTS trig_insff_OS ON OS cascade;
DROP TRIGGER IF EXISTS trig_insff_Programme ON Programme cascade;
DROP TABLE IF EXISTS Logiciel cascade;
DROP TABLE IF EXISTS Version cascade;
DROP TABLE IF EXISTS Probleme cascade;
DROP TABLE IF EXISTS Client cascade;
DROP TABLE IF EXISTS Achat cascade;
DROP TABLE IF EXISTS Correctif cascade;
DROP TABLE IF EXISTS Employe cascade;
DROP TABLE IF EXISTS RemonterProbleme cascade;
DROP TABLE IF EXISTS OS cascade;
DROP TABLE IF EXISTS Programme cascade;
DROP TABLE IF EXISTS SupporterOProg cascade;
DROP TABLE IF EXISTS ProgramType cascade;
DROP TABLE IF EXISTS Plateforme cascade;
DROP TABLE IF EXISTS SupporterOPlat cascade;
DROP TABLE IF EXISTS EstDeType cascade;
DROP TYPE IF EXISTS TYPE_t cascade;
DROP FUNCTION IF EXISTS fonction_trigger;


--Logiciel(#NomDeve: string , Nom: string, DateLancement: date) avec Nom UNIQUE
CREATE TABLE Logiciel(
  NomDeve VARCHAR PRIMARY KEY,
  Nom VARCHAR UNIQUE NOT NULL,
  DateLancement DATE NOT NULL
);

--Version(#NomLogiciel=>Logiciel.NomDeve, #Numero: int, DateDisponibilite: date)
CREATE TABLE Version(
  NomLogiciel VARCHAR REFERENCES Logiciel(NomDeve),
  Numero INTEGER,
  DateDisponibilite DATE NOT NULL,
  PRIMARY KEY (NomLogiciel, Numero)
);

--Probleme(#date : timestamp, #version ->Version.NomDeve, #numVersion ->Version.Numero. ,description : text, )
CREATE TABLE Probleme(
  Date TIMESTAMP,
  Logiciel VARCHAR,
  NumVersion INTEGER,
  Description TEXT NOT NULL,
  FOREIGN KEY (Logiciel, NumVersion) REFERENCES Version(NomLogiciel, Numero),
  PRIMARY KEY(Date, Logiciel, NumVersion)
);

--Client(#Telephone: integer, Adresse: string, Nom: string, Prenom: string, DateNaissance: date)
CREATE TABLE Client (
  telephone INTEGER PRIMARY KEY,
  adresse VARCHAR NOT NULL,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  dateNaissance DATE NOT NULL
);

--Employe( #numEmploye : integer, nom : string, prenom : string , poste : integer, dateNaissance : date)
CREATE TABLE Employe (
  numEmploye INTEGER PRIMARY KEY,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  poste INTEGER NOT NULL,
  dateNaissance DATE NOT NULL
);

--Achat(#NomLogiciel=>Logiciel.NomDeve,#Client=>Client.Telephone, #Date: date)
CREATE TABLE Achat (
  NomLogiciel VARCHAR NOT NULL,
  client INTEGER NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (NomLogiciel,client,date),
  FOREIGN KEY (NomLogiciel) REFERENCES Logiciel(NomDeve),
  FOREIGN KEY (client) REFERENCES Client
);

--Correctif(#id : integer, date : date, idPatch : integer, instructionText : text, type :{Instruction,Patch}, responsable ->Employe.numEmploye, pdate->Probleme.date, pversion->Probleme.Logiciel, pnumVersion->Probleme.numVersion)
CREATE TABLE Correctif (
  id INTEGER PRIMARY KEY,
  date TIMESTAMP NOT NULL,
  idPatch INTEGER UNIQUE,
  instructionText VARCHAR,
  type VARCHAR CHECK (type in('Instruction','Patch')) NOT NULL,
  responsable INTEGER NOT NULL,
  pdate TIMESTAMP NOT NULL,
  pversion VARCHAR NOT NULL,
  pnumVersion INTEGER NOT NULL,
  FOREIGN KEY (responsable) REFERENCES Employe(numEmploye),
  FOREIGN KEY (pdate,pversion, pnumVersion) REFERENCES Probleme(Date,Logiciel,NumVersion),
  CHECK ((type='Instruction' AND instructionText IS NOT NULL) OR (type='Patch' AND idPatch IS NOT NULL)),
  CHECK ((NOT (type='Instruction' AND idPatch IS NOT NULL)) OR (NOT (type='Patch' AND instructionText IS NOT NULL)))
);

--RemonterProbleme(#client->Client.telephone, #dateProbleme->Probleme.date, #versionProbleme->Probleme.version, #numProbleme->Probleme.numVersion)
CREATE TABLE RemonterProbleme (
  client INTEGER NOT NULL,
  date TIMESTAMP NOT NULL,
  versionProbleme VARCHAR NOT NULL,
  numProbleme INTEGER NOT NULL,
  PRIMARY KEY (client,date,versionProbleme,numProbleme),
  FOREIGN KEY (client) REFERENCES Client(telephone),
  FOREIGN KEY (date,versionProbleme,numProbleme) REFERENCES Probleme(Date,Logiciel,numVersion)
);

--OS(#NomDevOS->Logiciel.NomDeve)
CREATE TABLE OS(
  NomDevOS VARCHAR PRIMARY KEY,
  FOREIGN KEY(NomDevOS)REFERENCES Logiciel(NomDeve)
);

CREATE TYPE TYPE_t AS ENUM ('application', 'jeu');

--Programme(#NomDevProg->Logiciel.NomDeve, type : TYPE)
CREATE TABLE Programme(
  NomDevProg VARCHAR PRIMARY KEY REFERENCES Logiciel(NomDeve),
  type TYPE_t NOT NULL,
  FOREIGN KEY(NomDevProg)REFERENCES Logiciel(NomDeve)
  --CHECK (NOT(OS.NomDevOS)INTERSECT(NomDevProg))---------------------------------------------------
);

--SupporterOProg(#OS->OS.NomDevOS, #Programme->Programme.NomDevProg)
CREATE TABLE SupporterOProg(
  OS VARCHAR NOT NULL,
  Programme VARCHAR NOT NULL,
  FOREIGN KEY(OS)REFERENCES OS(NomDevOS),
  FOREIGN KEY(Programme)REFERENCES Programme(NomDevProg),
  PRIMARY KEY (OS,Programme)
);

--ProgramType(#type : string)
CREATE TABLE ProgramType(
  type VARCHAR PRIMARY KEY
);

--Plateforme(#type : string)
CREATE TABLE Plateforme(
  type VARCHAR PRIMARY KEY
);

--SupporterOPlat(#NomDevOS->OS.NomDevOS, #type->Plateforme.type)
CREATE TABLE SupporterOPlat(
  NomDevOS VARCHAR NOT NULL,
  type VARCHAR NOT NULL,
  FOREIGN KEY(NomDevOS)REFERENCES OS(NomDevOS),
  FOREIGN KEY(type)REFERENCES Plateforme(type),
  PRIMARY KEY (NomDevOS,type)
);

--EstDeType(#type->ProgramType.type, #Nom->Programme.NomDevProg)
CREATE TABLE EstDeType(
  type VARCHAR NOT NULL,
  Nom VARCHAR NOT NULL,
  FOREIGN KEY(type)REFERENCES ProgramType(type),
  FOREIGN KEY(Nom)REFERENCES Programme(NomDevProg),
  PRIMARY KEY (type,Nom)
);

--vPatch=PROJECTION(RESTRICTION(Correctif, type=Patch), date,idPatch)
CREATE VIEW vPatch AS
SELECT date, idPatch
FROM Correctif
WHERE type='Patch';

--vInstruction=PROJECTION(RESTRICTION(Correctif,type=Instruction),date,instructionText)
CREATE VIEW vInstruction AS
SELECT date, instructionText
FROM Correctif
WHERE type='Instruction';

--vPersonne=UNION ( PROJECTION(Employe,nom,prenom, dateNaissance), PROJECTION(Client,nom,prenom,dateNaissance))
CREATE VIEW vPersonne AS
SELECT nom,prenom,dateNaissance FROM Employe
UNION
SELECT nom,prenom,dateNaissance FROM Client;

--vOS=Jointure(Logiciel, OS, Logiciel.NomDeve= OS.NomDevOS)"
CREATE VIEW vOS AS
SELECT *
FROM Logiciel
INNER JOIN OS ON Logiciel.NomDeve=OS.NomDevOS;

--vProg = Jointure(Logiciel, Programme, Logiciel.NomDeve=Programme.NomDevProg) "
CREATE VIEW vProg AS
SELECT *
FROM Logiciel
INNER JOIN Programme
ON Logiciel.NomDeve=Programme.NomDevProg;

--vApplication = projection(Restriction(vProg, type = Application), NomDeve, Nom, date)"
CREATE VIEW vApplication AS
SELECT NomDeve, Nom, datelancement
FROM vProg
WHERE type = 'application';

--vJeu = projection(Restriction(vProg, type = jeu), NomDeve, Nom, date)"
CREATE VIEW vJeu AS
SELECT NomDeve, Nom, datelancement
FROM vProg
WHERE type = 'jeu';

--vOSandProgramme = UNION ( PROJECTION(OS, NomDeveOS), PROJECTION(Programme, NomDeveProg))
CREATE VIEW vOSandProgramme AS
SELECT OS.NomDevOS FROM OS
UNION
SELECT NomDevProg FROM Programme;


CREATE FUNCTION fonction_trigger()
  RETURNS trigger AS
$func$
BEGIN
IF EXISTS
    (
        (SELECT NomDevOS FROM OS)
        INTERSECT
        (SELECT NomDevProg FROM Programme)
    )
THEN
   RAISE EXCEPTION 'Non, un programme ne peut pas etre a la fois un OS et un programme.';
END IF;
RETURN NEW;
END
$func$  LANGUAGE plpgsql;


CREATE CONSTRAINT TRIGGER trig_insff_OS
  AFTER INSERT OR UPDATE
  ON OS
  FOR EACH ROW EXECUTE PROCEDURE fonction_trigger();


CREATE CONSTRAINT TRIGGER trig_insff_Programme
  AFTER INSERT OR UPDATE
  ON Programme
  FOR EACH ROW EXECUTE PROCEDURE fonction_trigger();