--Création de la base de donnée
CREATE DATABASE EvalCinema;

--Utilisation de la base de donnée
USE EvalCinema;

--Création des tables
CREATE TABLE client
(
    idClient INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT(100) NOT NULL CHECK (age > 0),
    student TINYINT(1)
);

CREATE TABLE cinema
(
    idCinema INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    salleNumber INT(25) NOT NULL
);

CREATE TABLE salle
(
    idSalle INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    place INT(255) NOT NULL CHECK (place > 0),
    id_cinema INT(11) NOT NULL,
    FOREIGN KEY (id_cinema) REFERENCES cinema(idCinema)
);

CREATE TABLE film
(
    idFilm INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE seance
(
    idSeance INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date DATETIME NOT NULL,
    id_film INT(11) NOT NULL,
    id_salle INT(11) NOT NULL,
    FOREIGN KEY (id_film) REFERENCES film(idFilm),
    FOREIGN KEY (id_salle) REFERENCES salle(idSalle)
);

CREATE TABLE ticket
(
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(3,2) NOT NULL CHECK (price > 0);
    id_seance INT(11) NOT NULL,
    id_client INT(11) NOT NULL,
    FOREIGN KEY (id_seance) REFERENCES seance(idSeance),
    FOREIGN KEY (id_client) REFERENCES client(idClient)
);

--Création des cinémas 1 par 1
INSERT INTO cinema (name, salleNumber) VALUES ('Pathé', 15);
INSERT INTO cinema (name, salleNumber) VALUES ('UGCciné', 12);

--Création des salles de cinéma plusieures en 1 seule requette
INSERT INTO salle (place, id_cinema)
VALUES
    (400, 1),
    (320, 1),
    (150, 2),
    (250, 2);

--Création des films
INSERT INTO film (name) 
VALUES 
    ('Matrix'),
    ('Intouchable'),
    ('Fast and Furious 10'),
    ('Moi moche et mechant');

--Création des seances
INSERT INTO seance (date, id_film, id_salle)
VALUES
    ('2024-01-12 18:30:00', 1, 2),
    ('2024-01-22 21:00:00', 1, 3),
    ('2024-01-17 22:30:00', 3, 1),
    ('2024-02-01 21:30:00', 4, 4);

--Création des clients
INSERT INTO client (idClient, name, prenom, age, student)
VALUES
    ('Doe', 'John', 25, 0),
    ('Dupond', 'Jeanne', 35, 0),
    ('Dupond', 'Nicolas', 16, 1),
    ('Jean', 'Dupont', 13, 0);

--Création de tickets
INSERT INTO ticket (price, id_seance, id_client)
VALUES
    (9.20, 1, 1),
    (9.20, 3, 2),
    (7.60, 3, 3),
    (5.90, 2, 4);

--Création des admin et de leurs privilèges
--Super Admin pour le cinema Pathé
SELECT PASSWORD('superAdmin_pathe');
CREATE USER 'SA_pathe'@'localhost' IDENTIFIED BY '*7C452BB57CCB104DE90416BA0293EFA2300E3468';
GRANT INSERT, SELECT, UPDATE, DELETE ON * . * TO 'SA_pathe'@'localhost';
--Super Admin pour le cinema UGCciné
SELECT PASSWORD('superAdmin_UGC');
CREATE USER 'SA_UGC'@'localhost' IDENTIFIED BY '*B9F31AA0FA950C59ACC086E5EB5B8D49200CE3A1';
GRANT INSERT, SELECT, UPDATE, DELETE ON * . * TO 'SA_UGC'@'localhost';
--Admins du cinéma Pathé
SELECT PASSWORD('Scoupart');
CREATE USER 'S_Coupart'@'localhost' IDENTIFIED BY '*A9CB9606EED603FCEAFFC35A0454403B25AA079B';
GRANT SELECT ON * . * TO 'S_Coupart'@'localhost';
SELECT PASSWORD('Vparrot');
CREATE USER 'V_Parrot'@'localhost' IDENTIFIED BY '*04D1AFC000429DC9D0E471E91281851B444C16A7';
GRANT SELECT ON * . * TO 'V_Parrot'@'localhost';
--Admin du cinéma UGCciné
SELECT PASSWORD('Marmand');
CREATE USER 'M_Armand'@'localhost' IDENTIFIED BY '*C81EF2F8C98F0BF9B8CE5769E27CDD9FE8B620D8';
GRANT SELECT ON * . * TO 'M_Armand'@'localhost';

--Création des tables Admin
CREATE TABLE SuperAdmin
(
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    id_cinema INT(11) NOT NULL,
    FOREIGN KEY (id_cinema) REFERENCES cinema(idCinema)
);

CREATE TABLE Admin
(
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    id_cinema INT(11) NOT NULL,
    FOREIGN KEY (id_cinema) REFERENCES cinema(idCinema)
);

--Insertion des données dans les tables Admin et SuperAdmin
--SuperAdmin
INSERT INTO superadmin (name, prenom, id_cinema)
VALUES
    ('Pathe','SuperAdmin', 1),
    ('UGC', 'SuperAdmin', 2);
--Admin
INSERT INTO admin (name, prenom, id_cinema)
VALUES
    ('Sandrine','Coupart', 1),
    ('Vincent', 'Parrot', 1),
    ('Marie', 'Armand', 2);

--Exemples de modification de la base de donnée
UPDATE client 
    SET age = 11, 
        student = 0 
    WHERE id = 3;
UPDATE ticket SET price = 9.20 WHERE student = 0 AND age > 14;

--Sauvegarde et restauration avec MySqlDump
--Dans le terminal de mon ordinateur
--Commande pour sauvegarder ma base de donnée
mysqldump -u root -p evalcinema > C:\Users\phili\OneDrive\Bureau\Projets STUDI\Eval-SQL-cinema\DataBase.sql
--Commande pour restaurer ma base de donnée
mysql -u root -p evalcinema < DataBase.sql --Nom du fichier modifié APRES avoir fait la sauvegarde (nouveau nom DataBase-PhilippeSP.sql)