-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 05 déc. 2024 à 22:04
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
-- Structure de la table `brigade`
--

CREATE TABLE `brigade` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_brigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `brigade`
--

INSERT INTO `brigade` (`ident`, `name`, `prenom`, `email_brigade`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'c Gomina clavaire', 'cc', 'clavaire.gominab@gmail.com', '92891445', '2024-12-04 10:59:12', '5669fb4cc8a47469cc15eb3e24dc8f23'),
(2, 'c Gomina clavaire', 'cc', 'clavaire.gominabb@gmail.com', '9289144', '2024-12-04 22:11:35', '5669fb4cc8a47469cc15eb3e24dc8f23');

-- --------------------------------------------------------

--
-- Structure de la table `chef_brigade`
--

CREATE TABLE `chef_brigade` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_chefbrigade` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `chef_brigade`
--

INSERT INTO `chef_brigade` (`ident`, `name`, `prenom`, `email_chefbrigade`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'c Gomina clavaire', 'cc', 'clavaire.gomina@gmail.com', '92891445', '2024-12-04 02:10:31', '5669fb4cc8a47469cc15eb3e24dc8f23'),
(3, 'c Gomina clavaire', 'cc', 'clavaire.gominaqq@gmail.com', '9289144', '2024-12-04 19:48:31', '5669fb4cc8a47469cc15eb3e24dc8f23');

-- --------------------------------------------------------

--
-- Structure de la table `conversation_fonciere`
--

CREATE TABLE `conversation_fonciere` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_conversationfonciere` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `conversation_fonciere`
--

INSERT INTO `conversation_fonciere` (`ident`, `name`, `prenom`, `email_conversationfonciere`, `numero_telephone`, `date_inscription`, `password`) VALUES
(2, 'c Gomina clavaire', 'cc', 'clavaire.gominacf@gmail.com', '9289144', '2024-12-05 18:02:29', '5669fb4cc8a47469cc15eb3e24dc8f23');

-- --------------------------------------------------------

--
-- Structure de la table `dossier`
--

CREATE TABLE `dossier` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `statut` enum('attente','validé','rejeté','terminé','en_cours') DEFAULT 'attente',
  `raison_rejet` text DEFAULT NULL,
  `raison_validation` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `evaluation_cadastrale`
--

CREATE TABLE `evaluation_cadastrale` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_evaluationcadastrale` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `evaluation_cadastrale`
--

INSERT INTO `evaluation_cadastrale` (`ident`, `name`, `prenom`, `email_evaluationcadastrale`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'c Gomina clavaire', 'cc', 'clavaire.gominaee@gmail.com', '9289144', '2024-12-05 12:17:11', '5669fb4cc8a47469cc15eb3e24dc8f23');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_brigade`
--

CREATE TABLE `gestion_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `raison` text DEFAULT NULL,
  `chef_brigade_id` int(11) DEFAULT NULL,
  `brigade_id` int(11) DEFAULT NULL,
  `validateur` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_brigade`
--

INSERT INTO `gestion_brigade` (`id`, `nom_dossier`, `date_creation`, `statut`, `raison`, `chef_brigade_id`, `brigade_id`, `validateur`) VALUES
(1, 'zz', '2024-12-04 20:03:18', 'En cours', NULL, 1, NULL, 'c Gomina clavaire cc'),
(2, 'azxz', '2024-12-04 20:28:58', 'En cours', NULL, 1, NULL, 'c Gomina clavaire cc'),
(3, 'azxz', '2024-12-04 20:36:50', 'Terminé', NULL, 1, 2, 'c Gomina clavaire cc'),
(4, 'lk', '2024-12-05 00:32:38', 'Terminé', NULL, 1, 2, 'c Gomina clavaire cc'),
(5, 'hoooo', '2024-12-05 09:16:48', 'Terminé', NULL, 1, 1, 'c Gomina clavaire cc'),
(6, 'zrzf', '2024-12-05 09:48:24', 'Terminé', NULL, 1, 2, 'c Gomina clavaire cc'),
(7, 'zzfzef', '2024-12-05 09:50:17', 'Terminé', NULL, 1, 2, 'c Gomina clavaire cc'),
(8, 'ssaa', '2024-12-05 10:38:52', 'Terminé', NULL, 3, 2, 'c Gomina clavaire cc');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_chef_brigade`
--

CREATE TABLE `gestion_chef_brigade` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_envoi` datetime DEFAULT NULL,
  `statut` enum('En attente','En cours','Terminé') DEFAULT 'En attente',
  `raison` text DEFAULT NULL,
  `chef_brigade_id` int(11) DEFAULT NULL,
  `chef_assigned` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_chef_brigade`
--

INSERT INTO `gestion_chef_brigade` (`id`, `nom_dossier`, `date_creation`, `date_envoi`, `statut`, `raison`, `chef_brigade_id`, `chef_assigned`) VALUES
(7, 'zrzf', '2024-12-05 09:38:55', '2024-12-05 09:48:24', 'Terminé', NULL, 1, NULL),
(8, 'zzfzef', '2024-12-05 09:49:35', '2024-12-05 09:50:17', 'Terminé', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_evaluation_cadastrale`
--

CREATE TABLE `gestion_evaluation_cadastrale` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_validation` datetime DEFAULT current_timestamp(),
  `nom_evaluation_cadastrale` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `evaluation_cadastrale_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_evaluation_cadastrale`
--

INSERT INTO `gestion_evaluation_cadastrale` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_evaluation_cadastrale`, `statut`, `evaluation_cadastrale_id`) VALUES
(1, '4', '0000-00-00 00:00:00', '2024-12-05 11:18:12', 'c Gomina clavaire cc', 'Terminé', 1),
(2, '5', '0000-00-00 00:00:00', '2024-12-05 11:37:35', 'c Gomina clavaire cc', 'Terminé', 1),
(3, 'ssaa', '2024-12-05 10:38:52', '2024-12-05 11:46:27', 'c Gomina clavaire cc', 'Terminé', 1),
(4, '4', NULL, '2024-12-05 13:45:07', 'c Gomina clavaire cc', 'En attente', NULL),
(5, '4', NULL, '2024-12-05 13:45:37', 'c Gomina clavaire cc', 'En attente', NULL);

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
(1, 'ssaa', '2024-12-05 10:38:52', '2024-12-05 17:32:22', 'c Gomina clavaire cc', 'Terminé', 2, NULL),
(2, '5', NULL, '2024-12-05 17:53:08', 'c Gomina clavaire cc', 'Terminé', 2, 'c Gomina clavaire cc');

-- --------------------------------------------------------

--
-- Structure de la table `gestion_securisation`
--

CREATE TABLE `gestion_securisation` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_validation` datetime DEFAULT current_timestamp(),
  `nom_brigade` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `securisation_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_securisation`
--

INSERT INTO `gestion_securisation` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_brigade`, `statut`, `securisation_id`) VALUES
(1, 'azxz', '2024-12-04 20:36:50', '2024-12-05 00:23:29', 'c Gomina clavaire cc', '', NULL),
(2, 'lk', '2024-12-05 00:32:38', '2024-12-05 00:35:13', 'c Gomina clavaire cc', 'Terminé', 1),
(4, 'zrzf', '2024-12-05 09:48:24', '2024-12-05 10:45:58', 'c Gomina clavaire cc', 'Terminé', 1),
(5, 'zzfzef', '2024-12-05 09:50:17', '2024-12-05 10:45:59', 'c Gomina clavaire cc', 'Terminé', 1),
(6, 'ssaa', '2024-12-05 10:38:52', '2024-12-05 10:45:59', 'c Gomina clavaire cc', 'Terminé', 1);

-- --------------------------------------------------------

--
-- Structure de la table `gestion_signature`
--

CREATE TABLE `gestion_signature` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_validation` datetime DEFAULT current_timestamp(),
  `nom_evaluation_cadastrale` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `signature_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_signature`
--

INSERT INTO `gestion_signature` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_evaluation_cadastrale`, `statut`, `signature_id`) VALUES
(1, 'ssaa', '2024-12-05 10:38:52', '2024-12-05 13:47:55', 'c Gomina clavaire cc', 'Terminé', 1),
(2, '5', NULL, '2024-12-05 13:51:02', 'c Gomina clavaire cc', 'Terminé', 1);

-- --------------------------------------------------------

--
-- Structure de la table `securisation`
--

CREATE TABLE `securisation` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_securisation` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `securisation`
--

INSERT INTO `securisation` (`ident`, `name`, `prenom`, `email_securisation`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'c Gomina clavaire', 'cc', 'clavaire.gominass@gmail.com', '9289144', '2024-12-05 01:07:38', '5669fb4cc8a47469cc15eb3e24dc8f23'),
(2, 'aed', 'e', 'sec@gmail.com', '24', '2024-12-05 02:07:28', '5669fb4cc8a47469cc15eb3e24dc8f23');

-- --------------------------------------------------------

--
-- Structure de la table `signature`
--

CREATE TABLE `signature` (
  `ident` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_signature` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `signature`
--

INSERT INTO `signature` (`ident`, `name`, `prenom`, `email_signature`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'c Gomina clavaire', 'cc', 'clavaire.gominas@gmail.com', '9289144', '2024-12-05 14:31:21', '5669fb4cc8a47469cc15eb3e24dc8f23');

--
-- Index pour les tables déchargées
--

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
  ADD UNIQUE KEY `email_conversationfonciere` (`email_conversationfonciere`),
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
  ADD UNIQUE KEY `email_evaluationcadastrale` (`email_evaluationcadastrale`),
  ADD UNIQUE KEY `numero_telephone` (`numero_telephone`);

--
-- Index pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chef_brigade_id` (`chef_brigade_id`);

--
-- Index pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_chef_brigade_id` (`chef_brigade_id`);

--
-- Index pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
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
-- Index pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
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
-- AUTO_INCREMENT pour la table `brigade`
--
ALTER TABLE `brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `evaluation_cadastrale`
--
ALTER TABLE `evaluation_cadastrale`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `gestion_securisation`
--
ALTER TABLE `gestion_securisation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
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
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  ADD CONSTRAINT `gestion_brigade_ibfk_1` FOREIGN KEY (`chef_brigade_id`) REFERENCES `chef_brigade` (`ident`) ON DELETE SET NULL;

--
-- Contraintes pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  ADD CONSTRAINT `fk_chef_brigade_id` FOREIGN KEY (`chef_brigade_id`) REFERENCES `chef_brigade` (`ident`) ON DELETE SET NULL,
  ADD CONSTRAINT `gestion_chef_brigade_ibfk_1` FOREIGN KEY (`chef_brigade_id`) REFERENCES `chef_brigade` (`ident`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
