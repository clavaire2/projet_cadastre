-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 06 déc. 2024 à 20:00
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
  `name` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email_admin` varchar(255) NOT NULL,
  `numero_telephone` varchar(15) DEFAULT NULL,
  `date_inscription` timestamp NOT NULL DEFAULT current_timestamp(),
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`ident`, `name`, `prenom`, `email_admin`, `numero_telephone`, `date_inscription`, `password`) VALUES
(1, 'Abalo cb', 'cf', 'abalo@gmail.com', '66565', '2024-12-06 18:55:54', 'ea66e9c169c7e5a307eb06fb8e6a239d');

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `brigade`
--

INSERT INTO `brigade` (`ident`, `name`, `prenom`, `email_brigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo ', 'b', 'abalo_b@gmail.com', '66565', '2024-12-06 18:28:10', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `chef_brigade`
--

INSERT INTO `chef_brigade` (`ident`, `name`, `prenom`, `email_chefbrigade`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(4, 'Abalo cb', 'cb', 'abalo_cb@gmail.com', '66565', '2024-12-06 18:19:59', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `conversation_fonciere`
--

INSERT INTO `conversation_fonciere` (`ident`, `name`, `prenom`, `email_conversationfonciere`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cb', 'cf', 'abalo_cf@gmail.com', '66565', '2024-12-06 18:48:30', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `evaluation_cadastrale`
--

INSERT INTO `evaluation_cadastrale` (`ident`, `name`, `prenom`, `email_evaluationcadastrale`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo ', 'cb', 'abalo_ec@gmail.com', '66565', '2024-12-06 18:46:59', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `securisation`
--

INSERT INTO `securisation` (`ident`, `name`, `prenom`, `email_securisation`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo ', 'cb', 'abalo_s@gmail.com', '66565', '2024-12-06 18:45:52', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
  `password` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `signature`
--

INSERT INTO `signature` (`ident`, `name`, `prenom`, `email_signature`, `numero_telephone`, `date_inscription`, `password`, `reset_token`, `token_expiration`) VALUES
(1, 'Abalo cb', 's', 'abalo_s@gmail.com', '66565', '2024-12-06 18:47:41', 'ea66e9c169c7e5a307eb06fb8e6a239d', NULL, NULL);

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
-- AUTO_INCREMENT pour la table `admin`
--
ALTER TABLE `admin`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `brigade`
--
ALTER TABLE `brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `chef_brigade`
--
ALTER TABLE `chef_brigade`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `conversation_fonciere`
--
ALTER TABLE `conversation_fonciere`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `dossier`
--
ALTER TABLE `dossier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `evaluation_cadastrale`
--
ALTER TABLE `evaluation_cadastrale`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gestion_brigade`
--
ALTER TABLE `gestion_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_chef_brigade`
--
ALTER TABLE `gestion_chef_brigade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_evaluation_cadastrale`
--
ALTER TABLE `gestion_evaluation_cadastrale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_securisation`
--
ALTER TABLE `gestion_securisation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gestion_signature`
--
ALTER TABLE `gestion_signature`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `securisation`
--
ALTER TABLE `securisation`
  MODIFY `ident` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
