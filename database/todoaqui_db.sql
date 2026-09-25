-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-09-2026 a las 14:29:08
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
-- Base de datos: `todoaqui_db`
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

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`CategoriaID`, `Nombre`, `Descripcion`, `Estado`, `CategoriaPadreID`) VALUES
(1, 'Celulares y tablets', 'Selección de celulares y tablets para la tienda TodoAquí.', 'Activo', NULL),
(2, 'Computación', 'Selección de computación para la tienda TodoAquí.', 'Activo', NULL),
(3, 'Audio y video', 'Selección de audio y video para la tienda TodoAquí.', 'Activo', NULL),
(4, 'Gaming', 'Selección de gaming para la tienda TodoAquí.', 'Activo', NULL),
(5, 'Hogar inteligente', 'Selección de hogar inteligente para la tienda TodoAquí.', 'Activo', NULL),
(6, 'Electrodomésticos', 'Selección de electrodomésticos para la tienda TodoAquí.', 'Activo', NULL),
(7, 'Hogar y cocina', 'Selección de hogar y cocina para la tienda TodoAquí.', 'Activo', NULL),
(8, 'Moda y accesorios', 'Selección de moda y accesorios para la tienda TodoAquí.', 'Activo', NULL),
(9, 'Deportes y aire libre', 'Selección de deportes y aire libre para la tienda TodoAquí.', 'Activo', NULL),
(10, 'Belleza y cuidado personal', 'Selección de belleza y cuidado personal para la tienda TodoAquí.', 'Activo', NULL),
(11, 'Herramientas y ferretería', 'Selección de herramientas y ferretería para la tienda TodoAquí.', 'Activo', NULL),
(12, 'Mascotas', 'Selección de mascotas para la tienda TodoAquí.', 'Activo', NULL),
(13, 'Smartphones', 'Productos de smartphones de la categoría Celulares y tablets.', 'Activo', 1),
(14, 'Tablets', 'Productos de tablets de la categoría Celulares y tablets.', 'Activo', 1),
(15, 'Cargadores móviles', 'Productos de cargadores móviles de la categoría Celulares y tablets.', 'Activo', 1),
(16, 'Portátiles', 'Productos de portátiles de la categoría Computación.', 'Activo', 2),
(17, 'Monitores', 'Productos de monitores de la categoría Computación.', 'Activo', 2),
(18, 'Almacenamiento', 'Productos de almacenamiento de la categoría Computación.', 'Activo', 2),
(19, 'Audífonos', 'Productos de audífonos de la categoría Audio y video.', 'Activo', 3),
(20, 'Bocinas', 'Productos de bocinas de la categoría Audio y video.', 'Activo', 3),
(21, 'Televisores', 'Productos de televisores de la categoría Audio y video.', 'Activo', 3),
(22, 'Teclados gaming', 'Productos de teclados gaming de la categoría Gaming.', 'Activo', 4),
(23, 'Ratones gaming', 'Productos de ratones gaming de la categoría Gaming.', 'Activo', 4),
(24, 'Controles gaming', 'Productos de controles gaming de la categoría Gaming.', 'Activo', 4),
(25, 'Cámaras de seguridad', 'Productos de cámaras de seguridad de la categoría Hogar inteligente.', 'Activo', 5),
(26, 'Iluminación inteligente', 'Productos de iluminación inteligente de la categoría Hogar inteligente.', 'Activo', 5),
(27, 'Sensores domésticos', 'Productos de sensores domésticos de la categoría Hogar inteligente.', 'Activo', 5),
(28, 'Cocina eléctrica', 'Productos de cocina eléctrica de la categoría Electrodomésticos.', 'Activo', 6),
(29, 'Limpieza eléctrica', 'Productos de limpieza eléctrica de la categoría Electrodomésticos.', 'Activo', 6),
(30, 'Ventilación', 'Productos de ventilación de la categoría Electrodomésticos.', 'Activo', 6),
(31, 'Utensilios de cocina', 'Productos de utensilios de cocina de la categoría Hogar y cocina.', 'Activo', 7),
(32, 'Organización del hogar', 'Productos de organización del hogar de la categoría Hogar y cocina.', 'Activo', 7),
(33, 'Ropa de cama', 'Productos de ropa de cama de la categoría Hogar y cocina.', 'Activo', 7),
(34, 'Relojes inteligentes', 'Productos de relojes inteligentes de la categoría Moda y accesorios.', 'Activo', 8),
(35, 'Mochilas', 'Productos de mochilas de la categoría Moda y accesorios.', 'Activo', 8),
(36, 'Bolsos y carteras', 'Productos de bolsos y carteras de la categoría Moda y accesorios.', 'Activo', 8),
(37, 'Ciclismo', 'Productos de ciclismo de la categoría Deportes y aire libre.', 'Activo', 9),
(38, 'Entrenamiento en casa', 'Productos de entrenamiento en casa de la categoría Deportes y aire libre.', 'Activo', 9),
(39, 'Campismo', 'Productos de campismo de la categoría Deportes y aire libre.', 'Activo', 9),
(40, 'Higiene personal', 'Productos de higiene personal de la categoría Belleza y cuidado personal.', 'Activo', 10),
(41, 'Cuidado del cabello', 'Productos de cuidado del cabello de la categoría Belleza y cuidado personal.', 'Activo', 10),
(42, 'Cuidado de la piel', 'Productos de cuidado de la piel de la categoría Belleza y cuidado personal.', 'Activo', 10),
(43, 'Herramientas manuales', 'Productos de herramientas manuales de la categoría Herramientas y ferretería.', 'Activo', 11),
(44, 'Herramientas eléctricas', 'Productos de herramientas eléctricas de la categoría Herramientas y ferretería.', 'Activo', 11),
(45, 'Seguridad industrial', 'Productos de seguridad industrial de la categoría Herramientas y ferretería.', 'Activo', 11),
(46, 'Alimentación para mascotas', 'Productos de alimentación para mascotas de la categoría Mascotas.', 'Activo', 12),
(47, 'Juguetes para mascotas', 'Productos de juguetes para mascotas de la categoría Mascotas.', 'Activo', 12),
(48, 'Accesorios para mascotas', 'Productos de accesorios para mascotas de la categoría Mascotas.', 'Activo', 12);

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

--
-- Volcado de datos para la tabla `detalledevoluciones`
--

INSERT INTO `detalledevoluciones` (`DetalleDevolucionID`, `DevolucionID`, `DetalleOrdenID`, `Cantidad`, `Motivo`, `MontoReembolso`) VALUES
(1, 1, 1, 1, 'Revisión de una unidad del producto.', 3299.00),
(2, 2, 4, 1, 'Revisión de una unidad del producto.', 499.00),
(3, 3, 7, 1, 'Revisión de una unidad del producto.', 429.00),
(4, 4, 10, 1, 'Revisión de una unidad del producto.', 4599.00);

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

--
-- Volcado de datos para la tabla `detallefacturas`
--

INSERT INTO `detallefacturas` (`DetalleFacturaID`, `FacturaID`, `DetalleOrdenID`, `Descripcion`, `Cantidad`, `PrecioUnitario`, `Descuento`, `Impuesto`, `Subtotal`) VALUES
(1, 1, 1, 'Smartphone Nova X 256 GB', 1, 3299.00, 0.00, 0.00, 3299.00),
(2, 1, 2, 'Laptop Air 14” 16 GB RAM', 2, 5799.00, 0.00, 0.00, 11598.00),
(3, 1, 3, 'Audífonos Wave Pro ANC', 1, 649.00, 0.00, 0.00, 649.00),
(4, 2, 4, 'Teclado Mecánico RGB', 2, 499.00, 0.00, 0.00, 998.00),
(5, 2, 5, 'Smartwatch Active S', 1, 899.00, 0.00, 0.00, 899.00),
(6, 2, 6, 'Monitor UltraView 27”', 2, 1699.00, 0.00, 0.00, 3398.00),
(7, 3, 7, 'Bocina Pulse Bluetooth', 1, 429.00, 0.00, 0.00, 429.00),
(8, 3, 8, 'Cámara Home Secure 2K', 2, 599.00, 0.00, 0.00, 1198.00),
(9, 3, 9, 'Smartphone Nova Lite 128 GB', 1, 1899.00, 0.00, 0.00, 1899.00),
(10, 4, 10, 'Smartphone Aurora 512 GB', 2, 4599.00, 0.00, 0.00, 9198.00),
(11, 4, 11, 'Tablet Estudio 10 pulgadas', 1, 1299.00, 0.00, 0.00, 1299.00),
(12, 4, 12, 'Tablet Dibujo 12 pulgadas', 2, 2499.00, 0.00, 0.00, 4998.00),
(13, 5, 13, 'Tablet Infantil 8 pulgadas', 1, 899.00, 0.00, 0.00, 899.00),
(14, 5, 14, 'Cargador USB-C 30 W', 2, 129.00, 0.00, 0.00, 258.00),
(15, 5, 15, 'Batería portátil 20000 mAh', 1, 249.00, 0.00, 0.00, 249.00),
(16, 6, 16, 'Cargador inalámbrico 15 W', 2, 179.00, 0.00, 0.00, 358.00),
(17, 6, 17, 'Laptop Aula 15 pulgadas', 1, 3799.00, 0.00, 0.00, 3799.00),
(18, 6, 18, 'Laptop Diseño 16 pulgadas', 2, 8499.00, 0.00, 0.00, 16998.00),
(19, 7, 19, 'Monitor Oficina 24 pulgadas', 1, 1199.00, 0.00, 0.00, 1199.00),
(20, 7, 20, 'Monitor Curvo 32 pulgadas', 2, 2499.00, 0.00, 0.00, 4998.00),
(21, 7, 21, 'SSD NVMe 1 TB', 1, 599.00, 0.00, 0.00, 599.00),
(22, 8, 22, 'Memoria USB 128 GB', 2, 89.00, 0.00, 0.00, 178.00),
(23, 8, 23, 'Disco externo 2 TB', 1, 749.00, 0.00, 0.00, 749.00),
(24, 8, 24, 'Audífonos Studio Cable', 2, 249.00, 0.00, 0.00, 498.00),
(25, 9, 25, 'Audífonos Mini Inalámbricos', 1, 349.00, 0.00, 0.00, 349.00),
(26, 9, 26, 'Bocina Fiesta 40 W', 2, 799.00, 0.00, 0.00, 1598.00),
(27, 9, 27, 'Bocina Compacta 10 W', 1, 199.00, 0.00, 0.00, 199.00),
(28, 10, 28, 'Televisor Smart 32 pulgadas', 2, 1699.00, 0.00, 0.00, 3398.00),
(29, 10, 29, 'Televisor Smart 43 pulgadas', 1, 2799.00, 0.00, 0.00, 2799.00),
(30, 10, 30, 'Televisor UHD 55 pulgadas', 2, 4499.00, 0.00, 0.00, 8998.00),
(31, 11, 31, 'Teclado Compacto 60 por ciento', 1, 399.00, 0.00, 0.00, 399.00),
(32, 11, 32, 'Teclado Membrana Retroiluminado', 2, 229.00, 0.00, 0.00, 458.00),
(33, 11, 33, 'Ratón Precisión 12000 DPI', 1, 249.00, 0.00, 0.00, 249.00),
(34, 12, 34, 'Ratón Inalámbrico Arena', 2, 349.00, 0.00, 0.00, 698.00),
(35, 12, 35, 'Ratón Ligero Competición', 1, 429.00, 0.00, 0.00, 429.00),
(36, 12, 36, 'Control USB Universal', 2, 199.00, 0.00, 0.00, 398.00),
(37, 13, 37, 'Control Bluetooth Pro', 1, 399.00, 0.00, 0.00, 399.00),
(38, 13, 38, 'Volante de Carreras Básico', 2, 1299.00, 0.00, 0.00, 2598.00),
(39, 13, 39, 'Cámara Exterior IP65', 1, 799.00, 0.00, 0.00, 799.00),
(40, 14, 40, 'Cámara Interior Giratoria', 2, 449.00, 0.00, 0.00, 898.00),
(41, 14, 41, 'Bombilla Wi-Fi RGB', 1, 99.00, 0.00, 0.00, 99.00),
(42, 14, 42, 'Tira LED Inteligente 5 m', 2, 199.00, 0.00, 0.00, 398.00),
(43, 15, 43, 'Enchufe Inteligente Wi-Fi', 1, 149.00, 0.00, 0.00, 149.00),
(44, 15, 44, 'Sensor de Puerta Wi-Fi', 2, 129.00, 0.00, 0.00, 258.00),
(45, 15, 45, 'Sensor de Movimiento Interior', 1, 179.00, 0.00, 0.00, 179.00),
(46, 16, 46, 'Detector de Fugas de Agua', 2, 159.00, 0.00, 0.00, 318.00),
(47, 16, 47, 'Licuadora Familiar 1.5 L', 1, 349.00, 0.00, 0.00, 349.00),
(48, 16, 48, 'Cafetera de Goteo 12 Tazas', 2, 299.00, 0.00, 0.00, 598.00),
(49, 17, 49, 'Freidora de Aire 5 L', 1, 799.00, 0.00, 0.00, 799.00),
(50, 17, 50, 'Aspiradora Compacta 1200 W', 2, 599.00, 0.00, 0.00, 1198.00),
(51, 17, 51, 'Aspiradora de Mano Recargable', 1, 299.00, 0.00, 0.00, 299.00),
(52, 18, 52, 'Limpiador a Vapor Doméstico', 2, 649.00, 0.00, 0.00, 1298.00),
(53, 18, 53, 'Ventilador de Pedestal 16 pulgadas', 1, 249.00, 0.00, 0.00, 249.00),
(54, 18, 54, 'Ventilador de Escritorio USB', 2, 99.00, 0.00, 0.00, 198.00),
(55, 19, 55, 'Ventilador de Torre 80 cm', 1, 449.00, 0.00, 0.00, 449.00),
(56, 19, 56, 'Juego de Sartenes Antiadherentes', 2, 299.00, 0.00, 0.00, 598.00),
(57, 19, 57, 'Juego de Utensilios de Silicona', 1, 119.00, 0.00, 0.00, 119.00),
(58, 20, 58, 'Tabla de Cortar de Bambú', 2, 89.00, 0.00, 0.00, 178.00),
(59, 20, 59, 'Organizador Modular de Cajones', 1, 79.00, 0.00, 0.00, 79.00),
(60, 20, 60, 'Caja Plegable de Almacenamiento', 2, 99.00, 0.00, 0.00, 198.00),
(61, 21, 61, 'Estante Metálico de 4 Niveles', 1, 349.00, 0.00, 0.00, 349.00),
(62, 21, 62, 'Juego de Sábanas Matrimonial', 2, 249.00, 0.00, 0.00, 498.00),
(63, 21, 63, 'Almohada de Microfibra', 1, 99.00, 0.00, 0.00, 99.00),
(64, 22, 64, 'Cobertor Ligero Individual', 2, 159.00, 0.00, 0.00, 318.00),
(65, 22, 65, 'Reloj Deportivo Track', 1, 549.00, 0.00, 0.00, 549.00),
(66, 22, 66, 'Pulsera de Actividad Fit', 2, 299.00, 0.00, 0.00, 598.00),
(67, 23, 67, 'Mochila Urbana para Laptop', 1, 249.00, 0.00, 0.00, 249.00),
(68, 23, 68, 'Mochila Escolar Reforzada', 2, 179.00, 0.00, 0.00, 358.00),
(69, 23, 69, 'Mochila de Viaje 35 L', 1, 349.00, 0.00, 0.00, 349.00),
(70, 24, 70, 'Bolso Casual de Lona', 2, 149.00, 0.00, 0.00, 298.00),
(71, 24, 71, 'Cartera Compacta Unisex', 1, 89.00, 0.00, 0.00, 89.00),
(72, 24, 72, 'Bolso Cruzado Impermeable', 2, 129.00, 0.00, 0.00, 258.00),
(73, 25, 73, 'Casco de Ciclismo Ajustable', 1, 229.00, 0.00, 0.00, 229.00),
(74, 25, 74, 'Luz Recargable para Bicicleta', 2, 99.00, 0.00, 0.00, 198.00),
(75, 25, 75, 'Bomba de Aire Portátil', 1, 79.00, 0.00, 0.00, 79.00),
(76, 26, 76, 'Par de Mancuernas 5 kg', 2, 249.00, 0.00, 0.00, 498.00),
(77, 26, 77, 'Bandas de Resistencia Set', 1, 119.00, 0.00, 0.00, 119.00),
(78, 26, 78, 'Colchoneta de Yoga 6 mm', 2, 99.00, 0.00, 0.00, 198.00),
(79, 27, 79, 'Tienda de Campaña para 2 Personas', 1, 599.00, 0.00, 0.00, 599.00),
(80, 27, 80, 'Linterna LED Recargable', 2, 149.00, 0.00, 0.00, 298.00),
(81, 27, 81, 'Botella Térmica de 750 ml', 1, 129.00, 0.00, 0.00, 129.00),
(82, 28, 82, 'Cepillo Dental Eléctrico', 2, 199.00, 0.00, 0.00, 398.00),
(83, 28, 83, 'Kit de Aseo de Viaje', 1, 79.00, 0.00, 0.00, 79.00),
(84, 28, 84, 'Dispensador de Jabón Recargable', 2, 149.00, 0.00, 0.00, 298.00),
(85, 29, 85, 'Secadora Compacta 1800 W', 1, 229.00, 0.00, 0.00, 229.00),
(86, 29, 86, 'Plancha Cerámica para Cabello', 2, 279.00, 0.00, 0.00, 558.00),
(87, 29, 87, 'Cepillo Desenredante', 1, 49.00, 0.00, 0.00, 49.00),
(88, 30, 88, 'Rodillo Facial de Cuarzo', 2, 89.00, 0.00, 0.00, 178.00),
(89, 30, 89, 'Espejo de Tocador LED', 1, 199.00, 0.00, 0.00, 199.00),
(90, 30, 90, 'Cepillo Facial de Silicona', 2, 129.00, 0.00, 0.00, 258.00),
(91, 31, 91, 'Juego de Destornilladores 12 Piezas', 1, 129.00, 0.00, 0.00, 129.00),
(92, 31, 92, 'Martillo de Uña 16 oz', 2, 79.00, 0.00, 0.00, 158.00),
(93, 31, 93, 'Juego de Llaves Combinadas', 1, 249.00, 0.00, 0.00, 249.00),
(94, 32, 94, 'Taladro Inalámbrico 20 V', 2, 699.00, 0.00, 0.00, 1398.00),
(95, 32, 95, 'Lijadora Orbital 240 W', 1, 449.00, 0.00, 0.00, 449.00),
(96, 32, 96, 'Atornillador Recargable 4 V', 2, 199.00, 0.00, 0.00, 398.00);

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

--
-- Volcado de datos para la tabla `detalleordenes`
--

INSERT INTO `detalleordenes` (`DetalleOrdenID`, `OrdenID`, `ProductoID`, `Cantidad`, `PrecioUnitario`, `Descuento`, `Subtotal`) VALUES
(1, 1, 1, 1, 3299.00, 0.00, 3299.00),
(2, 1, 2, 2, 5799.00, 0.00, 11598.00),
(3, 1, 3, 1, 649.00, 0.00, 649.00),
(4, 2, 4, 2, 499.00, 0.00, 998.00),
(5, 2, 5, 1, 899.00, 0.00, 899.00),
(6, 2, 6, 2, 1699.00, 0.00, 3398.00),
(7, 3, 7, 1, 429.00, 0.00, 429.00),
(8, 3, 8, 2, 599.00, 0.00, 1198.00),
(9, 3, 9, 1, 1899.00, 0.00, 1899.00),
(10, 4, 10, 2, 4599.00, 0.00, 9198.00),
(11, 4, 11, 1, 1299.00, 0.00, 1299.00),
(12, 4, 12, 2, 2499.00, 0.00, 4998.00),
(13, 5, 13, 1, 899.00, 0.00, 899.00),
(14, 5, 14, 2, 129.00, 0.00, 258.00),
(15, 5, 15, 1, 249.00, 0.00, 249.00),
(16, 6, 16, 2, 179.00, 0.00, 358.00),
(17, 6, 17, 1, 3799.00, 0.00, 3799.00),
(18, 6, 18, 2, 8499.00, 0.00, 16998.00),
(19, 7, 19, 1, 1199.00, 0.00, 1199.00),
(20, 7, 20, 2, 2499.00, 0.00, 4998.00),
(21, 7, 21, 1, 599.00, 0.00, 599.00),
(22, 8, 22, 2, 89.00, 0.00, 178.00),
(23, 8, 23, 1, 749.00, 0.00, 749.00),
(24, 8, 24, 2, 249.00, 0.00, 498.00),
(25, 9, 25, 1, 349.00, 0.00, 349.00),
(26, 9, 26, 2, 799.00, 0.00, 1598.00),
(27, 9, 27, 1, 199.00, 0.00, 199.00),
(28, 10, 28, 2, 1699.00, 0.00, 3398.00),
(29, 10, 29, 1, 2799.00, 0.00, 2799.00),
(30, 10, 30, 2, 4499.00, 0.00, 8998.00),
(31, 11, 31, 1, 399.00, 0.00, 399.00),
(32, 11, 32, 2, 229.00, 0.00, 458.00),
(33, 11, 33, 1, 249.00, 0.00, 249.00),
(34, 12, 34, 2, 349.00, 0.00, 698.00),
(35, 12, 35, 1, 429.00, 0.00, 429.00),
(36, 12, 36, 2, 199.00, 0.00, 398.00),
(37, 13, 37, 1, 399.00, 0.00, 399.00),
(38, 13, 38, 2, 1299.00, 0.00, 2598.00),
(39, 13, 39, 1, 799.00, 0.00, 799.00),
(40, 14, 40, 2, 449.00, 0.00, 898.00),
(41, 14, 41, 1, 99.00, 0.00, 99.00),
(42, 14, 42, 2, 199.00, 0.00, 398.00),
(43, 15, 43, 1, 149.00, 0.00, 149.00),
(44, 15, 44, 2, 129.00, 0.00, 258.00),
(45, 15, 45, 1, 179.00, 0.00, 179.00),
(46, 16, 46, 2, 159.00, 0.00, 318.00),
(47, 16, 47, 1, 349.00, 0.00, 349.00),
(48, 16, 48, 2, 299.00, 0.00, 598.00),
(49, 17, 49, 1, 799.00, 0.00, 799.00),
(50, 17, 50, 2, 599.00, 0.00, 1198.00),
(51, 17, 51, 1, 299.00, 0.00, 299.00),
(52, 18, 52, 2, 649.00, 0.00, 1298.00),
(53, 18, 53, 1, 249.00, 0.00, 249.00),
(54, 18, 54, 2, 99.00, 0.00, 198.00),
(55, 19, 55, 1, 449.00, 0.00, 449.00),
(56, 19, 56, 2, 299.00, 0.00, 598.00),
(57, 19, 57, 1, 119.00, 0.00, 119.00),
(58, 20, 58, 2, 89.00, 0.00, 178.00),
(59, 20, 59, 1, 79.00, 0.00, 79.00),
(60, 20, 60, 2, 99.00, 0.00, 198.00),
(61, 21, 61, 1, 349.00, 0.00, 349.00),
(62, 21, 62, 2, 249.00, 0.00, 498.00),
(63, 21, 63, 1, 99.00, 0.00, 99.00),
(64, 22, 64, 2, 159.00, 0.00, 318.00),
(65, 22, 65, 1, 549.00, 0.00, 549.00),
(66, 22, 66, 2, 299.00, 0.00, 598.00),
(67, 23, 67, 1, 249.00, 0.00, 249.00),
(68, 23, 68, 2, 179.00, 0.00, 358.00),
(69, 23, 69, 1, 349.00, 0.00, 349.00),
(70, 24, 70, 2, 149.00, 0.00, 298.00),
(71, 24, 71, 1, 89.00, 0.00, 89.00),
(72, 24, 72, 2, 129.00, 0.00, 258.00),
(73, 25, 73, 1, 229.00, 0.00, 229.00),
(74, 25, 74, 2, 99.00, 0.00, 198.00),
(75, 25, 75, 1, 79.00, 0.00, 79.00),
(76, 26, 76, 2, 249.00, 0.00, 498.00),
(77, 26, 77, 1, 119.00, 0.00, 119.00),
(78, 26, 78, 2, 99.00, 0.00, 198.00),
(79, 27, 79, 1, 599.00, 0.00, 599.00),
(80, 27, 80, 2, 149.00, 0.00, 298.00),
(81, 27, 81, 1, 129.00, 0.00, 129.00),
(82, 28, 82, 2, 199.00, 0.00, 398.00),
(83, 28, 83, 1, 79.00, 0.00, 79.00),
(84, 28, 84, 2, 149.00, 0.00, 298.00),
(85, 29, 85, 1, 229.00, 0.00, 229.00),
(86, 29, 86, 2, 279.00, 0.00, 558.00),
(87, 29, 87, 1, 49.00, 0.00, 49.00),
(88, 30, 88, 2, 89.00, 0.00, 178.00),
(89, 30, 89, 1, 199.00, 0.00, 199.00),
(90, 30, 90, 2, 129.00, 0.00, 258.00),
(91, 31, 91, 1, 129.00, 0.00, 129.00),
(92, 31, 92, 2, 79.00, 0.00, 158.00),
(93, 31, 93, 1, 249.00, 0.00, 249.00),
(94, 32, 94, 2, 699.00, 0.00, 1398.00),
(95, 32, 95, 1, 449.00, 0.00, 449.00),
(96, 32, 96, 2, 199.00, 0.00, 398.00),
(97, 33, 97, 1, 49.00, 0.00, 49.00),
(98, 33, 98, 2, 59.00, 0.00, 118.00),
(99, 33, 99, 1, 89.00, 0.00, 89.00),
(100, 34, 100, 2, 159.00, 0.00, 318.00),
(101, 34, 101, 1, 139.00, 0.00, 139.00),
(102, 34, 102, 2, 49.00, 0.00, 98.00),
(103, 35, 103, 1, 39.00, 0.00, 39.00),
(104, 35, 104, 2, 199.00, 0.00, 398.00),
(105, 35, 105, 1, 59.00, 0.00, 59.00),
(106, 36, 106, 2, 69.00, 0.00, 138.00),
(107, 36, 107, 1, 249.00, 0.00, 249.00),
(108, 36, 108, 2, 89.00, 0.00, 178.00);

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

--
-- Volcado de datos para la tabla `devoluciones`
--

INSERT INTO `devoluciones` (`DevolucionID`, `OrdenID`, `FechaSolicitud`, `Motivo`, `Estado`, `MontoReembolso`, `Notas`) VALUES
(1, 1, '2026-08-09 16:00:00', 'Producto recibido con daño en el empaque', 'Solicitada', 3299.00, 'Caso de demostración; importe solicitado sujeto a aprobación.'),
(2, 2, '2026-08-10 16:00:00', 'Producto con funcionamiento intermitente', 'Aprobada', 499.00, 'Caso de demostración; importe solicitado sujeto a aprobación.'),
(3, 3, '2026-08-11 16:00:00', 'Solicitud fuera de la política de cambios', 'Rechazada', 429.00, 'Caso de demostración; importe solicitado sujeto a aprobación.'),
(4, 4, '2026-08-12 16:00:00', 'Accesorio recibido con defecto', 'Procesada', 4599.00, 'Reembolso parcial simulado; no se repuso inventario automáticamente.');

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
(1, 'Avenida Las Flores 11-03, Zona 2', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 3, '01001', 'Casa', 1),
(2, 'Calle del Comercio 12-06, Zona 3', 'Mixco', 'Guatemala', 'Guatemala', 4, '01057', 'Casa', 1),
(3, 'Avenida Reforma 13-09, Zona 4', 'Villa Nueva', 'Guatemala', 'Guatemala', 5, '01064', 'Casa', 1),
(4, 'Calle Principal 14-12, Zona 5', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 6, '01066', 'Casa', 1),
(5, 'Avenida Los Próceres 15-15, Zona 6', 'Amatitlán', 'Guatemala', 'Guatemala', 7, '01063', 'Casa', 1),
(6, 'Calle de la Paz 16-18, Zona 7', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 8, '03001', 'Casa', 1),
(7, 'Avenida del Bosque 17-21, Zona 8', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 9, '04001', 'Casa', 1),
(8, 'Calle Central 18-24, Zona 9', 'Escuintla', 'Escuintla', 'Guatemala', 10, '05001', 'Casa', 1),
(9, 'Avenida La Esperanza 19-27, Zona 10', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 11, '09001', 'Casa', 1),
(10, 'Calle Los Pinos 20-30, Zona 11', 'Totonicapán', 'Totonicapán', 'Guatemala', 12, '08001', 'Casa', 1),
(11, 'Avenida del Mercado 21-33, Zona 12', 'Sololá', 'Sololá', 'Guatemala', 13, '07001', 'Casa', 1),
(12, 'Calle Las Rosas 22-36, Zona 13', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 14, '13001', 'Casa', 1),
(13, 'Avenida del Lago 23-39, Zona 14', 'Cobán', 'Alta Verapaz', 'Guatemala', 15, '16001', 'Casa', 1),
(14, 'Calle San José 24-42, Zona 15', 'Salamá', 'Baja Verapaz', 'Guatemala', 16, '15001', 'Casa', 1),
(15, 'Avenida Los Alamos 25-45, Zona 16', 'Puerto Barrios', 'Izabal', 'Guatemala', 17, '18001', 'Casa', 1),
(16, 'Avenida Las Flores 26-48, Zona 17', 'Zacapa', 'Zacapa', 'Guatemala', 18, '19001', 'Casa', 1),
(17, 'Calle del Comercio 27-51, Zona 18', 'Chiquimula', 'Chiquimula', 'Guatemala', 19, '20001', 'Casa', 1),
(18, 'Avenida Reforma 28-54, Zona 1', 'Jalapa', 'Jalapa', 'Guatemala', 20, '21001', 'Casa', 1),
(19, 'Calle Principal 29-57, Zona 2', 'Jutiapa', 'Jutiapa', 'Guatemala', 21, '22001', 'Casa', 1),
(20, 'Avenida Los Próceres 30-60, Zona 3', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 22, '11001', 'Casa', 1),
(21, 'Calle de la Paz 31-63, Zona 4', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 23, '01001', 'Casa', 1),
(22, 'Avenida del Bosque 32-66, Zona 5', 'Mixco', 'Guatemala', 'Guatemala', 24, '01057', 'Casa', 1),
(23, 'Calle Central 33-69, Zona 6', 'Villa Nueva', 'Guatemala', 'Guatemala', 25, '01064', 'Casa', 1),
(24, 'Avenida La Esperanza 34-72, Zona 7', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 26, '01066', 'Casa', 1),
(25, 'Calle Los Pinos 35-75, Zona 8', 'Amatitlán', 'Guatemala', 'Guatemala', 27, '01063', 'Casa', 1),
(26, 'Avenida del Mercado 36-78, Zona 9', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 28, '03001', 'Casa', 1),
(27, 'Calle Las Rosas 37-81, Zona 10', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 29, '04001', 'Casa', 1),
(28, 'Avenida del Lago 38-84, Zona 11', 'Escuintla', 'Escuintla', 'Guatemala', 30, '05001', 'Casa', 1),
(29, 'Calle San José 39-87, Zona 12', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 31, '09001', 'Casa', 1),
(30, 'Avenida Los Alamos 40-00, Zona 13', 'Totonicapán', 'Totonicapán', 'Guatemala', 32, '08001', 'Casa', 1),
(31, 'Avenida Las Flores 41-03, Zona 14', 'Sololá', 'Sololá', 'Guatemala', 33, '07001', 'Casa', 1),
(32, 'Calle del Comercio 42-06, Zona 15', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 34, '13001', 'Casa', 1),
(33, 'Avenida Reforma 43-09, Zona 16', 'Cobán', 'Alta Verapaz', 'Guatemala', 35, '16001', 'Casa', 1),
(34, 'Calle Principal 44-12, Zona 17', 'Salamá', 'Baja Verapaz', 'Guatemala', 36, '15001', 'Casa', 1),
(35, 'Avenida Los Próceres 45-15, Zona 18', 'Puerto Barrios', 'Izabal', 'Guatemala', 37, '18001', 'Casa', 1),
(36, 'Calle de la Paz 46-18, Zona 1', 'Zacapa', 'Zacapa', 'Guatemala', 38, '19001', 'Casa', 1),
(37, 'Avenida del Bosque 47-21, Zona 2', 'Chiquimula', 'Chiquimula', 'Guatemala', 39, '20001', 'Casa', 1),
(38, 'Calle Central 48-24, Zona 3', 'Jalapa', 'Jalapa', 'Guatemala', 40, '21001', 'Casa', 1),
(39, 'Avenida La Esperanza 49-27, Zona 4', 'Jutiapa', 'Jutiapa', 'Guatemala', 41, '22001', 'Casa', 1),
(40, 'Calle Los Pinos 50-30, Zona 5', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 42, '11001', 'Casa', 1),
(41, 'Avenida del Mercado 51-33, Zona 6', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 43, '01001', 'Casa', 1),
(42, 'Calle Las Rosas 52-36, Zona 7', 'Mixco', 'Guatemala', 'Guatemala', 44, '01057', 'Casa', 1),
(43, 'Avenida del Lago 53-39, Zona 8', 'Villa Nueva', 'Guatemala', 'Guatemala', 45, '01064', 'Casa', 1),
(44, 'Calle San José 54-42, Zona 9', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 46, '01066', 'Casa', 1),
(45, 'Avenida Los Alamos 55-45, Zona 10', 'Amatitlán', 'Guatemala', 'Guatemala', 47, '01063', 'Casa', 1),
(46, 'Avenida Las Flores 56-48, Zona 11', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 48, '03001', 'Casa', 1),
(47, 'Calle del Comercio 57-51, Zona 12', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 49, '04001', 'Casa', 1),
(48, 'Avenida Reforma 58-54, Zona 13', 'Escuintla', 'Escuintla', 'Guatemala', 50, '05001', 'Casa', 1),
(49, 'Calle Principal 59-57, Zona 14', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 51, '09001', 'Casa', 1),
(50, 'Avenida Los Próceres 60-60, Zona 15', 'Totonicapán', 'Totonicapán', 'Guatemala', 52, '08001', 'Casa', 1),
(51, 'Calle de la Paz 61-63, Zona 16', 'Sololá', 'Sololá', 'Guatemala', 53, '07001', 'Casa', 1),
(52, 'Avenida del Bosque 62-66, Zona 17', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 54, '13001', 'Casa', 1),
(53, 'Calle Central 63-69, Zona 18', 'Cobán', 'Alta Verapaz', 'Guatemala', 55, '16001', 'Casa', 1),
(54, 'Avenida La Esperanza 64-72, Zona 1', 'Salamá', 'Baja Verapaz', 'Guatemala', 56, '15001', 'Casa', 1),
(55, 'Calle Los Pinos 65-75, Zona 2', 'Puerto Barrios', 'Izabal', 'Guatemala', 57, '18001', 'Casa', 1),
(56, 'Avenida del Mercado 66-78, Zona 3', 'Zacapa', 'Zacapa', 'Guatemala', 58, '19001', 'Casa', 1),
(57, 'Calle Las Rosas 67-81, Zona 4', 'Chiquimula', 'Chiquimula', 'Guatemala', 59, '20001', 'Casa', 1),
(58, 'Avenida del Lago 68-84, Zona 5', 'Jalapa', 'Jalapa', 'Guatemala', 60, '21001', 'Casa', 1),
(59, 'Calle San José 69-87, Zona 6', 'Jutiapa', 'Jutiapa', 'Guatemala', 61, '22001', 'Casa', 1),
(60, 'Avenida Los Alamos 70-00, Zona 7', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 62, '11001', 'Casa', 1),
(61, 'Avenida Las Flores 71-03, Zona 8', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 63, '01001', 'Casa', 1),
(62, 'Calle del Comercio 72-06, Zona 9', 'Mixco', 'Guatemala', 'Guatemala', 64, '01057', 'Casa', 1),
(63, 'Avenida Reforma 73-09, Zona 10', 'Villa Nueva', 'Guatemala', 'Guatemala', 65, '01064', 'Casa', 1),
(64, 'Calle Principal 74-12, Zona 11', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 66, '01066', 'Casa', 1),
(65, 'Avenida Los Próceres 75-15, Zona 12', 'Amatitlán', 'Guatemala', 'Guatemala', 67, '01063', 'Casa', 1),
(66, 'Calle de la Paz 76-18, Zona 13', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 68, '03001', 'Casa', 1),
(67, 'Avenida del Bosque 77-21, Zona 14', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 69, '04001', 'Casa', 1),
(68, 'Calle Central 78-24, Zona 15', 'Escuintla', 'Escuintla', 'Guatemala', 70, '05001', 'Casa', 1),
(69, 'Avenida La Esperanza 79-27, Zona 16', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 71, '09001', 'Casa', 1),
(70, 'Calle Los Pinos 80-30, Zona 17', 'Totonicapán', 'Totonicapán', 'Guatemala', 72, '08001', 'Casa', 1),
(71, 'Avenida del Mercado 81-33, Zona 18', 'Sololá', 'Sololá', 'Guatemala', 73, '07001', 'Casa', 1),
(72, 'Calle Las Rosas 82-36, Zona 1', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 74, '13001', 'Casa', 1),
(73, 'Avenida del Lago 83-39, Zona 2', 'Cobán', 'Alta Verapaz', 'Guatemala', 75, '16001', 'Casa', 1),
(74, 'Calle San José 84-42, Zona 3', 'Salamá', 'Baja Verapaz', 'Guatemala', 76, '15001', 'Casa', 1),
(75, 'Avenida Los Alamos 85-45, Zona 4', 'Puerto Barrios', 'Izabal', 'Guatemala', 77, '18001', 'Casa', 1),
(76, 'Avenida Las Flores 86-48, Zona 5', 'Zacapa', 'Zacapa', 'Guatemala', 78, '19001', 'Casa', 1),
(77, 'Calle del Comercio 87-51, Zona 6', 'Chiquimula', 'Chiquimula', 'Guatemala', 79, '20001', 'Casa', 1),
(78, 'Calle Principal 89-57, Zona 8', 'Jutiapa', 'Jutiapa', 'Guatemala', 80, '22001', 'Casa', 1),
(79, 'Avenida Los Próceres 90-60, Zona 9', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 81, '11001', 'Casa', 1),
(80, 'Calle de la Paz 91-63, Zona 10', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 82, '01001', 'Casa', 1),
(81, 'Avenida del Bosque 92-66, Zona 11', 'Mixco', 'Guatemala', 'Guatemala', 83, '01057', 'Casa', 1),
(82, 'Calle Central 93-69, Zona 12', 'Villa Nueva', 'Guatemala', 'Guatemala', 84, '01064', 'Casa', 1),
(83, 'Avenida La Esperanza 94-72, Zona 13', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 85, '01066', 'Casa', 1),
(84, 'Calle Los Pinos 95-75, Zona 14', 'Amatitlán', 'Guatemala', 'Guatemala', 86, '01063', 'Casa', 1),
(85, 'Avenida del Mercado 96-78, Zona 15', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 87, '03001', 'Casa', 1),
(86, 'Calle Las Rosas 97-81, Zona 16', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 88, '04001', 'Casa', 1),
(87, 'Avenida del Lago 98-84, Zona 17', 'Escuintla', 'Escuintla', 'Guatemala', 89, '05001', 'Casa', 1),
(88, 'Calle San José 99-87, Zona 18', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 90, '09001', 'Casa', 1),
(89, 'Avenida Los Alamos 100-00, Zona 1', 'Totonicapán', 'Totonicapán', 'Guatemala', 91, '08001', 'Casa', 1),
(90, 'Avenida Las Flores 101-03, Zona 2', 'Sololá', 'Sololá', 'Guatemala', 92, '07001', 'Casa', 1),
(91, 'Calle del Comercio 102-06, Zona 3', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 93, '13001', 'Casa', 1),
(92, 'Avenida Reforma 103-09, Zona 4', 'Cobán', 'Alta Verapaz', 'Guatemala', 94, '16001', 'Casa', 1),
(93, 'Calle Principal 104-12, Zona 5', 'Salamá', 'Baja Verapaz', 'Guatemala', 95, '15001', 'Casa', 1),
(94, 'Avenida Los Próceres 105-15, Zona 6', 'Puerto Barrios', 'Izabal', 'Guatemala', 96, '18001', 'Casa', 1),
(95, 'Calle de la Paz 106-18, Zona 7', 'Zacapa', 'Zacapa', 'Guatemala', 97, '19001', 'Casa', 1),
(96, 'Avenida del Bosque 107-21, Zona 8', 'Chiquimula', 'Chiquimula', 'Guatemala', 98, '20001', 'Casa', 1),
(97, 'Calle Central 108-24, Zona 9', 'Jalapa', 'Jalapa', 'Guatemala', 99, '21001', 'Casa', 1),
(98, 'Avenida La Esperanza 109-27, Zona 10', 'Jutiapa', 'Jutiapa', 'Guatemala', 100, '22001', 'Casa', 1),
(99, 'Calle Los Pinos 110-30, Zona 11', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 101, '11001', 'Casa', 1),
(100, 'Avenida del Mercado 111-33, Zona 12', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 102, '01001', 'Casa', 1),
(101, 'Calle Las Rosas 112-36, Zona 13', 'Mixco', 'Guatemala', 'Guatemala', 103, '01057', 'Casa', 1),
(102, 'Avenida del Lago 113-39, Zona 14', 'Villa Nueva', 'Guatemala', 'Guatemala', 104, '01064', 'Casa', 1),
(103, 'Calle San José 114-42, Zona 15', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 105, '01066', 'Casa', 1),
(104, 'Avenida Los Alamos 115-45, Zona 16', 'Amatitlán', 'Guatemala', 'Guatemala', 106, '01063', 'Casa', 1),
(105, 'Avenida Las Flores 116-48, Zona 17', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 107, '03001', 'Casa', 1),
(106, 'Calle del Comercio 117-51, Zona 18', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 108, '04001', 'Casa', 1),
(107, 'Avenida Reforma 118-54, Zona 1', 'Escuintla', 'Escuintla', 'Guatemala', 109, '05001', 'Casa', 1),
(108, 'Calle Principal 119-57, Zona 2', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 110, '09001', 'Casa', 1),
(109, 'Avenida Los Próceres 120-60, Zona 3', 'Totonicapán', 'Totonicapán', 'Guatemala', 111, '08001', 'Casa', 1),
(110, 'Calle de la Paz 121-63, Zona 4', 'Sololá', 'Sololá', 'Guatemala', 112, '07001', 'Casa', 1),
(111, 'Avenida del Bosque 122-66, Zona 5', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 113, '13001', 'Casa', 1),
(112, 'Calle Central 123-69, Zona 6', 'Cobán', 'Alta Verapaz', 'Guatemala', 114, '16001', 'Casa', 1),
(113, 'Avenida La Esperanza 124-72, Zona 7', 'Salamá', 'Baja Verapaz', 'Guatemala', 115, '15001', 'Casa', 1),
(114, 'Calle Los Pinos 125-75, Zona 8', 'Puerto Barrios', 'Izabal', 'Guatemala', 116, '18001', 'Casa', 1),
(115, 'Avenida del Mercado 126-78, Zona 9', 'Zacapa', 'Zacapa', 'Guatemala', 117, '19001', 'Casa', 1),
(116, 'Calle Las Rosas 127-81, Zona 10', 'Chiquimula', 'Chiquimula', 'Guatemala', 118, '20001', 'Casa', 1),
(117, 'Avenida del Lago 128-84, Zona 11', 'Jalapa', 'Jalapa', 'Guatemala', 119, '21001', 'Casa', 1),
(118, 'Calle San José 129-87, Zona 12', 'Jutiapa', 'Jutiapa', 'Guatemala', 120, '22001', 'Casa', 1),
(119, 'Avenida Los Alamos 130-00, Zona 13', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 121, '11001', 'Casa', 1),
(120, 'Avenida Las Flores 131-03, Zona 14', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 122, '01001', 'Casa', 1),
(121, 'Calle del Comercio 132-06, Zona 15', 'Mixco', 'Guatemala', 'Guatemala', 123, '01057', 'Casa', 1),
(122, 'Avenida Reforma 133-09, Zona 16', 'Villa Nueva', 'Guatemala', 'Guatemala', 124, '01064', 'Casa', 1),
(123, 'Calle Principal 134-12, Zona 17', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 125, '01066', 'Casa', 1),
(124, 'Avenida Los Próceres 135-15, Zona 18', 'Amatitlán', 'Guatemala', 'Guatemala', 126, '01063', 'Casa', 1),
(125, 'Calle de la Paz 136-18, Zona 1', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 127, '03001', 'Casa', 1),
(126, 'Avenida del Bosque 137-21, Zona 2', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 128, '04001', 'Casa', 1),
(127, 'Calle Central 138-24, Zona 3', 'Escuintla', 'Escuintla', 'Guatemala', 129, '05001', 'Casa', 1),
(128, 'Avenida La Esperanza 139-27, Zona 4', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 130, '09001', 'Casa', 1),
(129, 'Calle Los Pinos 140-30, Zona 5', 'Totonicapán', 'Totonicapán', 'Guatemala', 131, '08001', 'Casa', 1),
(130, 'Avenida del Mercado 141-33, Zona 6', 'Sololá', 'Sololá', 'Guatemala', 132, '07001', 'Casa', 1),
(131, 'Calle Las Rosas 142-36, Zona 7', 'Huehuetenango', 'Huehuetenango', 'Guatemala', 133, '13001', 'Casa', 1),
(132, 'Avenida del Lago 143-39, Zona 8', 'Cobán', 'Alta Verapaz', 'Guatemala', 134, '16001', 'Casa', 1),
(133, 'Calle San José 144-42, Zona 9', 'Salamá', 'Baja Verapaz', 'Guatemala', 135, '15001', 'Casa', 1),
(134, 'Avenida Los Alamos 145-45, Zona 10', 'Puerto Barrios', 'Izabal', 'Guatemala', 136, '18001', 'Casa', 1),
(135, 'Avenida Las Flores 146-48, Zona 11', 'Zacapa', 'Zacapa', 'Guatemala', 137, '19001', 'Casa', 1),
(136, 'Calle del Comercio 147-51, Zona 12', 'Chiquimula', 'Chiquimula', 'Guatemala', 138, '20001', 'Casa', 1),
(137, 'Avenida Reforma 148-54, Zona 13', 'Jalapa', 'Jalapa', 'Guatemala', 139, '21001', 'Casa', 1),
(138, 'Calle Principal 149-57, Zona 14', 'Jutiapa', 'Jutiapa', 'Guatemala', 140, '22001', 'Casa', 1),
(139, 'Avenida Los Próceres 150-60, Zona 15', 'Retalhuleu', 'Retalhuleu', 'Guatemala', 141, '11001', 'Casa', 1),
(140, 'Calle de la Paz 151-63, Zona 16', 'Ciudad de Guatemala', 'Guatemala', 'Guatemala', 142, '01001', 'Casa', 1),
(141, 'Avenida del Bosque 152-66, Zona 17', 'Mixco', 'Guatemala', 'Guatemala', 143, '01057', 'Casa', 1),
(142, 'Calle Central 153-69, Zona 18', 'Villa Nueva', 'Guatemala', 'Guatemala', 144, '01064', 'Casa', 1),
(143, 'Avenida La Esperanza 154-72, Zona 1', 'San Miguel Petapa', 'Guatemala', 'Guatemala', 145, '01066', 'Casa', 1),
(144, 'Calle Los Pinos 155-75, Zona 2', 'Amatitlán', 'Guatemala', 'Guatemala', 146, '01063', 'Casa', 1),
(145, 'Avenida del Mercado 156-78, Zona 3', 'Antigua Guatemala', 'Sacatepéquez', 'Guatemala', 147, '03001', 'Casa', 1),
(146, 'Calle Las Rosas 157-81, Zona 4', 'Chimaltenango', 'Chimaltenango', 'Guatemala', 148, '04001', 'Casa', 1),
(147, 'Avenida del Lago 158-84, Zona 5', 'Escuintla', 'Escuintla', 'Guatemala', 149, '05001', 'Casa', 1),
(148, 'Calle San José 159-87, Zona 6', 'Quetzaltenango', 'Quetzaltenango', 'Guatemala', 150, '09001', 'Casa', 1),
(149, 'Avenida Los Alamos 160-00, Zona 7', 'Totonicapán', 'Totonicapán', 'Guatemala', 151, '08001', 'Casa', 1),
(150, 'Calle Las Jacarandas 24-18, Zona 3', 'San Lucas Sacatepéquez', 'Sacatepéquez', 'Guatemala', 152, '03008', 'Casa', 1);

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

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`FacturaID`, `NumeroFactura`, `FechaEmision`, `OrdenID`, `Nombre`, `NIT`, `Direccion`, `Subtotal`, `ImpuestoTotal`, `DescuentoTotal`, `Total`, `Notas`, `Estado`) VALUES
(1, 'DEMO-2026-00001', '2026-08-01 12:00:00', 1, 'Cliente de demostración 3', 'CF', 'Dirección de demostración 1, zona 1, Ciudad de Guatemala', 15546.00, 0.00, 0.00, 15546.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(2, 'DEMO-2026-00002', '2026-08-02 12:00:00', 2, 'Cliente de demostración 4', 'CF', 'Dirección de demostración 2, zona 2, Ciudad de Guatemala', 5295.00, 0.00, 0.00, 5295.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(3, 'DEMO-2026-00003', '2026-08-03 12:00:00', 3, 'Cliente de demostración 5', 'CF', 'Dirección de demostración 3, zona 3, Ciudad de Guatemala', 3526.00, 0.00, 0.00, 3526.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(4, 'DEMO-2026-00004', '2026-08-04 12:00:00', 4, 'Cliente de demostración 6', 'CF', 'Dirección de demostración 4, zona 4, Ciudad de Guatemala', 15495.00, 0.00, 0.00, 15495.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(5, 'DEMO-2026-00005', '2026-08-05 12:00:00', 5, 'Cliente de demostración 7', 'CF', 'Dirección de demostración 5, zona 5, Ciudad de Guatemala', 1406.00, 0.00, 0.00, 1406.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(6, 'DEMO-2026-00006', '2026-08-06 12:00:00', 6, 'Cliente de demostración 8', 'CF', 'Dirección de demostración 6, zona 6, Ciudad de Guatemala', 21155.00, 0.00, 0.00, 21155.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(7, 'DEMO-2026-00007', '2026-08-07 12:00:00', 7, 'Cliente de demostración 9', 'CF', 'Dirección de demostración 7, zona 7, Ciudad de Guatemala', 6796.00, 0.00, 0.00, 6796.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(8, 'DEMO-2026-00008', '2026-08-08 12:00:00', 8, 'Cliente de demostración 10', 'CF', 'Dirección de demostración 8, zona 8, Ciudad de Guatemala', 1425.00, 0.00, 0.00, 1425.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(9, 'DEMO-2026-00009', '2026-08-09 12:00:00', 9, 'Cliente de demostración 11', 'CF', 'Dirección de demostración 9, zona 9, Ciudad de Guatemala', 2146.00, 0.00, 0.00, 2146.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(10, 'DEMO-2026-00010', '2026-08-10 12:00:00', 10, 'Cliente de demostración 13', 'CF', 'Dirección de demostración 10, zona 10, Ciudad de Guatemala', 15195.00, 0.00, 0.00, 15195.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(11, 'DEMO-2026-00011', '2026-08-11 12:00:00', 11, 'Cliente de demostración 14', 'CF', 'Dirección de demostración 11, zona 11, Ciudad de Guatemala', 1106.00, 0.00, 0.00, 1106.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(12, 'DEMO-2026-00012', '2026-08-12 12:00:00', 12, 'Cliente de demostración 15', 'CF', 'Dirección de demostración 12, zona 12, Ciudad de Guatemala', 1525.00, 0.00, 0.00, 1525.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(13, 'DEMO-2026-00013', '2026-08-13 12:00:00', 13, 'Cliente de demostración 16', 'CF', 'Dirección de demostración 13, zona 1, Ciudad de Guatemala', 3796.00, 0.00, 0.00, 3796.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(14, 'DEMO-2026-00014', '2026-08-14 12:00:00', 14, 'Cliente de demostración 17', 'CF', 'Dirección de demostración 14, zona 2, Ciudad de Guatemala', 1395.00, 0.00, 0.00, 1395.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(15, 'DEMO-2026-00015', '2026-08-15 12:00:00', 15, 'Cliente de demostración 18', 'CF', 'Dirección de demostración 15, zona 3, Ciudad de Guatemala', 586.00, 0.00, 0.00, 586.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(16, 'DEMO-2026-00016', '2026-08-16 12:00:00', 16, 'Cliente de demostración 19', 'CF', 'Dirección de demostración 16, zona 4, Ciudad de Guatemala', 1265.00, 0.00, 0.00, 1265.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(17, 'DEMO-2026-00017', '2026-08-17 12:00:00', 17, 'Cliente de demostración 20', 'CF', 'Dirección de demostración 17, zona 5, Ciudad de Guatemala', 2296.00, 0.00, 0.00, 2296.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(18, 'DEMO-2026-00018', '2026-08-18 12:00:00', 18, 'Cliente de demostración 21', 'CF', 'Dirección de demostración 18, zona 6, Ciudad de Guatemala', 1745.00, 0.00, 0.00, 1745.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(19, 'DEMO-2026-00019', '2026-08-19 12:00:00', 19, 'Cliente de demostración 23', 'CF', 'Dirección de demostración 19, zona 7, Ciudad de Guatemala', 1166.00, 0.00, 0.00, 1166.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(20, 'DEMO-2026-00020', '2026-08-20 12:00:00', 20, 'Cliente de demostración 24', 'CF', 'Dirección de demostración 20, zona 8, Ciudad de Guatemala', 455.00, 0.00, 0.00, 455.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(21, 'DEMO-2026-00021', '2026-08-21 12:00:00', 21, 'Cliente de demostración 25', 'CF', 'Dirección de demostración 21, zona 9, Ciudad de Guatemala', 946.00, 0.00, 0.00, 946.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(22, 'DEMO-2026-00022', '2026-08-22 12:00:00', 22, 'Cliente de demostración 26', 'CF', 'Dirección de demostración 22, zona 10, Ciudad de Guatemala', 1465.00, 0.00, 0.00, 1465.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(23, 'DEMO-2026-00023', '2026-08-23 12:00:00', 23, 'Cliente de demostración 27', 'CF', 'Dirección de demostración 23, zona 11, Ciudad de Guatemala', 956.00, 0.00, 0.00, 956.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(24, 'DEMO-2026-00024', '2026-08-24 12:00:00', 24, 'Cliente de demostración 28', 'CF', 'Dirección de demostración 24, zona 12, Ciudad de Guatemala', 645.00, 0.00, 0.00, 645.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(25, 'DEMO-2026-00025', '2026-08-25 12:00:00', 25, 'Cliente de demostración 29', 'CF', 'Dirección de demostración 25, zona 1, Ciudad de Guatemala', 506.00, 0.00, 0.00, 506.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(26, 'DEMO-2026-00026', '2026-08-26 12:00:00', 26, 'Cliente de demostración 30', 'CF', 'Dirección de demostración 26, zona 2, Ciudad de Guatemala', 815.00, 0.00, 0.00, 815.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(27, 'DEMO-2026-00027', '2026-08-27 12:00:00', 27, 'Cliente de demostración 31', 'CF', 'Dirección de demostración 27, zona 3, Ciudad de Guatemala', 1026.00, 0.00, 0.00, 1026.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(28, 'DEMO-2026-00028', '2026-08-28 12:00:00', 28, 'Cliente de demostración 33', 'CF', 'Dirección de demostración 28, zona 4, Ciudad de Guatemala', 775.00, 0.00, 0.00, 775.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(29, 'DEMO-2026-00029', '2026-08-29 12:00:00', 29, 'Cliente de demostración 34', 'CF', 'Dirección de demostración 29, zona 5, Ciudad de Guatemala', 836.00, 0.00, 0.00, 836.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(30, 'DEMO-2026-00030', '2026-08-30 12:00:00', 30, 'Cliente de demostración 35', 'CF', 'Dirección de demostración 30, zona 6, Ciudad de Guatemala', 635.00, 0.00, 0.00, 635.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(31, 'DEMO-2026-00031', '2026-08-31 12:00:00', 31, 'Cliente de demostración 36', 'CF', 'Dirección de demostración 31, zona 7, Ciudad de Guatemala', 536.00, 0.00, 0.00, 536.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida'),
(32, 'DEMO-2026-00032', '2026-09-01 12:00:00', 32, 'Cliente de demostración 37', 'CF', 'Dirección de demostración 32, zona 8, Ciudad de Guatemala', 2245.00, 0.00, 0.00, 2245.00, 'Documento interno de demostración; sin validez fiscal.', 'Emitida');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `listadeseos`
--

CREATE TABLE `listadeseos` (
  `UsuarioID` int(11) NOT NULL,
  `ProductoID` int(11) NOT NULL,
  `FechaAgregado` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `listadeseos`
--

INSERT INTO `listadeseos` (`UsuarioID`, `ProductoID`, `FechaAgregado`) VALUES
(3, 16, '2026-08-02 14:00:00'),
(3, 17, '2026-08-02 14:00:00'),
(4, 19, '2026-08-03 14:00:00'),
(4, 20, '2026-08-03 14:00:00'),
(5, 22, '2026-08-04 14:00:00'),
(5, 23, '2026-08-04 14:00:00'),
(6, 25, '2026-08-05 14:00:00'),
(6, 26, '2026-08-05 14:00:00'),
(7, 28, '2026-08-06 14:00:00'),
(7, 29, '2026-08-06 14:00:00'),
(8, 31, '2026-08-07 14:00:00'),
(8, 32, '2026-08-07 14:00:00'),
(9, 34, '2026-08-08 14:00:00'),
(9, 35, '2026-08-08 14:00:00'),
(10, 37, '2026-08-09 14:00:00'),
(10, 38, '2026-08-09 14:00:00'),
(11, 40, '2026-08-10 14:00:00'),
(11, 41, '2026-08-10 14:00:00'),
(13, 43, '2026-08-11 14:00:00'),
(13, 44, '2026-08-11 14:00:00'),
(14, 46, '2026-08-12 14:00:00'),
(14, 47, '2026-08-12 14:00:00'),
(15, 49, '2026-08-13 14:00:00'),
(15, 50, '2026-08-13 14:00:00'),
(16, 52, '2026-08-14 14:00:00'),
(16, 53, '2026-08-14 14:00:00'),
(17, 55, '2026-08-15 14:00:00'),
(17, 56, '2026-08-15 14:00:00'),
(18, 58, '2026-08-16 14:00:00'),
(18, 59, '2026-08-16 14:00:00'),
(19, 61, '2026-08-17 14:00:00'),
(19, 62, '2026-08-17 14:00:00'),
(20, 64, '2026-08-18 14:00:00'),
(20, 65, '2026-08-18 14:00:00'),
(21, 67, '2026-08-19 14:00:00'),
(21, 68, '2026-08-19 14:00:00'),
(23, 70, '2026-08-20 14:00:00'),
(23, 71, '2026-08-20 14:00:00'),
(24, 73, '2026-08-21 14:00:00'),
(24, 74, '2026-08-21 14:00:00'),
(25, 76, '2026-08-22 14:00:00'),
(25, 77, '2026-08-22 14:00:00'),
(26, 79, '2026-08-23 14:00:00'),
(26, 80, '2026-08-23 14:00:00'),
(27, 82, '2026-08-24 14:00:00'),
(27, 83, '2026-08-24 14:00:00'),
(28, 85, '2026-08-25 14:00:00'),
(28, 86, '2026-08-25 14:00:00'),
(29, 88, '2026-08-26 14:00:00'),
(29, 89, '2026-08-26 14:00:00'),
(30, 91, '2026-08-27 14:00:00'),
(30, 92, '2026-08-27 14:00:00'),
(31, 94, '2026-08-28 14:00:00'),
(31, 95, '2026-08-28 14:00:00'),
(33, 97, '2026-08-29 14:00:00'),
(33, 98, '2026-08-29 14:00:00'),
(34, 100, '2026-08-30 14:00:00'),
(34, 101, '2026-08-30 14:00:00'),
(35, 103, '2026-08-31 14:00:00'),
(35, 104, '2026-08-31 14:00:00'),
(36, 106, '2026-09-01 14:00:00'),
(36, 107, '2026-09-01 14:00:00'),
(37, 1, '2026-09-02 14:00:00'),
(37, 2, '2026-09-02 14:00:00'),
(38, 4, '2026-09-03 14:00:00'),
(38, 5, '2026-09-03 14:00:00'),
(39, 7, '2026-09-04 14:00:00'),
(39, 8, '2026-09-04 14:00:00'),
(40, 10, '2026-09-05 14:00:00'),
(40, 11, '2026-09-05 14:00:00'),
(41, 13, '2026-09-06 14:00:00'),
(41, 14, '2026-09-06 14:00:00');

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

--
-- Volcado de datos para la tabla `ordenes`
--

INSERT INTO `ordenes` (`OrdenID`, `UsuarioID`, `FechaOrden`, `DireccionPago`, `DireccionEnvio`, `Subtotal`, `DescuentoTotal`, `ImpuestoTotal`, `CostoEnvio`, `Total`, `Estado`) VALUES
(1, 3, '2026-08-01 10:00:00', 'Dirección de demostración 1, zona 1, Ciudad de Guatemala', 'Dirección de demostración 1, zona 1, Ciudad de Guatemala', 15546.00, 0.00, 0.00, 0.00, 15546.00, 'Entregada'),
(2, 4, '2026-08-02 10:00:00', 'Dirección de demostración 2, zona 2, Ciudad de Guatemala', 'Dirección de demostración 2, zona 2, Ciudad de Guatemala', 5295.00, 0.00, 0.00, 0.00, 5295.00, 'Entregada'),
(3, 5, '2026-08-03 10:00:00', 'Dirección de demostración 3, zona 3, Ciudad de Guatemala', 'Dirección de demostración 3, zona 3, Ciudad de Guatemala', 3526.00, 0.00, 0.00, 0.00, 3526.00, 'Entregada'),
(4, 6, '2026-08-04 10:00:00', 'Dirección de demostración 4, zona 4, Ciudad de Guatemala', 'Dirección de demostración 4, zona 4, Ciudad de Guatemala', 15495.00, 0.00, 0.00, 0.00, 15495.00, 'Entregada'),
(5, 7, '2026-08-05 10:00:00', 'Dirección de demostración 5, zona 5, Ciudad de Guatemala', 'Dirección de demostración 5, zona 5, Ciudad de Guatemala', 1406.00, 0.00, 0.00, 0.00, 1406.00, 'Entregada'),
(6, 8, '2026-08-06 10:00:00', 'Dirección de demostración 6, zona 6, Ciudad de Guatemala', 'Dirección de demostración 6, zona 6, Ciudad de Guatemala', 21155.00, 0.00, 0.00, 0.00, 21155.00, 'Entregada'),
(7, 9, '2026-08-07 10:00:00', 'Dirección de demostración 7, zona 7, Ciudad de Guatemala', 'Dirección de demostración 7, zona 7, Ciudad de Guatemala', 6796.00, 0.00, 0.00, 0.00, 6796.00, 'Entregada'),
(8, 10, '2026-08-08 10:00:00', 'Dirección de demostración 8, zona 8, Ciudad de Guatemala', 'Dirección de demostración 8, zona 8, Ciudad de Guatemala', 1425.00, 0.00, 0.00, 0.00, 1425.00, 'Entregada'),
(9, 11, '2026-08-09 10:00:00', 'Dirección de demostración 9, zona 9, Ciudad de Guatemala', 'Dirección de demostración 9, zona 9, Ciudad de Guatemala', 2146.00, 0.00, 0.00, 0.00, 2146.00, 'Entregada'),
(10, 13, '2026-08-10 10:00:00', 'Dirección de demostración 10, zona 10, Ciudad de Guatemala', 'Dirección de demostración 10, zona 10, Ciudad de Guatemala', 15195.00, 0.00, 0.00, 0.00, 15195.00, 'Entregada'),
(11, 14, '2026-08-11 10:00:00', 'Dirección de demostración 11, zona 11, Ciudad de Guatemala', 'Dirección de demostración 11, zona 11, Ciudad de Guatemala', 1106.00, 0.00, 0.00, 0.00, 1106.00, 'Entregada'),
(12, 15, '2026-08-12 10:00:00', 'Dirección de demostración 12, zona 12, Ciudad de Guatemala', 'Dirección de demostración 12, zona 12, Ciudad de Guatemala', 1525.00, 0.00, 0.00, 0.00, 1525.00, 'Entregada'),
(13, 16, '2026-08-13 10:00:00', 'Dirección de demostración 13, zona 1, Ciudad de Guatemala', 'Dirección de demostración 13, zona 1, Ciudad de Guatemala', 3796.00, 0.00, 0.00, 0.00, 3796.00, 'Entregada'),
(14, 17, '2026-08-14 10:00:00', 'Dirección de demostración 14, zona 2, Ciudad de Guatemala', 'Dirección de demostración 14, zona 2, Ciudad de Guatemala', 1395.00, 0.00, 0.00, 0.00, 1395.00, 'Entregada'),
(15, 18, '2026-08-15 10:00:00', 'Dirección de demostración 15, zona 3, Ciudad de Guatemala', 'Dirección de demostración 15, zona 3, Ciudad de Guatemala', 586.00, 0.00, 0.00, 0.00, 586.00, 'Entregada'),
(16, 19, '2026-08-16 10:00:00', 'Dirección de demostración 16, zona 4, Ciudad de Guatemala', 'Dirección de demostración 16, zona 4, Ciudad de Guatemala', 1265.00, 0.00, 0.00, 0.00, 1265.00, 'Entregada'),
(17, 20, '2026-08-17 10:00:00', 'Dirección de demostración 17, zona 5, Ciudad de Guatemala', 'Dirección de demostración 17, zona 5, Ciudad de Guatemala', 2296.00, 0.00, 0.00, 0.00, 2296.00, 'Entregada'),
(18, 21, '2026-08-18 10:00:00', 'Dirección de demostración 18, zona 6, Ciudad de Guatemala', 'Dirección de demostración 18, zona 6, Ciudad de Guatemala', 1745.00, 0.00, 0.00, 0.00, 1745.00, 'Entregada'),
(19, 23, '2026-08-19 10:00:00', 'Dirección de demostración 19, zona 7, Ciudad de Guatemala', 'Dirección de demostración 19, zona 7, Ciudad de Guatemala', 1166.00, 0.00, 0.00, 0.00, 1166.00, 'Enviada'),
(20, 24, '2026-08-20 10:00:00', 'Dirección de demostración 20, zona 8, Ciudad de Guatemala', 'Dirección de demostración 20, zona 8, Ciudad de Guatemala', 455.00, 0.00, 0.00, 0.00, 455.00, 'Enviada'),
(21, 25, '2026-08-21 10:00:00', 'Dirección de demostración 21, zona 9, Ciudad de Guatemala', 'Dirección de demostración 21, zona 9, Ciudad de Guatemala', 946.00, 0.00, 0.00, 0.00, 946.00, 'Enviada'),
(22, 26, '2026-08-22 10:00:00', 'Dirección de demostración 22, zona 10, Ciudad de Guatemala', 'Dirección de demostración 22, zona 10, Ciudad de Guatemala', 1465.00, 0.00, 0.00, 0.00, 1465.00, 'Enviada'),
(23, 27, '2026-08-23 10:00:00', 'Dirección de demostración 23, zona 11, Ciudad de Guatemala', 'Dirección de demostración 23, zona 11, Ciudad de Guatemala', 956.00, 0.00, 0.00, 0.00, 956.00, 'Enviada'),
(24, 28, '2026-08-24 10:00:00', 'Dirección de demostración 24, zona 12, Ciudad de Guatemala', 'Dirección de demostración 24, zona 12, Ciudad de Guatemala', 645.00, 0.00, 0.00, 0.00, 645.00, 'Procesando'),
(25, 29, '2026-08-25 10:00:00', 'Dirección de demostración 25, zona 1, Ciudad de Guatemala', 'Dirección de demostración 25, zona 1, Ciudad de Guatemala', 506.00, 0.00, 0.00, 0.00, 506.00, 'Procesando'),
(26, 30, '2026-08-26 10:00:00', 'Dirección de demostración 26, zona 2, Ciudad de Guatemala', 'Dirección de demostración 26, zona 2, Ciudad de Guatemala', 815.00, 0.00, 0.00, 0.00, 815.00, 'Procesando'),
(27, 31, '2026-08-27 10:00:00', 'Dirección de demostración 27, zona 3, Ciudad de Guatemala', 'Dirección de demostración 27, zona 3, Ciudad de Guatemala', 1026.00, 0.00, 0.00, 0.00, 1026.00, 'Procesando'),
(28, 33, '2026-08-28 10:00:00', 'Dirección de demostración 28, zona 4, Ciudad de Guatemala', 'Dirección de demostración 28, zona 4, Ciudad de Guatemala', 775.00, 0.00, 0.00, 0.00, 775.00, 'Procesando'),
(29, 34, '2026-08-29 10:00:00', 'Dirección de demostración 29, zona 5, Ciudad de Guatemala', 'Dirección de demostración 29, zona 5, Ciudad de Guatemala', 836.00, 0.00, 0.00, 0.00, 836.00, 'Confirmada'),
(30, 35, '2026-08-30 10:00:00', 'Dirección de demostración 30, zona 6, Ciudad de Guatemala', 'Dirección de demostración 30, zona 6, Ciudad de Guatemala', 635.00, 0.00, 0.00, 0.00, 635.00, 'Confirmada'),
(31, 36, '2026-08-31 10:00:00', 'Dirección de demostración 31, zona 7, Ciudad de Guatemala', 'Dirección de demostración 31, zona 7, Ciudad de Guatemala', 536.00, 0.00, 0.00, 0.00, 536.00, 'Confirmada'),
(32, 37, '2026-09-01 10:00:00', 'Dirección de demostración 32, zona 8, Ciudad de Guatemala', 'Dirección de demostración 32, zona 8, Ciudad de Guatemala', 2245.00, 0.00, 0.00, 0.00, 2245.00, 'Confirmada'),
(33, 38, '2026-09-02 10:00:00', 'Dirección de demostración 33, zona 9, Ciudad de Guatemala', 'Dirección de demostración 33, zona 9, Ciudad de Guatemala', 256.00, 0.00, 0.00, 0.00, 256.00, 'Pendiente'),
(34, 39, '2026-09-03 10:00:00', 'Dirección de demostración 34, zona 10, Ciudad de Guatemala', 'Dirección de demostración 34, zona 10, Ciudad de Guatemala', 555.00, 0.00, 0.00, 0.00, 555.00, 'Pendiente'),
(35, 40, '2026-09-04 10:00:00', 'Dirección de demostración 35, zona 11, Ciudad de Guatemala', 'Dirección de demostración 35, zona 11, Ciudad de Guatemala', 496.00, 0.00, 0.00, 0.00, 496.00, 'Cancelada'),
(36, 41, '2026-09-05 10:00:00', 'Dirección de demostración 36, zona 12, Ciudad de Guatemala', 'Dirección de demostración 36, zona 12, Ciudad de Guatemala', 565.00, 0.00, 0.00, 0.00, 565.00, 'Cancelada');

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

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`PagoID`, `OrdenID`, `FechaPago`, `Monto`, `MetodoPago`, `ReferenciaPago`, `Notas`, `Estado`) VALUES
(1, 1, '2026-08-01 11:00:00', 15546.00, 'Tarjeta', 'DEMO-PAGO-0001', 'Pago simulado; no representa un cobro real.', 'Completado'),
(2, 2, '2026-08-02 11:00:00', 5295.00, 'Transferencia', 'DEMO-PAGO-0002', 'Pago simulado; no representa un cobro real.', 'Completado'),
(3, 3, '2026-08-03 11:00:00', 3526.00, 'Tarjeta', 'DEMO-PAGO-0003', 'Pago simulado; no representa un cobro real.', 'Completado'),
(4, 4, '2026-08-04 11:00:00', 15495.00, 'Transferencia', 'DEMO-PAGO-0004', 'Pago simulado; no representa un cobro real.', 'Completado'),
(5, 5, '2026-08-05 11:00:00', 1406.00, 'Tarjeta', 'DEMO-PAGO-0005', 'Pago simulado; no representa un cobro real.', 'Completado'),
(6, 6, '2026-08-06 11:00:00', 21155.00, 'Transferencia', 'DEMO-PAGO-0006', 'Pago simulado; no representa un cobro real.', 'Completado'),
(7, 7, '2026-08-07 11:00:00', 6796.00, 'Tarjeta', 'DEMO-PAGO-0007', 'Pago simulado; no representa un cobro real.', 'Completado'),
(8, 8, '2026-08-08 11:00:00', 1425.00, 'Transferencia', 'DEMO-PAGO-0008', 'Pago simulado; no representa un cobro real.', 'Completado'),
(9, 9, '2026-08-09 11:00:00', 2146.00, 'Tarjeta', 'DEMO-PAGO-0009', 'Pago simulado; no representa un cobro real.', 'Completado'),
(10, 10, '2026-08-10 11:00:00', 15195.00, 'Transferencia', 'DEMO-PAGO-0010', 'Pago simulado; no representa un cobro real.', 'Completado'),
(11, 11, '2026-08-11 11:00:00', 1106.00, 'Tarjeta', 'DEMO-PAGO-0011', 'Pago simulado; no representa un cobro real.', 'Completado'),
(12, 12, '2026-08-12 11:00:00', 1525.00, 'Transferencia', 'DEMO-PAGO-0012', 'Pago simulado; no representa un cobro real.', 'Completado'),
(13, 13, '2026-08-13 11:00:00', 3796.00, 'Tarjeta', 'DEMO-PAGO-0013', 'Pago simulado; no representa un cobro real.', 'Completado'),
(14, 14, '2026-08-14 11:00:00', 1395.00, 'Transferencia', 'DEMO-PAGO-0014', 'Pago simulado; no representa un cobro real.', 'Completado'),
(15, 15, '2026-08-15 11:00:00', 586.00, 'Tarjeta', 'DEMO-PAGO-0015', 'Pago simulado; no representa un cobro real.', 'Completado'),
(16, 16, '2026-08-16 11:00:00', 1265.00, 'Transferencia', 'DEMO-PAGO-0016', 'Pago simulado; no representa un cobro real.', 'Completado'),
(17, 17, '2026-08-17 11:00:00', 2296.00, 'Tarjeta', 'DEMO-PAGO-0017', 'Pago simulado; no representa un cobro real.', 'Completado'),
(18, 18, '2026-08-18 11:00:00', 1745.00, 'Transferencia', 'DEMO-PAGO-0018', 'Pago simulado; no representa un cobro real.', 'Completado'),
(19, 19, '2026-08-19 11:00:00', 1166.00, 'Tarjeta', 'DEMO-PAGO-0019', 'Pago simulado; no representa un cobro real.', 'Completado'),
(20, 20, '2026-08-20 11:00:00', 455.00, 'Transferencia', 'DEMO-PAGO-0020', 'Pago simulado; no representa un cobro real.', 'Completado'),
(21, 21, '2026-08-21 11:00:00', 946.00, 'Tarjeta', 'DEMO-PAGO-0021', 'Pago simulado; no representa un cobro real.', 'Completado'),
(22, 22, '2026-08-22 11:00:00', 1465.00, 'Transferencia', 'DEMO-PAGO-0022', 'Pago simulado; no representa un cobro real.', 'Completado'),
(23, 23, '2026-08-23 11:00:00', 956.00, 'Tarjeta', 'DEMO-PAGO-0023', 'Pago simulado; no representa un cobro real.', 'Completado'),
(24, 24, '2026-08-24 11:00:00', 645.00, 'Transferencia', 'DEMO-PAGO-0024', 'Pago simulado; no representa un cobro real.', 'Completado'),
(25, 25, '2026-08-25 11:00:00', 506.00, 'Tarjeta', 'DEMO-PAGO-0025', 'Pago simulado; no representa un cobro real.', 'Completado'),
(26, 26, '2026-08-26 11:00:00', 815.00, 'Transferencia', 'DEMO-PAGO-0026', 'Pago simulado; no representa un cobro real.', 'Completado'),
(27, 27, '2026-08-27 11:00:00', 1026.00, 'Tarjeta', 'DEMO-PAGO-0027', 'Pago simulado; no representa un cobro real.', 'Completado'),
(28, 28, '2026-08-28 11:00:00', 775.00, 'Transferencia', 'DEMO-PAGO-0028', 'Pago simulado; no representa un cobro real.', 'Completado'),
(29, 29, '2026-08-29 11:00:00', 836.00, 'Tarjeta', 'DEMO-PAGO-0029', 'Pago simulado; no representa un cobro real.', 'Completado'),
(30, 30, '2026-08-30 11:00:00', 635.00, 'Transferencia', 'DEMO-PAGO-0030', 'Pago simulado; no representa un cobro real.', 'Completado'),
(31, 31, '2026-08-31 11:00:00', 536.00, 'Tarjeta', 'DEMO-PAGO-0031', 'Pago simulado; no representa un cobro real.', 'Completado'),
(32, 32, '2026-09-01 11:00:00', 2245.00, 'Transferencia', 'DEMO-PAGO-0032', 'Pago simulado; no representa un cobro real.', 'Completado'),
(33, 33, '2026-09-02 11:00:00', 256.00, 'Tarjeta', 'DEMO-PAGO-0033', 'Pago simulado; no representa un cobro real.', 'Pendiente'),
(34, 34, '2026-09-03 11:00:00', 555.00, 'Transferencia', 'DEMO-PAGO-0034', 'Pago simulado; no representa un cobro real.', 'Pendiente');

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

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ProductoID`, `CategoriaID`, `SKU`, `Nombre`, `Descripcion`, `Precio`, `Cantidad`, `Imagen`, `Estado`, `FechaRegistro`) VALUES
(1, 13, 'TA-00001', 'Smartphone Nova X 256 GB', 'Smartphone Nova X 256 GB. Producto de demostración para el catálogo de TodoAquí.', 3299.00, 27, '/productos/smartphone.jpg', 'Activo', '2026-07-01 09:00:00'),
(2, 16, 'TA-00002', 'Laptop Air 14” 16 GB RAM', 'Laptop Air 14” 16 GB RAM. Producto de demostración para el catálogo de TodoAquí.', 5799.00, 34, '/productos/laptop.jpg', 'Activo', '2026-07-01 09:00:00'),
(3, 19, 'TA-00003', 'Audífonos Wave Pro ANC', 'Audífonos Wave Pro ANC. Producto de demostración para el catálogo de TodoAquí.', 649.00, 41, '/productos/headsets.jpg', 'Activo', '2026-07-01 09:00:00'),
(4, 22, 'TA-00004', 'Teclado Mecánico RGB', 'Teclado Mecánico RGB. Producto de demostración para el catálogo de TodoAquí.', 499.00, 48, '/productos/rgb-keyboard.jpg', 'Activo', '2026-07-01 09:00:00'),
(5, 34, 'TA-00005', 'Smartwatch Active S', 'Smartwatch Active S. Producto de demostración para el catálogo de TodoAquí.', 899.00, 55, '/productos/smartwatch.jpg', 'Activo', '2026-07-01 09:00:00'),
(6, 17, 'TA-00006', 'Monitor UltraView 27”', 'Monitor UltraView 27”. Producto de demostración para el catálogo de TodoAquí.', 1699.00, 62, '/productos/computer-monitor.png', 'Activo', '2026-07-01 09:00:00'),
(7, 20, 'TA-00007', 'Bocina Pulse Bluetooth', 'Bocina Pulse Bluetooth. Producto de demostración para el catálogo de TodoAquí.', 429.00, 69, '/productos/bluetooth-speaker.jpg', 'Activo', '2026-07-01 09:00:00'),
(8, 25, 'TA-00008', 'Cámara Home Secure 2K', 'Cámara Home Secure 2K. Producto de demostración para el catálogo de TodoAquí.', 599.00, 76, '/productos/indoor-ip-camera.jpg', 'Activo', '2026-07-01 09:00:00'),
(9, 13, 'TA-00009', 'Smartphone Nova Lite 128 GB', 'Smartphone Nova Lite 128 GB. Producto de demostración para el catálogo de TodoAquí.', 1899.00, 83, '/productos/smartphone.jpg', 'Activo', '2026-07-01 09:00:00'),
(10, 13, 'TA-00010', 'Smartphone Aurora 512 GB', 'Smartphone Aurora 512 GB. Producto de demostración para el catálogo de TodoAquí.', 4599.00, 25, '/productos/smartphone.jpg', 'Activo', '2026-07-01 09:00:00'),
(11, 14, 'TA-00011', 'Tablet Estudio 10 pulgadas', 'Tablet Estudio 10 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 1299.00, 32, '/productos/tablet-computer.jpg', 'Activo', '2026-07-01 09:00:00'),
(12, 14, 'TA-00012', 'Tablet Dibujo 12 pulgadas', 'Tablet Dibujo 12 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 2499.00, 39, '/productos/graphics-tablet-pen.jpg', 'Activo', '2026-07-01 09:00:00'),
(13, 14, 'TA-00013', 'Tablet Infantil 8 pulgadas', 'Tablet Infantil 8 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 899.00, 46, '/productos/tablet-computer.jpg', 'Activo', '2026-07-01 09:00:00'),
(14, 15, 'TA-00014', 'Cargador USB-C 30 W', 'Cargador USB-C 30 W. Producto de demostración para el catálogo de TodoAquí.', 129.00, 53, '/productos/usb-c-charger.jpg', 'Activo', '2026-07-01 09:00:00'),
(15, 15, 'TA-00015', 'Batería portátil 20000 mAh', 'Batería portátil 20000 mAh. Producto de demostración para el catálogo de TodoAquí.', 249.00, 60, '/productos/power-bank.jpg', 'Activo', '2026-07-01 09:00:00'),
(16, 15, 'TA-00016', 'Cargador inalámbrico 15 W', 'Cargador inalámbrico 15 W. Producto de demostración para el catálogo de TodoAquí.', 179.00, 67, '/productos/wireless-charger.png', 'Activo', '2026-07-01 09:00:00'),
(17, 16, 'TA-00017', 'Laptop Aula 15 pulgadas', 'Laptop Aula 15 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 3799.00, 74, '/productos/laptop.jpg', 'Activo', '2026-07-01 09:00:00'),
(18, 16, 'TA-00018', 'Laptop Diseño 16 pulgadas', 'Laptop Diseño 16 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 8499.00, 81, '/productos/laptop.jpg', 'Activo', '2026-07-01 09:00:00'),
(19, 17, 'TA-00019', 'Monitor Oficina 24 pulgadas', 'Monitor Oficina 24 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 1199.00, 23, '/productos/computer-monitor.png', 'Activo', '2026-07-01 09:00:00'),
(20, 17, 'TA-00020', 'Monitor Curvo 32 pulgadas', 'Monitor Curvo 32 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 2499.00, 30, '/productos/curved-monitor.jpg', 'Activo', '2026-07-01 09:00:00'),
(21, 18, 'TA-00021', 'SSD NVMe 1 TB', 'SSD NVMe 1 TB. Producto de demostración para el catálogo de TodoAquí.', 599.00, 37, '/productos/nvme-ssd.jpg', 'Activo', '2026-07-01 09:00:00'),
(22, 18, 'TA-00022', 'Memoria USB 128 GB', 'Memoria USB 128 GB. Producto de demostración para el catálogo de TodoAquí.', 89.00, 44, '/productos/usb-flash-drive.jpg', 'Activo', '2026-07-01 09:00:00'),
(23, 18, 'TA-00023', 'Disco externo 2 TB', 'Disco externo 2 TB. Producto de demostración para el catálogo de TodoAquí.', 749.00, 51, '/productos/external-hard-disk.jpg', 'Activo', '2026-07-01 09:00:00'),
(24, 19, 'TA-00024', 'Audífonos Studio Cable', 'Audífonos Studio Cable. Producto de demostración para el catálogo de TodoAquí.', 249.00, 58, '/productos/headphones.jpg', 'Activo', '2026-07-01 09:00:00'),
(25, 19, 'TA-00025', 'Audífonos Mini Inalámbricos', 'Audífonos Mini Inalámbricos. Producto de demostración para el catálogo de TodoAquí.', 349.00, 65, '/productos/wireless-earbuds.jpg', 'Activo', '2026-07-01 09:00:00'),
(26, 20, 'TA-00026', 'Bocina Fiesta 40 W', 'Bocina Fiesta 40 W. Producto de demostración para el catálogo de TodoAquí.', 799.00, 72, '/productos/bluetooth-speaker.jpg', 'Activo', '2026-07-01 09:00:00'),
(27, 20, 'TA-00027', 'Bocina Compacta 10 W', 'Bocina Compacta 10 W. Producto de demostración para el catálogo de TodoAquí.', 199.00, 79, '/productos/bluetooth-speaker.jpg', 'Activo', '2026-07-01 09:00:00'),
(28, 21, 'TA-00028', 'Televisor Smart 32 pulgadas', 'Televisor Smart 32 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 1699.00, 21, '/productos/flat-screen-television.jpg', 'Activo', '2026-07-01 09:00:00'),
(29, 21, 'TA-00029', 'Televisor Smart 43 pulgadas', 'Televisor Smart 43 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 2799.00, 28, '/productos/flat-screen-television.jpg', 'Activo', '2026-07-01 09:00:00'),
(30, 21, 'TA-00030', 'Televisor UHD 55 pulgadas', 'Televisor UHD 55 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 4499.00, 35, '/productos/flat-screen-television.jpg', 'Activo', '2026-07-01 09:00:00'),
(31, 22, 'TA-00031', 'Teclado Compacto 60 por ciento', 'Teclado Compacto 60 por ciento. Producto de demostración para el catálogo de TodoAquí.', 399.00, 42, '/productos/compact-mechanical-keyboard.jpg', 'Activo', '2026-07-01 09:00:00'),
(32, 22, 'TA-00032', 'Teclado Membrana Retroiluminado', 'Teclado Membrana Retroiluminado. Producto de demostración para el catálogo de TodoAquí.', 229.00, 49, '/productos/computer-keyboard-backlight.jpg', 'Activo', '2026-07-01 09:00:00'),
(33, 23, 'TA-00033', 'Ratón Precisión 12000 DPI', 'Ratón Precisión 12000 DPI. Producto de demostración para el catálogo de TodoAquí.', 249.00, 56, '/productos/gaming-mouse.jpg', 'Activo', '2026-07-01 09:00:00'),
(34, 23, 'TA-00034', 'Ratón Inalámbrico Arena', 'Ratón Inalámbrico Arena. Producto de demostración para el catálogo de TodoAquí.', 349.00, 63, '/productos/gaming-mouse.jpg', 'Activo', '2026-07-01 09:00:00'),
(35, 23, 'TA-00035', 'Ratón Ligero Competición', 'Ratón Ligero Competición. Producto de demostración para el catálogo de TodoAquí.', 429.00, 70, '/productos/gaming-mouse.jpg', 'Activo', '2026-07-01 09:00:00'),
(36, 24, 'TA-00036', 'Control USB Universal', 'Control USB Universal. Producto de demostración para el catálogo de TodoAquí.', 199.00, 77, '/productos/game-controller.jpg', 'Activo', '2026-07-01 09:00:00'),
(37, 24, 'TA-00037', 'Control Bluetooth Pro', 'Control Bluetooth Pro. Producto de demostración para el catálogo de TodoAquí.', 399.00, 84, '/productos/game-controller.jpg', 'Activo', '2026-07-01 09:00:00'),
(38, 24, 'TA-00038', 'Volante de Carreras Básico', 'Volante de Carreras Básico. Producto de demostración para el catálogo de TodoAquí.', 1299.00, 26, '/productos/racing-wheel-controller.jpg', 'Activo', '2026-07-01 09:00:00'),
(39, 25, 'TA-00039', 'Cámara Exterior IP65', 'Cámara Exterior IP65. Producto de demostración para el catálogo de TodoAquí.', 799.00, 33, '/productos/outdoor-surveillance-camera.jpg', 'Activo', '2026-07-01 09:00:00'),
(40, 25, 'TA-00040', 'Cámara Interior Giratoria', 'Cámara Interior Giratoria. Producto de demostración para el catálogo de TodoAquí.', 449.00, 40, '/productos/indoor-ip-camera.jpg', 'Activo', '2026-07-01 09:00:00'),
(41, 26, 'TA-00041', 'Bombilla Wi-Fi RGB', 'Bombilla Wi-Fi RGB. Producto de demostración para el catálogo de TodoAquí.', 99.00, 47, '/productos/smart-light-bulb.jpg', 'Activo', '2026-07-01 09:00:00'),
(42, 26, 'TA-00042', 'Tira LED Inteligente 5 m', 'Tira LED Inteligente 5 m. Producto de demostración para el catálogo de TodoAquí.', 199.00, 54, '/productos/led-strip.jpg', 'Activo', '2026-07-01 09:00:00'),
(43, 26, 'TA-00043', 'Enchufe Inteligente Wi-Fi', 'Enchufe Inteligente Wi-Fi. Producto de demostración para el catálogo de TodoAquí.', 149.00, 61, '/productos/smart-plug.jpg', 'Activo', '2026-07-01 09:00:00'),
(44, 27, 'TA-00044', 'Sensor de Puerta Wi-Fi', 'Sensor de Puerta Wi-Fi. Producto de demostración para el catálogo de TodoAquí.', 129.00, 68, '/productos/door-window-sensor.jpg', 'Activo', '2026-07-01 09:00:00'),
(45, 27, 'TA-00045', 'Sensor de Movimiento Interior', 'Sensor de Movimiento Interior. Producto de demostración para el catálogo de TodoAquí.', 179.00, 75, '/productos/pir-motion-sensor.jpg', 'Activo', '2026-07-01 09:00:00'),
(46, 27, 'TA-00046', 'Detector de Fugas de Agua', 'Detector de Fugas de Agua. Producto de demostración para el catálogo de TodoAquí.', 159.00, 82, '/productos/water-leak-detector.jpg', 'Activo', '2026-07-01 09:00:00'),
(47, 28, 'TA-00047', 'Licuadora Familiar 1.5 L', 'Licuadora Familiar 1.5 L. Producto de demostración para el catálogo de TodoAquí.', 349.00, 24, '/productos/blender-appliance.jpg', 'Activo', '2026-07-01 09:00:00'),
(48, 28, 'TA-00048', 'Cafetera de Goteo 12 Tazas', 'Cafetera de Goteo 12 Tazas. Producto de demostración para el catálogo de TodoAquí.', 299.00, 31, '/productos/drip-coffee-maker.jpg', 'Activo', '2026-07-01 09:00:00'),
(49, 28, 'TA-00049', 'Freidora de Aire 5 L', 'Freidora de Aire 5 L. Producto de demostración para el catálogo de TodoAquí.', 799.00, 38, '/productos/air-fryer.jpg', 'Activo', '2026-07-01 09:00:00'),
(50, 29, 'TA-00050', 'Aspiradora Compacta 1200 W', 'Aspiradora Compacta 1200 W. Producto de demostración para el catálogo de TodoAquí.', 599.00, 45, '/productos/canister-vacuum-cleaner.jpg', 'Activo', '2026-07-01 09:00:00'),
(51, 29, 'TA-00051', 'Aspiradora de Mano Recargable', 'Aspiradora de Mano Recargable. Producto de demostración para el catálogo de TodoAquí.', 299.00, 52, '/productos/handheld-vacuum-cleaner.jpg', 'Activo', '2026-07-01 09:00:00'),
(52, 29, 'TA-00052', 'Limpiador a Vapor Doméstico', 'Limpiador a Vapor Doméstico. Producto de demostración para el catálogo de TodoAquí.', 649.00, 59, '/productos/steam-cleaner.jpg', 'Activo', '2026-07-01 09:00:00'),
(53, 30, 'TA-00053', 'Ventilador de Pedestal 16 pulgadas', 'Ventilador de Pedestal 16 pulgadas. Producto de demostración para el catálogo de TodoAquí.', 249.00, 66, '/productos/pedestal-fan.jpg', 'Activo', '2026-07-01 09:00:00'),
(54, 30, 'TA-00054', 'Ventilador de Escritorio USB', 'Ventilador de Escritorio USB. Producto de demostración para el catálogo de TodoAquí.', 99.00, 73, '/productos/usb-fan.jpg', 'Activo', '2026-07-01 09:00:00'),
(55, 30, 'TA-00055', 'Ventilador de Torre 80 cm', 'Ventilador de Torre 80 cm. Producto de demostración para el catálogo de TodoAquí.', 449.00, 80, '/productos/tower-fan.jpg', 'Activo', '2026-07-01 09:00:00'),
(56, 31, 'TA-00056', 'Juego de Sartenes Antiadherentes', 'Juego de Sartenes Antiadherentes. Producto de demostración para el catálogo de TodoAquí.', 299.00, 22, '/productos/frying-pans.jpg', 'Activo', '2026-07-01 09:00:00'),
(57, 31, 'TA-00057', 'Juego de Utensilios de Silicona', 'Juego de Utensilios de Silicona. Producto de demostración para el catálogo de TodoAquí.', 119.00, 29, '/productos/silicone-kitchen-utensils.jpg', 'Activo', '2026-07-01 09:00:00'),
(58, 31, 'TA-00058', 'Tabla de Cortar de Bambú', 'Tabla de Cortar de Bambú. Producto de demostración para el catálogo de TodoAquí.', 89.00, 36, '/productos/bamboo-cutting-board.jpg', 'Activo', '2026-07-01 09:00:00'),
(59, 32, 'TA-00059', 'Organizador Modular de Cajones', 'Organizador Modular de Cajones. Producto de demostración para el catálogo de TodoAquí.', 79.00, 43, '/productos/drawer-organizer.jpg', 'Activo', '2026-07-01 09:00:00'),
(60, 32, 'TA-00060', 'Caja Plegable de Almacenamiento', 'Caja Plegable de Almacenamiento. Producto de demostración para el catálogo de TodoAquí.', 99.00, 50, '/productos/folding-storage-box.jpg', 'Activo', '2026-07-01 09:00:00'),
(61, 32, 'TA-00061', 'Estante Metálico de 4 Niveles', 'Estante Metálico de 4 Niveles. Producto de demostración para el catálogo de TodoAquí.', 349.00, 57, '/productos/metal-shelving.jpg', 'Activo', '2026-07-01 09:00:00'),
(62, 33, 'TA-00062', 'Juego de Sábanas Matrimonial', 'Juego de Sábanas Matrimonial. Producto de demostración para el catálogo de TodoAquí.', 249.00, 64, '/productos/bed-sheets.jpg', 'Activo', '2026-07-01 09:00:00'),
(63, 33, 'TA-00063', 'Almohada de Microfibra', 'Almohada de Microfibra. Producto de demostración para el catálogo de TodoAquí.', 99.00, 71, '/productos/pillow.jpg', 'Activo', '2026-07-01 09:00:00'),
(64, 33, 'TA-00064', 'Cobertor Ligero Individual', 'Cobertor Ligero Individual. Producto de demostración para el catálogo de TodoAquí.', 159.00, 78, '/productos/blanket.jpg', 'Activo', '2026-07-01 09:00:00'),
(65, 34, 'TA-00065', 'Reloj Deportivo Track', 'Reloj Deportivo Track. Producto de demostración para el catálogo de TodoAquí.', 549.00, 20, '/productos/smartwatch.jpg', 'Activo', '2026-07-01 09:00:00'),
(66, 34, 'TA-00066', 'Pulsera de Actividad Fit', 'Pulsera de Actividad Fit. Producto de demostración para el catálogo de TodoAquí.', 299.00, 27, '/productos/fitness-tracker.jpg', 'Activo', '2026-07-01 09:00:00'),
(67, 35, 'TA-00067', 'Mochila Urbana para Laptop', 'Mochila Urbana para Laptop. Producto de demostración para el catálogo de TodoAquí.', 249.00, 34, '/productos/laptop-backpack.jpg', 'Activo', '2026-07-01 09:00:00'),
(68, 35, 'TA-00068', 'Mochila Escolar Reforzada', 'Mochila Escolar Reforzada. Producto de demostración para el catálogo de TodoAquí.', 179.00, 41, '/productos/school-backpack.jpg', 'Activo', '2026-07-01 09:00:00'),
(69, 35, 'TA-00069', 'Mochila de Viaje 35 L', 'Mochila de Viaje 35 L. Producto de demostración para el catálogo de TodoAquí.', 349.00, 48, '/productos/travel-backpack.jpg', 'Activo', '2026-07-01 09:00:00'),
(70, 36, 'TA-00070', 'Bolso Casual de Lona', 'Bolso Casual de Lona. Producto de demostración para el catálogo de TodoAquí.', 149.00, 55, '/productos/canvas-tote-bag.jpg', 'Activo', '2026-07-01 09:00:00'),
(71, 36, 'TA-00071', 'Cartera Compacta Unisex', 'Cartera Compacta Unisex. Producto de demostración para el catálogo de TodoAquí.', 89.00, 62, '/productos/wallet.jpg', 'Activo', '2026-07-01 09:00:00'),
(72, 36, 'TA-00072', 'Bolso Cruzado Impermeable', 'Bolso Cruzado Impermeable. Producto de demostración para el catálogo de TodoAquí.', 129.00, 69, '/productos/crossbody-bag.jpg', 'Activo', '2026-07-01 09:00:00'),
(73, 37, 'TA-00073', 'Casco de Ciclismo Ajustable', 'Casco de Ciclismo Ajustable. Producto de demostración para el catálogo de TodoAquí.', 229.00, 76, '/productos/bicycle-helmet.jpg', 'Activo', '2026-07-01 09:00:00'),
(74, 37, 'TA-00074', 'Luz Recargable para Bicicleta', 'Luz Recargable para Bicicleta. Producto de demostración para el catálogo de TodoAquí.', 99.00, 83, '/productos/bicycle-light.jpg', 'Activo', '2026-07-01 09:00:00'),
(75, 37, 'TA-00075', 'Bomba de Aire Portátil', 'Bomba de Aire Portátil. Producto de demostración para el catálogo de TodoAquí.', 79.00, 25, '/productos/bicycle-pump.jpg', 'Activo', '2026-07-01 09:00:00'),
(76, 38, 'TA-00076', 'Par de Mancuernas 5 kg', 'Par de Mancuernas 5 kg. Producto de demostración para el catálogo de TodoAquí.', 249.00, 32, '/productos/dumbbells.jpg', 'Activo', '2026-07-01 09:00:00'),
(77, 38, 'TA-00077', 'Bandas de Resistencia Set', 'Bandas de Resistencia Set. Producto de demostración para el catálogo de TodoAquí.', 119.00, 39, '/productos/resistance-bands.jpg', 'Activo', '2026-07-01 09:00:00'),
(78, 38, 'TA-00078', 'Colchoneta de Yoga 6 mm', 'Colchoneta de Yoga 6 mm. Producto de demostración para el catálogo de TodoAquí.', 99.00, 46, '/productos/yoga-mat.png', 'Activo', '2026-07-01 09:00:00'),
(79, 39, 'TA-00079', 'Tienda de Campaña para 2 Personas', 'Tienda de Campaña para 2 Personas. Producto de demostración para el catálogo de TodoAquí.', 599.00, 53, '/productos/camping-tent.jpg', 'Activo', '2026-07-01 09:00:00'),
(80, 39, 'TA-00080', 'Linterna LED Recargable', 'Linterna LED Recargable. Producto de demostración para el catálogo de TodoAquí.', 149.00, 60, '/productos/led-flashlight.jpg', 'Activo', '2026-07-01 09:00:00'),
(81, 39, 'TA-00081', 'Botella Térmica de 750 ml', 'Botella Térmica de 750 ml. Producto de demostración para el catálogo de TodoAquí.', 129.00, 67, '/productos/vacuum-flask.jpg', 'Activo', '2026-07-01 09:00:00'),
(82, 40, 'TA-00082', 'Cepillo Dental Eléctrico', 'Cepillo Dental Eléctrico. Producto de demostración para el catálogo de TodoAquí.', 199.00, 74, '/productos/electric-toothbrush.jpg', 'Activo', '2026-07-01 09:00:00'),
(83, 40, 'TA-00083', 'Kit de Aseo de Viaje', 'Kit de Aseo de Viaje. Producto de demostración para el catálogo de TodoAquí.', 79.00, 81, '/productos/toiletry-bag.jpg', 'Activo', '2026-07-01 09:00:00'),
(84, 40, 'TA-00084', 'Dispensador de Jabón Recargable', 'Dispensador de Jabón Recargable. Producto de demostración para el catálogo de TodoAquí.', 149.00, 23, '/productos/soap-dispenser.jpg', 'Activo', '2026-07-01 09:00:00'),
(85, 41, 'TA-00085', 'Secadora Compacta 1800 W', 'Secadora Compacta 1800 W. Producto de demostración para el catálogo de TodoAquí.', 229.00, 30, '/productos/hair-dryer.jpg', 'Activo', '2026-07-01 09:00:00'),
(86, 41, 'TA-00086', 'Plancha Cerámica para Cabello', 'Plancha Cerámica para Cabello. Producto de demostración para el catálogo de TodoAquí.', 279.00, 37, '/productos/hair-straightener.jpg', 'Activo', '2026-07-01 09:00:00'),
(87, 41, 'TA-00087', 'Cepillo Desenredante', 'Cepillo Desenredante. Producto de demostración para el catálogo de TodoAquí.', 49.00, 44, '/productos/hair-brush.jpg', 'Activo', '2026-07-01 09:00:00'),
(88, 42, 'TA-00088', 'Rodillo Facial de Cuarzo', 'Rodillo Facial de Cuarzo. Producto de demostración para el catálogo de TodoAquí.', 89.00, 51, '/productos/facial-roller.jpg', 'Activo', '2026-07-01 09:00:00'),
(89, 42, 'TA-00089', 'Espejo de Tocador LED', 'Espejo de Tocador LED. Producto de demostración para el catálogo de TodoAquí.', 199.00, 58, '/productos/makeup-mirror.jpg', 'Activo', '2026-07-01 09:00:00'),
(90, 42, 'TA-00090', 'Cepillo Facial de Silicona', 'Cepillo Facial de Silicona. Producto de demostración para el catálogo de TodoAquí.', 129.00, 65, '/productos/silicone-facial-brush.jpg', 'Activo', '2026-07-01 09:00:00'),
(91, 43, 'TA-00091', 'Juego de Destornilladores 12 Piezas', 'Juego de Destornilladores 12 Piezas. Producto de demostración para el catálogo de TodoAquí.', 129.00, 72, '/productos/screwdriver-set.jpg', 'Activo', '2026-07-01 09:00:00'),
(92, 43, 'TA-00092', 'Martillo de Uña 16 oz', 'Martillo de Uña 16 oz. Producto de demostración para el catálogo de TodoAquí.', 79.00, 79, '/productos/claw-hammer.jpg', 'Activo', '2026-07-01 09:00:00'),
(93, 43, 'TA-00093', 'Juego de Llaves Combinadas', 'Juego de Llaves Combinadas. Producto de demostración para el catálogo de TodoAquí.', 249.00, 21, '/productos/combination-wrenches.jpg', 'Activo', '2026-07-01 09:00:00'),
(94, 44, 'TA-00094', 'Taladro Inalámbrico 20 V', 'Taladro Inalámbrico 20 V. Producto de demostración para el catálogo de TodoAquí.', 699.00, 28, '/productos/cordless-drill.jpg', 'Activo', '2026-07-01 09:00:00'),
(95, 44, 'TA-00095', 'Lijadora Orbital 240 W', 'Lijadora Orbital 240 W. Producto de demostración para el catálogo de TodoAquí.', 449.00, 35, '/productos/orbital-sander.jpg', 'Activo', '2026-07-01 09:00:00'),
(96, 44, 'TA-00096', 'Atornillador Recargable 4 V', 'Atornillador Recargable 4 V. Producto de demostración para el catálogo de TodoAquí.', 199.00, 42, '/productos/electric-screwdriver.jpg', 'Activo', '2026-07-01 09:00:00'),
(97, 45, 'TA-00097', 'Gafas de Protección Transparentes', 'Gafas de Protección Transparentes. Producto de demostración para el catálogo de TodoAquí.', 49.00, 49, '/productos/safety-glasses.jpg', 'Activo', '2026-07-01 09:00:00'),
(98, 45, 'TA-00098', 'Guantes de Trabajo Reforzados', 'Guantes de Trabajo Reforzados. Producto de demostración para el catálogo de TodoAquí.', 59.00, 56, '/productos/work-gloves.jpg', 'Activo', '2026-07-01 09:00:00'),
(99, 45, 'TA-00099', 'Casco de Seguridad Ajustable', 'Casco de Seguridad Ajustable. Producto de demostración para el catálogo de TodoAquí.', 89.00, 63, '/productos/hard-hat.jpg', 'Activo', '2026-07-01 09:00:00'),
(100, 46, 'TA-00100', 'Alimento Seco para Perro 3 kg', 'Alimento Seco para Perro 3 kg. Producto de demostración para el catálogo de TodoAquí.', 159.00, 70, '/productos/dry-dog-food.jpg', 'Activo', '2026-07-01 09:00:00'),
(101, 46, 'TA-00101', 'Alimento Seco para Gato 1.5 kg', 'Alimento Seco para Gato 1.5 kg. Producto de demostración para el catálogo de TodoAquí.', 139.00, 77, '/productos/dry-cat-food.jpg', 'Activo', '2026-07-01 09:00:00'),
(102, 46, 'TA-00102', 'Premios para Perro 200 g', 'Premios para Perro 200 g. Producto de demostración para el catálogo de TodoAquí.', 49.00, 84, '/productos/dog-treats.jpg', 'Activo', '2026-07-01 09:00:00'),
(103, 47, 'TA-00103', 'Pelota Resistente para Perro', 'Pelota Resistente para Perro. Producto de demostración para el catálogo de TodoAquí.', 39.00, 26, '/productos/dog-ball-toy.jpg', 'Activo', '2026-07-01 09:00:00'),
(104, 47, 'TA-00104', 'Rascador Compacto para Gato', 'Rascador Compacto para Gato. Producto de demostración para el catálogo de TodoAquí.', 199.00, 33, '/productos/cat-scratching-post.jpg', 'Activo', '2026-07-01 09:00:00'),
(105, 47, 'TA-00105', 'Juguete Interactivo con Cuerda', 'Juguete Interactivo con Cuerda. Producto de demostración para el catálogo de TodoAquí.', 59.00, 40, '/productos/dog-rope-toy.jpg', 'Activo', '2026-07-01 09:00:00'),
(106, 48, 'TA-00106', 'Correa Ajustable 1.5 m', 'Correa Ajustable 1.5 m. Producto de demostración para el catálogo de TodoAquí.', 69.00, 47, '/productos/dog-leash.jpg', 'Activo', '2026-07-01 09:00:00'),
(107, 48, 'TA-00107', 'Cama Lavable para Mascota', 'Cama Lavable para Mascota. Producto de demostración para el catálogo de TodoAquí.', 249.00, 54, '/productos/dog-bed.jpg', 'Activo', '2026-07-01 09:00:00'),
(108, 48, 'TA-00108', 'Comedero Doble Antideslizante', 'Comedero Doble Antideslizante. Producto de demostración para el catálogo de TodoAquí.', 89.00, 61, '/productos/double-pet-bowl.jpg', 'Activo', '2026-07-01 09:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productospromociones`
--

CREATE TABLE `productospromociones` (
  `ProductoID` int(11) NOT NULL,
  `PromocionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productospromociones`
--

INSERT INTO `productospromociones` (`ProductoID`, `PromocionID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 8),
(6, 2),
(7, 3),
(8, 5),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2),
(24, 3),
(25, 3),
(26, 3),
(27, 3),
(28, 3),
(29, 3),
(30, 3),
(31, 4),
(32, 4),
(33, 4),
(34, 4),
(35, 4),
(36, 4),
(37, 4),
(38, 4),
(39, 5),
(40, 5),
(41, 5),
(42, 5),
(43, 5),
(44, 5),
(45, 5),
(46, 5),
(47, 6),
(48, 6),
(49, 6),
(50, 6),
(51, 6),
(52, 6),
(53, 6),
(54, 6),
(55, 6),
(56, 7),
(57, 7),
(58, 7),
(59, 7),
(60, 7),
(61, 7),
(62, 7),
(63, 7),
(64, 7),
(65, 8),
(66, 8),
(67, 8),
(68, 8),
(69, 8),
(70, 8),
(71, 8),
(72, 8),
(73, 9),
(74, 9),
(75, 9),
(76, 9),
(77, 9),
(78, 9),
(79, 9),
(80, 9),
(81, 9),
(82, 10),
(83, 10),
(84, 10),
(85, 10),
(86, 10),
(87, 10),
(88, 10),
(89, 10),
(90, 10),
(91, 11),
(92, 11),
(93, 11),
(94, 11),
(95, 11),
(96, 11),
(97, 11),
(98, 11),
(99, 11),
(100, 12),
(101, 12),
(102, 12),
(103, 12),
(104, 12),
(105, 12),
(106, 12),
(107, 12),
(108, 12);

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

--
-- Volcado de datos para la tabla `productosproveedores`
--

INSERT INTO `productosproveedores` (`ProductoID`, `ProveedorID`, `CostoCompra`, `EsPrincipal`) VALUES
(1, 1, 2309.30, 1),
(2, 2, 4059.30, 1),
(3, 3, 454.30, 1),
(4, 4, 349.30, 1),
(5, 8, 629.30, 1),
(6, 2, 1189.30, 1),
(7, 3, 300.30, 1),
(8, 5, 419.30, 1),
(9, 1, 1329.30, 1),
(10, 1, 3219.30, 1),
(11, 1, 909.30, 1),
(12, 1, 1749.30, 1),
(13, 1, 629.30, 1),
(14, 1, 90.30, 1),
(15, 1, 174.30, 1),
(16, 1, 125.30, 1),
(17, 2, 2659.30, 1),
(18, 2, 5949.30, 1),
(19, 2, 839.30, 1),
(20, 2, 1749.30, 1),
(21, 2, 419.30, 1),
(22, 2, 62.30, 1),
(23, 2, 524.30, 1),
(24, 3, 174.30, 1),
(25, 3, 244.30, 1),
(26, 3, 559.30, 1),
(27, 3, 139.30, 1),
(28, 3, 1189.30, 1),
(29, 3, 1959.30, 1),
(30, 3, 3149.30, 1),
(31, 4, 279.30, 1),
(32, 4, 160.30, 1),
(33, 4, 174.30, 1),
(34, 4, 244.30, 1),
(35, 4, 300.30, 1),
(36, 4, 139.30, 1),
(37, 4, 279.30, 1),
(38, 4, 909.30, 1),
(39, 5, 559.30, 1),
(40, 5, 314.30, 1),
(41, 5, 69.30, 1),
(42, 5, 139.30, 1),
(43, 5, 104.30, 1),
(44, 5, 90.30, 1),
(45, 5, 125.30, 1),
(46, 5, 111.30, 1),
(47, 6, 244.30, 1),
(48, 6, 209.30, 1),
(49, 6, 559.30, 1),
(50, 6, 419.30, 1),
(51, 6, 209.30, 1),
(52, 6, 454.30, 1),
(53, 6, 174.30, 1),
(54, 6, 69.30, 1),
(55, 6, 314.30, 1),
(56, 7, 209.30, 1),
(57, 7, 83.30, 1),
(58, 7, 62.30, 1),
(59, 7, 55.30, 1),
(60, 7, 69.30, 1),
(61, 7, 244.30, 1),
(62, 7, 174.30, 1),
(63, 7, 69.30, 1),
(64, 7, 111.30, 1),
(65, 8, 384.30, 1),
(66, 8, 209.30, 1),
(67, 8, 174.30, 1),
(68, 8, 125.30, 1),
(69, 8, 244.30, 1),
(70, 8, 104.30, 1),
(71, 8, 62.30, 1),
(72, 8, 90.30, 1),
(73, 9, 160.30, 1),
(74, 9, 69.30, 1),
(75, 9, 55.30, 1),
(76, 9, 174.30, 1),
(77, 9, 83.30, 1),
(78, 9, 69.30, 1),
(79, 9, 419.30, 1),
(80, 9, 104.30, 1),
(81, 9, 90.30, 1),
(82, 10, 139.30, 1),
(83, 10, 55.30, 1),
(84, 10, 104.30, 1),
(85, 10, 160.30, 1),
(86, 10, 195.30, 1),
(87, 10, 34.30, 1),
(88, 10, 62.30, 1),
(89, 10, 139.30, 1),
(90, 10, 90.30, 1),
(91, 11, 90.30, 1),
(92, 11, 55.30, 1),
(93, 11, 174.30, 1),
(94, 11, 489.30, 1),
(95, 11, 314.30, 1),
(96, 11, 139.30, 1),
(97, 11, 34.30, 1),
(98, 11, 41.30, 1),
(99, 11, 62.30, 1),
(100, 12, 111.30, 1),
(101, 12, 97.30, 1),
(102, 12, 34.30, 1),
(103, 12, 27.30, 1),
(104, 12, 139.30, 1),
(105, 12, 41.30, 1),
(106, 12, 48.30, 1),
(107, 12, 174.30, 1),
(108, 12, 62.30, 1);

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

--
-- Volcado de datos para la tabla `promociones`
--

INSERT INTO `promociones` (`PromocionID`, `Nombre`, `Descripcion`, `TipoDescuento`, `ValorDescuento`, `FechaInicio`, `FechaFin`, `RequiereCupon`, `CodigoCupon`, `AplicaTodosProductos`, `Estado`) VALUES
(1, 'Septiembre: Celulares y tablets', 'Promoción de demostración para celulares y tablets.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO01', 0, 'Activo'),
(2, 'Septiembre: Computación', 'Promoción de demostración para computación.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO02', 0, 'Activo'),
(3, 'Septiembre: Audio y video', 'Promoción de demostración para audio y video.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO03', 0, 'Activo'),
(4, 'Septiembre: Gaming', 'Promoción de demostración para gaming.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO04', 0, 'Activo'),
(5, 'Septiembre: Hogar inteligente', 'Promoción de demostración para hogar inteligente.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO05', 0, 'Activo'),
(6, 'Septiembre: Electrodomésticos', 'Promoción de demostración para electrodomésticos.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO06', 0, 'Activo'),
(7, 'Septiembre: Hogar y cocina', 'Promoción de demostración para hogar y cocina.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO07', 0, 'Activo'),
(8, 'Septiembre: Moda y accesorios', 'Promoción de demostración para moda y accesorios.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO08', 0, 'Activo'),
(9, 'Septiembre: Deportes y aire libre', 'Promoción de demostración para deportes y aire libre.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO09', 0, 'Activo'),
(10, 'Septiembre: Belleza y cuidado personal', 'Promoción de demostración para belleza y cuidado personal.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO10', 0, 'Activo'),
(11, 'Septiembre: Herramientas y ferretería', 'Promoción de demostración para herramientas y ferretería.', 'Porcentaje', 10.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO11', 0, 'Activo'),
(12, 'Septiembre: Mascotas', 'Promoción de demostración para mascotas.', 'Monto', 25.00, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1, 'DEMO12', 0, 'Activo');

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

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`ProveedorID`, `Nombre`, `NIT`, `Contacto`, `Correo`, `Telefono`, `Direccion`, `Estado`, `FechaRegistro`) VALUES
(1, 'Distribuidora Conecta Demo', NULL, 'Contacto de demostración 1', 'proveedor1@example.com', NULL, 'Bodega de demostración 1, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(2, 'Suministros Digitales Demo', NULL, 'Contacto de demostración 2', 'proveedor2@example.com', NULL, 'Bodega de demostración 2, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(3, 'Sonido y Pantalla Demo', NULL, 'Contacto de demostración 3', 'proveedor3@example.com', NULL, 'Bodega de demostración 3, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(4, 'Accesorios Arena Demo', NULL, 'Contacto de demostración 4', 'proveedor4@example.com', NULL, 'Bodega de demostración 4, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(5, 'Casa Conectada Demo', NULL, 'Contacto de demostración 5', 'proveedor5@example.com', NULL, 'Bodega de demostración 5, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(6, 'Electrodomésticos Central Demo', NULL, 'Contacto de demostración 6', 'proveedor6@example.com', NULL, 'Bodega de demostración 6, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(7, 'Hogar Práctico Demo', NULL, 'Contacto de demostración 7', 'proveedor7@example.com', NULL, 'Bodega de demostración 7, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(8, 'Estilo Urbano Demo', NULL, 'Contacto de demostración 8', 'proveedor8@example.com', NULL, 'Bodega de demostración 8, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(9, 'Ruta Activa Demo', NULL, 'Contacto de demostración 9', 'proveedor9@example.com', NULL, 'Bodega de demostración 9, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(10, 'Cuidado Diario Demo', NULL, 'Contacto de demostración 10', 'proveedor10@example.com', NULL, 'Bodega de demostración 10, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(11, 'Taller y Obra Demo', NULL, 'Contacto de demostración 11', 'proveedor11@example.com', NULL, 'Bodega de demostración 11, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00'),
(12, 'Compañía Animal Demo', NULL, 'Contacto de demostración 12', 'proveedor12@example.com', NULL, 'Bodega de demostración 12, Ciudad de Guatemala', 'Activo', '2026-06-01 08:00:00');

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

--
-- Volcado de datos para la tabla `resenas`
--

INSERT INTO `resenas` (`ResenaID`, `UsuarioID`, `ProductoID`, `Calificacion`, `Comentario`, `FechaResena`, `Estado`) VALUES
(1, 3, 1, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-06 15:00:00', 'Publicada'),
(2, 3, 2, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-06 15:00:00', 'Publicada'),
(3, 4, 4, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-07 15:00:00', 'Publicada'),
(4, 4, 5, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-07 15:00:00', 'Publicada'),
(5, 5, 7, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-08 15:00:00', 'Publicada'),
(6, 5, 8, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-08 15:00:00', 'Publicada'),
(7, 6, 10, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-09 15:00:00', 'Publicada'),
(8, 6, 11, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-09 15:00:00', 'Publicada'),
(9, 7, 13, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-10 15:00:00', 'Publicada'),
(10, 7, 14, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-10 15:00:00', 'Publicada'),
(11, 8, 16, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-11 15:00:00', 'Publicada'),
(12, 8, 17, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-11 15:00:00', 'Publicada'),
(13, 9, 19, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-12 15:00:00', 'Publicada'),
(14, 9, 20, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-12 15:00:00', 'Publicada'),
(15, 10, 22, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-13 15:00:00', 'Publicada'),
(16, 10, 23, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-13 15:00:00', 'Publicada'),
(17, 11, 25, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-14 15:00:00', 'Publicada'),
(18, 11, 26, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-14 15:00:00', 'Publicada'),
(19, 13, 28, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-15 15:00:00', 'Publicada'),
(20, 13, 29, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-15 15:00:00', 'Publicada'),
(21, 14, 31, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-16 15:00:00', 'Publicada'),
(22, 14, 32, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-16 15:00:00', 'Publicada'),
(23, 15, 34, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-17 15:00:00', 'Publicada'),
(24, 15, 35, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-17 15:00:00', 'Publicada'),
(25, 16, 37, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-18 15:00:00', 'Publicada'),
(26, 16, 38, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-18 15:00:00', 'Publicada'),
(27, 17, 40, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-19 15:00:00', 'Publicada'),
(28, 17, 41, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-19 15:00:00', 'Publicada'),
(29, 18, 43, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-20 15:00:00', 'Publicada'),
(30, 18, 44, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-20 15:00:00', 'Publicada'),
(31, 19, 46, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-21 15:00:00', 'Publicada'),
(32, 19, 47, 3, 'El producto llegó bien empacado y funciona como esperaba.', '2026-08-21 15:00:00', 'Publicada'),
(33, 20, 49, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-22 15:00:00', 'Publicada'),
(34, 20, 50, 4, 'Buena relación entre precio y calidad; la entrega fue puntual.', '2026-08-22 15:00:00', 'Publicada'),
(35, 21, 52, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-23 15:00:00', 'Publicada'),
(36, 21, 53, 5, 'Cumple su función, aunque las instrucciones podrían ser más claras.', '2026-08-23 15:00:00', 'Publicada');

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
(1, 'Oscar Estuardo', 'Ardón Castillo', 'adminoa@todoaqui.gt', '5500-1234', 'adminoa', '$2y$10$nRR49i1qmznd2RUwwzbqZOnpMNZdf/Ucf6DynK0FreWGGEDXK1Fv6', 'Administrador', 'Activo', '2024-12-01 12:00:00'),
(2, 'Alba Gabriela', 'Ortega', 'adminao@todoaqui.gt', '5500-4321', 'adminao', '$2y$10$S9sRqSZ8jOiGxKrUXE89DuBuI6vTRMBdu/TCcnHZJ2yJ4QoODf6lu', 'Administrador', 'Activo', '2024-12-01 12:00:00'),
(3, 'Ana', 'García López', 'cliente001@example.com', '5550-0001', 'cliente001', '$2y$10$Vdnxk/y9Uydb9HL50/3a3eZtbwZuf.WuDTRHmogSHUNQt0i7bunQG', 'Cliente', 'Activo', '2025-01-13 09:07:00'),
(4, 'Carlos', 'López Ramírez', 'cliente002@example.com', '5550-0002', 'cliente002', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-16 10:14:00'),
(5, 'María', 'González Méndez', 'cliente003@example.com', '5550-0003', 'cliente003', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-19 11:21:00'),
(6, 'José', 'Castillo Reyes', 'cliente004@example.com', '5550-0004', 'cliente004', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-22 12:28:00'),
(7, 'Gabriela', 'Vásquez Flores', 'cliente005@example.com', '5550-0005', 'cliente005', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-25 13:35:00'),
(8, 'Luis', 'Aguilar Rojas', 'cliente006@example.com', '5550-0006', 'cliente006', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-28 14:42:00'),
(9, 'Daniela', 'Fuentes Herrera', 'cliente007@example.com', '5550-0007', 'cliente007', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-01-31 15:49:00'),
(10, 'Fernando', 'Salazar Pineda', 'cliente008@example.com', '5550-0008', 'cliente008', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-03 16:56:00'),
(11, 'Paola', 'Alvarado Cifuentes', 'cliente009@example.com', '5550-0009', 'cliente009', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-06 08:03:00'),
(12, 'Ricardo', 'Rodríguez Morales', 'cliente010@example.com', '5550 0010', 'cliente010', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-02-09 09:10:00'),
(13, 'Sofía', 'Hernández Castillo', 'cliente011@example.com', '5550-0011', 'cliente011', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-12 10:17:00'),
(14, 'Javier', 'Morales Vásquez', 'cliente012@example.com', '5550-0012', 'cliente012', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-15 11:24:00'),
(15, 'Andrea', 'Díaz Aguilar', 'cliente013@example.com', '5550-0013', 'cliente013', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-18 12:31:00'),
(16, 'Miguel', 'Ortiz Fuentes', 'cliente014@example.com', '5550-0014', 'cliente014', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-21 13:38:00'),
(17, 'Valeria', 'Cabrera Salazar', 'cliente015@example.com', '5550-0015', 'cliente015', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-24 14:45:00'),
(18, 'Diego', 'Mendoza Alvarado', 'cliente016@example.com', '5550-0016', 'cliente016', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-02-27 15:52:00'),
(19, 'Lucía', 'Calderón Escobar', 'cliente017@example.com', '5550-0017', 'cliente017', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-02 16:59:00'),
(20, 'Alejandro', 'Pérez Hernández', 'cliente018@example.com', '5550 0018', 'cliente018', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-05 08:06:00'),
(21, 'Camila', 'Martínez Gómez', 'cliente019@example.com', '5550-0019', 'cliente019', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-08 09:13:00'),
(22, 'Manuel', 'Ramírez Díaz', 'cliente020@example.com', '5550-0020', 'cliente020', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-03-11 10:20:00'),
(23, 'Fernanda', 'Méndez Ortiz', 'cliente021@example.com', '5550-0021', 'cliente021', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-14 11:27:00'),
(24, 'Esteban', 'Reyes Cabrera', 'cliente022@example.com', '5550-0022', 'cliente022', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-17 12:34:00'),
(25, 'Natalia', 'Flores Mendoza', 'cliente023@example.com', '5550-0023', 'cliente023', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-20 13:41:00'),
(26, 'Oscar', 'Rojas Calderón', 'cliente024@example.com', '5550-0024', 'cliente024', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-23 14:48:00'),
(27, 'Isabel', 'Herrera Barrios', 'cliente025@example.com', '5550-0025', 'cliente025', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-26 15:55:00'),
(28, 'Héctor', 'García López', 'cliente026@example.com', '5550-0026', 'cliente026', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-03-29 16:02:00'),
(29, 'Elena', 'López Ramírez', 'cliente027@example.com', '5550-0027', 'cliente027', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-01 08:09:00'),
(30, 'Roberto', 'González Méndez', 'cliente028@example.com', '5550 0028', 'cliente028', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-04 09:16:00'),
(31, 'Mónica', 'Castillo Reyes', 'cliente029@example.com', '5550-0029', 'cliente029', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-07 10:23:00'),
(32, 'Andrés', 'Vásquez Flores', 'cliente030@example.com', '5550-0030', 'cliente030', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-04-10 11:30:00'),
(33, 'Ana', 'Aguilar Rojas', 'cliente031@example.com', '5550-0031', 'cliente031', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-13 12:37:00'),
(34, 'Carlos', 'Fuentes Herrera', 'cliente032@example.com', '5550-0032', 'cliente032', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-16 13:44:00'),
(35, 'María', 'Salazar Pineda', 'cliente033@example.com', '5550-0033', 'cliente033', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-19 14:51:00'),
(36, 'José', 'Alvarado Cifuentes', 'cliente034@example.com', '5550-0034', 'cliente034', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-22 15:58:00'),
(37, 'Gabriela', 'Rodríguez Morales', 'cliente035@example.com', '5550 0035', 'cliente035', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-25 16:05:00'),
(38, 'Luis', 'Hernández Castillo', 'cliente036@example.com', '5550-0036', 'cliente036', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-04-28 08:12:00'),
(39, 'Daniela', 'Morales Vásquez', 'cliente037@example.com', '5550-0037', 'cliente037', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-01 09:19:00'),
(40, 'Fernando', 'Díaz Aguilar', 'cliente038@example.com', '5550-0038', 'cliente038', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-04 10:26:00'),
(41, 'Paola', 'Ortiz Fuentes', 'cliente039@example.com', '5550-0039', 'cliente039', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-07 11:33:00'),
(42, 'Ricardo', 'Cabrera Salazar', 'cliente040@example.com', '5550-0040', 'cliente040', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-05-10 12:40:00'),
(43, 'Sofía', 'Mendoza Alvarado', 'cliente041@example.com', '5550-0041', 'cliente041', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-13 13:47:00'),
(44, 'Javier', 'Calderón Escobar', 'cliente042@example.com', '5550-0042', 'cliente042', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-16 14:54:00'),
(45, 'Andrea', 'Pérez Hernández', 'cliente043@example.com', '5550-0043', 'cliente043', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-19 15:01:00'),
(46, 'Miguel', 'Martínez Gómez', 'cliente044@example.com', '5550-0044', 'cliente044', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-22 16:08:00'),
(47, 'Valeria', 'Ramírez Díaz', 'cliente045@example.com', '5550-0045', 'cliente045', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-25 08:15:00'),
(48, 'Diego', 'Méndez Ortiz', 'cliente046@example.com', '5550-0046', 'cliente046', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-28 09:22:00'),
(49, 'Lucía', 'Reyes Cabrera', 'cliente047@example.com', '5550-0047', 'cliente047', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-05-31 10:29:00'),
(50, 'Alejandro', 'Flores Mendoza', 'cliente048@example.com', '5550-0048', 'cliente048', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-03 11:36:00'),
(51, 'Camila', 'Rojas Calderón', 'cliente049@example.com', '5550-0049', 'cliente049', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-06 12:43:00'),
(52, 'Manuel', 'Herrera Barrios', 'cliente050@example.com', '5550-0050', 'cliente050', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-06-09 13:50:00'),
(53, 'Fernanda', 'García López', 'cliente051@example.com', '5550-0051', 'cliente051', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-12 14:57:00'),
(54, 'Esteban', 'López Ramírez', 'cliente052@example.com', '5550-0052', 'cliente052', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-15 15:04:00'),
(55, 'Natalia', 'González Méndez', 'cliente053@example.com', '5550-0053', 'cliente053', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-18 16:11:00'),
(56, 'Oscar', 'Castillo Reyes', 'cliente054@example.com', '5550-0054', 'cliente054', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-21 08:18:00'),
(57, 'Isabel', 'Vásquez Flores', 'cliente055@example.com', '5550-0055', 'cliente055', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-24 09:25:00'),
(58, 'Héctor', 'Aguilar Rojas', 'cliente056@example.com', '5550-0056', 'cliente056', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-27 10:32:00'),
(59, 'Elena', 'Fuentes Herrera', 'cliente057@example.com', '5550-0057', 'cliente057', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-06-30 11:39:00'),
(60, 'Roberto', 'Salazar Pineda', 'cliente058@example.com', '5550-0058', 'cliente058', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-03 12:46:00'),
(61, 'Mónica', 'Alvarado Cifuentes', 'cliente059@example.com', '5550-0059', 'cliente059', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-06 13:53:00'),
(62, 'Andrés', 'Rodríguez Morales', 'cliente060@example.com', '5550-0060', 'cliente060', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-07-09 14:00:00'),
(63, 'Ana', 'Hernández Castillo', 'cliente061@example.com', '5550-0061', 'cliente061', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-12 15:07:00'),
(64, 'Carlos', 'Morales Vásquez', 'cliente062@example.com', '5550-0062', 'cliente062', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-15 16:14:00'),
(65, 'María', 'Díaz Aguilar', 'cliente063@example.com', '5550-0063', 'cliente063', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-18 08:21:00'),
(66, 'José', 'Ortiz Fuentes', 'cliente064@example.com', '5550-0064', 'cliente064', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-21 09:28:00'),
(67, 'Gabriela', 'Cabrera Salazar', 'cliente065@example.com', '5550-0065', 'cliente065', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-24 10:35:00'),
(68, 'Luis', 'Mendoza Alvarado', 'cliente066@example.com', '5550-0066', 'cliente066', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-27 11:42:00'),
(69, 'Daniela', 'Calderón Escobar', 'cliente067@example.com', '5550-0067', 'cliente067', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-07-30 12:49:00'),
(70, 'Fernando', 'Pérez Hernández', 'cliente068@example.com', '5550-0068', 'cliente068', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-02 13:56:00'),
(71, 'Paola', 'Martínez Gómez', 'cliente069@example.com', '5550-0069', 'cliente069', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-05 14:03:00'),
(72, 'Ricardo', 'Ramírez Díaz', 'cliente070@example.com', '5550-0070', 'cliente070', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-08-08 15:10:00'),
(73, 'Sofía', 'Méndez Ortiz', 'cliente071@example.com', '5550-0071', 'cliente071', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-11 16:17:00'),
(74, 'Javier', 'Reyes Cabrera', 'cliente072@example.com', '5550-0072', 'cliente072', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-14 08:24:00'),
(75, 'Andrea', 'Flores Mendoza', 'cliente073@example.com', '5550-0073', 'cliente073', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-17 09:31:00'),
(76, 'Miguel', 'Rojas Calderón', 'cliente074@example.com', '5550-0074', 'cliente074', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-20 10:38:00'),
(77, 'Valeria', 'Herrera Barrios', 'cliente075@example.com', '5550-0075', 'cliente075', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-23 11:45:00'),
(78, 'Diego', 'García López', 'cliente076@example.com', '5550-0076', 'cliente076', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-26 12:52:00'),
(79, 'Lucía', 'López Ramírez', 'cliente077@example.com', '5550-0077', 'cliente077', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-08-29 13:59:00'),
(80, 'Alejandro', 'González Méndez', 'cliente078@example.com', '5550-0078', 'cliente078', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-01 14:06:00'),
(81, 'Manuel', 'Vásquez Flores', 'cliente080@example.com', '5550-0080', 'cliente080', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-09-07 16:20:00'),
(82, 'Fernanda', 'Aguilar Rojas', 'cliente081@example.com', '5550-0081', 'cliente081', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-10 08:27:00'),
(83, 'Esteban', 'Fuentes Herrera', 'cliente082@example.com', '5550-0082', 'cliente082', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-13 09:34:00'),
(84, 'Natalia', 'Salazar Pineda', 'cliente083@example.com', '5550-0083', 'cliente083', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-16 10:41:00'),
(85, 'Oscar', 'Alvarado Cifuentes', 'cliente084@example.com', '5550-0084', 'cliente084', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-19 11:48:00'),
(86, 'Isabel', 'Rodríguez Morales', 'cliente085@example.com', '5550-0085', 'cliente085', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-22 12:55:00'),
(87, 'Héctor', 'Hernández Castillo', 'cliente086@example.com', '5550-0086', 'cliente086', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-25 13:02:00'),
(88, 'Elena', 'Morales Vásquez', 'cliente087@example.com', '5550-0087', 'cliente087', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-09-28 14:09:00'),
(89, 'Roberto', 'Díaz Aguilar', 'cliente088@example.com', '5550-0088', 'cliente088', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-01 15:16:00'),
(90, 'Mónica', 'Ortiz Fuentes', 'cliente089@example.com', '5550-0089', 'cliente089', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-04 16:23:00'),
(91, 'Andrés', 'Cabrera Salazar', 'cliente090@example.com', '5550-0090', 'cliente090', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-10-07 08:30:00'),
(92, 'Ana', 'Mendoza Alvarado', 'cliente091@example.com', '5550-0091', 'cliente091', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-10 09:37:00'),
(93, 'Carlos', 'Calderón Escobar', 'cliente092@example.com', '5550-0092', 'cliente092', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-13 10:44:00'),
(94, 'María', 'Pérez Hernández', 'cliente093@example.com', '5550-0093', 'cliente093', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-16 11:51:00'),
(95, 'José', 'Martínez Gómez', 'cliente094@example.com', '5550-0094', 'cliente094', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-19 12:58:00'),
(96, 'Gabriela', 'Ramírez Díaz', 'cliente095@example.com', '5550-0095', 'cliente095', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-22 13:05:00'),
(97, 'Luis', 'Méndez Ortiz', 'cliente096@example.com', '5550-0096', 'cliente096', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-25 14:12:00'),
(98, 'Daniela', 'Reyes Cabrera', 'cliente097@example.com', '5550-0097', 'cliente097', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-28 15:19:00'),
(99, 'Fernando', 'Flores Mendoza', 'cliente098@example.com', '5550 0098', 'cliente098', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-10-31 16:26:00'),
(100, 'Paola', 'Rojas Calderón', 'cliente099@example.com', '5550-0099', 'cliente099', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-03 08:33:00'),
(101, 'Ricardo', 'Herrera Barrios', 'cliente100@example.com', '5550-0100', 'cliente100', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-11-06 09:40:00'),
(102, 'Sofía', 'García López', 'cliente101@example.com', '5550-0101', 'cliente101', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-09 10:47:00'),
(103, 'Javier', 'López Ramírez', 'cliente102@example.com', '5550-0102', 'cliente102', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-12 11:54:00'),
(104, 'Andrea', 'González Méndez', 'cliente103@example.com', '5550-0103', 'cliente103', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-15 12:01:00'),
(105, 'Miguel', 'Castillo Reyes', 'cliente104@example.com', '5550-0104', 'cliente104', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-18 13:08:00'),
(106, 'Valeria', 'Vásquez Flores', 'cliente105@example.com', '5550-0105', 'cliente105', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-21 14:15:00'),
(107, 'Diego', 'Aguilar Rojas', 'cliente106@example.com', '5550-0106', 'cliente106', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-24 15:22:00'),
(108, 'Lucía', 'Fuentes Herrera', 'cliente107@example.com', '5550-0107', 'cliente107', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-27 16:29:00'),
(109, 'Alejandro', 'Salazar Pineda', 'cliente108@example.com', '5550-0108', 'cliente108', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-11-30 08:36:00'),
(110, 'Camila', 'Alvarado Cifuentes', 'cliente109@example.com', '5550-0109', 'cliente109', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-03 09:43:00'),
(111, 'Manuel', 'Rodríguez Morales', 'cliente110@example.com', '5550-0110', 'cliente110', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2025-12-06 10:50:00'),
(112, 'Fernanda', 'Hernández Castillo', 'cliente111@example.com', '5550-0111', 'cliente111', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-09 11:57:00'),
(113, 'Esteban', 'Morales Vásquez', 'cliente112@example.com', '5550-0112', 'cliente112', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-12 12:04:00'),
(114, 'Natalia', 'Díaz Aguilar', 'cliente113@example.com', '5550-0113', 'cliente113', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-15 13:11:00'),
(115, 'Oscar', 'Ortiz Fuentes', 'cliente114@example.com', '5550-0114', 'cliente114', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-18 14:18:00'),
(116, 'Isabel', 'Cabrera Salazar', 'cliente115@example.com', '5550-0115', 'cliente115', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-21 15:25:00'),
(117, 'Héctor', 'Mendoza Alvarado', 'cliente116@example.com', '5550-0116', 'cliente116', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-24 16:32:00'),
(118, 'Elena', 'Calderón Escobar', 'cliente117@example.com', '5550-0117', 'cliente117', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-27 08:39:00'),
(119, 'Roberto', 'Pérez Hernández', 'cliente118@example.com', '5550-0118', 'cliente118', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2025-12-30 09:46:00'),
(120, 'Mónica', 'Martínez Gómez', 'cliente119@example.com', '5550-0119', 'cliente119', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-02 10:53:00'),
(121, 'Andrés', 'Ramírez Díaz', 'cliente120@example.com', '5550-0120', 'cliente120', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-01-05 11:00:00'),
(122, 'Ana', 'Méndez Ortiz', 'cliente121@example.com', '5550-0121', 'cliente121', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-08 12:07:00'),
(123, 'Carlos', 'Reyes Cabrera', 'cliente122@example.com', '5550-0122', 'cliente122', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-11 13:14:00'),
(124, 'María', 'Flores Mendoza', 'cliente123@example.com', '5550-0123', 'cliente123', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-14 14:21:00'),
(125, 'José', 'Rojas Calderón', 'cliente124@example.com', '5550-0124', 'cliente124', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-17 15:28:00'),
(126, 'Gabriela', 'Herrera Barrios', 'cliente125@example.com', '5550-0125', 'cliente125', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-20 16:35:00'),
(127, 'Luis', 'García López', 'cliente126@example.com', '5550-0126', 'cliente126', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-23 08:42:00'),
(128, 'Daniela', 'López Ramírez', 'cliente127@example.com', '5550-0127', 'cliente127', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-26 09:49:00'),
(129, 'Fernando', 'González Méndez', 'cliente128@example.com', '5550-0128', 'cliente128', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-01-29 10:56:00'),
(130, 'Paola', 'Castillo Reyes', 'cliente129@example.com', '5550-0129', 'cliente129', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-01 11:03:00'),
(131, 'Ricardo', 'Vásquez Flores', 'cliente130@example.com', '5550-0130', 'cliente130', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-02-04 12:10:00'),
(132, 'Sofía', 'Aguilar Rojas', 'cliente131@example.com', '5550-0131', 'cliente131', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-07 13:17:00'),
(133, 'Javier', 'Fuentes Herrera', 'cliente132@example.com', '5550-0132', 'cliente132', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-10 14:24:00'),
(134, 'Andrea', 'Salazar Pineda', 'cliente133@example.com', '5550-0133', 'cliente133', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-13 15:31:00'),
(135, 'Miguel', 'Alvarado Cifuentes', 'cliente134@example.com', '5550-0134', 'cliente134', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-16 16:38:00'),
(136, 'Valeria', 'Rodríguez Morales', 'cliente135@example.com', '5550-0135', 'cliente135', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-19 08:45:00'),
(137, 'Diego', 'Hernández Castillo', 'cliente136@example.com', '5550-0136', 'cliente136', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-22 09:52:00'),
(138, 'Lucía', 'Morales Vásquez', 'cliente137@example.com', '5550-0137', 'cliente137', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-25 10:59:00'),
(139, 'Alejandro', 'Díaz Aguilar', 'cliente138@example.com', '5550-0138', 'cliente138', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-28 11:06:00'),
(140, 'Camila', 'Ortiz Fuentes', 'cliente139@example.com', '5550-0139', 'cliente139', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-03 12:13:00'),
(141, 'Manuel', 'Cabrera Salazar', 'cliente140@example.com', '5550-0140', 'cliente140', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-03-06 13:20:00'),
(142, 'Fernanda', 'Mendoza Alvarado', 'cliente141@example.com', '5550-0141', 'cliente141', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-09 14:27:00'),
(143, 'Esteban', 'Calderón Escobar', 'cliente142@example.com', '5550-0142', 'cliente142', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-12 15:34:00'),
(144, 'Natalia', 'Pérez Hernández', 'cliente143@example.com', '5550-0143', 'cliente143', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-15 16:41:00'),
(145, 'Oscar', 'Martínez Gómez', 'cliente144@example.com', '5550-0144', 'cliente144', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-18 08:48:00'),
(146, 'Isabel', 'Ramírez Díaz', 'cliente145@example.com', '5550-0145', 'cliente145', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-21 09:55:00'),
(147, 'Héctor', 'Méndez Ortiz', 'cliente146@example.com', '5550-0146', 'cliente146', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-24 10:02:00'),
(148, 'Elena', 'Reyes Cabrera', 'cliente147@example.com', '5550-0147', 'cliente147', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-27 11:09:00'),
(149, 'Roberto', 'Flores Mendoza', 'cliente148@example.com', '5550-0148', 'cliente148', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-03-30 12:16:00'),
(150, 'Mónica', 'Rojas Calderón', 'cliente149@example.com', '5550-0149', 'cliente149', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-04-02 13:23:00'),
(151, 'Andrés', 'Herrera Barrios', 'cliente150@example.com', '5550-0150', 'cliente150', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Inactivo', '2026-04-05 14:30:00'),
(152, 'Mariana', 'Soto Villagrán', 'mariana.soto151@example.com', '5551-0151', 'marianasoto151', '$2y$12$qDdl9rxMat1KSbvYQRy1J.XqXGCHYJSaBcVLNqI7Ipu0v74caYs2a', 'Cliente', 'Activo', '2026-02-14 10:20:00');

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
  MODIFY `CategoriaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `detalledevoluciones`
--
ALTER TABLE `detalledevoluciones`
  MODIFY `DetalleDevolucionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `detallefacturas`
--
ALTER TABLE `detallefacturas`
  MODIFY `DetalleFacturaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT de la tabla `detalleordenes`
--
ALTER TABLE `detalleordenes`
  MODIFY `DetalleOrdenID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `DevolucionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `DireccionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `FacturaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `OrdenID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `PagoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ProductoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `PromocionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ProveedorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `resenas`
--
ALTER TABLE `resenas`
  MODIFY `ResenaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `UsuarioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

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
