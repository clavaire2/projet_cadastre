-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 22 déc. 2024 à 21:16
-- Version du serveur : 8.3.0
-- Version de PHP : 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cadastre`
--

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_admin` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_admin` (`email_admin`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`ident`, `nom_complet`, `email_admin`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'Abalo admin', 'abalo@gmail.com', '66565', '2024-12-06 18:55:54', 'ea66e9c169c7e5a307eb06fb8e6a239d');

-- --------------------------------------------------------

--
-- Structure de la table `brigade`
--

DROP TABLE IF EXISTS `brigade`;
CREATE TABLE IF NOT EXISTS `brigade` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_brigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_brigade` (`email_brigade`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `brigade`
--

INSERT INTO `brigade` (`ident`, `nom_complet`, `email_brigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo Brigarde', 'abalo_b@gmail.com', '66565', '2024-12-06 18:28:10', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'Gomina clavaire', 'clavaire.gominab@gmail.com', '92891445', '2024-12-10 09:20:31', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `chef_brigade`
--

DROP TABLE IF EXISTS `chef_brigade`;
CREATE TABLE IF NOT EXISTS `chef_brigade` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_chefbrigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_chefbrigade` (`email_chefbrigade`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `chef_brigade`
--

INSERT INTO `chef_brigade` (`ident`, `nom_complet`, `email_chefbrigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(4, 'Abalo cb', 'abalo_cb@gmail.com', '66565', '2024-12-06 18:19:59', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(5, 'c Gomina clavaire', 'clavaire.gomina@gmail.com', '92891445', '2024-12-10 08:27:15', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `conversation_fonciere`
--

DROP TABLE IF EXISTS `conversation_fonciere`;
CREATE TABLE IF NOT EXISTS `conversation_fonciere` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_conversationfonciere` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_conversationfonciere` (`email_conversationfonciere`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `conversation_fonciere`
--

INSERT INTO `conversation_fonciere` (`ident`, `name`, `prenom`, `email_conversationfonciere`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cb', 'cf', 'abalo_cf@gmail.com', '66565', '2024-12-06 18:48:30', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `dossier`
--

DROP TABLE IF EXISTS `dossier`;
CREATE TABLE IF NOT EXISTS `dossier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  `statut` enum('attente','valide','rejete','termine','en_cours') COLLATE utf8mb4_unicode_ci DEFAULT 'attente',
  `nom_de_ajouteur` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `evaluation_cadastrale`
--

DROP TABLE IF EXISTS `evaluation_cadastrale`;
CREATE TABLE IF NOT EXISTS `evaluation_cadastrale` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_evaluationcadastrale` (`email_evaluation_cadastrale`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `evaluation_cadastrale`
--

INSERT INTO `evaluation_cadastrale` (`ident`, `nom_complet`, `email_evaluation_cadastrale`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo ec', 'abalo_ec@gmail.com', '66565', '2024-12-06 18:46:59', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'c Gomina clavaire', 'clavaire.gominasev@gmail.com', '92891445', '2024-12-10 10:50:14', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade`
--

DROP TABLE IF EXISTS `gestion_brigade`;
CREATE TABLE IF NOT EXISTS `gestion_brigade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_brigade`
--

INSERT INTO `gestion_brigade` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`) VALUES
(2, 'B1245787', '2024-12-14 00:00:24', '2024-12-22 20:53:33', '2024-12-22 20:53:33', 'En attente', 'Abalo cb', 'Abalo cb', '4', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade_terminer`
--

DROP TABLE IF EXISTS `gestion_brigade_terminer`;
CREATE TABLE IF NOT EXISTS `gestion_brigade_terminer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_brigade_terminer`
--

INSERT INTO `gestion_brigade_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `date_temine_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-14 20:26:02', '2024-12-15 17:02:51', 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade`
--

DROP TABLE IF EXISTS `gestion_chef_brigade`;
CREATE TABLE IF NOT EXISTS `gestion_chef_brigade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade_terminer`
--

DROP TABLE IF EXISTS `gestion_chef_brigade_terminer`;
CREATE TABLE IF NOT EXISTS `gestion_chef_brigade_terminer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation` datetime DEFAULT NULL,
  `date_terminer` datetime DEFAULT NULL,
  `statut` enum('Termine') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Termine',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_chef_brigade_terminer`
--

INSERT INTO `gestion_chef_brigade_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation`, `date_terminer`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 08:49:21', '2024-12-14 09:24:07', 'Termine', 'Abalo cb', 'Abalo cb', '4'),
(2, 'B1245787', '2024-12-14 00:00:24', '2024-12-14 01:41:07', '2024-12-22 20:53:33', 'Termine', 'Abalo cb', 'Abalo cb', '4');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale`
--

DROP TABLE IF EXISTS `gestion_evaluation_cadastrale`;
CREATE TABLE IF NOT EXISTS `gestion_evaluation_cadastrale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_evaluation_cadastrale`
--

INSERT INTO `gestion_evaluation_cadastrale` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', '2024-12-22 12:48:22', 'En cours', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1', 'Abalo S', '1', 'Abalo ec', '1');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale_terminer`
--

DROP TABLE IF EXISTS `gestion_evaluation_cadastrale_terminer`;
CREATE TABLE IF NOT EXISTS `gestion_evaluation_cadastrale_terminer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `date_ajout` datetime NOT NULL,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `statut` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Terminé',
  `n1_admin` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_chef_brigade` int DEFAULT NULL,
  `n3_brigade` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_brigade` int DEFAULT NULL,
  `n4_securisation` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_securisation` int DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_evaluation_cadastrale` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_fonciere`
--

DROP TABLE IF EXISTS `gestion_fonciere`;
CREATE TABLE IF NOT EXISTS `gestion_fonciere` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_validation` datetime DEFAULT CURRENT_TIMESTAMP,
  `nom_signature` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `fonciere_id` int DEFAULT NULL,
  `validateur` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `gestion_fonciere`
--

INSERT INTO `gestion_fonciere` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_signature`, `statut`, `fonciere_id`, `validateur`) VALUES
(1, 'ss', '2024-12-10 09:02:14', '2024-12-10 12:24:23', 'c Gomina clavaire w', 'En attente', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation`
--

DROP TABLE IF EXISTS `gestion_securisation`;
CREATE TABLE IF NOT EXISTS `gestion_securisation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation_terminer`
--

DROP TABLE IF EXISTS `gestion_securisation_terminer`;
CREATE TABLE IF NOT EXISTS `gestion_securisation_terminer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_securisation_terminer`
--

INSERT INTO `gestion_securisation_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation`, `id_evaluation`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1', 'Abalo S', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature`
--

DROP TABLE IF EXISTS `gestion_signature`;
CREATE TABLE IF NOT EXISTS `gestion_signature` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_dossier` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `date_ajout` datetime NOT NULL,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_assignation_n6` datetime DEFAULT NULL,
  `statut` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `n1_admin` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_chef_brigade` int DEFAULT NULL,
  `n3_brigade` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_brigade` int DEFAULT NULL,
  `n4_securisation` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_securisation` int DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_evaluation_cadastrale` int DEFAULT NULL,
  `n6_signature` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_signature` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `securisation`
--

DROP TABLE IF EXISTS `securisation`;
CREATE TABLE IF NOT EXISTS `securisation` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_securisation` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_securisation` (`email_securisation`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `securisation`
--

INSERT INTO `securisation` (`ident`, `nom_complet`, `email_securisation`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo S', 'abalo_s@gmail.com', '66565', '2024-12-06 18:45:52', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'c Gomina clavaire', 'clavaire.gominas@gmail.com', '92891445', '2024-12-10 10:27:11', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `signature`
--

DROP TABLE IF EXISTS `signature`;
CREATE TABLE IF NOT EXISTS `signature` (
  `ident` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_signature` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`ident`),
  UNIQUE KEY `email_signature` (`email_signature`),
  UNIQUE KEY `numero_telephone` (`numero_telephone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `signature`
--

INSERT INTO `signature` (`ident`, `name`, `prenom`, `email_signature`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cb', 's', 'abalo_s@gmail.com', '66565', '2024-12-06 18:47:41', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'c Gomina clavaire', 'w', 'clavaire.gominasi@gmail.com', '92891445', '2024-12-10 12:21:01', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `terminer_brigade`
--

DROP TABLE IF EXISTS `terminer_brigade`;
CREATE TABLE IF NOT EXISTS `terminer_brigade` (
  `id` int NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_assignation` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_terminer` datetime DEFAULT CURRENT_TIMESTAMP,
  `nom_brigade` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
