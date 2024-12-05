-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 05 déc. 2024 à 19:48
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
-- Structure de la table `gestion_fonciere`
--

CREATE TABLE `gestion_fonciere` (
  `id` int(11) NOT NULL,
  `nom_dossier` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_validation` datetime DEFAULT current_timestamp(),
  `nom_signature` varchar(255) NOT NULL,
  `statut` enum('En cours','Terminé','En attente') DEFAULT 'En cours',
  `fonciere_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `gestion_fonciere`
--

INSERT INTO `gestion_fonciere` (`id`, `nom_dossier`, `date_creation`, `date_validation`, `nom_signature`, `statut`, `fonciere_id`) VALUES
(1, 'ssaa', '2024-12-05 10:38:52', '2024-12-05 17:32:22', 'c Gomina clavaire cc', 'Terminé', 2),
(2, '5', NULL, '2024-12-05 17:53:08', 'c Gomina clavaire cc', 'En attente', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `gestion_fonciere`
--
ALTER TABLE `gestion_fonciere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
