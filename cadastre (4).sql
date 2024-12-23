-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 23 déc. 2024 à 19:21
-- Version du serveur : 10.6.9-MariaDB
-- Version de PHP : 8.1.25

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

CREATE TABLE `admin` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_admin` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`ident`, `nom_complet`, `email_admin`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'Abalo admin', 'abalo@gmail.com', '66565', '2024-12-06 18:55:54', 'ea66e9c169c7e5a307eb06fb8e6a239d');

-- --------------------------------------------------------

--
-- Structure de la table `brigade`
--

CREATE TABLE `brigade` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_brigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE `chef_brigade` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_chefbrigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE `conversation_fonciere` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(255) NOT NULL,
  `email_conversation_fonciere` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `conversation_fonciere`
--

INSERT INTO `conversation_fonciere` (`ident`, `nom_complet`, `email_conversation_fonciere`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cf', 'abalo_cf@gmail.com', '66565', '2024-12-06 18:48:30', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `dossier`
--

CREATE TABLE `dossier` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `statut` enum('attente','valide','rejete','termine','en_cours') COLLATE utf8mb4_unicode_ci DEFAULT 'attente',
  `nom_de_ajouteur` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `evaluation_cadastrale`
--

CREATE TABLE `evaluation_cadastrale` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE `gestion_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_brigade`
--

INSERT INTO `gestion_brigade` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`) VALUES
(2, 'B1245787', '2024-12-14 00:00:24', '2024-12-22 20:53:33', '2024-12-22 20:53:33', 'En attente', 'Abalo cb', 'Abalo cb', '4', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade_terminer`
--

CREATE TABLE `gestion_brigade_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_brigade_terminer`
--

INSERT INTO `gestion_brigade_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `date_temine_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-14 20:26:02', '2024-12-15 17:02:51', 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade`
--

CREATE TABLE `gestion_chef_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade_terminer`
--

CREATE TABLE `gestion_chef_brigade_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation` datetime DEFAULT NULL,
  `date_terminer` datetime DEFAULT NULL,
  `statut` enum('Termine') COLLATE utf8mb4_unicode_ci DEFAULT 'Termine',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_chef_brigade_terminer`
--

INSERT INTO `gestion_chef_brigade_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation`, `date_terminer`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 08:49:21', '2024-12-14 09:24:07', 'Termine', 'Abalo cb', 'Abalo cb', '4'),
(2, 'B1245787', '2024-12-14 00:00:24', '2024-12-14 01:41:07', '2024-12-22 20:53:33', 'Termine', 'Abalo cb', 'Abalo cb', '4');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_conversation_fonciere`
--

CREATE TABLE `gestion_conversation_fonciere` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_assignation_n6` datetime DEFAULT NULL,
  `date_temine_n6` datetime DEFAULT NULL,
  `date_assignation_n7` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n6_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n7_conversation_fonciere` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_conversation_fonciere` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_conversation_fonciere_terminer`
--

CREATE TABLE `gestion_conversation_fonciere_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_assignation_n6` datetime DEFAULT NULL,
  `date_temine_n6` datetime DEFAULT NULL,
  `date_assignation_n7` datetime DEFAULT NULL,
  `date_temine_n7` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n6_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n7_conversation_fonciere` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_conversation_fonciere` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_conversation_fonciere_terminer`
--

INSERT INTO `gestion_conversation_fonciere_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `date_assignation_n6`, `date_temine_n6`, `date_assignation_n7`, `date_temine_n7`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `n6_signature`, `id_signature`, `n7_conversation_fonciere`, `id_conversation_fonciere`) VALUES
(2, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', '2024-12-22 12:48:22', '2024-12-23 11:33:30', '2024-12-23 12:42:31', '2024-12-23 15:21:47', '2024-12-23 16:40:28', '2024-12-23 17:24:54', 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1', 'Abalo S', '1', 'Abalo ec', '1', 'Abalo si', '1', 'Abalo cf', '1');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale`
--

CREATE TABLE `gestion_evaluation_cadastrale` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale_terminer`
--

CREATE TABLE `gestion_evaluation_cadastrale_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime NOT NULL,
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `statut` varchar(50) NOT NULL DEFAULT 'Terminé',
  `n1_admin` varchar(255) DEFAULT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` int(11) DEFAULT NULL,
  `n3_brigade` varchar(255) DEFAULT NULL,
  `id_brigade` int(11) DEFAULT NULL,
  `n4_securisation` varchar(255) DEFAULT NULL,
  `id_securisation` int(11) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(255) DEFAULT NULL,
  `id_evaluation_cadastrale` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_evaluation_cadastrale_terminer`
--

INSERT INTO `gestion_evaluation_cadastrale_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', '2024-12-22 12:48:22', '2024-12-23 11:33:30', 'Terminé', 'Abalo cb', 'Abalo cb', 4, 'Abalo Brigarde', 1, 'Abalo S', 1, 'Abalo ec', 1);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_fonciere`
--

CREATE TABLE `gestion_fonciere` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_validation` datetime DEFAULT current_timestamp(),
  `nom_signature` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `fonciere_id` int(11) DEFAULT NULL,
  `validateur` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_fonciere`
--

INSERT INTO `gestion_fonciere` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_signature`, `statut`, `fonciere_id`, `validateur`) VALUES
(1, 'ss', '2024-12-10 09:02:14', '2024-12-10 12:24:23', 'c Gomina clavaire w', 'En attente', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation`
--

CREATE TABLE `gestion_securisation` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation_terminer`
--

CREATE TABLE `gestion_securisation_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_securisation_terminer`
--

INSERT INTO `gestion_securisation_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation`, `id_evaluation`) VALUES
(1, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1', 'Abalo S', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature`
--

CREATE TABLE `gestion_signature` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_assignation_n6` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n6_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature_terminer`
--

CREATE TABLE `gestion_signature_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_temine_n6` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') COLLATE utf8mb4_unicode_ci DEFAULT 'En attente',
  `n1_admin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n2_chef_brigade` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_chef_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n3_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_brigade` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n4_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_securisation` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n6_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_signature` varchar(225) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `gestion_signature_terminer`
--

INSERT INTO `gestion_signature_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `date_temine_n6`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `n6_signature`, `id_signature`) VALUES
(2, 'B1245788', '2024-12-14 08:13:05', '2024-12-14 09:24:07', '2024-12-15 17:02:51', '2024-12-22 09:51:30', '2024-12-22 11:32:45', '2024-12-22 12:48:22', '2024-12-23 15:21:47', NULL, 'Terminé', 'Abalo cb', 'Abalo cb', '4', 'Abalo Brigarde', '1', 'Abalo S', '1', 'Abalo ec', '1', 'Abalo si', '1');

-- --------------------------------------------------------

--
-- Structure de la table `securisation`
--

CREATE TABLE `securisation` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(225) DEFAULT NULL,
  `email_securisation` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE `signature` (
  `ident` int(11) NOT NULL,
  `nom_complet` varchar(255) NOT NULL,
  `email_signature` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `signature`
--

INSERT INTO `signature` (`ident`, `nom_complet`, `email_signature`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo si', 'abalo_si@gmail.com', '66565', '2024-12-06 18:47:41', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'c Gomina clavaire', 'clavaire.gominasi@gmail.com', '92891445', '2024-12-10 12:21:01', '5669fb4cc8a47469cc15eb3e24dc8f23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `terminer_brigade`
--

CREATE TABLE `terminer_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_assignation` datetime DEFAULT current_timestamp(),
  `date_terminer` datetime DEFAULT current_timestamp(),
  `nom_brigade` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_admin` (`email_admin`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `brigade`
--
ALTER TABLE `brigade`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_brigade` (`email_brigade`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `chef_brigade`
--
ALTER TABLE `chef_brigade`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_chefbrigade` (`email_chefbrigade`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `conversation_fonciere`
--
ALTER TABLE `conversation_fonciere`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_conversationfonciere` (`email_conversation_fonciere`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `dossier`
--
ALTER TABLE `dossier`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `evaluation_cadastrale`
--
ALTER TABLE `evaluation_cadastrale`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_evaluationcadastrale` (`email_evaluation_cadastrale`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_brigade_terminer`
--
ALTER TABLE `gestion_brigade_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_chef_brigade_terminer`
--
ALTER TABLE `gestion_chef_brigade_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_conversation_fonciere`
--
ALTER TABLE `gestion_conversation_fonciere`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_conversation_fonciere_terminer`
--
ALTER TABLE `gestion_conversation_fonciere_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_evaluation_cadastrale_terminer`
--
ALTER TABLE `gestion_evaluation_cadastrale_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_securisation`
--
ALTER TABLE `gestion_securisation`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_securisation_terminer`
--
ALTER TABLE `gestion_securisation_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gestion_signature_terminer`
--
ALTER TABLE `gestion_signature_terminer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `securisation`
--
ALTER TABLE `securisation`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_securisation` (`email_securisation`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `signature`
--
ALTER TABLE `signature`
  ADD PRIMARY KEY (`ident`),
  ADD UNIQUE KEY `email_signature` (`email_signature`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `admin`
--
ALTER TABLE `admin`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `brigade`
--
ALTER TABLE `brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `chef_brigade`
--
ALTER TABLE `chef_brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `conversation_fonciere`
--
ALTER TABLE `conversation_fonciere`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `dossier`
--
ALTER TABLE `dossier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `evaluation_cadastrale`
--
ALTER TABLE `evaluation_cadastrale`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_brigade_terminer`
--
ALTER TABLE `gestion_brigade_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade_terminer`
--
ALTER TABLE `gestion_chef_brigade_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_conversation_fonciere`
--
ALTER TABLE `gestion_conversation_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_conversation_fonciere_terminer`
--
ALTER TABLE `gestion_conversation_fonciere_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale_terminer`
--
ALTER TABLE `gestion_evaluation_cadastrale_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_securisation`
--
ALTER TABLE `gestion_securisation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_securisation_terminer`
--
ALTER TABLE `gestion_securisation_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_signature_terminer`
--
ALTER TABLE `gestion_signature_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `securisation`
--
ALTER TABLE `securisation`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `signature`
--
ALTER TABLE `signature`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
