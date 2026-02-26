----- | SCRIPT CREATION DE TABLES | -----

-- Création de la table Vente_Detail
CREATE TABLE Vente_Detail (
  	id_BDD VARCHAR(255) NOT NULL PRIMARY KEY,                
	CUSTOMER_ID VARCHAR(255) NOT NULL,
    id_employe VARCHAR(255) NOT NULL,
    EAN BIGINT NOT NULL,
    date_vente INTEGER NOT NULL,
    ID_ticket VARCHAR(10) NOT NULL            
);

-- Création de la table Produits
CREATE TABLE Produits (
    EAN BIGINT NOT NULL PRIMARY KEY,
    Catégorie VARCHAR(255) NOT NULL,     
    Rayon VARCHAR(255) NOT NULL,             
    Libelle_produit VARCHAR(255) NOT NULL,                    
    Prix DOUBLE PRECISION NOT NULL
);

-- Création de la table Clients
CREATE TABLE Clients (
    CUSTOMER_ID VARCHAR(255) NOT NULL PRIMARY KEY,                 
    date_inscription DATE NOT NULL
);

-- Création de la table Calendrier
CREATE TABLE Calendrier (
    date INTEGER NOT NULL PRIMARY KEY,                
    annee VARCHAR(255) NOT NULL,
    mois INTEGER NOT NULL,
    jour INTEGER NOT NULL,                         
    mois_nom VARCHAR(255) NOT NULL,
    annee_mois INTEGER NOT NULL,
    jour_semaine INTEGER NOT NULL,
    trimestre VARCHAR(2) NOT NULL
);

-- Création de la table Employé
CREATE TABLE Employé (
    id_employe VARCHAR(32) NOT NULL PRIMARY KEY,                
    employe VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,                         
    date_debut INTEGER NOT NULL,
    hash_mdp VARCHAR(255) NOT NULL,
    mail VARCHAR(255) NOT NULL
);

----- | CLES ETRANGERES | -----

-- Liaison de CUSTOMER_ID de Vente_Detail avec CUSTOMER_ID de Clients
ALTER TABLE Vente_Detail
ADD CONSTRAINT fk_customer
FOREIGN KEY (CUSTOMER_ID)
REFERENCES Clients(CUSTOMER_ID)
ON DELETE CASCADE;

-- Liaison de id_employe de Vente_Detail avec id_employe de Employé
ALTER TABLE Vente_Detail
ADD CONSTRAINT fk_employe
FOREIGN KEY (id_employe)
REFERENCES Employé(id_employe)
ON DELETE SET NULL;

-- Liaison de EAN de Vente_Detail avec EAN de Produits
ALTER TABLE Vente_Detail
ADD CONSTRAINT fk_produits
FOREIGN KEY (EAN)
REFERENCES Produits(EAN)
ON DELETE CASCADE;

-- Liaison de date_vente de Vente_Detail avec date de Calendrier
ALTER TABLE Vente_Detail
ADD CONSTRAINT fk_calendrier
FOREIGN KEY (date_vente)
REFERENCES Calendrier(date)
ON DELETE CASCADE;


----- | Le chiffre d'affaires total pour le 14 août 2024 | -----

SELECT 
    ROUND(SUM(P.Prix)::NUMERIC, 2) AS Chiffre_Affaires
FROM 
    Vente_Detail V
JOIN 
    Produits P ON V.EAN = P.EAN
JOIN 
    Calendrier C ON V.date_vente = C.date
WHERE 
    C.annee = '2024' 
    AND C.mois = 8 
    AND C.jour = 14;

----- | Le chiffre d'affaires par client pour le top 10 des clients | -----

SELECT 
    V.CUSTOMER_ID, 
    ROUND(SUM(P.Prix)::NUMERIC, 2) AS Chiffre_Affaires
FROM 
    Vente_Detail V
JOIN 
    Produits P ON V.EAN = P.EAN
GROUP BY 
    V.CUSTOMER_ID
ORDER BY 
    Chiffre_Affaires DESC
LIMIT 10;


----- | La part de chiffre d'affaires encaissé par employé | -----

WITH ChiffreAffairesEmploye AS (
    SELECT 
        V.id_employe,
        ROUND(SUM(P.Prix)::NUMERIC, 2) AS Chiffre_Affaires_Employe
    FROM 
        Vente_Detail V
    JOIN 
        Produits P ON V.EAN = P.EAN
    GROUP BY 
        V.id_employe
),
ChiffreAffairesTotal AS (
    SELECT 
        ROUND(SUM(P.Prix)::NUMERIC, 2) AS Chiffre_Affaires_Total
    FROM 
        Vente_Detail V
    JOIN 
        Produits P ON V.EAN = P.EAN
)
SELECT 
    E.prenom,
    E.nom,
    CAE.Chiffre_Affaires_Employe,
    CAT.Chiffre_Affaires_Total,
    ROUND((CAE.Chiffre_Affaires_Employe / CAT.Chiffre_Affaires_Total) * 100, 2) AS Part_Chiffre_Affaires_Employe
FROM 
    Employé E
JOIN 
    ChiffreAffairesEmploye CAE ON E.id_employe = CAE.id_employe
JOIN 
    ChiffreAffairesTotal CAT ON 1 = 1;

----- | CREATION DE LA TABLE DES LOGS | -----

CREATE TABLE Logs (
    id_user VARCHAR(255),
    date INTEGER,
    action VARCHAR(255),
    table_insert VARCHAR(255),
    id_ligne VARCHAR(255),
    champs VARCHAR(255),
    detail VARCHAR(255)
);

-------------------- | EXPLICATION DIFFERENCES DE PRIX 14 JUILLET 2024 | --------------------

---------- | LIGNES DU 15 AOUT LIEES AU 14 AOUT PAR UN MÊME NUMÉRO DE TICKET | ----------

SELECT *
FROM Logs
WHERE champs = 'ID ticket'
  AND date = 45519
  AND detail IN (
        SELECT detail
        FROM Logs
        WHERE champs = 'ID ticket'
          AND date IN (45518, 45519)
        GROUP BY detail
        HAVING COUNT(DISTINCT date) = 2
  );

---------- | NOMBRE DE LIGNES TOTALES | ----------

SELECT COUNT(*) AS total_lignes_45519
FROM Logs
WHERE champs = 'ID ticket'
  AND date = 45519;

---------- | NOMBRE DE LIGNES CONCERNEES PAR DES ACHATS PRESENTS SUR LES 2 JOURS | ----------

SELECT COUNT(*) AS nb_lignes
FROM Logs
WHERE champs = 'ID ticket'
  AND date = 45519
  AND detail IN (
        SELECT detail
        FROM Logs
        WHERE champs = 'ID ticket'
          AND date IN (45518, 45519)
        GROUP BY detail
        HAVING COUNT(DISTINCT date) = 2
  );

---------- | CHIFFRE D'AFFAIRES ENREGISTRE LE 15 AOUT 2024 | ----------

SELECT 
    ROUND(SUM(P.Prix)::NUMERIC, 2) AS Chiffre_Affaires
FROM 
    Logs L
JOIN 
    Produits P 
    ON L.detail::BIGINT = P.EAN
WHERE 
    L.date = 45519
    AND L.champs = 'EAN';  