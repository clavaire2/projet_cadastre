-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 14 fév. 2025 à 17:25
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`ident`, `nom_complet`, `email_admin`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'Awadi Abalo', 'abalo.awadi@gmail.com', '93464350', '2024-12-06 18:55:54', 'ea66e9c169c7e5a307eb06fb8e6a239d');

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
  `token_expiration` datetime DEFAULT NULL,
  `id_chef_brigarde` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `brigade`
--

INSERT INTO `brigade` (`ident`, `nom_complet`, `email_brigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`, `id_chef_brigarde`) VALUES
(1, 'AGBODJAN Kossi Bruce', 'clavaireb.gomina@gmail.com', '90611326', '2025-02-05 00:17:06', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL, 1),
(2, 'ALOUMEDJI Emmanuel Kofi Mawoulé', 'excellencealoumedji@gmail.com', '91723907', '2025-02-05 00:18:12', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL, 1),
(3, 'ATSU ETSITSU Josué', 'jatsuetsitsu@otr.tg', '91075997', '2025-02-05 00:19:05', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL, 1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `chef_brigade`
--

INSERT INTO `chef_brigade` (`ident`, `nom_complet`, `email_chefbrigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'BAKEM	 Essimna', 'clavaire.gomina@gmail.com', '92871153', '2025-02-04 21:11:14', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'KOUMA Féidibé', 'fkouma@otr.tg', '92644004', '2025-02-04 21:11:59', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(3, 'NYATSO Komla Lolonyo', 'lolonnyatso@gmail.com', '90678251', '2025-02-04 21:15:02', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `conversation_fonciere`
--

INSERT INTO `conversation_fonciere` (`ident`, `nom_complet`, `email_conversation_fonciere`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cf', 'abalo_cf@gmail.com', '93464350', '2024-12-06 18:48:30', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `dossier`
--

CREATE TABLE `dossier` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `statut` enum('attente','valide','rejete','termine','en_cours') DEFAULT 'attente',
  `nom_de_ajouteur` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `dossier`
--

INSERT INTO `dossier` (`id`, `nom_dossier`, `date_creation`, `statut`, `nom_de_ajouteur`) VALUES
(17, 'Ab015', '2025-02-13 17:18:51', 'attente', 'Awadi Abalo');

-- --------------------------------------------------------

--
-- Structure de la table `dossier_terminer`
--

CREATE TABLE `dossier_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime NOT NULL,
  `date_assignation` datetime NOT NULL,
  `date_terminer` datetime NOT NULL,
  `statut` varchar(50) NOT NULL,
  `n1_admin` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `dossier_terminer`
--

INSERT INTO `dossier_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation`, `date_terminer`, `statut`, `n1_admin`) VALUES
(1, '61021', '2025-02-04 19:52:45', '2025-02-04 19:53:36', '2025-02-04 19:53:36', 'Terminé', 'Awadi Abalo'),
(2, '60170', '2025-02-04 19:52:45', '2025-02-04 19:53:36', '2025-02-04 19:53:36', 'Terminé', 'Awadi Abalo'),
(3, '57195', '2025-02-04 19:52:45', '2025-02-04 19:53:47', '2025-02-04 19:53:47', 'Terminé', 'Awadi Abalo'),
(4, '55326', '2025-02-04 19:52:45', '2025-02-04 19:53:47', '2025-02-04 19:53:47', 'Terminé', 'Awadi Abalo'),
(5, '54010', '2025-02-04 19:52:45', '2025-02-05 00:03:03', '2025-02-05 00:03:03', 'Terminé', 'Awadi Abalo'),
(6, '49312', '2025-02-04 19:52:45', '2025-02-05 00:03:03', '2025-02-05 00:03:03', 'Terminé', 'Awadi Abalo'),
(7, '47660', '2025-02-04 19:52:45', '2025-02-09 10:30:06', '2025-02-09 10:30:06', 'Terminé', 'Awadi Abalo'),
(8, '47242', '2025-02-04 19:52:45', '2025-02-09 10:30:06', '2025-02-09 10:30:06', 'Terminé', 'Awadi Abalo'),
(9, '46957', '2025-02-04 19:52:45', '2025-02-09 10:30:06', '2025-02-09 10:30:06', 'Terminé', 'Awadi Abalo'),
(10, '52890', '2025-02-04 19:52:45', '2025-02-09 23:53:30', '2025-02-09 23:53:30', 'Terminé', 'Awadi Abalo'),
(11, '45688', '2025-02-04 19:52:45', '2025-02-09 23:53:30', '2025-02-09 23:53:30', 'Terminé', 'Awadi Abalo'),
(12, '43958', '2025-02-04 19:52:45', '2025-02-09 23:53:30', '2025-02-09 23:53:30', 'Terminé', 'Awadi Abalo'),
(13, '38511', '2025-02-04 19:52:45', '2025-02-10 00:08:35', '2025-02-10 00:08:35', 'Terminé', 'Awadi Abalo'),
(14, 'ezr6', '2025-02-10 15:16:38', '2025-02-10 17:42:50', '2025-02-10 17:42:54', 'Terminé', 'Awadi Abalo'),
(15, 'zvcz68', '2025-02-10 15:16:38', '2025-02-10 18:01:18', '2025-02-10 18:01:22', 'Terminé', 'Awadi Abalo'),
(16, 'zevez64', '2025-02-10 15:16:38', '2025-02-10 18:01:18', '2025-02-10 18:01:25', 'Terminé', 'Awadi Abalo'),
(17, 'zefezf6', '2025-02-10 15:16:38', '2025-02-10 18:02:43', '2025-02-10 18:02:46', 'Terminé', 'Awadi Abalo'),
(18, 'zefze54', '2025-02-10 15:16:38', '2025-02-10 18:02:43', '2025-02-10 18:02:49', 'Terminé', 'Awadi Abalo'),
(19, 'zegve55', '2025-02-11 11:17:15', '2025-02-11 11:17:23', '2025-02-11 11:17:27', 'Terminé', 'Awadi Abalo'),
(20, 'Ab016', '2025-02-13 17:19:01', '2025-02-13 17:20:56', '2025-02-13 17:20:56', 'Terminé', 'Awadi Abalo'),
(21, 'AB017', '2025-02-13 17:19:14', '2025-02-13 17:20:56', '2025-02-13 17:20:56', 'Terminé', 'Awadi Abalo'),
(22, 'Ab014', '2025-02-13 17:18:39', '2025-02-14 14:52:39', '2025-02-14 14:52:39', 'Terminé', 'Awadi Abalo');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `evaluation_cadastrale`
--

INSERT INTO `evaluation_cadastrale` (`ident`, `nom_complet`, `email_evaluation_cadastrale`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(2, 'KOUGNIGAN Reine Marimar Théréza', 'rkougnigan@otr.tg', '98978181', '2025-02-04 21:21:47', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade`
--

CREATE TABLE `gestion_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé','Rejeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `objet` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_brigade`
--

INSERT INTO `gestion_brigade` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `objet`) VALUES
(10, 'zefezf6', '2025-02-10 18:02:43', '2025-02-14 14:15:31', '2025-02-14 14:34:50', 'En cours', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'non'),
(12, '45688', '2025-02-09 23:53:30', '2025-02-14 14:49:34', '2025-02-14 14:51:45', 'En cours', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'encore'),
(13, 'Ab014', '2025-02-14 14:52:39', NULL, '2025-02-14 14:52:52', 'En attente', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'non');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade_terminer`
--

CREATE TABLE `gestion_brigade_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade`
--

CREATE TABLE `gestion_chef_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `objet` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_chef_brigade`
--

INSERT INTO `gestion_chef_brigade` (`id`, `nom_dossier`, `date_ajout`, `date_assignation`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `objet`) VALUES
(3, 'ezr6', '2025-02-10 17:42:50', '2025-02-10 17:42:50', 'En cours', 'Awadi Abalo', 'BAKEM	 Essimna', '1', NULL),
(4, 'zvcz68', '2025-02-10 18:01:18', '2025-02-10 18:01:18', 'En cours', 'Awadi Abalo', 'BAKEM	 Essimna', '1', NULL),
(5, 'zevez64', '2025-02-10 18:01:18', '2025-02-10 18:01:18', 'En cours', 'Awadi Abalo', 'BAKEM	 Essimna', '1', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade_terminer`
--

CREATE TABLE `gestion_chef_brigade_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation` datetime DEFAULT NULL,
  `date_terminer` datetime DEFAULT NULL,
  `statut` enum('Termine') DEFAULT 'Termine',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_chef_brigade_terminer`
--

INSERT INTO `gestion_chef_brigade_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation`, `date_terminer`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`) VALUES
(1, '49312', '2025-02-05 00:03:03', '2025-02-05 00:03:03', '2025-02-05 00:33:05', 'Termine', 'Awadi Abalo', 'BAKEM	 Essimna', '1'),
(2, '54010', '2025-02-05 00:03:03', '2025-02-05 00:03:03', '2025-02-10 16:18:25', 'Termine', 'Awadi Abalo', 'BAKEM	 Essimna', '1'),
(3, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:17:23', '2025-02-11 11:20:45', 'Termine', 'Awadi Abalo', 'BAKEM	 Essimna', '1'),
(4, 'zefze54', '2025-02-10 18:02:43', '2025-02-10 18:02:43', '2025-02-11 12:00:04', 'Termine', 'Awadi Abalo', 'BAKEM	 Essimna', '1'),
(5, 'zefezf6', '2025-02-10 18:02:43', '2025-02-10 18:02:43', '2025-02-14 14:15:31', 'Termine', 'Awadi Abalo', 'BAKEM	 Essimna', '1');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_conversation_fonciere`
--

CREATE TABLE `gestion_conversation_fonciere` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
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
  `statut` enum('En attente','En cours','Terminé','Réjeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `n6_signature` varchar(225) DEFAULT NULL,
  `id_signature` varchar(225) DEFAULT NULL,
  `n7_conversation_fonciere` varchar(225) DEFAULT NULL,
  `id_conversation_fonciere` varchar(225) DEFAULT NULL,
  `objet` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_conversation_fonciere`
--

INSERT INTO `gestion_conversation_fonciere` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `date_assignation_n6`, `date_temine_n6`, `date_assignation_n7`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `n6_signature`, `id_signature`, `n7_conversation_fonciere`, `id_conversation_fonciere`, `objet`) VALUES
(2, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:20:45', '2025-02-11 11:29:53', '2025-02-11 11:30:11', '2025-02-11 11:30:20', '2025-02-11 11:30:48', '2025-02-11 11:36:12', '2025-02-11 13:24:16', '2025-02-11 13:29:54', '2025-02-11 13:29:54', 'En attente', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', 'Nom du chef', '2', 'Nom du chef', '2', 'dd'),
(3, '46957', '2025-02-09 10:30:06', NULL, NULL, '2025-02-09 10:30:06', '2025-02-09 11:03:46', '2025-02-12 17:08:15', '2025-02-12 20:24:41', '2025-02-12 20:32:28', '2025-02-12 20:32:43', '2025-02-12 21:23:10', 'En cours', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', 'Nom du chef', '2', 'Nom du chef', '2', 'Abalo cf', '1', 'fin du dossier '),
(7, 'Ab016', '2025-02-13 17:20:56', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-14 08:27:26', '2025-02-14 08:52:37', '2025-02-14 08:52:37', 'En attente', 'Awadi Abalo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nom du chef', '2', 'Nom du chef', '2', 'bien je valide');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_conversation_fonciere_terminer`
--

CREATE TABLE `gestion_conversation_fonciere_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
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
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `n6_signature` varchar(225) DEFAULT NULL,
  `id_signature` varchar(225) DEFAULT NULL,
  `n7_conversation_fonciere` varchar(225) DEFAULT NULL,
  `id_conversation_fonciere` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale`
--

CREATE TABLE `gestion_evaluation_cadastrale` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé','Réjeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `objet` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_evaluation_cadastrale`
--

INSERT INTO `gestion_evaluation_cadastrale` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `objet`) VALUES
(19, '38511', '2025-02-10 00:08:35', '2025-02-10 00:30:32', '2025-02-11 11:52:01', '2025-02-14 13:51:40', '2025-02-14 14:04:18', '2025-02-14 14:04:18', 'En attente', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL, 'bien'),
(20, 'zefze54', '2025-02-10 18:02:43', '2025-02-11 12:00:04', '2025-02-11 12:00:50', '2025-02-11 12:01:15', '2025-02-14 14:05:37', '2025-02-14 14:05:37', 'En attente', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL, 'merci');

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_evaluation_cadastrale_terminer`
--

INSERT INTO `gestion_evaluation_cadastrale_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`) VALUES
(1, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:20:45', '2025-02-11 11:29:53', '2025-02-11 11:30:11', '2025-02-11 11:30:20', '2025-02-11 11:30:48', '2025-02-11 11:36:12', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(2, '49312', '2025-02-05 00:03:03', '2025-02-05 00:33:05', '2025-02-06 21:18:14', '2025-02-09 09:35:18', '2025-02-09 09:36:10', '2025-02-11 11:52:17', '2025-02-11 11:53:22', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(3, 'zefze54', '2025-02-10 18:02:43', '2025-02-11 12:00:04', '2025-02-11 12:00:50', '2025-02-11 12:01:15', '2025-02-11 12:58:04', '2025-02-11 13:20:44', '2025-02-11 13:21:09', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(4, '55326', '2025-02-04 19:53:47', NULL, NULL, '2025-02-04 19:53:47', '2025-02-09 09:35:45', '2025-02-09 09:54:17', '2025-02-12 16:53:32', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(5, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', '2025-02-12 16:51:22', '2025-02-12 16:51:40', '2025-02-12 16:53:46', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(6, '46957', '2025-02-09 10:30:06', NULL, NULL, '2025-02-09 10:30:06', '2025-02-09 11:03:46', '2025-02-12 17:08:15', '2025-02-12 17:08:24', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(7, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', '2025-02-12 17:15:36', '2025-02-12 17:15:54', '2025-02-12 17:16:05', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(8, '43958', '2025-02-09 23:53:30', NULL, NULL, '2025-02-09 23:53:30', '2025-02-10 00:05:14', '2025-02-12 20:08:32', '2025-02-12 20:08:40', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', 1, 'KOUGNIGAN Reine Marimar Théréza', 2),
(9, '49312', '2025-02-05 00:03:03', '2025-02-05 00:33:05', '2025-02-06 21:18:14', '2025-02-09 09:35:18', '2025-02-11 11:53:22', '2025-02-14 09:38:53', '2025-02-14 13:22:46', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', 1, 'BAKEM	 Essimna', 1, 'KOUGNIGAN Reine Marimar Théréza', 2, 'KOUGNIGAN Reine Marimar Théréza', 2);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation`
--

CREATE TABLE `gestion_securisation` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé','Réjeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `objet` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_securisation`
--

INSERT INTO `gestion_securisation` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `objet`) VALUES
(20, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', 'Réjeté', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', 'fini');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation_terminer`
--

CREATE TABLE `gestion_securisation_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation` varchar(225) DEFAULT NULL,
  `id_evaluation` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_securisation_terminer`
--

INSERT INTO `gestion_securisation_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation`, `id_evaluation`) VALUES
(1, '55326', '2025-02-04 19:53:47', NULL, NULL, '2025-02-04 19:53:47', '2025-02-09 09:35:45', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(2, '49312', '2025-02-05 00:03:03', '2025-02-05 00:33:05', '2025-02-06 21:18:14', '2025-02-09 09:35:18', '2025-02-09 09:36:10', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(3, '46957', '2025-02-09 10:30:06', NULL, NULL, '2025-02-09 10:30:06', '2025-02-09 11:03:46', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(4, '43958', '2025-02-09 23:53:30', NULL, NULL, '2025-02-09 23:53:30', '2025-02-10 00:05:14', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(5, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:20:45', '2025-02-11 11:29:53', '2025-02-11 11:30:11', '2025-02-11 11:30:20', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(6, 'zefze54', '2025-02-10 18:02:43', '2025-02-11 12:00:04', '2025-02-11 12:00:50', '2025-02-11 12:01:15', '2025-02-11 12:01:31', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(7, 'zefze54', '2025-02-10 18:02:43', '2025-02-11 12:00:04', '2025-02-11 12:00:50', '2025-02-11 12:01:15', '2025-02-11 12:58:04', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(8, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', '2025-02-12 16:45:43', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(9, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', '2025-02-12 16:51:22', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(10, '54010', '2025-02-05 00:03:03', '2025-02-10 16:18:25', '2025-02-11 11:51:32', '2025-02-12 16:43:13', '2025-02-12 17:15:36', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(11, '38511', '2025-02-10 00:08:35', '2025-02-10 00:30:32', '2025-02-11 11:52:01', '2025-02-14 13:51:40', '2025-02-14 14:04:18', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL),
(12, 'zefze54', '2025-02-10 18:02:43', '2025-02-11 12:00:04', '2025-02-11 12:00:50', '2025-02-11 12:01:15', '2025-02-14 14:05:37', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature`
--

CREATE TABLE `gestion_signature` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_assignation_n6` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé','Réjeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `n6_signature` varchar(225) DEFAULT NULL,
  `id_signature` varchar(225) DEFAULT NULL,
  `objet` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_signature`
--

INSERT INTO `gestion_signature` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `date_assignation_n6`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `n6_signature`, `id_signature`, `objet`) VALUES
(8, '43958', '2025-02-09 23:53:30', NULL, NULL, '2025-02-09 23:53:30', '2025-02-10 00:05:14', '2025-02-12 20:08:32', '2025-02-12 20:08:40', '2025-02-12 20:08:40', 'En attente', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', NULL, NULL, 'fin'),
(10, 'AB017', '2025-02-13 17:20:56', '2025-02-13 20:27:57', '2025-02-13 20:27:57', '2025-02-13 20:27:57', '2025-02-13 20:27:57', '2025-02-13 20:27:57', '2025-02-13 20:27:57', '2025-02-13 20:27:57', 'En attente', 'Awadi Abalo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'non'),
(13, '49312', '2025-02-05 00:03:03', '2025-02-05 00:33:05', '2025-02-06 21:18:14', '2025-02-09 09:35:18', '2025-02-11 11:53:22', '2025-02-14 09:38:53', '2025-02-14 13:22:46', '2025-02-14 13:22:46', 'En attente', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', 'KOUGNIGAN Reine Marimar Théréza', '2', NULL, NULL, 'bien'),
(14, '55326', '2025-02-04 19:53:47', '2025-02-14 09:25:50', '2025-02-14 09:25:50', '2025-02-04 19:53:47', '2025-02-09 09:35:45', '2025-02-09 09:54:17', '2025-02-14 13:42:02', '2025-02-14 13:42:02', 'En attente', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', NULL, NULL, 'fini et bon');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature_terminer`
--

CREATE TABLE `gestion_signature_terminer` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_temine_n3` datetime DEFAULT NULL,
  `date_assignation_n4` datetime DEFAULT NULL,
  `date_temine_n4` datetime DEFAULT NULL,
  `date_assignation_n5` datetime DEFAULT NULL,
  `date_temine_n5` datetime DEFAULT NULL,
  `date_temine_n6` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `n4_securisation` varchar(225) DEFAULT NULL,
  `id_securisation` varchar(225) DEFAULT NULL,
  `n5_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `id_evaluation_cadastrale` varchar(225) DEFAULT NULL,
  `n6_signature` varchar(225) DEFAULT NULL,
  `id_signature` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_signature_terminer`
--

INSERT INTO `gestion_signature_terminer` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_temine_n3`, `date_assignation_n4`, `date_temine_n4`, `date_assignation_n5`, `date_temine_n5`, `date_temine_n6`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `n4_securisation`, `id_securisation`, `n5_evaluation_cadastrale`, `id_evaluation_cadastrale`, `n6_signature`, `id_signature`) VALUES
(1, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:20:45', '2025-02-11 11:29:53', '2025-02-11 11:30:11', '2025-02-11 11:30:20', '2025-02-11 11:30:48', '2025-02-11 11:36:12', '2025-02-11 13:24:24', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', 'Nom du chef', '2'),
(2, 'zegve55', '2025-02-11 11:17:23', '2025-02-11 11:20:45', '2025-02-11 11:29:53', '2025-02-11 11:30:11', '2025-02-11 11:30:20', '2025-02-11 11:30:48', '2025-02-11 11:36:12', '2025-02-11 13:29:54', 'Terminé', 'Awadi Abalo', 'BAKEM	 Essimna', '1', 'BAKEM	 Essimna', '1', 'CLOUKPO	Amy Sitou Elsa', '1', 'KOUGNIGAN Reine Marimar Théréza', '2', 'Nom du chef', '2'),
(3, '46957', '2025-02-09 10:30:06', NULL, NULL, '2025-02-09 10:30:06', '2025-02-09 11:03:46', '2025-02-12 17:08:15', '2025-02-12 20:24:41', '2025-02-12 20:32:43', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, 'CLOUKPO	Amy Sitou Elsa', '1', 'Nom du chef', '2', 'Nom du chef', '2'),
(4, 'Ab016', '2025-02-13 17:20:56', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-14 08:27:55', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nom du chef', '2'),
(5, 'Ab016', '2025-02-13 17:20:56', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-13 20:48:51', '2025-02-14 08:52:37', 'Terminé', 'Awadi Abalo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nom du chef', '2');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_verification_chef_brigade`
--

CREATE TABLE `gestion_verification_chef_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_ajout` datetime DEFAULT current_timestamp(),
  `date_assignation_termin_n2` datetime DEFAULT NULL,
  `date_assignation_n3` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé','Rejeté') DEFAULT 'En attente',
  `n1_admin` varchar(255) NOT NULL,
  `n2_chef_brigade` varchar(255) DEFAULT NULL,
  `id_chef_brigade` varchar(225) DEFAULT NULL,
  `n3_brigade` varchar(225) DEFAULT NULL,
  `id_brigade` varchar(225) DEFAULT NULL,
  `objet` text DEFAULT NULL,
  `date_envoie` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `gestion_verification_chef_brigade`
--

INSERT INTO `gestion_verification_chef_brigade` (`id`, `nom_dossier`, `date_ajout`, `date_assignation_termin_n2`, `date_assignation_n3`, `statut`, `n1_admin`, `n2_chef_brigade`, `id_chef_brigade`, `n3_brigade`, `id_brigade`, `objet`, `date_envoie`) VALUES
(1, '52890', '2025-02-09 23:53:30', '2025-02-10 00:21:00', '2025-02-10 00:20:41', 'En cours', 'Awadi Abalo', '3', 'BAKEM	 Essimna', 'AGBODJAN Kossi Bruce', '1', 'fin dossier ', '2025-02-10 00:21:00');

-- --------------------------------------------------------

--
-- Structure de la table `objectifs_direction`
--

CREATE TABLE `objectifs_direction` (
  `id` int(11) NOT NULL,
  `chef_brigade` int(11) DEFAULT 0,
  `brigade` int(11) DEFAULT 0,
  `securisation` int(11) DEFAULT 0,
  `evaluation_cadastrale` int(11) DEFAULT 0,
  `signature` int(11) DEFAULT 0,
  `conversation_fonciere` int(11) DEFAULT 0,
  `date_mise_a_jour` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `objectifs_direction`
--

INSERT INTO `objectifs_direction` (`id`, `chef_brigade`, `brigade`, `securisation`, `evaluation_cadastrale`, `signature`, `conversation_fonciere`, `date_mise_a_jour`) VALUES
(1, 1200, 1200, 1200, 1200, 1200, 1200, '2025-01-04 20:36:16');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `securisation`
--

INSERT INTO `securisation` (`ident`, `nom_complet`, `email_securisation`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'CLOUKPO	Amy Sitou Elsa', 'acloukpo@otr.tg', '96244244', '2024-12-06 18:45:52', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL),
(2, 'TANAN Solim Prisca', 'stanan@otr.tg', '91616255', '2024-12-10 10:27:11', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `signature`
--

INSERT INTO `signature` (`ident`, `nom_complet`, `email_signature`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(2, 'Nom du chef', 'signature@gmail.com', '93464350', '2024-12-10 12:21:01', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
-- Index pour la table `dossier_terminer`
--
ALTER TABLE `dossier_terminer`
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
-- Index pour la table `gestion_verification_chef_brigade`
--
ALTER TABLE `gestion_verification_chef_brigade`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `objectifs_direction`
--
ALTER TABLE `objectifs_direction`
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
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `chef_brigade`
--
ALTER TABLE `chef_brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `conversation_fonciere`
--
ALTER TABLE `conversation_fonciere`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `dossier`
--
ALTER TABLE `dossier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pour la table `dossier_terminer`
--
ALTER TABLE `dossier_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `evaluation_cadastrale`
--
ALTER TABLE `evaluation_cadastrale`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `gestion_brigade_terminer`
--
ALTER TABLE `gestion_brigade_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade_terminer`
--
ALTER TABLE `gestion_chef_brigade_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `gestion_conversation_fonciere`
--
ALTER TABLE `gestion_conversation_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `gestion_conversation_fonciere_terminer`
--
ALTER TABLE `gestion_conversation_fonciere_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale_terminer`
--
ALTER TABLE `gestion_evaluation_cadastrale_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_securisation`
--
ALTER TABLE `gestion_securisation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pour la table `gestion_securisation_terminer`
--
ALTER TABLE `gestion_securisation_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `gestion_signature_terminer`
--
ALTER TABLE `gestion_signature_terminer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `gestion_verification_chef_brigade`
--
ALTER TABLE `gestion_verification_chef_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `objectifs_direction`
--
ALTER TABLE `objectifs_direction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
