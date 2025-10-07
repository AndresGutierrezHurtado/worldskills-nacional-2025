-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-09-2025 a las 04:57:17
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `concert_tickets`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_comprar_boletos` (IN `p_evento_id` INT, IN `p_seccion_id` INT, IN `p_cantidad` INT, IN `p_nombre_cliente` VARCHAR(255), IN `p_email_cliente` VARCHAR(255))   BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_disponibles INT;
    DECLARE v_codigo_confirmacion VARCHAR(100);
    
    -- Obtener precio y disponibles
    SELECT precio, disponibles INTO v_precio, v_disponibles
    FROM secciones 
    WHERE id = p_seccion_id AND evento_id = p_evento_id;
    
    -- Verificar disponibilidad
    IF v_disponibles IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sección no encontrada para este evento';
    ELSEIF v_disponibles < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficientes boletos disponibles';
    END IF;
    
    -- Calcular total
    SET v_total = v_precio * p_cantidad;
    
    -- Generar código de confirmación
    SET v_codigo_confirmacion = CONCAT('TICKET-', UPPER(SUBSTRING(MD5(RAND()), 1, 8)));
    
    -- Insertar compra
    INSERT INTO compras (evento_id, seccion_id, cantidad, nombre_cliente, email_cliente, total, codigo_confirmacion)
    VALUES (p_evento_id, p_seccion_id, p_cantidad, p_nombre_cliente, p_email_cliente, v_total, v_codigo_confirmacion);
    
    -- Actualizar disponibles
    UPDATE secciones 
    SET disponibles = disponibles - p_cantidad 
    WHERE id = p_seccion_id;
    
    -- Devolver información de la compra
    SELECT 
        v_codigo_confirmacion AS codigo_confirmacion,
        v_total AS total,
        p_cantidad AS cantidad,
        (SELECT nombre FROM eventos WHERE id = p_evento_id) AS evento,
        (SELECT nombre FROM secciones WHERE id = p_seccion_id) AS seccion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_compras_cliente` (IN `p_email` VARCHAR(255))   BEGIN
    SELECT 
        c.codigo_confirmacion,
        c.cantidad,
        c.total,
        c.created_at AS fecha_compra,
        e.nombre AS evento,
        e.fecha AS evento_fecha,
        e.lugar AS evento_lugar,
        s.nombre AS seccion,
        s.precio AS precio_unitario
    FROM compras c
    JOIN eventos e ON c.evento_id = e.id
    JOIN secciones s ON c.seccion_id = s.id
    WHERE c.email_cliente = p_email
    ORDER BY c.created_at DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `venue` varchar(255) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `genre` enum('rock','pop','electronic','jazz','reggaeton','hiphop') NOT NULL,
  `min_price` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `events`
--

INSERT INTO `events` (`id`, `name`, `date`, `venue`, `image_url`, `description`, `genre`, `min_price`, `created_at`, `updated_at`) VALUES
(1, 'Festival de Rock', '2023-12-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'El mejor festival de rock del año con las bandas más importantes del género', 'rock', 50.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(2, 'Super Pop Live', '2023-12-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'Festival con los artistas pop más importantes del momento', 'pop', 60.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(3, 'Electronic Music Festival', '2023-12-25 22:00:00', 'Plaza Central', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'La mejor música electrónica en vivo con DJs internacionales', 'electronic', 70.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(4, 'Noche de Rock & Metal', '2024-01-05 21:00:00', 'Teatro Municipal', 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'Noche de rock y metal con bandas locales e internacionales', 'rock', 40.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(5, 'Concierto de Pop Stars', '2024-01-12 19:30:00', 'Auditorio Nacional', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'Los artistas pop más famosos en un concierto exclusivo', 'pop', 80.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(6, 'Festival de Jazz', '2024-01-20 17:00:00', 'Jardín Botánico', 'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'Disfruta del mejor jazz en un entorno natural único', 'jazz', 60.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(7, 'Fiesta Reggaeton Beach', '2024-02-02 16:00:00', 'Playa Sol', 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'La mejor fiesta de reggaeton frente al mar', 'reggaeton', 70.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(8, 'Hip Hop Revolution', '2024-02-15 20:00:00', 'Club Urbano', 'https://images.unsplash.com/photo-1494232410401-ad00d5433cfa?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 'Los máximos exponentes del hip hop en un evento único', 'hiphop', 55.00, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(9, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:35:51', '2025-09-26 05:35:51'),
(10, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:35:51', '2025-09-26 05:35:51'),
(11, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:38:12', '2025-09-26 05:38:12'),
(12, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:38:12', '2025-09-26 05:38:12'),
(13, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(14, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(15, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(16, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(17, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(18, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(19, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(20, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(21, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(22, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(23, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(24, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(25, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(26, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(27, 'Festival de Rock Internacional', '2024-03-15 20:00:00', 'Estadio Nacional', 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89', 'El mejor festival de rock con bandas internacionales y nacionales', 'rock', 50.00, '2025-09-26 05:50:57', '2025-09-26 05:50:57'),
(28, 'Super Pop Live 2024', '2024-04-20 18:00:00', 'Arena Ciudad', 'https://images.unsplash.com/photo-1506157786151-b8491531f063', 'Los artistas pop más importantes del momento en un solo evento', 'pop', 60.00, '2025-09-26 05:50:57', '2025-09-26 05:50:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `confirmation_code` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `purchases`
--

INSERT INTO `purchases` (`id`, `event_id`, `section_id`, `quantity`, `customer_name`, `customer_email`, `total`, `confirmation_code`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 2, 'María González', 'maria.gonzalez@email.com', 240.00, 'TICKET-ROCK123', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(2, 1, 2, 4, 'Carlos López', 'carlos.lopez@email.com', 320.00, 'TICKET-ROCK456', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(3, 2, 1, 3, 'Ana Martínez', 'ana.martinez@email.com', 180.00, 'TICKET-POP789', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(4, 2, 5, 2, 'Juan Pérez', 'juan.perez@email.com', 180.00, 'TICKET-POP012', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(5, 3, 9, 1, 'Laura Rodríguez', 'laura.rodriguez@email.com', 180.00, 'TICKET-ELECTRO345', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(6, 3, 8, 2, 'Miguel Sánchez', 'miguel.sanchez@email.com', 200.00, 'TICKET-ELECTRO678', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(7, 4, 10, 3, 'Elena Castro', 'elena.castro@email.com', 120.00, 'TICKET-ROCK2901', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(8, 4, 12, 1, 'David Torres', 'david.torres@email.com', 110.00, 'TICKET-ROCK2234', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(9, 5, 13, 2, 'Sofía Ruiz', 'sofia.ruiz@email.com', 160.00, 'TICKET-POP2567', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(10, 5, 15, 1, 'Javier Moreno', 'javier.moreno@email.com', 200.00, 'TICKET-POP2890', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(11, 6, 16, 4, 'Carmen Vargas', 'carmen.vargas@email.com', 240.00, 'TICKET-JAZZ1234', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(12, 6, 18, 2, 'Francisco Reyes', 'francisco.reyes@email.com', 300.00, 'TICKET-JAZZ1567', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(13, 7, 19, 3, 'Isabel Ortega', 'isabel.ortega@email.com', 210.00, 'TICKET-REGGAETON1890', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(14, 7, 21, 1, 'Roberto Medina', 'roberto.medina@email.com', 170.00, 'TICKET-REGGAETON1123', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(15, 8, 22, 2, 'Patricia Silva', 'patricia.silva@email.com', 110.00, 'TICKET-HIPHOP1456', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(16, 8, 24, 1, 'Daniel Herrera', 'daniel.herrera@email.com', 140.00, 'TICKET-HIPHOP1789', '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(19, 1, 3, 2, 'María González', 'maria.gonzalez@email.com', 240.00, 'TICKET-ROCK125', '2025-09-26 05:45:26', '2025-09-26 05:45:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `capacity` int(11) NOT NULL,
  `available` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sections`
--

INSERT INTO `sections` (`id`, `event_id`, `name`, `price`, `capacity`, `available`, `created_at`, `updated_at`) VALUES
(1, 1, 'General', 50.00, 1000, 245, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(2, 1, 'Preferencial', 80.00, 500, 150, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(3, 1, 'VIP', 120.00, 200, 45, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(4, 2, 'General', 60.00, 1200, 400, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(5, 2, 'Preferencial', 90.00, 600, 200, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(6, 2, 'VIP', 150.00, 300, 75, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(7, 3, 'General', 70.00, 1500, 600, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(8, 3, 'Preferencial', 100.00, 700, 250, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(9, 3, 'VIP', 180.00, 400, 100, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(10, 4, 'General', 40.00, 800, 300, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(11, 4, 'Preferencial', 70.00, 400, 120, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(12, 4, 'VIP', 110.00, 150, 30, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(13, 5, 'General', 80.00, 2000, 800, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(14, 5, 'Preferencial', 120.00, 800, 300, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(15, 5, 'VIP', 200.00, 400, 100, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(16, 6, 'General', 60.00, 500, 200, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(17, 6, 'Preferencial', 90.00, 300, 100, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(18, 6, 'VIP', 150.00, 100, 25, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(19, 7, 'General', 70.00, 3000, 1500, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(20, 7, 'Preferencial', 100.00, 1000, 400, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(21, 7, 'VIP', 170.00, 500, 120, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(22, 8, 'General', 55.00, 1000, 400, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(23, 8, 'Preferencial', 85.00, 500, 150, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(24, 8, 'VIP', 140.00, 200, 50, '2025-09-25 23:50:42', '2025-09-25 23:50:42'),
(25, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(26, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(27, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(28, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(29, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(30, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(31, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(32, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(33, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:39:59', '2025-09-26 05:39:59'),
(34, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(35, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(36, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(37, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(38, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(39, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(40, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(41, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(42, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:40:37', '2025-09-26 05:40:37'),
(43, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(44, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(45, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(46, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(47, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(48, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(49, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(50, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(51, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:43:22', '2025-09-26 05:43:22'),
(52, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(53, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(54, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(55, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(56, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(57, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(58, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(59, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(60, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:44:29', '2025-09-26 05:44:29'),
(61, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(62, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(63, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(64, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(65, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(66, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(67, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(68, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(69, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:45:26', '2025-09-26 05:45:26'),
(70, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(71, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(72, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(73, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(74, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(75, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(76, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(77, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(78, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:45:45', '2025-09-26 05:45:45'),
(79, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(80, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(81, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(82, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(83, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(84, 2, 'vip', 150.00, 300, 75, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(85, 3, 'general', 70.00, 1500, 600, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(86, 3, 'preferencial', 100.00, 700, 250, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(87, 1, 'vip', 180.00, 400, 100, '2025-09-26 05:46:03', '2025-09-26 05:46:03'),
(88, 1, 'general', 50.00, 1000, 245, '2025-09-26 05:50:57', '2025-09-26 05:50:57'),
(89, 1, 'preferencial', 80.00, 500, 150, '2025-09-26 05:50:57', '2025-09-26 05:50:57'),
(90, 1, 'vip', 120.00, 200, 75, '2025-09-26 05:50:57', '2025-09-26 05:50:57'),
(91, 2, 'general', 60.00, 1200, 400, '2025-09-26 05:50:57', '2025-09-26 05:50:57'),
(92, 2, 'preferencial', 90.00, 600, 200, '2025-09-26 05:50:57', '2025-09-26 05:50:57');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_eventos_genero` (`genre`),
  ADD KEY `idx_eventos_fecha` (`date`);

--
-- Indices de la tabla `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_confirmacion` (`confirmation_code`),
  ADD KEY `evento_id` (`event_id`),
  ADD KEY `seccion_id` (`section_id`),
  ADD KEY `idx_compras_email` (`customer_email`),
  ADD KEY `idx_compras_codigo` (`confirmation_code`);

--
-- Indices de la tabla `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_secciones_evento_id` (`event_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
