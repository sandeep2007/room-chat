-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 23, 2020 at 08:01 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `room_chat`
--

-- --------------------------------------------------------

--
-- Table structure for table `co_chat`
--

CREATE TABLE `co_chat` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `channel_id` varchar(50) NOT NULL,
  `message` varbinary(2000) NOT NULL,
  `is_seen` int(11) NOT NULL,
  `date_created` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `co_last_seen`
--

CREATE TABLE `co_last_seen` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(10) NOT NULL,
  `date_created` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `co_last_seen`
--

INSERT INTO `co_last_seen` (`id`, `user_id`, `action`, `date_created`) VALUES
(1, 1, 'LOGIN', '2020-12-17 12:29:17'),
(2, 1, 'LOGOUT', '2020-12-17 12:29:30'),
(3, 1, 'LOGIN', '2020-12-17 12:29:31'),
(4, 1, 'LOGOUT', '2020-12-17 13:25:09'),
(5, 1, 'LOGIN', '2020-12-17 13:28:18'),
(6, 1, 'LOGOUT', '2020-12-17 14:18:16'),
(7, 1, 'LOGIN', '2020-12-17 14:19:41'),
(8, 1, 'LOGOUT', '2020-12-17 14:48:42');

-- --------------------------------------------------------

--
-- Table structure for table `co_socket_users`
--

CREATE TABLE `co_socket_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `token` varchar(100) NOT NULL,
  `socket_id` varchar(100) NOT NULL,
  `date_created` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `image` varchar(500) NOT NULL,
  `date_created` varchar(50) NOT NULL,
  `auth_key` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `name`, `image`, `date_created`, `auth_key`) VALUES
(1, 'user1@mail.com', '123', 'User 1', 'profile.jpg', '2020-11-27 12:00:00', '589623'),
(2, 'user2@mail.com', '123', 'User 2', 'profile.jpg', '2020-11-27 12:00:00', '369852'),
(3, 'user3@mail.com', '123', 'User 3', 'profile.jpg', '2020-11-27 12:00:00', '123456'),
(4, 'user4@mail.com', '123', 'User 4', 'profile.jpg', '2020-11-27 12:00:00', '654321');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `co_chat`
--
ALTER TABLE `co_chat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `co_last_seen`
--
ALTER TABLE `co_last_seen`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `co_socket_users`
--
ALTER TABLE `co_socket_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`,`socket_id`),
  ADD KEY `socket_id` (`socket_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`auth_key`),
  ADD KEY `email` (`email`),
  ADD KEY `password` (`password`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `co_chat`
--
ALTER TABLE `co_chat`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `co_last_seen`
--
ALTER TABLE `co_last_seen`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `co_socket_users`
--
ALTER TABLE `co_socket_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
