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