-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-09-2026 a las 06:11:18
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
-- Base de datos: `todoaqui`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `CategoriaID` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` varchar(255) DEFAULT NULL,
  `Estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `CategoriaPadreID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalledevoluciones`
--

CREATE TABLE `detalledevoluciones` (
  `DetalleDevolucionID` int(11) NOT NULL,
  `DevolucionID` int(11) NOT NULL,
  `DetalleOrdenID` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL CHECK (`Cantidad` > 0),
  `Motivo` varchar(255) DEFAULT NULL,
  `MontoReembolso` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallefacturas`
--

CREATE TABLE `detallefacturas` (
  `DetalleFacturaID` int(11) NOT NULL,
  `FacturaID` int(11) NOT NULL,
  `DetalleOrdenID` int(11) NOT NULL,
  `Descripcion` varchar(255) NOT NULL,
  `Cantidad` int(11) NOT NULL CHECK (`Cantidad` > 0),
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Impuesto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleordenes`
--

CREATE TABLE `detalleordenes` (
  `DetalleOrdenID` int(11) NOT NULL,
  `OrdenID` int(11) NOT NULL,
  `ProductoID` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL CHECK (`Cantidad` > 0),
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `DevolucionID` int(11) NOT NULL,
  `OrdenID` int(11) NOT NULL,
  `FechaSolicitud` datetime NOT NULL DEFAULT current_timestamp(),
  `Motivo` varchar(255) NOT NULL,
  `Estado` enum('Solicitada','Aprobada','Rechazada','Procesada') NOT NULL DEFAULT 'Solicitada',
  `MontoReembolso` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Notas` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

CREATE TABLE `direcciones` (
  `DireccionID` int(11) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `Ciudad` varchar(75) NOT NULL,
  `Subnacional` varchar(100) NOT NULL,
  `Pais` varchar(50) NOT NULL DEFAULT 'Guatemala',
  `UsuarioID` int(11) NOT NULL,
  `CodigoPostal` varchar(15) DEFAULT NULL,
  `TipoDireccion` enum('Casa','Trabajo','Otro') NOT NULL DEFAULT 'Casa',
  `EsPrincipal` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `direcciones`
--

INSERT INTO `direcciones` (`DireccionID`, `Direccion`, `Ciudad`, `Subnacional`, `Pais`, `UsuarioID`, `CodigoPostal`, `TipoDireccion`, `EsPrincipal`) VALUES
(1, 'Avenida Las Flores 11-03, Zona 2', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 1, '01001', 'Casa', 1),
(2, 'Calle del Comercio 12-06, Zona 3', 'Mixco', 'Guatemala', 'Guatemala', 2, '01057', 'Trabajo', 1),
(3, 'Avenida Reforma 13-09, Zona 4', 'Villa Nueva', 'Guatemala', 'Guatemala', 3, '01064', 'Otro', 1),
(4, 'Calle Principal 14-12, Zona 5', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 4, '01066', 'Casa', 1),
(5, 'Avenida Los Próceres 15-15, Zona 6', 'Amatitlán', 'Guatemala', 'Guatemala', 5, '01063', 'Trabajo', 1),
(6, 'Calle de la Paz 16-18, Zona 7', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 6, '03001', 'Otro', 1),
(7, 'Avenida del Bosque 17-21, Zona 8', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 7, '04001', 'Casa', 1),
(8, 'Calle Central 18-24, Zona 9', 'Escuintla', 'Escuintla', 'Guatemala', 8, '05001', 'Trabajo', 1),
(9, 'Avenida La Esperanza 19-27, Zona 10', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 9, '09001', 'Otro', 1),
(10, 'Calle Los Pinos 20-30, Zona 11', 'Totonicapán', 'Totonicapán', 'Guatemala', 10, '08001', 'Casa', 1),
(11, 'Avenida del Mercado 21-33, Zona 12', 'Sololá', 'Sololá', 'Guatemala', 11, '07001', 'Trabajo', 1),
(12, 'Calle Las Rosas 22-36, Zona 13', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 12, '13001', 'Otro', 1),
(13, 'Avenida del Lago 23-39, Zona 14', 'Cobán', 'Alta Verapaz', 'Guatemala', 13, '16001', 'Casa', 1),
(14, 'Calle San José 24-42, Zona 15', 'Salamá', 'Baja Verapaz', 'Guatemala', 14, '15001', 'Trabajo', 1),
(15, 'Avenida Los Alamos 25-45, Zona 16', 'Puerto Barrios', 'Izabal', 'Guatemala', 15, '18001', 'Otro', 1),
(16, 'Avenida Las Flores 26-48, Zona 17', 'Zacapa', 'Zacapa', 'Guatemala', 16, '19001', 'Casa', 1),
(17, 'Calle del Comercio 27-51, Zona 18', 'Chiquimula', 'Chiquimula', 'Guatemala', 17, '20001', 'Trabajo', 1),
(18, 'Avenida Reforma 28-54, Zona 1', 'Jalapa', 'Jalapa', 'Guatemala', 18, '21001', 'Otro', 1),
(19, 'Calle Principal 29-57, Zona 2', 'Jutiapa', 'Jutiapa', 'Guatemala', 19, '22001', 'Casa', 1),
(20, 'Avenida Los Próceres 30-60, Zona 3', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 20, '11001', 'Trabajo', 1),
(21, 'Calle de la Paz 31-63, Zona 4', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 21, '01001', 'Otro', 1),
(22, 'Avenida del Bosque 32-66, Zona 5', 'Mixco', 'Guatemala', 'Guatemala', 22, '01057', 'Casa', 1),
(23, 'Calle Central 33-69, Zona 6', 'Villa Nueva', 'Guatemala', 'Guatemala', 23, '01064', 'Trabajo', 1),
(24, 'Avenida La Esperanza 34-72, Zona 7', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 24, '01066', 'Otro', 1),
(25, 'Calle Los Pinos 35-75, Zona 8', 'Amatitlán', 'Guatemala', 'Guatemala', 25, '01063', 'Casa', 1),
(26, 'Avenida del Mercado 36-78, Zona 9', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 26, '03001', 'Trabajo', 1),
(27, 'Calle Las Rosas 37-81, Zona 10', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 27, '04001', 'Otro', 1),
(28, 'Avenida del Lago 38-84, Zona 11', 'Escuintla', 'Escuintla', 'Guatemala', 28, '05001', 'Casa', 1),
(29, 'Calle San José 39-87, Zona 12', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 29, '09001', 'Trabajo', 1),
(30, 'Avenida Los Alamos 40-00, Zona 13', 'Totonicapán', 'Totonicapán', 'Guatemala', 30, '08001', 'Otro', 1),
(31, 'Avenida Las Flores 41-03, Zona 14', 'Sololá', 'Sololá', 'Guatemala', 31, '07001', 'Casa', 1),
(32, 'Calle del Comercio 42-06, Zona 15', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 32, '13001', 'Trabajo', 1),
(33, 'Avenida Reforma 43-09, Zona 16', 'Cobán', 'Alta Verapaz', 'Guatemala', 33, '16001', 'Otro', 1),
(34, 'Calle Principal 44-12, Zona 17', 'Salamá', 'Baja Verapaz', 'Guatemala', 34, '15001', 'Casa', 1),
(35, 'Avenida Los Próceres 45-15, Zona 18', 'Puerto Barrios', 'Izabal', 'Guatemala', 35, '18001', 'Trabajo', 1),
(36, 'Calle de la Paz 46-18, Zona 1', 'Zacapa', 'Zacapa', 'Guatemala', 36, '19001', 'Otro', 1),
(37, 'Avenida del Bosque 47-21, Zona 2', 'Chiquimula', 'Chiquimula', 'Guatemala', 37, '20001', 'Casa', 1),
(38, 'Calle Central 48-24, Zona 3', 'Jalapa', 'Jalapa', 'Guatemala', 38, '21001', 'Trabajo', 1),
(39, 'Avenida La Esperanza 49-27, Zona 4', 'Jutiapa', 'Jutiapa', 'Guatemala', 39, '22001', 'Otro', 1),
(40, 'Calle Los Pinos 50-30, Zona 5', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 40, '11001', 'Casa', 1),
(41, 'Avenida del Mercado 51-33, Zona 6', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 41, '01001', 'Trabajo', 1),
(42, 'Calle Las Rosas 52-36, Zona 7', 'Mixco', 'Guatemala', 'Guatemala', 42, '01057', 'Otro', 1),
(43, 'Avenida del Lago 53-39, Zona 8', 'Villa Nueva', 'Guatemala', 'Guatemala', 43, '01064', 'Casa', 1),
(44, 'Calle San José 54-42, Zona 9', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 44, '01066', 'Trabajo', 1),
(45, 'Avenida Los Alamos 55-45, Zona 10', 'Amatitlán', 'Guatemala', 'Guatemala', 45, '01063', 'Otro', 1),
(46, 'Avenida Las Flores 56-48, Zona 11', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 46, '03001', 'Casa', 1),
(47, 'Calle del Comercio 57-51, Zona 12', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 47, '04001', 'Trabajo', 1),
(48, 'Avenida Reforma 58-54, Zona 13', 'Escuintla', 'Escuintla', 'Guatemala', 48, '05001', 'Otro', 1),
(49, 'Calle Principal 59-57, Zona 14', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 49, '09001', 'Casa', 1),
(50, 'Avenida Los Próceres 60-60, Zona 15', 'Totonicapán', 'Totonicapán', 'Guatemala', 50, '08001', 'Trabajo', 1),
(51, 'Calle de la Paz 61-63, Zona 16', 'Sololá', 'Sololá', 'Guatemala', 51, '07001', 'Otro', 1),
(52, 'Avenida del Bosque 62-66, Zona 17', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 52, '13001', 'Casa', 1),
(53, 'Calle Central 63-69, Zona 18', 'Cobán', 'Alta Verapaz', 'Guatemala', 53, '16001', 'Trabajo', 1),
(54, 'Avenida La Esperanza 64-72, Zona 1', 'Salamá', 'Baja Verapaz', 'Guatemala', 54, '15001', 'Otro', 1),
(55, 'Calle Los Pinos 65-75, Zona 2', 'Puerto Barrios', 'Izabal', 'Guatemala', 55, '18001', 'Casa', 1),
(56, 'Avenida del Mercado 66-78, Zona 3', 'Zacapa', 'Zacapa', 'Guatemala', 56, '19001', 'Trabajo', 1),
(57, 'Calle Las Rosas 67-81, Zona 4', 'Chiquimula', 'Chiquimula', 'Guatemala', 57, '20001', 'Otro', 1),
(58, 'Avenida del Lago 68-84, Zona 5', 'Jalapa', 'Jalapa', 'Guatemala', 58, '21001', 'Casa', 1),
(59, 'Calle San José 69-87, Zona 6', 'Jutiapa', 'Jutiapa', 'Guatemala', 59, '22001', 'Trabajo', 1),
(60, 'Avenida Los Alamos 70-00, Zona 7', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 60, '11001', 'Otro', 1),
(61, 'Avenida Las Flores 71-03, Zona 8', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 61, '01001', 'Casa', 1),
(62, 'Calle del Comercio 72-06, Zona 9', 'Mixco', 'Guatemala', 'Guatemala', 62, '01057', 'Trabajo', 1),
(63, 'Avenida Reforma 73-09, Zona 10', 'Villa Nueva', 'Guatemala', 'Guatemala', 63, '01064', 'Otro', 1),
(64, 'Calle Principal 74-12, Zona 11', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 64, '01066', 'Casa', 1),
(65, 'Avenida Los Próceres 75-15, Zona 12', 'Amatitlán', 'Guatemala', 'Guatemala', 65, '01063', 'Trabajo', 1),
(66, 'Calle de la Paz 76-18, Zona 13', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 66, '03001', 'Otro', 1),
(67, 'Avenida del Bosque 77-21, Zona 14', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 67, '04001', 'Casa', 1),
(68, 'Calle Central 78-24, Zona 15', 'Escuintla', 'Escuintla', 'Guatemala', 68, '05001', 'Trabajo', 1),
(69, 'Avenida La Esperanza 79-27, Zona 16', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 69, '09001', 'Otro', 1),
(70, 'Calle Los Pinos 80-30, Zona 17', 'Totonicapán', 'Totonicapán', 'Guatemala', 70, '08001', 'Casa', 1),
(71, 'Avenida del Mercado 81-33, Zona 18', 'Sololá', 'Sololá', 'Guatemala', 71, '07001', 'Trabajo', 1),
(72, 'Calle Las Rosas 82-36, Zona 1', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 72, '13001', 'Otro', 1),
(73, 'Avenida del Lago 83-39, Zona 2', 'Cobán', 'Alta Verapaz', 'Guatemala', 73, '16001', 'Casa', 1),
(74, 'Calle San José 84-42, Zona 3', 'Salamá', 'Baja Verapaz', 'Guatemala', 74, '15001', 'Trabajo', 1),
(75, 'Avenida Los Alamos 85-45, Zona 4', 'Puerto Barrios', 'Izabal', 'Guatemala', 75, '18001', 'Otro', 1),
(76, 'Avenida Las Flores 86-48, Zona 5', 'Zacapa', 'Zacapa', 'Guatemala', 76, '19001', 'Casa', 1),
(77, 'Calle del Comercio 87-51, Zona 6', 'Chiquimula', 'Chiquimula', 'Guatemala', 77, '20001', 'Trabajo', 1),
(78, 'Calle Principal 89-57, Zona 8', 'Jutiapa', 'Jutiapa', 'Guatemala', 78, '22001', 'Casa', 1),
(79, 'Avenida Los Próceres 90-60, Zona 9', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 79, '11001', 'Trabajo', 1),
(80, 'Calle de la Paz 91-63, Zona 10', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 80, '01001', 'Otro', 1),
(81, 'Avenida del Bosque 92-66, Zona 11', 'Mixco', 'Guatemala', 'Guatemala', 81, '01057', 'Casa', 1),
(82, 'Calle Central 93-69, Zona 12', 'Villa Nueva', 'Guatemala', 'Guatemala', 82, '01064', 'Trabajo', 1),
(83, 'Avenida La Esperanza 94-72, Zona 13', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 83, '01066', 'Otro', 1),
(84, 'Calle Los Pinos 95-75, Zona 14', 'Amatitlán', 'Guatemala', 'Guatemala', 84, '01063', 'Casa', 1),
(85, 'Avenida del Mercado 96-78, Zona 15', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 85, '03001', 'Trabajo', 1),
(86, 'Calle Las Rosas 97-81, Zona 16', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 86, '04001', 'Otro', 1),
(87, 'Avenida del Lago 98-84, Zona 17', 'Escuintla', 'Escuintla', 'Guatemala', 87, '05001', 'Casa', 1),
(88, 'Calle San José 99-87, Zona 18', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 88, '09001', 'Trabajo', 1),
(89, 'Avenida Los Alamos 100-00, Zona 1', 'Totonicapán', 'Totonicapán', 'Guatemala', 89, '08001', 'Otro', 1),
(90, 'Avenida Las Flores 101-03, Zona 2', 'Sololá', 'Sololá', 'Guatemala', 90, '07001', 'Casa', 1),
(91, 'Calle del Comercio 102-06, Zona 3', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 91, '13001', 'Trabajo', 1),
(92, 'Avenida Reforma 103-09, Zona 4', 'Cobán', 'Alta Verapaz', 'Guatemala', 92, '16001', 'Otro', 1),
(93, 'Calle Principal 104-12, Zona 5', 'Salamá', 'Baja Verapaz', 'Guatemala', 93, '15001', 'Casa', 1),
(94, 'Avenida Los Próceres 105-15, Zona 6', 'Puerto Barrios', 'Izabal', 'Guatemala', 94, '18001', 'Trabajo', 1),
(95, 'Calle de la Paz 106-18, Zona 7', 'Zacapa', 'Zacapa', 'Guatemala', 95, '19001', 'Otro', 1),
(96, 'Avenida del Bosque 107-21, Zona 8', 'Chiquimula', 'Chiquimula', 'Guatemala', 96, '20001', 'Casa', 1),
(97, 'Calle Central 108-24, Zona 9', 'Jalapa', 'Jalapa', 'Guatemala', 97, '21001', 'Trabajo', 1),
(98, 'Avenida La Esperanza 109-27, Zona 10', 'Jutiapa', 'Jutiapa', 'Guatemala', 98, '22001', 'Otro', 1),
(99, 'Calle Los Pinos 110-30, Zona 11', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 99, '11001', 'Casa', 1),
(100, 'Avenida del Mercado 111-33, Zona 12', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 100, '01001', 'Trabajo', 1),
(101, 'Calle Las Rosas 112-36, Zona 13', 'Mixco', 'Guatemala', 'Guatemala', 101, '01057', 'Otro', 1),
(102, 'Avenida del Lago 113-39, Zona 14', 'Villa Nueva', 'Guatemala', 'Guatemala', 102, '01064', 'Casa', 1),
(103, 'Calle San José 114-42, Zona 15', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 103, '01066', 'Trabajo', 1),
(104, 'Avenida Los Alamos 115-45, Zona 16', 'Amatitlán', 'Guatemala', 'Guatemala', 104, '01063', 'Otro', 1),
(105, 'Avenida Las Flores 116-48, Zona 17', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 105, '03001', 'Casa', 1),
(106, 'Calle del Comercio 117-51, Zona 18', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 106, '04001', 'Trabajo', 1),
(107, 'Avenida Reforma 118-54, Zona 1', 'Escuintla', 'Escuintla', 'Guatemala', 107, '05001', 'Otro', 1),
(108, 'Calle Principal 119-57, Zona 2', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 108, '09001', 'Casa', 1),
(109, 'Avenida Los Próceres 120-60, Zona 3', 'Totonicapán', 'Totonicapán', 'Guatemala', 109, '08001', 'Trabajo', 1),
(110, 'Calle de la Paz 121-63, Zona 4', 'Sololá', 'Sololá', 'Guatemala', 110, '07001', 'Otro', 1),
(111, 'Avenida del Bosque 122-66, Zona 5', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 111, '13001', 'Casa', 1),
(112, 'Calle Central 123-69, Zona 6', 'Cobán', 'Alta Verapaz', 'Guatemala', 112, '16001', 'Trabajo', 1),
(113, 'Avenida La Esperanza 124-72, Zona 7', 'Salamá', 'Baja Verapaz', 'Guatemala', 113, '15001', 'Otro', 1),
(114, 'Calle Los Pinos 125-75, Zona 8', 'Puerto Barrios', 'Izabal', 'Guatemala', 114, '18001', 'Casa', 1),
(115, 'Avenida del Mercado 126-78, Zona 9', 'Zacapa', 'Zacapa', 'Guatemala', 115, '19001', 'Trabajo', 1),
(116, 'Calle Las Rosas 127-81, Zona 10', 'Chiquimula', 'Chiquimula', 'Guatemala', 116, '20001', 'Otro', 1),
(117, 'Avenida del Lago 128-84, Zona 11', 'Jalapa', 'Jalapa', 'Guatemala', 117, '21001', 'Casa', 1),
(118, 'Calle San José 129-87, Zona 12', 'Jutiapa', 'Jutiapa', 'Guatemala', 118, '22001', 'Trabajo', 1),
(119, 'Avenida Los Alamos 130-00, Zona 13', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 119, '11001', 'Otro', 1),
(120, 'Avenida Las Flores 131-03, Zona 14', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 120, '01001', 'Casa', 1),
(121, 'Calle del Comercio 132-06, Zona 15', 'Mixco', 'Guatemala', 'Guatemala', 121, '01057', 'Trabajo', 1),
(122, 'Avenida Reforma 133-09, Zona 16', 'Villa Nueva', 'Guatemala', 'Guatemala', 122, '01064', 'Otro', 1),
(123, 'Calle Principal 134-12, Zona 17', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 123, '01066', 'Casa', 1),
(124, 'Avenida Los Próceres 135-15, Zona 18', 'Amatitlán', 'Guatemala', 'Guatemala', 124, '01063', 'Trabajo', 1),
(125, 'Calle de la Paz 136-18, Zona 1', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 125, '03001', 'Otro', 1),
(126, 'Avenida del Bosque 137-21, Zona 2', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 126, '04001', 'Casa', 1),
(127, 'Calle Central 138-24, Zona 3', 'Escuintla', 'Escuintla', 'Guatemala', 127, '05001', 'Trabajo', 1),
(128, 'Avenida La Esperanza 139-27, Zona 4', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 128, '09001', 'Otro', 1),
(129, 'Calle Los Pinos 140-30, Zona 5', 'Totonicapán', 'Totonicapán', 'Guatemala', 129, '08001', 'Casa', 1),
(130, 'Avenida del Mercado 141-33, Zona 6', 'Sololá', 'Sololá', 'Guatemala', 130, '07001', 'Trabajo', 1),
(131, 'Calle Las Rosas 142-36, Zona 7', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 131, '13001', 'Otro', 1),
(132, 'Avenida del Lago 143-39, Zona 8', 'Cobán', 'Alta Verapaz', 'Guatemala', 132, '16001', 'Casa', 1),
(133, 'Calle San José 144-42, Zona 9', 'Salamá', 'Baja Verapaz', 'Guatemala', 133, '15001', 'Trabajo', 1),
(134, 'Avenida Los Alamos 145-45, Zona 10', 'Puerto Barrios', 'Izabal', 'Guatemala', 134, '18001', 'Otro', 1),
(135, 'Avenida Las Flores 146-48, Zona 11', 'Zacapa', 'Zacapa', 'Guatemala', 135, '19001', 'Casa', 1),
(136, 'Calle del Comercio 147-51, Zona 12', 'Chiquimula', 'Chiquimula', 'Guatemala', 136, '20001', 'Trabajo', 1),
(137, 'Avenida Reforma 148-54, Zona 13', 'Jalapa', 'Jalapa', 'Guatemala', 137, '21001', 'Otro', 1),
(138, 'Calle Principal 149-57, Zona 14', 'Jutiapa', 'Jutiapa', 'Guatemala', 138, '22001', 'Casa', 1),
(139, 'Avenida Los Próceres 150-60, Zona 15', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 139, '11001', 'Trabajo', 1),
(140, 'Calle de la Paz 151-63, Zona 16', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 140, '01001', 'Otro', 1),
(141, 'Avenida del Bosque 152-66, Zona 17', 'Mixco', 'Guatemala', 'Guatemala', 141, '01057', 'Casa', 1),
(142, 'Calle Central 153-69, Zona 18', 'Villa Nueva', 'Guatemala', 'Guatemala', 142, '01064', 'Trabajo', 1),
(143, 'Avenida La Esperanza 154-72, Zona 1', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 143, '01066', 'Otro', 1),
(144, 'Calle Los Pinos 155-75, Zona 2', 'Amatitlán', 'Guatemala', 'Guatemala', 144, '01063', 'Casa', 1),
(145, 'Avenida del Mercado 156-78, Zona 3', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 145, '03001', 'Trabajo', 1),
(146, 'Calle Las Rosas 157-81, Zona 4', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 146, '04001', 'Otro', 1),
(147, 'Avenida del Lago 158-84, Zona 5', 'Escuintla', 'Escuintla', 'Guatemala', 147, '05001', 'Casa', 1),
(148, 'Calle San José 159-87, Zona 6', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 148, '09001', 'Trabajo', 1),
(149, 'Avenida Los Alamos 160-00, Zona 7', 'Totonicapán', 'Totonicapán', 'Guatemala', 149, '08001', 'Otro', 1),
(150, 'Calle Las Jacarandas 24-18, Zona 3', 'San Lucas Sacatepéquez', 'Sacatepéquez', 'Guatemala', 150, '03008', 'Casa', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `FacturaID` int(11) NOT NULL,
  `NumeroFactura` varchar(50) NOT NULL,
  `FechaEmision` datetime NOT NULL DEFAULT current_timestamp(),
  `OrdenID` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `NIT` varchar(20) NOT NULL DEFAULT 'CF',
  `Direccion` varchar(255) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL,
  `ImpuestoTotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `DescuentoTotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Total` decimal(10,2) NOT NULL,
  `Notas` varchar(255) DEFAULT NULL,
  `Estado` enum('Emitida','Anulada') NOT NULL DEFAULT 'Emitida'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `listadeseos`
--

CREATE TABLE `listadeseos` (
  `UsuarioID` int(11) NOT NULL,
  `ProductoID` int(11) NOT NULL,
  `FechaAgregado` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes`
--

CREATE TABLE `ordenes` (
  `OrdenID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL,
  `FechaOrden` datetime NOT NULL DEFAULT current_timestamp(),
  `DireccionPago` varchar(255) NOT NULL,
  `DireccionEnvio` varchar(255) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL,
  `DescuentoTotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ImpuestoTotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `CostoEnvio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Total` decimal(10,2) NOT NULL,
  `Estado` enum('Pendiente','Confirmada','Procesando','Enviada','Entregada','Cancelada') NOT NULL DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `PagoID` int(11) NOT NULL,
  `OrdenID` int(11) NOT NULL,
  `FechaPago` datetime NOT NULL DEFAULT current_timestamp(),
  `Monto` decimal(10,2) NOT NULL CHECK (`Monto` >= 0),
  `MetodoPago` varchar(30) NOT NULL,
  `ReferenciaPago` varchar(100) DEFAULT NULL,
  `Notas` varchar(255) DEFAULT NULL,
  `Estado` enum('Pendiente','Completado','Rechazado','Reembolsado') NOT NULL DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `ProductoID` int(11) NOT NULL,
  `CategoriaID` int(11) NOT NULL,
  `SKU` varchar(50) DEFAULT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Descripcion` varchar(255) DEFAULT NULL,
  `Precio` decimal(10,2) NOT NULL CHECK (`Precio` >= 0),
  `Cantidad` int(11) NOT NULL DEFAULT 0 CHECK (`Cantidad` >= 0),
  `Imagen` varchar(255) DEFAULT NULL,
  `Estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `FechaRegistro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productospromociones`
--

CREATE TABLE `productospromociones` (
  `ProductoID` int(11) NOT NULL,
  `PromocionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productosproveedores`
--

CREATE TABLE `productosproveedores` (
  `ProductoID` int(11) NOT NULL,
  `ProveedorID` int(11) NOT NULL,
  `CostoCompra` decimal(10,2) DEFAULT NULL CHECK (`CostoCompra` >= 0),
  `EsPrincipal` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones`
--

CREATE TABLE `promociones` (
  `PromocionID` int(11) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Descripcion` varchar(255) DEFAULT NULL,
  `TipoDescuento` enum('Porcentaje','Monto') NOT NULL,
  `ValorDescuento` decimal(10,2) NOT NULL CHECK (`ValorDescuento` >= 0),
  `FechaInicio` datetime NOT NULL,
  `FechaFin` datetime DEFAULT NULL,
  `RequiereCupon` tinyint(1) NOT NULL DEFAULT 0,
  `CodigoCupon` varchar(40) DEFAULT NULL,
  `AplicaTodosProductos` tinyint(1) NOT NULL DEFAULT 0,
  `Estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `ProveedorID` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `NIT` varchar(20) DEFAULT NULL,
  `Contacto` varchar(100) DEFAULT NULL,
  `Correo` varchar(100) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `FechaRegistro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resenas`
--

CREATE TABLE `resenas` (
  `ResenaID` int(11) NOT NULL,
  `UsuarioID` int(11) NOT NULL,
  `ProductoID` int(11) NOT NULL,
  `Calificacion` tinyint(4) NOT NULL CHECK (`Calificacion` between 1 and 5),
  `Comentario` longtext DEFAULT NULL,
  `FechaResena` datetime NOT NULL DEFAULT current_timestamp(),
  `Estado` enum('Publicada','Oculta') NOT NULL DEFAULT 'Publicada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `UsuarioID` int(11) NOT NULL,
  `Nombres` varchar(75) NOT NULL,
  `Apellidos` varchar(75) NOT NULL,
  `Correo` varchar(100) NOT NULL,
  `Telefono` varchar(20) NOT NULL,
  `Usuario` varchar(50) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `TipoUsuario` enum('Administrador','Cliente') NOT NULL DEFAULT 'Cliente',
  `Estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `FechaRegistro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`UsuarioID`, `Nombres`, `Apellidos`, `Correo`, `Telefono`, `Usuario`, `Contrasena`, `TipoUsuario`, `Estado`, `FechaRegistro`) VALUES
(1, 'Ana', 'García López', 'cliente001@example.com', '5550-0001', 'cliente001', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-13 09:07:00'),
(2, 'Carlos', 'López Ramírez', 'cliente002@example.com', '5550-0002', 'cliente002', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-16 10:14:00'),
(3, 'María', 'González Méndez', 'cliente003@example.com', '5550-0003', 'cliente003', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-19 11:21:00'),
(4, 'José', 'Castillo Reyes', 'cliente004@example.com', '5550-0004', 'cliente004', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-22 12:28:00'),
(5, 'Gabriela', 'Vásquez Flores', 'cliente005@example.com', '5550-0005', 'cliente005', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-25 13:35:00'),
(6, 'Luis', 'Aguilar Rojas', 'cliente006@example.com', '5550-0006', 'cliente006', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-28 14:42:00'),
(7, 'Daniela', 'Fuentes Herrera', 'cliente007@example.com', '5550-0007', 'cliente007', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-31 15:49:00'),
(8, 'Fernando', 'Salazar Pineda', 'cliente008@example.com', '5550-0008', 'cliente008', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-03 16:56:00'),
(9, 'Paola', 'Alvarado Cifuentes', 'cliente009@example.com', '5550-0009', 'cliente009', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-06 08:03:00'),
(10, 'Ricardo', 'Rodríguez Morales', 'cliente010@example.com', '5550 0010', 'cliente010', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-02-09 09:10:00'),
(11, 'Sofía', 'Hernández Castillo', 'cliente011@example.com', '5550-0011', 'cliente011', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-12 10:17:00'),
(12, 'Javier', 'Morales Vásquez', 'cliente012@example.com', '5550-0012', 'cliente012', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-15 11:24:00'),
(13, 'Andrea', 'Díaz Aguilar', 'cliente013@example.com', '5550-0013', 'cliente013', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-18 12:31:00'),
(14, 'Miguel', 'Ortiz Fuentes', 'cliente014@example.com', '5550-0014', 'cliente014', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-21 13:38:00'),
(15, 'Valeria', 'Cabrera Salazar', 'cliente015@example.com', '5550-0015', 'cliente015', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-24 14:45:00'),
(16, 'Diego', 'Mendoza Alvarado', 'cliente016@example.com', '5550-0016', 'cliente016', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-27 15:52:00'),
(17, 'Lucía', 'Calderón Escobar', 'cliente017@example.com', '5550-0017', 'cliente017', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-02 16:59:00'),
(18, 'Alejandro', 'Pérez Hernández', 'cliente018@example.com', '5550 0018', 'cliente018', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-05 08:06:00'),
(19, 'Camila', 'Martínez Gómez', 'cliente019@example.com', '5550-0019', 'cliente019', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-08 09:13:00'),
(20, 'Manuel', 'Ramírez Díaz', 'cliente020@example.com', '5550-0020', 'cliente020', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-03-11 10:20:00'),
(21, 'Fernanda', 'Méndez Ortiz', 'cliente021@example.com', '5550-0021', 'cliente021', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-14 11:27:00'),
(22, 'Esteban', 'Reyes Cabrera', 'cliente022@example.com', '5550-0022', 'cliente022', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-17 12:34:00'),
(23, 'Natalia', 'Flores Mendoza', 'cliente023@example.com', '5550-0023', 'cliente023', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-20 13:41:00'),
(24, 'Oscar', 'Rojas Calderón', 'cliente024@example.com', '5550-0024', 'cliente024', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-23 14:48:00'),
(25, 'Isabel', 'Herrera Barrios', 'cliente025@example.com', '5550-0025', 'cliente025', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-26 15:55:00'),
(26, 'Héctor', 'García López', 'cliente026@example.com', '5550-0026', 'cliente026', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-29 16:02:00'),
(27, 'Elena', 'López Ramírez', 'cliente027@example.com', '5550-0027', 'cliente027', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-01 08:09:00'),
(28, 'Roberto', 'González Méndez', 'cliente028@example.com', '5550 0028', 'cliente028', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-04 09:16:00'),
(29, 'Mónica', 'Castillo Reyes', 'cliente029@example.com', '5550-0029', 'cliente029', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-07 10:23:00'),
(30, 'Andrés', 'Vásquez Flores', 'cliente030@example.com', '5550-0030', 'cliente030', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-04-10 11:30:00'),
(31, 'Ana', 'Aguilar Rojas', 'cliente031@example.com', '5550-0031', 'cliente031', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-13 12:37:00'),
(32, 'Carlos', 'Fuentes Herrera', 'cliente032@example.com', '5550-0032', 'cliente032', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-16 13:44:00'),
(33, 'María', 'Salazar Pineda', 'cliente033@example.com', '5550-0033', 'cliente033', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-19 14:51:00'),
(34, 'José', 'Alvarado Cifuentes', 'cliente034@example.com', '5550-0034', 'cliente034', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-22 15:58:00'),
(35, 'Gabriela', 'Rodríguez Morales', 'cliente035@example.com', '5550 0035', 'cliente035', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-25 16:05:00'),
(36, 'Luis', 'Hernández Castillo', 'cliente036@example.com', '5550-0036', 'cliente036', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-28 08:12:00'),
(37, 'Daniela', 'Morales Vásquez', 'cliente037@example.com', '5550-0037', 'cliente037', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-01 09:19:00'),
(38, 'Fernando', 'Díaz Aguilar', 'cliente038@example.com', '5550-0038', 'cliente038', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-04 10:26:00'),
(39, 'Paola', 'Ortiz Fuentes', 'cliente039@example.com', '5550-0039', 'cliente039', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-07 11:33:00'),
(40, 'Ricardo', 'Cabrera Salazar', 'cliente040@example.com', '5550-0040', 'cliente040', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-05-10 12:40:00'),
(41, 'Sofía', 'Mendoza Alvarado', 'cliente041@example.com', '5550-0041', 'cliente041', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-13 13:47:00'),
(42, 'Javier', 'Calderón Escobar', 'cliente042@example.com', '5550-0042', 'cliente042', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-16 14:54:00'),
(43, 'Andrea', 'Pérez Hernández', 'cliente043@example.com', '5550-0043', 'cliente043', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-19 15:01:00'),
(44, 'Miguel', 'Martínez Gómez', 'cliente044@example.com', '5550-0044', 'cliente044', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-22 16:08:00'),
(45, 'Valeria', 'Ramírez Díaz', 'cliente045@example.com', '5550-0045', 'cliente045', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-25 08:15:00'),
(46, 'Diego', 'Méndez Ortiz', 'cliente046@example.com', '5550-0046', 'cliente046', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-28 09:22:00'),
(47, 'Lucía', 'Reyes Cabrera', 'cliente047@example.com', '5550-0047', 'cliente047', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-31 10:29:00'),
(48, 'Alejandro', 'Flores Mendoza', 'cliente048@example.com', '5550-0048', 'cliente048', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-03 11:36:00'),
(49, 'Camila', 'Rojas Calderón', 'cliente049@example.com', '5550-0049', 'cliente049', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-06 12:43:00'),
(50, 'Manuel', 'Herrera Barrios', 'cliente050@example.com', '5550-0050', 'cliente050', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-06-09 13:50:00'),
(51, 'Fernanda', 'García López', 'cliente051@example.com', '5550-0051', 'cliente051', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-12 14:57:00'),
(52, 'Esteban', 'López Ramírez', 'cliente052@example.com', '5550-0052', 'cliente052', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-15 15:04:00'),
(53, 'Natalia', 'González Méndez', 'cliente053@example.com', '5550-0053', 'cliente053', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-18 16:11:00'),
(54, 'Oscar', 'Castillo Reyes', 'cliente054@example.com', '5550-0054', 'cliente054', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-21 08:18:00'),
(55, 'Isabel', 'Vásquez Flores', 'cliente055@example.com', '5550-0055', 'cliente055', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-24 09:25:00'),
(56, 'Héctor', 'Aguilar Rojas', 'cliente056@example.com', '5550-0056', 'cliente056', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-27 10:32:00'),
(57, 'Elena', 'Fuentes Herrera', 'cliente057@example.com', '5550-0057', 'cliente057', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-30 11:39:00'),
(58, 'Roberto', 'Salazar Pineda', 'cliente058@example.com', '5550-0058', 'cliente058', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-03 12:46:00'),
(59, 'Mónica', 'Alvarado Cifuentes', 'cliente059@example.com', '5550-0059', 'cliente059', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-06 13:53:00'),
(60, 'Andrés', 'Rodríguez Morales', 'cliente060@example.com', '5550-0060', 'cliente060', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-07-09 14:00:00'),
(61, 'Ana', 'Hernández Castillo', 'cliente061@example.com', '5550-0061', 'cliente061', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-12 15:07:00'),
(62, 'Carlos', 'Morales Vásquez', 'cliente062@example.com', '5550-0062', 'cliente062', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-15 16:14:00'),
(63, 'María', 'Díaz Aguilar', 'cliente063@example.com', '5550-0063', 'cliente063', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-18 08:21:00'),
(64, 'José', 'Ortiz Fuentes', 'cliente064@example.com', '5550-0064', 'cliente064', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-21 09:28:00'),
(65, 'Gabriela', 'Cabrera Salazar', 'cliente065@example.com', '5550-0065', 'cliente065', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-24 10:35:00'),
(66, 'Luis', 'Mendoza Alvarado', 'cliente066@example.com', '5550-0066', 'cliente066', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-27 11:42:00'),
(67, 'Daniela', 'Calderón Escobar', 'cliente067@example.com', '5550-0067', 'cliente067', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-30 12:49:00'),
(68, 'Fernando', 'Pérez Hernández', 'cliente068@example.com', '5550-0068', 'cliente068', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-02 13:56:00'),
(69, 'Paola', 'Martínez Gómez', 'cliente069@example.com', '5550-0069', 'cliente069', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-05 14:03:00'),
(70, 'Ricardo', 'Ramírez Díaz', 'cliente070@example.com', '5550-0070', 'cliente070', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-08-08 15:10:00'),
(71, 'Sofía', 'Méndez Ortiz', 'cliente071@example.com', '5550-0071', 'cliente071', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-11 16:17:00'),
(72, 'Javier', 'Reyes Cabrera', 'cliente072@example.com', '5550-0072', 'cliente072', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-14 08:24:00'),
(73, 'Andrea', 'Flores Mendoza', 'cliente073@example.com', '5550-0073', 'cliente073', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-17 09:31:00'),
(74, 'Miguel', 'Rojas Calderón', 'cliente074@example.com', '5550-0074', 'cliente074', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-20 10:38:00'),
(75, 'Valeria', 'Herrera Barrios', 'cliente075@example.com', '5550-0075', 'cliente075', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-23 11:45:00'),
(76, 'Diego', 'García López', 'cliente076@example.com', '5550-0076', 'cliente076', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-26 12:52:00'),
(77, 'Lucía', 'López Ramírez', 'cliente077@example.com', '5550-0077', 'cliente077', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-29 13:59:00'),
(78, 'Alejandro', 'González Méndez', 'cliente078@example.com', '5550-0078', 'cliente078', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-01 14:06:00'),
(79, 'Manuel', 'Vásquez Flores', 'cliente080@example.com', '5550-0080', 'cliente080', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-09-07 16:20:00'),
(80, 'Fernanda', 'Aguilar Rojas', 'cliente081@example.com', '5550-0081', 'cliente081', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-10 08:27:00'),
(81, 'Esteban', 'Fuentes Herrera', 'cliente082@example.com', '5550-0082', 'cliente082', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-13 09:34:00'),
(82, 'Natalia', 'Salazar Pineda', 'cliente083@example.com', '5550-0083', 'cliente083', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-16 10:41:00'),
(83, 'Oscar', 'Alvarado Cifuentes', 'cliente084@example.com', '5550-0084', 'cliente084', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-19 11:48:00'),
(84, 'Isabel', 'Rodríguez Morales', 'cliente085@example.com', '5550-0085', 'cliente085', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-22 12:55:00'),
(85, 'Héctor', 'Hernández Castillo', 'cliente086@example.com', '5550-0086', 'cliente086', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-25 13:02:00'),
(86, 'Elena', 'Morales Vásquez', 'cliente087@example.com', '5550-0087', 'cliente087', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-28 14:09:00'),
(87, 'Roberto', 'Díaz Aguilar', 'cliente088@example.com', '5550-0088', 'cliente088', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-01 15:16:00'),
(88, 'Mónica', 'Ortiz Fuentes', 'cliente089@example.com', '5550-0089', 'cliente089', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-04 16:23:00'),
(89, 'Andrés', 'Cabrera Salazar', 'cliente090@example.com', '5550-0090', 'cliente090', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-10-07 08:30:00'),
(90, 'Ana', 'Mendoza Alvarado', 'cliente091@example.com', '5550-0091', 'cliente091', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-10 09:37:00'),
(91, 'Carlos', 'Calderón Escobar', 'cliente092@example.com', '5550-0092', 'cliente092', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-13 10:44:00'),
(92, 'María', 'Pérez Hernández', 'cliente093@example.com', '5550-0093', 'cliente093', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-16 11:51:00'),
(93, 'José', 'Martínez Gómez', 'cliente094@example.com', '5550-0094', 'cliente094', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-19 12:58:00'),
(94, 'Gabriela', 'Ramírez Díaz', 'cliente095@example.com', '5550-0095', 'cliente095', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-22 13:05:00'),
(95, 'Luis', 'Méndez Ortiz', 'cliente096@example.com', '5550-0096', 'cliente096', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-25 14:12:00'),
(96, 'Daniela', 'Reyes Cabrera', 'cliente097@example.com', '5550-0097', 'cliente097', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-28 15:19:00'),
(97, 'Fernando', 'Flores Mendoza', 'cliente098@example.com', '5550 0098', 'cliente098', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-31 16:26:00'),
(98, 'Paola', 'Rojas Calderón', 'cliente099@example.com', '5550-0099', 'cliente099', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-03 08:33:00'),
(99, 'Ricardo', 'Herrera Barrios', 'cliente100@example.com', '5550-0100', 'cliente100', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-11-06 09:40:00'),
(100, 'Sofía', 'García López', 'cliente101@example.com', '5550-0101', 'cliente101', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-09 10:47:00'),
(101, 'Javier', 'López Ramírez', 'cliente102@example.com', '5550-0102', 'cliente102', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-12 11:54:00'),
(102, 'Andrea', 'González Méndez', 'cliente103@example.com', '5550-0103', 'cliente103', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-15 12:01:00'),
(103, 'Miguel', 'Castillo Reyes', 'cliente104@example.com', '5550-0104', 'cliente104', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-18 13:08:00'),
(104, 'Valeria', 'Vásquez Flores', 'cliente105@example.com', '5550-0105', 'cliente105', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-21 14:15:00'),
(105, 'Diego', 'Aguilar Rojas', 'cliente106@example.com', '5550-0106', 'cliente106', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-24 15:22:00'),
(106, 'Lucía', 'Fuentes Herrera', 'cliente107@example.com', '5550-0107', 'cliente107', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-27 16:29:00'),
(107, 'Alejandro', 'Salazar Pineda', 'cliente108@example.com', '5550-0108', 'cliente108', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-30 08:36:00'),
(108, 'Camila', 'Alvarado Cifuentes', 'cliente109@example.com', '5550-0109', 'cliente109', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-03 09:43:00'),
(109, 'Manuel', 'Rodríguez Morales', 'cliente110@example.com', '5550-0110', 'cliente110', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-12-06 10:50:00'),
(110, 'Fernanda', 'Hernández Castillo', 'cliente111@example.com', '5550-0111', 'cliente111', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-09 11:57:00'),
(111, 'Esteban', 'Morales Vásquez', 'cliente112@example.com', '5550-0112', 'cliente112', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-12 12:04:00'),
(112, 'Natalia', 'Díaz Aguilar', 'cliente113@example.com', '5550-0113', 'cliente113', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-15 13:11:00'),
(113, 'Oscar', 'Ortiz Fuentes', 'cliente114@example.com', '5550-0114', 'cliente114', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-18 14:18:00'),
(114, 'Isabel', 'Cabrera Salazar', 'cliente115@example.com', '5550-0115', 'cliente115', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-21 15:25:00'),
(115, 'Héctor', 'Mendoza Alvarado', 'cliente116@example.com', '5550-0116', 'cliente116', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-24 16:32:00'),
(116, 'Elena', 'Calderón Escobar', 'cliente117@example.com', '5550-0117', 'cliente117', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-27 08:39:00'),
(117, 'Roberto', 'Pérez Hernández', 'cliente118@example.com', '5550-0118', 'cliente118', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-30 09:46:00'),
(118, 'Mónica', 'Martínez Gómez', 'cliente119@example.com', '5550-0119', 'cliente119', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-02 10:53:00'),
(119, 'Andrés', 'Ramírez Díaz', 'cliente120@example.com', '5550-0120', 'cliente120', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-01-05 11:00:00'),
(120, 'Ana', 'Méndez Ortiz', 'cliente121@example.com', '5550-0121', 'cliente121', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-08 12:07:00'),
(121, 'Carlos', 'Reyes Cabrera', 'cliente122@example.com', '5550-0122', 'cliente122', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-11 13:14:00'),
(122, 'María', 'Flores Mendoza', 'cliente123@example.com', '5550-0123', 'cliente123', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-14 14:21:00'),
(123, 'José', 'Rojas Calderón', 'cliente124@example.com', '5550-0124', 'cliente124', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-17 15:28:00'),
(124, 'Gabriela', 'Herrera Barrios', 'cliente125@example.com', '5550-0125', 'cliente125', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-20 16:35:00'),
(125, 'Luis', 'García López', 'cliente126@example.com', '5550-0126', 'cliente126', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-23 08:42:00'),
(126, 'Daniela', 'López Ramírez', 'cliente127@example.com', '5550-0127', 'cliente127', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-26 09:49:00'),
(127, 'Fernando', 'González Méndez', 'cliente128@example.com', '5550-0128', 'cliente128', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-29 10:56:00'),
(128, 'Paola', 'Castillo Reyes', 'cliente129@example.com', '5550-0129', 'cliente129', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-01 11:03:00'),
(129, 'Ricardo', 'Vásquez Flores', 'cliente130@example.com', '5550-0130', 'cliente130', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-02-04 12:10:00'),
(130, 'Sofía', 'Aguilar Rojas', 'cliente131@example.com', '5550-0131', 'cliente131', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-07 13:17:00'),
(131, 'Javier', 'Fuentes Herrera', 'cliente132@example.com', '5550-0132', 'cliente132', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-10 14:24:00'),
(132, 'Andrea', 'Salazar Pineda', 'cliente133@example.com', '5550-0133', 'cliente133', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-13 15:31:00'),
(133, 'Miguel', 'Alvarado Cifuentes', 'cliente134@example.com', '5550-0134', 'cliente134', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-16 16:38:00'),
(134, 'Valeria', 'Rodríguez Morales', 'cliente135@example.com', '5550-0135', 'cliente135', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-19 08:45:00'),
(135, 'Diego', 'Hernández Castillo', 'cliente136@example.com', '5550-0136', 'cliente136', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-22 09:52:00'),
(136, 'Lucía', 'Morales Vásquez', 'cliente137@example.com', '5550-0137', 'cliente137', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-25 10:59:00'),
(137, 'Alejandro', 'Díaz Aguilar', 'cliente138@example.com', '5550-0138', 'cliente138', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-28 11:06:00'),
(138, 'Camila', 'Ortiz Fuentes', 'cliente139@example.com', '5550-0139', 'cliente139', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-03 12:13:00'),
(139, 'Manuel', 'Cabrera Salazar', 'cliente140@example.com', '5550-0140', 'cliente140', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-03-06 13:20:00'),
(140, 'Fernanda', 'Mendoza Alvarado', 'cliente141@example.com', '5550-0141', 'cliente141', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-09 14:27:00'),
(141, 'Esteban', 'Calderón Escobar', 'cliente142@example.com', '5550-0142', 'cliente142', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-12 15:34:00'),
(142, 'Natalia', 'Pérez Hernández', 'cliente143@example.com', '5550-0143', 'cliente143', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-15 16:41:00'),
(143, 'Oscar', 'Martínez Gómez', 'cliente144@example.com', '5550-0144', 'cliente144', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-18 08:48:00'),
(144, 'Isabel', 'Ramírez Díaz', 'cliente145@example.com', '5550-0145', 'cliente145', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-21 09:55:00'),
(145, 'Héctor', 'Méndez Ortiz', 'cliente146@example.com', '5550-0146', 'cliente146', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-24 10:02:00'),
(146, 'Elena', 'Reyes Cabrera', 'cliente147@example.com', '5550-0147', 'cliente147', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-27 11:09:00'),
(147, 'Roberto', 'Flores Mendoza', 'cliente148@example.com', '5550-0148', 'cliente148', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-30 12:16:00'),
(148, 'Mónica', 'Rojas Calderón', 'cliente149@example.com', '5550-0149', 'cliente149', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-04-02 13:23:00'),
(149, 'Andrés', 'Herrera Barrios', 'cliente150@example.com', '5550-0150', 'cliente150', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-04-05 14:30:00'),
(150, 'Mariana', 'Soto Villagrán', 'mariana.soto151@example.com', '5551-0151', 'marianasoto151', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-14 10:20:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`CategoriaID`),
  ADD UNIQUE KEY `Nombre` (`Nombre`),
  ADD KEY `FK_Categorias_Padre` (`CategoriaPadreID`);

--
-- Indices de la tabla `detalledevoluciones`
--
ALTER TABLE `detalledevoluciones`
  ADD PRIMARY KEY (`DetalleDevolucionID`),
  ADD UNIQUE KEY `UQ_DetalleDevoluciones` (`DevolucionID`,`DetalleOrdenID`),
  ADD KEY `FK_DetalleDevoluciones_DetalleOrdenes` (`DetalleOrdenID`);

--
-- Indices de la tabla `detallefacturas`
--
ALTER TABLE `detallefacturas`
  ADD PRIMARY KEY (`DetalleFacturaID`),
  ADD UNIQUE KEY `UQ_DetalleFacturas` (`FacturaID`,`DetalleOrdenID`),
  ADD KEY `FK_DetalleFacturas_DetalleOrdenes` (`DetalleOrdenID`);

--
-- Indices de la tabla `detalleordenes`
--
ALTER TABLE `detalleordenes`
  ADD PRIMARY KEY (`DetalleOrdenID`),
  ADD KEY `FK_DetalleOrdenes_Ordenes` (`OrdenID`),
  ADD KEY `FK_DetalleOrdenes_Productos` (`ProductoID`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`DevolucionID`),
  ADD KEY `FK_Devoluciones_Ordenes` (`OrdenID`);

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`DireccionID`),
  ADD KEY `FK_Direcciones_Usuarios` (`UsuarioID`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`FacturaID`),
  ADD UNIQUE KEY `NumeroFactura` (`NumeroFactura`),
  ADD KEY `FK_Facturas_Ordenes` (`OrdenID`);

--
-- Indices de la tabla `listadeseos`
--
ALTER TABLE `listadeseos`
  ADD PRIMARY KEY (`UsuarioID`,`ProductoID`),
  ADD KEY `FK_ListaDeseos_Productos` (`ProductoID`);

--
-- Indices de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`OrdenID`),
  ADD KEY `FK_Ordenes_Usuarios` (`UsuarioID`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`PagoID`),
  ADD KEY `FK_Pagos_Ordenes` (`OrdenID`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`ProductoID`),
  ADD UNIQUE KEY `SKU` (`SKU`),
  ADD KEY `FK_Productos_Categorias` (`CategoriaID`);

--
-- Indices de la tabla `productospromociones`
--
ALTER TABLE `productospromociones`
  ADD PRIMARY KEY (`ProductoID`,`PromocionID`),
  ADD KEY `FK_ProductosPromociones_Promociones` (`PromocionID`);

--
-- Indices de la tabla `productosproveedores`
--
ALTER TABLE `productosproveedores`
  ADD PRIMARY KEY (`ProductoID`,`ProveedorID`),
  ADD KEY `FK_ProductosProveedores_Proveedores` (`ProveedorID`);

--
-- Indices de la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD PRIMARY KEY (`PromocionID`),
  ADD UNIQUE KEY `CodigoCupon` (`CodigoCupon`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`ProveedorID`);

--
-- Indices de la tabla `resenas`
--
ALTER TABLE `resenas`
  ADD PRIMARY KEY (`ResenaID`),
  ADD UNIQUE KEY `UQ_Resenas_UsuarioProducto` (`UsuarioID`,`ProductoID`),
  ADD KEY `FK_Resenas_Productos` (`ProductoID`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`UsuarioID`),
  ADD UNIQUE KEY `Correo` (`Correo`),
  ADD UNIQUE KEY `Telefono` (`Telefono`),
  ADD UNIQUE KEY `Usuario` (`Usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `CategoriaID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalledevoluciones`
--
ALTER TABLE `detalledevoluciones`
  MODIFY `DetalleDevolucionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detallefacturas`
--
ALTER TABLE `detallefacturas`
  MODIFY `DetalleFacturaID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalleordenes`
--
ALTER TABLE `detalleordenes`
  MODIFY `DetalleOrdenID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `DevolucionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `DireccionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `FacturaID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `OrdenID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `PagoID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ProductoID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `PromocionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ProveedorID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resenas`
--
ALTER TABLE `resenas`
  MODIFY `ResenaID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `UsuarioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `FK_Categorias_Padre` FOREIGN KEY (`CategoriaPadreID`) REFERENCES `categorias` (`CategoriaID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `detalledevoluciones`
--
ALTER TABLE `detalledevoluciones`
  ADD CONSTRAINT `FK_DetalleDevoluciones_DetalleOrdenes` FOREIGN KEY (`DetalleOrdenID`) REFERENCES `detalleordenes` (`DetalleOrdenID`),
  ADD CONSTRAINT `FK_DetalleDevoluciones_Devoluciones` FOREIGN KEY (`DevolucionID`) REFERENCES `devoluciones` (`DevolucionID`);

--
-- Filtros para la tabla `detallefacturas`
--
ALTER TABLE `detallefacturas`
  ADD CONSTRAINT `FK_DetalleFacturas_DetalleOrdenes` FOREIGN KEY (`DetalleOrdenID`) REFERENCES `detalleordenes` (`DetalleOrdenID`),
  ADD CONSTRAINT `FK_DetalleFacturas_Facturas` FOREIGN KEY (`FacturaID`) REFERENCES `facturas` (`FacturaID`);

--
-- Filtros para la tabla `detalleordenes`
--
ALTER TABLE `detalleordenes`
  ADD CONSTRAINT `FK_DetalleOrdenes_Ordenes` FOREIGN KEY (`OrdenID`) REFERENCES `ordenes` (`OrdenID`),
  ADD CONSTRAINT `FK_DetalleOrdenes_Productos` FOREIGN KEY (`ProductoID`) REFERENCES `productos` (`ProductoID`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `FK_Devoluciones_Ordenes` FOREIGN KEY (`OrdenID`) REFERENCES `ordenes` (`OrdenID`);

--
-- Filtros para la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD CONSTRAINT `FK_Direcciones_Usuarios` FOREIGN KEY (`UsuarioID`) REFERENCES `usuarios` (`UsuarioID`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `FK_Facturas_Ordenes` FOREIGN KEY (`OrdenID`) REFERENCES `ordenes` (`OrdenID`);

--
-- Filtros para la tabla `listadeseos`
--
ALTER TABLE `listadeseos`
  ADD CONSTRAINT `FK_ListaDeseos_Productos` FOREIGN KEY (`ProductoID`) REFERENCES `productos` (`ProductoID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_ListaDeseos_Usuarios` FOREIGN KEY (`UsuarioID`) REFERENCES `usuarios` (`UsuarioID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD CONSTRAINT `FK_Ordenes_Usuarios` FOREIGN KEY (`UsuarioID`) REFERENCES `usuarios` (`UsuarioID`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `FK_Pagos_Ordenes` FOREIGN KEY (`OrdenID`) REFERENCES `ordenes` (`OrdenID`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `FK_Productos_Categorias` FOREIGN KEY (`CategoriaID`) REFERENCES `categorias` (`CategoriaID`);

--
-- Filtros para la tabla `productospromociones`
--
ALTER TABLE `productospromociones`
  ADD CONSTRAINT `FK_ProductosPromociones_Productos` FOREIGN KEY (`ProductoID`) REFERENCES `productos` (`ProductoID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_ProductosPromociones_Promociones` FOREIGN KEY (`PromocionID`) REFERENCES `promociones` (`PromocionID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `productosproveedores`
--
ALTER TABLE `productosproveedores`
  ADD CONSTRAINT `FK_ProductosProveedores_Productos` FOREIGN KEY (`ProductoID`) REFERENCES `productos` (`ProductoID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_ProductosProveedores_Proveedores` FOREIGN KEY (`ProveedorID`) REFERENCES `proveedores` (`ProveedorID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `resenas`
--
ALTER TABLE `resenas`
  ADD CONSTRAINT `FK_Resenas_Productos` FOREIGN KEY (`ProductoID`) REFERENCES `productos` (`ProductoID`),
  ADD CONSTRAINT `FK_Resenas_Usuarios` FOREIGN KEY (`UsuarioID`) REFERENCES `usuarios` (`UsuarioID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
