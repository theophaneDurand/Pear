--comme le nombre de problèmes non corrigés pour chaque version de ses logiciels,

--SQL
SELECT p.Logiciel, p.numVersion, COUNT(*) AS nprobleme
FROM Probleme p LEFT JOIN Correctif c 
ON p.date = c.pdate
AND p.Logiciel = c.pversion
AND p.numVersion = c.pnumVersion
WHERE c.pdate IS NULL
GROUP BY (p.Logiciel, p.numVersion);

--quelles applications tournant sur tablettes ont eu plus d'un correctif, 
--SQL
SELECT pg.NomDevProg,COUNT(c.id) AS ncorrectif
FROM SupporterOPlat s1, SupporterOProg s2,Programme pg, Correctif c
WHERE s1.type='tablette'
AND pg.type='application'
AND s2.Programme = pg.NomDevProg
AND s1.NomDevOS = s2.OS
AND c.pversion = pg.NomDevProg
GROUP BY pg.NomDevProg
HAVING COUNT(c.id)>1;

--quels clients ont remonté des problèmes sur des logiciels qu'ils ne possèdent pas.
--Algèbre
/*
R1 = LEFTJOIN(RemonterProbleme r,Achat a, a.Client = r.client AND a.NomLogiciel = r.versionProbleme)
R2 = RESTRICTION(R1, R1.Client IS NULL)
R3 = JOINTURE(R2, Client c,R2.client = c.telephone)
R5 = PROJECTION(R4,nom,prenom)
*/
--SQL
SELECT DISTINCT(c.nom,c.prenom)
FROM (RemonterProbleme r LEFT JOIN Achat a
ON a.Client = r.client
AND a.NomLogiciel = r.versionProbleme), Client c
WHERE a.Client IS NULL
AND r.client = c.telephone;

