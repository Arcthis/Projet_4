# Projet 4 - Analyse des ventes et audit de données

## Contexte et objectifs

La mission consiste à réaliser un audit de la qualité des données d'une enseigne de grande distribution, puis à produire une analyse des ventes à partir de ces données.

L'entreprise dispose de plusieurs sources de données brutes : un historique des transactions de vente, un catalogue produits, une base clients, un référentiel employés ainsi qu'un journal de logs retraçant les modifications effectuées en base. Ces données, initialement stockées sous forme de fichiers Excel et CSV, présentaient des incohérences à identifier et à documenter.

Les objectifs principaux du projet sont :

- Concevoir et alimenter une base de données relationnelle à partir de fichiers sources hétérogènes.
- Auditer la qualité des données en identifiant les anomalies et incohérences (doublons, écarts de prix, tickets multi-journées, etc.).
- Produire des analyses métier répondant à des questions concrètes : chiffre d'affaires par jour, par client, par employé.
- Fournir un rapport d'audit documentant les problèmes détectés et les pistes de correction.

---

## Technologies utilisées

- **PostgreSQL** : système de gestion de base de données relationnelle utilisé pour stocker, structurer et interroger les données.
- **SQL** : langage utilisé pour la création des tables, la définition des contraintes d'intégrité (clés primaires, clés étrangères) et l'écriture des requêtes d'analyse.
- **Python** : utilisé pour le nettoyage et la préparation des données avant leur intégration en base.
- **pandas** : bibliothèque Python employée pour la manipulation des fichiers CSV (filtrage de colonnes, conversion de types, export).
- **Jupyter Notebook** : environnement interactif utilisé pour développer et exécuter les scripts de traitement des données.
- **Excel** : format des fichiers sources fournis (données brutes non traitées).

---

## Installation et utilisation du projet

### Prérequis

- Avoir PostgreSQL installé et un serveur de base de données opérationnel.
- Avoir Python installé avec les bibliothèques `pandas`.
- Avoir Jupyter Notebook disponible pour exécuter le notebook de traitement.

### Etapes

1. **Préparation des données** : ouvrir le notebook dans Jupyter et l'exécuter. Il lit les fichiers CSV sources (notamment `clients.csv`), applique les transformations nécessaires (conversion des types de dates, sélection des colonnes utiles) et génère les fichiers CSV nettoyés prêts à être importés.

2. **Création de la base de données** : utiliser la première partie du fichier `script.sql` pour créer les tables (`Vente_Detail`, `Produits`, `Clients`, `Calendrier`, `Employé`, `Logs`) ainsi que les contraintes de clés étrangères associées.

3. **Import des données** : importer les fichiers CSV du dossier `csv/` dans les tables correspondantes de la base PostgreSQL (via un outil comme pgAdmin ou la commande `COPY` en SQL).

4. **Exécution des requêtes d'analyse** : lancer les requêtes présentes dans `script.sql` pour obtenir les résultats d'analyse métier (chiffre d'affaires, classement clients, répartition par employé, investigation des anomalies de logs).

---

## Résultats obtenus

L'analyse des données a permis de répondre aux principales questions métier :

- **Chiffre d'affaires journalier** : le chiffre d'affaires total pour une journée donnée (ex. 14 août 2024) a pu être calculé avec précision en croisant les ventes et le catalogue produits.
- **Top 10 des clients** : identification des dix clients générant le chiffre d'affaires le plus élevé sur l'ensemble de la période.
- **Répartition par employé** : calcul de la part du chiffre d'affaires encaissé par chaque employé, exprimée en valeur absolue et en pourcentage du total.
- **Audit des anomalies** : l'analyse du journal de logs a mis en évidence des tickets de caisse s'étendant sur deux journées consécutives (14 et 15 août 2024), ce qui expliquait une partie des écarts constatés dans les chiffres d'affaires. Le nombre de lignes concernées et leur impact financier ont été quantifiés.