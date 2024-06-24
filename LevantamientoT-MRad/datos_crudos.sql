-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-06-2024 a las 22:23:16
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `datos_radiacion`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_crudos`
--

CREATE TABLE `datos_crudos` (
  `Punto` varchar(10) CHARACTER SET armscii8 NOT NULL,
  `Distancia (m)` varchar(15) CHARACTER SET armscii8 NOT NULL,
  `HD (decimales)` varchar(10) CHARACTER SET armscii8 NOT NULL,
  `VD (decimales)` varchar(10) CHARACTER SET armscii8 NOT NULL,
  `X este (m)` varchar(15) CHARACTER SET armscii8 NOT NULL,
  `Y norte (m)` varchar(15) CHARACTER SET armscii8 NOT NULL,
  `Z cota (m)` varchar(15) CHARACTER SET armscii8 NOT NULL,
  `Cod` varchar(10) CHARACTER SET armscii8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `datos_crudos`
--

INSERT INTO `datos_crudos` (`Punto`, `Distancia (m)`, `HD (decimales)`, `VD (decimales)`, `X este (m)`, `Y norte (m)`, `Z cota (m)`, `Cod`) VALUES
('1', '120.785', '45.209', '30.363', '510.261', '-33.45050', '302.175', 'p1'),
('2', '110.567', '50.123', '25.456', '515.678', '-32.56780', '305.456', 'p2'),
('3', '95.432', '55.345', '35.123', '520.123', '-34.23450', '298.567', 'p3'),
('4', '130.789', '60.678', '40.789', '525.678', '31.45670', '310.678', 'p4'),
('5', '105.345', '65.234', '45.123', '530.234', '-30.12340', '315.789', 'p5'),
('6', '115.678', '70.456', '50.678', '535.789', '-35.67890', '320.123', 'p6'),
('7', '98.234', '75.789', '55.234', '540.123', '-29.78901', '325.456', 'p7'),
('8', '120.567', '80.123', '60.456', '545.678', '28.56789', '330.789', 'p8'),
('9', '107.890', '85.456', '65.789', '550.234', '-27.34567', '335.123', 'p9'),
('10', '112.345', '90.789', '70.123', '555.789', '-26.12345', '340.456', 'p10'),
('11', '99.678', '95.123', '75.456', '560.123', '-25.90123', '345.789', 'p11'),
('12', '105.234', '100.456', '80.789', '565.567', '-24.67890', '350.123', 'p12'),
('13', '110.789', '105.789', '85.123', '570.234', '-23.45678', '355.456', 'p13'),
('14', '125.456', '110.123', '90.456', '575.789', '-22.23456', '360.789', 'p14'),
('15', '130.123', '115.456', '95.789', '580.123', '-21.01234', '365.123', 'p15');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
