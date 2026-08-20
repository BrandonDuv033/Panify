-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: panify
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS panify;
use panify;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del cliente.',
  `tipoCliente` enum('Nuevo','Frecuente','Ocasional') NOT NULL COMMENT 'Clasificación del cliente (ej. Nuevo, Frecuente, Ocasional).',
  `direccion` varchar(150) NOT NULL COMMENT 'Dirección de despacho o residencia del cliente.',
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Nuevo','Diagonal 63 #29-18, Barrio Modelia, Bogotá D.C.'),(2,'Ocasional','Calle 109 #5-4, Barrio Suba, Bogotá D.C.'),(3,'Frecuente','Calle 51 #92-84, Barrio Salitre, Bogotá D.C.'),(4,'Nuevo','Diagonal 2 #98-21, Barrio Salitre, Bogotá D.C.'),(5,'Nuevo','Carrera 87 #14-12, Barrio Tunjuelito, Bogotá D.C.'),(6,'Ocasional','Diagonal 12 #94-59, Barrio Los Mártires, Bogotá D.C.'),(7,'Frecuente','Diagonal 93 #74-25, Barrio Salitre, Bogotá D.C.'),(8,'Frecuente','Diagonal 21 #30-13, Barrio Tunjuelito, Bogotá D.C.'),(9,'Frecuente','Diagonal 42 #48-46, Barrio Bosa, Bogotá D.C.'),(10,'Ocasional','Calle 44 #69-94, Barrio Teusaquillo, Bogotá D.C.'),(11,'Frecuente','Carrera 84 #99-8, Barrio Teusaquillo, Bogotá D.C.'),(12,'Frecuente','Diagonal 17 #28-73, Barrio Castilla, Bogotá D.C.'),(13,'Nuevo','Transversal 102 #83-59, Barrio Engativá, Bogotá D.C.'),(14,'Nuevo','Diagonal 110 #75-52, Barrio Rafael Uribe Uribe, Bogotá D.C.'),(15,'Frecuente','Calle 13 #15-20, Barrio Cedritos, Bogotá D.C.'),(16,'Frecuente','Calle 99 #49-77, Barrio Antonio Nariño, Bogotá D.C.'),(17,'Ocasional','Calle 30 #88-69, Barrio Normandía, Bogotá D.C.'),(18,'Frecuente','Calle 76 #56-21, Barrio Antonio Nariño, Bogotá D.C.'),(19,'Ocasional','Diagonal 129 #98-23, Barrio Santa Fe, Bogotá D.C.'),(20,'Frecuente','Carrera 40 #48-98, Barrio Fontibón, Bogotá D.C.'),(21,'Ocasional','Calle 83 #63-3, Barrio Kennedy, Bogotá D.C.'),(22,'Ocasional','Diagonal 62 #8-31, Barrio Castilla, Bogotá D.C.'),(23,'Nuevo','Transversal 18 #98-69, Barrio Normandía, Bogotá D.C.'),(24,'Frecuente','Carrera 68 #68-78, Barrio Barrios Unidos, Bogotá D.C.'),(25,'Frecuente','Carrera 80 #52-86, Barrio Cedritos, Bogotá D.C.'),(26,'Ocasional','Transversal 31 #32-29, Barrio Suba, Bogotá D.C.'),(27,'Frecuente','Carrera 57 #1-10, Barrio Salitre, Bogotá D.C.'),(28,'Nuevo','Calle 85 #10-66, Barrio Teusaquillo, Bogotá D.C.'),(29,'Frecuente','Carrera 122 #32-61, Barrio Galerías, Bogotá D.C.'),(30,'Nuevo','Transversal 91 #55-53, Barrio Antonio Nariño, Bogotá D.C.'),(31,'Frecuente','Calle 16 #52-94, Barrio San Cristóbal, Bogotá D.C.'),(32,'Nuevo','Transversal 36 #55-24, Barrio Puente Aranda, Bogotá D.C.'),(33,'Ocasional','Calle 114 #71-13, Barrio Usaquén, Bogotá D.C.'),(34,'Ocasional','Calle 61 #22-53, Barrio La Candelaria, Bogotá D.C.'),(35,'Ocasional','Calle 43 #49-1, Barrio Tunjuelito, Bogotá D.C.'),(36,'Ocasional','Transversal 74 #55-90, Barrio Modelia, Bogotá D.C.'),(37,'Ocasional','Carrera 49 #38-28, Barrio Usaquén, Bogotá D.C.'),(38,'Frecuente','Diagonal 15 #7-75, Barrio La Candelaria, Bogotá D.C.'),(39,'Ocasional','Carrera 15 #66-11, Barrio Quirigua, Bogotá D.C.'),(40,'Frecuente','Carrera 104 #16-73, Barrio Teusaquillo, Bogotá D.C.'),(41,'Nuevo','Calle 108 #85-75, Barrio Usme, Bogotá D.C.'),(42,'Ocasional','Carrera 81 #31-34, Barrio Tunjuelito, Bogotá D.C.'),(43,'Frecuente','Transversal 81 #97-10, Barrio Chapinero, Bogotá D.C.'),(44,'Ocasional','Calle 19 #69-28, Barrio Santa Fe, Bogotá D.C.'),(45,'Ocasional','Calle 63 #48-37, Barrio Fontibón, Bogotá D.C.'),(46,'Frecuente','Diagonal 3 #86-71, Barrio Ciudad Bolívar, Bogotá D.C.'),(47,'Ocasional','Carrera 68 #15-14, Barrio Modelia, Bogotá D.C.'),(48,'Nuevo','Carrera 88 #27-88, Barrio Cedritos, Bogotá D.C.'),(49,'Frecuente','Calle 24 #82-55, Barrio Prado Veraniego, Bogotá D.C.'),(50,'Nuevo','Carrera 68 #21-95, Barrio Antonio Nariño, Bogotá D.C.');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `idDetalle_Pedido` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único de la línea de detalle.',
  `precioFijo` decimal(10,2) NOT NULL COMMENT 'Precio unitario del producto congelado al momento de la compra.',
  `cantidad` int(11) NOT NULL COMMENT 'Número de unidades solicitadas de un mismo producto.',
  `pedido_idPedido` int(11) NOT NULL COMMENT 'Clave foránea (FK). Conecta este detalle con la cabecera del pedido global.',
  `producto_idProducto` int(11) NOT NULL,
  PRIMARY KEY (`idDetalle_Pedido`),
  KEY `fk_Detalle_Pedido_Pedido1_idx` (`pedido_idPedido`),
  KEY `fk_detalle_pedido_producto1_idx` (`producto_idProducto`),
  CONSTRAINT `fk_Detalle_Pedido_Pedido1` FOREIGN KEY (`pedido_idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_pedido_producto1` FOREIGN KEY (`producto_idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
INSERT INTO `detalle_pedido` VALUES (1,7500.00,9,1,46),(2,1500.00,5,2,8),(3,4500.00,3,3,6),(4,45000.00,8,4,18),(5,15000.00,3,5,33),(6,2500.00,2,6,28),(7,3000.00,8,7,15),(8,7500.00,1,8,23),(9,80000.00,1,9,27),(10,2200.00,9,10,26),(11,2000.00,4,11,24),(12,1500.00,2,12,25),(13,2000.00,4,13,24),(14,2000.00,6,14,2),(15,4500.00,12,15,7),(16,5000.00,6,16,42),(17,80000.00,3,17,10),(18,15000.00,5,18,3),(19,6000.00,12,19,31),(20,7500.00,12,20,9),(21,6000.00,8,21,31),(22,18000.00,1,22,40),(23,4500.00,1,23,6),(24,45000.00,4,24,17),(25,80000.00,9,25,10),(26,5000.00,10,26,47),(27,6000.00,7,27,34),(28,1500.00,5,28,8),(29,3000.00,5,29,16),(30,1500.00,1,30,8),(31,3000.00,7,31,16),(32,15000.00,10,32,41),(33,15000.00,2,33,30),(34,1500.00,8,34,8),(35,18000.00,9,35,39),(36,2000.00,11,36,2),(37,15000.00,10,37,33),(38,3000.00,12,38,16),(39,80000.00,5,39,10),(40,2500.00,1,40,28),(41,18000.00,6,41,40),(42,3000.00,10,42,16),(43,80000.00,3,43,27),(44,5000.00,11,44,43),(45,4500.00,9,45,6),(46,2000.00,2,46,24),(47,6000.00,9,47,34),(48,15000.00,9,48,33),(49,4500.00,1,49,36),(50,1500.00,8,50,25);
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domiciliario`
--

DROP TABLE IF EXISTS `domiciliario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domiciliario` (
  `idDomiciliario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del repartidor o domiciliario.',
  `estadoDisponibilidad` enum('Libre','Ocupado','Inactivo') NOT NULL COMMENT 'Disponibilidad actual del domiciliario (ej. Libre, Ocupado, Inactivo)',
  PRIMARY KEY (`idDomiciliario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domiciliario`
--

LOCK TABLES `domiciliario` WRITE;
/*!40000 ALTER TABLE `domiciliario` DISABLE KEYS */;
INSERT INTO `domiciliario` VALUES (1,'Libre'),(2,'Ocupado');
/*!40000 ALTER TABLE `domiciliario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `idInventario` int(11) NOT NULL AUTO_INCREMENT,
  `stockMinimo` int(11) NOT NULL,
  `stockActual` int(11) NOT NULL,
  `producto_idProducto` int(11) NOT NULL,
  PRIMARY KEY (`idInventario`),
  UNIQUE KEY `idInventario_UNIQUE` (`idInventario`),
  KEY `fk_inventario_producto1_idx` (`producto_idProducto`),
  CONSTRAINT `fk_inventario_producto1` FOREIGN KEY (`producto_idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,8,45,1),(2,12,50,2),(3,5,21,3),(4,13,0,4),(5,14,30,5),(6,20,0,6),(7,14,70,7),(8,15,21,8),(9,13,74,9),(10,8,6,10),(11,20,1,11),(12,9,4,12),(13,7,22,13),(14,18,97,14),(15,12,60,15),(16,19,57,16),(17,18,1,17),(18,8,34,18),(19,11,21,19),(20,10,80,20),(21,7,59,21),(22,19,79,22),(23,14,4,23),(24,14,72,24),(25,7,40,25),(26,11,80,26),(27,12,46,27),(28,9,2,28),(29,14,86,29),(30,14,73,30),(31,14,48,31),(32,20,96,32),(33,6,47,33),(34,13,3,34),(35,5,39,35),(36,6,28,36),(37,20,14,37),(38,13,87,38),(39,18,80,39),(40,7,59,40),(41,15,28,41),(42,10,73,42),(43,14,65,43),(44,6,46,44),(45,13,64,45),(46,5,74,46),(47,19,43,47),(48,16,79,48),(49,19,45,49),(50,13,49,50);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimiento`
--

DROP TABLE IF EXISTS `movimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimiento` (
  `idMovimiento` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del movimiento de inventario.',
  `tipoMovimiento` enum('Entrada','Salida','Ajuste') NOT NULL COMMENT 'Naturaleza de la transacción física de stock (''Entrada'', ''Salida'').',
  `cantidad` int(11) NOT NULL COMMENT 'Número de unidades físicas transadas del producto.',
  `fechaHora` datetime NOT NULL COMMENT 'Fecha y hora exacta en la que se ejecutó el movimiento.',
  `panadero_idPanadero` int(11) NOT NULL COMMENT 'Clave foránea (FK). Identifica al operario responsable de registrar la producción o merma.',
  `producto_idProducto` int(11) NOT NULL,
  PRIMARY KEY (`idMovimiento`),
  KEY `fk_movimientos_panadero1_idx` (`panadero_idPanadero`),
  KEY `fk_movimiento_producto1_idx` (`producto_idProducto`),
  CONSTRAINT `fk_movimiento_producto1` FOREIGN KEY (`producto_idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_movimientos_panadero1` FOREIGN KEY (`panadero_idPanadero`) REFERENCES `panadero` (`idPanadero`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimiento`
--

LOCK TABLES `movimiento` WRITE;
/*!40000 ALTER TABLE `movimiento` DISABLE KEYS */;
INSERT INTO `movimiento` VALUES (1,'Entrada',49,'2026-08-02 06:31:00',1,41),(2,'Salida',20,'2026-06-21 10:05:00',1,1),(3,'Salida',10,'2026-06-29 06:59:00',1,8),(4,'Salida',14,'2026-08-03 16:48:00',1,33),(5,'Salida',31,'2026-08-01 12:45:00',1,30),(6,'Salida',29,'2026-06-25 15:02:00',1,48),(7,'Salida',60,'2026-06-09 10:19:00',1,27),(8,'Entrada',55,'2026-08-04 10:22:00',1,1),(9,'Entrada',24,'2026-08-15 15:12:00',1,32),(10,'Salida',33,'2026-08-08 12:52:00',1,22),(11,'Salida',39,'2026-07-19 13:29:00',1,21),(12,'Salida',49,'2026-07-01 14:54:00',1,15),(13,'Salida',31,'2026-06-06 11:17:00',1,31),(14,'Salida',56,'2026-07-19 12:12:00',1,42),(15,'Ajuste',36,'2026-06-05 08:02:00',1,38),(16,'Entrada',11,'2026-07-27 07:03:00',1,30),(17,'Entrada',14,'2026-07-23 15:39:00',1,5),(18,'Salida',21,'2026-07-14 15:14:00',1,26),(19,'Salida',59,'2026-07-13 16:24:00',1,35),(20,'Entrada',25,'2026-08-02 13:32:00',1,40),(21,'Entrada',45,'2026-07-07 09:17:00',1,6),(22,'Entrada',11,'2026-06-13 12:40:00',1,45),(23,'Entrada',6,'2026-06-06 11:20:00',1,4),(24,'Entrada',28,'2026-07-26 07:45:00',1,34),(25,'Entrada',48,'2026-06-24 07:41:00',1,6),(26,'Salida',29,'2026-08-19 15:45:00',1,32),(27,'Ajuste',14,'2026-06-30 13:10:00',1,17),(28,'Salida',47,'2026-06-02 17:59:00',1,19),(29,'Salida',15,'2026-06-10 12:52:00',1,38),(30,'Entrada',32,'2026-07-03 13:24:00',1,20),(31,'Entrada',29,'2026-08-01 06:45:00',1,25),(32,'Salida',41,'2026-07-08 16:48:00',1,2),(33,'Ajuste',47,'2026-07-21 09:30:00',1,37),(34,'Salida',54,'2026-06-07 15:17:00',1,32),(35,'Salida',23,'2026-06-30 15:21:00',1,23),(36,'Entrada',17,'2026-08-19 10:13:00',1,49),(37,'Salida',47,'2026-06-18 15:36:00',1,41),(38,'Salida',24,'2026-07-27 06:07:00',1,24),(39,'Salida',10,'2026-07-08 11:17:00',1,27),(40,'Entrada',13,'2026-08-09 11:03:00',1,33),(41,'Ajuste',58,'2026-06-22 10:28:00',1,31),(42,'Ajuste',23,'2026-07-14 17:37:00',1,30),(43,'Ajuste',14,'2026-06-29 16:16:00',1,44),(44,'Ajuste',59,'2026-08-11 10:35:00',1,26),(45,'Entrada',39,'2026-06-16 12:53:00',1,44),(46,'Salida',21,'2026-08-14 12:22:00',1,41),(47,'Ajuste',11,'2026-06-30 12:31:00',1,40),(48,'Salida',40,'2026-07-12 14:44:00',1,42),(49,'Entrada',57,'2026-07-30 16:49:00',1,42),(50,'Entrada',13,'2026-06-06 05:49:00',1,32);
/*!40000 ALTER TABLE `movimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panadero`
--

DROP TABLE IF EXISTS `panadero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `panadero` (
  `idPanadero` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del operario de producción.',
  `estadoActivdad` enum('En turno','Descanso','Inactivo') NOT NULL COMMENT 'Estado operativo del panadero (ej. En turno, Descanso, Inactivo).',
  PRIMARY KEY (`idPanadero`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panadero`
--

LOCK TABLES `panadero` WRITE;
/*!40000 ALTER TABLE `panadero` DISABLE KEYS */;
INSERT INTO `panadero` VALUES (1,'En turno');
/*!40000 ALTER TABLE `panadero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único de la orden de compra.',
  `fechaHoraCreacion` datetime NOT NULL COMMENT 'Fecha y hora exacta en la que se registró el pedido.',
  `fechaHoraEntregaEstimada` datetime NOT NULL COMMENT 'Fecha y hora proyectada para la entrega del producto.',
  `estadoPedido` enum('Pendiente','En preparación','Listo','En camino','Entregado','Cancelado') NOT NULL COMMENT 'Etapa actual de la orden (ej. Pendiente, En preparación, Enviado, Entregado).',
  `cliente_idCliente` int(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula el pedido con el cliente que lo solicitó',
  `domiciliario_idDomiciliario` int(11) NOT NULL COMMENT 'Clave foránea (FK). Asigna el pedido al domiciliario encargado del reparto.',
  `ruta_entrega_idRuta_entrega` int(11) NOT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `fk_Pedido_Cliente1_idx` (`cliente_idCliente`),
  KEY `fk_Pedido_Domiciliario1_idx` (`domiciliario_idDomiciliario`),
  KEY `fk_pedido_ruta_entrega1_idx` (`ruta_entrega_idRuta_entrega`),
  CONSTRAINT `fk_Pedido_Cliente1` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Domiciliario1` FOREIGN KEY (`domiciliario_idDomiciliario`) REFERENCES `domiciliario` (`idDomiciliario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_ruta_entrega1` FOREIGN KEY (`ruta_entrega_idRuta_entrega`) REFERENCES `ruta_entrega` (`idRuta_entrega`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,'2026-07-31 12:35:00','2026-07-31 13:35:00','En preparación',7,2,1),(2,'2026-06-17 19:33:00','2026-06-18 00:33:00','Cancelado',36,2,2),(3,'2026-06-16 17:52:00','2026-06-16 21:52:00','Entregado',47,1,3),(4,'2026-07-07 20:49:00','2026-07-07 23:49:00','En preparación',33,1,4),(5,'2026-06-20 22:00:00','2026-06-21 00:00:00','Entregado',23,2,5),(6,'2026-06-15 16:06:00','2026-06-15 18:06:00','Entregado',36,1,6),(7,'2026-08-17 22:23:00','2026-08-18 01:23:00','Pendiente',18,2,7),(8,'2026-07-14 16:30:00','2026-07-14 18:30:00','Entregado',37,2,8),(9,'2026-06-09 14:17:00','2026-06-09 15:17:00','En preparación',34,1,9),(10,'2026-07-19 17:59:00','2026-07-19 20:59:00','En preparación',20,2,10),(11,'2026-08-12 20:35:00','2026-08-12 21:35:00','En preparación',49,1,11),(12,'2026-06-11 15:58:00','2026-06-11 19:58:00','Entregado',29,2,12),(13,'2026-07-05 15:18:00','2026-07-05 20:18:00','En preparación',28,1,13),(14,'2026-07-07 22:13:00','2026-07-08 03:13:00','Entregado',43,2,14),(15,'2026-06-06 14:55:00','2026-06-06 19:55:00','Pendiente',14,2,15),(16,'2026-06-28 14:18:00','2026-06-28 17:18:00','En camino',8,1,16),(17,'2026-08-03 22:57:00','2026-08-04 00:57:00','En preparación',35,1,17),(18,'2026-08-04 20:23:00','2026-08-04 23:23:00','Pendiente',48,1,18),(19,'2026-07-26 11:59:00','2026-07-26 12:59:00','Entregado',37,2,19),(20,'2026-08-13 18:15:00','2026-08-13 22:15:00','En camino',26,1,20),(21,'2026-07-12 14:21:00','2026-07-12 19:21:00','Entregado',45,2,21),(22,'2026-06-12 18:24:00','2026-06-12 19:24:00','Listo',38,2,22),(23,'2026-08-07 12:55:00','2026-08-07 15:55:00','Entregado',15,2,23),(24,'2026-06-22 13:02:00','2026-06-22 14:02:00','Entregado',13,2,24),(25,'2026-07-15 23:22:00','2026-07-16 01:22:00','Listo',10,2,25),(26,'2026-06-26 14:08:00','2026-06-26 16:08:00','Entregado',42,1,26),(27,'2026-06-23 22:01:00','2026-06-24 02:01:00','Entregado',49,2,27),(28,'2026-08-12 22:10:00','2026-08-13 03:10:00','En camino',41,2,28),(29,'2026-06-20 18:34:00','2026-06-20 22:34:00','Entregado',20,2,29),(30,'2026-08-15 11:52:00','2026-08-15 16:52:00','Pendiente',30,2,30),(31,'2026-06-05 11:53:00','2026-06-05 14:53:00','Pendiente',6,2,31),(32,'2026-07-30 21:05:00','2026-07-30 22:05:00','Entregado',37,1,32),(33,'2026-07-12 21:00:00','2026-07-13 02:00:00','En preparación',4,2,33),(34,'2026-06-14 17:15:00','2026-06-14 18:15:00','Entregado',12,1,34),(35,'2026-07-02 22:58:00','2026-07-03 02:58:00','Entregado',40,1,35),(36,'2026-07-17 17:28:00','2026-07-17 20:28:00','Entregado',50,2,36),(37,'2026-08-16 12:20:00','2026-08-16 15:20:00','Pendiente',7,2,37),(38,'2026-07-07 16:16:00','2026-07-07 21:16:00','Entregado',22,1,38),(39,'2026-08-14 21:39:00','2026-08-15 00:39:00','En camino',42,2,39),(40,'2026-06-17 21:15:00','2026-06-17 22:15:00','En camino',25,2,40),(41,'2026-06-17 22:14:00','2026-06-18 03:14:00','En preparación',43,2,41),(42,'2026-08-05 16:31:00','2026-08-05 19:31:00','En camino',14,2,42),(43,'2026-08-02 14:44:00','2026-08-02 16:44:00','En preparación',19,1,43),(44,'2026-08-04 20:23:00','2026-08-05 01:23:00','Pendiente',22,1,44),(45,'2026-08-16 17:39:00','2026-08-16 19:39:00','Listo',45,1,45),(46,'2026-07-27 11:56:00','2026-07-27 14:56:00','Entregado',16,2,46),(47,'2026-08-18 16:18:00','2026-08-18 20:18:00','Listo',16,2,47),(48,'2026-07-31 14:53:00','2026-07-31 19:53:00','Cancelado',30,2,48),(49,'2026-07-19 20:03:00','2026-07-20 00:03:00','Cancelado',13,1,49),(50,'2026-07-03 12:11:00','2026-07-03 16:11:00','Entregado',36,1,50);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del artículo de panadería.',
  `nombre` varchar(45) NOT NULL COMMENT 'Nombre comercial del producto (ej. Pan Aliñado, Roscones).',
  `precio` decimal(10,2) NOT NULL COMMENT 'Valor comercial de venta por cada unidad del producto.',
  `estado` enum('Disponbile','Agotado') NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (1,'Pan Francés',45000.00,'Disponbile','Elaborado artesanalmente cada mañana.'),(2,'Pan Integral',2000.00,'Disponbile','Horneado con ingredientes seleccionados.'),(3,'Pan de Queso',15000.00,'Disponbile','Ideal para acompañar el café.'),(4,'Pan de Yuca',9000.00,'Disponbile',NULL),(5,'Pandebono',6000.00,'Disponbile','Producto estrella de Oro Pan.'),(6,'Almojábana',4500.00,'Disponbile','Producto estrella de Oro Pan.'),(7,'Buñuelo',4500.00,'Disponbile',NULL),(8,'Roscón de Reyes',1500.00,'Disponbile','Elaborado artesanalmente cada mañana.'),(9,'Croissant Sencillo',7500.00,'Disponbile','Receta tradicional de la casa.'),(10,'Croissant de Jamón y Queso',80000.00,'Agotado','Elaborado artesanalmente cada mañana.'),(11,'Milhoja de Arequipe',4000.00,'Disponbile','Elaborado artesanalmente cada mañana.'),(12,'Milhoja de Manjar Blanco',60000.00,'Disponbile','Horneado con ingredientes seleccionados.'),(13,'Torta de Chocolate',18000.00,'Disponbile',NULL),(14,'Torta de Vainilla',15000.00,'Disponbile',NULL),(15,'Torta de Zanahoria',3000.00,'Disponbile','Receta tradicional de la casa.'),(16,'Torta Tres Leches',3000.00,'Disponbile','Receta tradicional de la casa.'),(17,'Ponqué de Naranja',45000.00,'Agotado','Ideal para acompañar el café.'),(18,'Ponqué de Limón',45000.00,'Disponbile','Producto estrella de Oro Pan.'),(19,'Galletas de Avena',9000.00,'Disponbile',NULL),(20,'Galletas de Chocolate',2000.00,'Disponbile',NULL),(21,'Galletas de Mantequilla',2200.00,'Disponbile','Ideal para acompañar el café.'),(22,'Empanada de Pollo',60000.00,'Disponbile','Elaborado artesanalmente cada mañana.'),(23,'Empanada de Carne',7500.00,'Disponbile',NULL),(24,'Empanada de Queso',2000.00,'Disponbile',NULL),(25,'Pan de Bono Grande',1500.00,'Disponbile',NULL),(26,'Pan Campesino',2200.00,'Disponbile',NULL),(27,'Pan Hawaiano',80000.00,'Disponbile',NULL),(28,'Pan de Chocolate',2500.00,'Disponbile','Ideal para acompañar el café.'),(29,'Pan de Coco',60000.00,'Disponbile',NULL),(30,'Pan de Ajonjolí',15000.00,'Disponbile','Ideal para acompañar el café.'),(31,'Deditos de Queso',6000.00,'Disponbile','Receta tradicional de la casa.'),(32,'Palitos de Queso',4500.00,'Disponbile',NULL),(33,'Mantecada',15000.00,'Disponbile','Producto estrella de Oro Pan.'),(34,'Achiras',6000.00,'Agotado',NULL),(35,'Rosquillas',3000.00,'Disponbile',NULL),(36,'Colaciones',4500.00,'Disponbile','Ideal para acompañar el café.'),(37,'Merengón',35000.00,'Agotado',NULL),(38,'Brownie de Chocolate',2000.00,'Disponbile','Producto estrella de Oro Pan.'),(39,'Cupcake de Vainilla',18000.00,'Disponbile',NULL),(40,'Cupcake de Chocolate',18000.00,'Disponbile',NULL),(41,'Donas Glaseadas',15000.00,'Disponbile','Receta tradicional de la casa.'),(42,'Donas de Chocolate',5000.00,'Disponbile',NULL),(43,'Pan Multigrano',5000.00,'Disponbile',NULL),(44,'Pan Blanco Tajado',18000.00,'Disponbile',NULL),(45,'Torta de Cumpleaños Personalizada',12000.00,'Disponbile',NULL),(46,'Pan de Leche',7500.00,'Disponbile','Ideal para acompañar el café.'),(47,'Croissant de Almendras',5000.00,'Disponbile','Receta tradicional de la casa.'),(48,'Baguette',3500.00,'Disponbile','Horneado con ingredientes seleccionados.'),(49,'Pan Pita',3500.00,'Disponbile',NULL),(50,'Tostadas Integrales',4500.00,'Disponbile','Ideal para acompañar el café.');
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recibo`
--

DROP TABLE IF EXISTS `recibo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recibo` (
  `idRecibo` int(11) NOT NULL COMMENT 'Clave primaria. Identificador único del comprobante o factura de pago.',
  `totalPagar` decimal(10,2) NOT NULL COMMENT 'Monto económico total consolidado de la transacción.',
  `fechaEmision` datetime NOT NULL COMMENT 'Fecha exacta en la que se generó y cobró el recibo.',
  `pedido_idPedido` int(11) NOT NULL,
  PRIMARY KEY (`idRecibo`),
  KEY `fk_recibo_pedido1_idx` (`pedido_idPedido`),
  CONSTRAINT `fk_recibo_pedido1` FOREIGN KEY (`pedido_idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recibo`
--

LOCK TABLES `recibo` WRITE;
/*!40000 ALTER TABLE `recibo` DISABLE KEYS */;
INSERT INTO `recibo` VALUES (1,67500.00,'2026-07-31 13:38:00',1),(2,7500.00,'2026-06-18 00:47:00',2),(3,13500.00,'2026-06-16 22:05:00',3),(4,360000.00,'2026-07-07 23:59:00',4),(5,45000.00,'2026-06-21 00:02:00',5),(6,5000.00,'2026-06-15 18:19:00',6),(7,24000.00,'2026-08-18 01:27:00',7),(8,7500.00,'2026-07-14 18:43:00',8),(9,80000.00,'2026-06-09 15:26:00',9),(10,19800.00,'2026-07-19 21:04:00',10),(11,8000.00,'2026-08-12 21:55:00',11),(12,3000.00,'2026-06-11 20:10:00',12),(13,8000.00,'2026-07-05 20:24:00',13),(14,12000.00,'2026-07-08 03:16:00',14),(15,54000.00,'2026-06-06 20:08:00',15),(16,30000.00,'2026-06-28 17:37:00',16),(17,240000.00,'2026-08-04 01:09:00',17),(18,75000.00,'2026-08-04 23:30:00',18),(19,72000.00,'2026-07-26 13:15:00',19),(20,90000.00,'2026-08-13 22:32:00',20),(21,48000.00,'2026-07-12 19:28:00',21),(22,18000.00,'2026-06-12 19:30:00',22),(23,4500.00,'2026-08-07 15:59:00',23),(24,180000.00,'2026-06-22 14:18:00',24),(25,720000.00,'2026-07-16 01:25:00',25),(26,50000.00,'2026-06-26 16:19:00',26),(27,42000.00,'2026-06-24 02:09:00',27),(28,7500.00,'2026-08-13 03:13:00',28),(29,15000.00,'2026-06-20 22:42:00',29),(30,1500.00,'2026-08-15 16:55:00',30),(31,21000.00,'2026-06-05 15:05:00',31),(32,150000.00,'2026-07-30 22:16:00',32),(33,30000.00,'2026-07-13 02:18:00',33),(34,12000.00,'2026-06-14 18:29:00',34),(35,162000.00,'2026-07-03 03:17:00',35),(36,22000.00,'2026-07-17 20:45:00',36),(37,150000.00,'2026-08-16 15:30:00',37),(38,36000.00,'2026-07-07 21:19:00',38),(39,400000.00,'2026-08-15 00:47:00',39),(40,2500.00,'2026-06-17 22:26:00',40),(41,108000.00,'2026-06-18 03:27:00',41),(42,30000.00,'2026-08-05 19:34:00',42),(43,240000.00,'2026-08-02 16:56:00',43),(44,55000.00,'2026-08-05 01:33:00',44),(45,40500.00,'2026-08-16 19:44:00',45),(46,4000.00,'2026-07-27 15:09:00',46),(47,54000.00,'2026-08-18 20:33:00',47),(48,135000.00,'2026-07-31 20:07:00',48),(49,4500.00,'2026-07-20 00:19:00',49),(50,12000.00,'2026-07-03 16:25:00',50);
/*!40000 ALTER TABLE `recibo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `idRol` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del rol.',
  `nombre` varchar(45) NOT NULL COMMENT 'Define permisos o características específicas para el rol de cliente.',
  PRIMARY KEY (`idRol`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Cliente'),(3,'Domiciliario'),(2,'Panadero');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta_entrega`
--

DROP TABLE IF EXISTS `ruta_entrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruta_entrega` (
  `idRuta_entrega` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único de la ruta de distribución.',
  `estadoRuta` enum('Pendiente','En Curso','Completada','Cancelada') NOT NULL COMMENT 'Estado logístico del despacho (''Pendiente'', ''En Curso'', ''Completada'', ''Cancelada'').',
  `urlRutaGoogle` varchar(500) NOT NULL COMMENT 'Enlace o dirección web de Google Maps con el recorrido optimizado.',
  PRIMARY KEY (`idRuta_entrega`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta_entrega`
--

LOCK TABLES `ruta_entrega` WRITE;
/*!40000 ALTER TABLE `ruta_entrega` DISABLE KEYS */;
INSERT INTO `ruta_entrega` VALUES (1,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.630775,-74.120457&travelmode=bicycling'),(2,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.659459,-74.98629&travelmode=bicycling'),(3,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.697404,-74.141289&travelmode=bicycling'),(4,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.654935,-74.126983&travelmode=bicycling'),(5,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.620253,-74.104379&travelmode=bicycling'),(6,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.709273,-74.114139&travelmode=bicycling'),(7,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.636666,-74.54288&travelmode=bicycling'),(8,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.628477,-74.108115&travelmode=bicycling'),(9,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.630947,-74.97537&travelmode=bicycling'),(10,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.689873,-74.98147&travelmode=bicycling'),(11,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.684518,-74.97012&travelmode=bicycling'),(12,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.636160,-74.74878&travelmode=bicycling'),(13,'Cancelada','https://www.google.com/maps/dir/?api=1&destination=4.711153,-74.109600&travelmode=bicycling'),(14,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.627801,-74.134109&travelmode=bicycling'),(15,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.602799,-74.56629&travelmode=bicycling'),(16,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.631925,-74.66505&travelmode=bicycling'),(17,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.626896,-74.58992&travelmode=bicycling'),(18,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.672641,-74.77152&travelmode=bicycling'),(19,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.706568,-74.80539&travelmode=bicycling'),(20,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.619340,-74.128116&travelmode=bicycling'),(21,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.712513,-74.68964&travelmode=bicycling'),(22,'Cancelada','https://www.google.com/maps/dir/?api=1&destination=4.670807,-74.82853&travelmode=bicycling'),(23,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.614408,-74.136646&travelmode=bicycling'),(24,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.617275,-74.51947&travelmode=bicycling'),(25,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.703341,-74.81186&travelmode=bicycling'),(26,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.602068,-74.72838&travelmode=bicycling'),(27,'En Curso','https://www.google.com/maps/dir/?api=1&destination=4.616614,-74.147218&travelmode=bicycling'),(28,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.614896,-74.147735&travelmode=bicycling'),(29,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.658756,-74.97453&travelmode=bicycling'),(30,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.614293,-74.109245&travelmode=bicycling'),(31,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.680623,-74.55683&travelmode=bicycling'),(32,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.719111,-74.136363&travelmode=bicycling'),(33,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.660036,-74.134323&travelmode=bicycling'),(34,'Cancelada','https://www.google.com/maps/dir/?api=1&destination=4.607972,-74.112781&travelmode=bicycling'),(35,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.655872,-74.139928&travelmode=bicycling'),(36,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.693375,-74.108138&travelmode=bicycling'),(37,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.610589,-74.92219&travelmode=bicycling'),(38,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.608609,-74.66540&travelmode=bicycling'),(39,'En Curso','https://www.google.com/maps/dir/?api=1&destination=4.682978,-74.126724&travelmode=bicycling'),(40,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.642622,-74.99925&travelmode=bicycling'),(41,'Cancelada','https://www.google.com/maps/dir/?api=1&destination=4.669541,-74.88652&travelmode=bicycling'),(42,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.679354,-74.106387&travelmode=bicycling'),(43,'Pendiente','https://www.google.com/maps/dir/?api=1&destination=4.691983,-74.64996&travelmode=bicycling'),(44,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.685316,-74.122264&travelmode=bicycling'),(45,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.628183,-74.106370&travelmode=bicycling'),(46,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.629949,-74.104239&travelmode=bicycling'),(47,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.659441,-74.102262&travelmode=bicycling'),(48,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.612463,-74.90966&travelmode=bicycling'),(49,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.687177,-74.83408&travelmode=bicycling'),(50,'Completada','https://www.google.com/maps/dir/?api=1&destination=4.620006,-74.140023&travelmode=bicycling');
/*!40000 ALTER TABLE `ruta_entrega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único y autoincremental del usuario.',
  `nombre` varchar(45) NOT NULL COMMENT 'Nombres completos del usuario.',
  `apellido` varchar(45) NOT NULL COMMENT 'Apellidos completos del usuario.',
  `correoElectronico` varchar(150) NOT NULL COMMENT 'Dirección de correo electrónico. Funciona como login único del sistema.',
  `contrasena` varchar(255) NOT NULL COMMENT 'Contraseña encriptada de acceso a la plataforma',
  `telefono` varchar(15) NOT NULL COMMENT 'Número telefónico o celular de contacto.',
  `estadoCuenta` enum('Activo','Inactivo') NOT NULL COMMENT 'Estado de la cuenta del usuario (ej. Activo/Inactivo).',
  `Rol_idRol` int(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula al usuario con su rol correspondiente en la tabla ROL.',
  `cliente_idCliente` int(11) DEFAULT NULL,
  `panadero_idPanadero` int(11) DEFAULT NULL,
  `domiciliario_idDomiciliario` int(11) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correoElectronico_UNIQUE` (`correoElectronico`),
  UNIQUE KEY `domiciliario_idDomiciliario_UNIQUE` (`domiciliario_idDomiciliario`),
  UNIQUE KEY `panadero_idPanadero_UNIQUE` (`panadero_idPanadero`),
  UNIQUE KEY `cliente_idCliente_UNIQUE` (`cliente_idCliente`),
  KEY `fk_Usuario_Rol1_idx` (`Rol_idRol`),
  KEY `fk_usuario_cliente1_idx` (`cliente_idCliente`),
  KEY `fk_usuario_panadero1_idx` (`panadero_idPanadero`),
  KEY `fk_usuario_domiciliario1_idx` (`domiciliario_idDomiciliario`),
  CONSTRAINT `fk_Usuario_Rol1` FOREIGN KEY (`Rol_idRol`) REFERENCES `rol` (`idRol`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_cliente1` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_domiciliario1` FOREIGN KEY (`domiciliario_idDomiciliario`) REFERENCES `domiciliario` (`idDomiciliario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_panadero1` FOREIGN KEY (`panadero_idPanadero`) REFERENCES `panadero` (`idPanadero`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Tatiana','López','tatiana.lopez1@gmail.com','$2y$10$7bf1471e9f7c9cbfddf2ae','326 674 1158','Activo',1,1,NULL,NULL),(2,'Sebastián','Mendoza','sebastian.mendoza2@gmail.com','$2y$10$200acc2aaf9b0d1973ac21','322 658 1590','Activo',1,2,NULL,NULL),(3,'Julián','Ramírez','julian.ramirez3@gmail.com','$2y$10$c107085aa6bf1db68fb3da','328 251 8041','Activo',1,3,NULL,NULL),(4,'Alejandra','Morales','alejandra.morales4@gmail.com','$2y$10$9eb243cb4f34c9b60fe0ba','315 915 1653','Activo',1,4,NULL,NULL),(5,'Natalia','Vargas','natalia.vargas5@gmail.com','$2y$10$f7591448c6928d2ed77177','303 782 2684','Activo',1,5,NULL,NULL),(6,'Sebastián','Castro','sebastian.castro6@gmail.com','$2y$10$cb72ce6a0416bcdd25392f','326 735 3532','Activo',1,6,NULL,NULL),(7,'Daniel','Bermúdez','daniel.bermudez7@gmail.com','$2y$10$e0d36b57438e8da872d873','302 919 3900','Activo',1,7,NULL,NULL),(8,'Felipe','Rodríguez','felipe.rodriguez8@gmail.com','$2y$10$31824717d9527c6520a495','302 854 6442','Activo',1,8,NULL,NULL),(9,'Jorge','Ortiz','jorge.ortiz9@gmail.com','$2y$10$7a90ab9f9cb3129285e046','313 373 3608','Activo',1,9,NULL,NULL),(10,'Wilmer','Torres','wilmer.torres10@gmail.com','$2y$10$0b2ddd8201f24d0f4ea102','306 993 1634','Activo',1,10,NULL,NULL),(11,'Alejandro','Ortiz','alejandro.ortiz11@gmail.com','$2y$10$3aa87e054416001cf1ae23','303 936 8541','Activo',1,11,NULL,NULL),(12,'Andrés','Guzmán','andres.guzman12@gmail.com','$2y$10$ade7a4f64e245716e71ec8','303 124 4164','Activo',1,12,NULL,NULL),(13,'Leidy','Vargas','leidy.vargas13@gmail.com','$2y$10$c6191515f85410d6d9bcb4','311 891 5573','Activo',1,13,NULL,NULL),(14,'Fernando','García','fernando.garcia14@gmail.com','$2y$10$d0ba355775f0ff733a20af','326 795 9785','Activo',1,14,NULL,NULL),(15,'Esteban','García','esteban.garcia15@gmail.com','$2y$10$fe44fa61c1e07eb51f6e55','301 998 5279','Activo',1,15,NULL,NULL),(16,'Alejandro','Guzmán','alejandro.guzman16@gmail.com','$2y$10$ec5f4a447101f0d4733051','310 211 8119','Activo',1,16,NULL,NULL),(17,'Gabriela','Torres','gabriela.torres17@gmail.com','$2y$10$a77621f0b659193ce9f9bc','316 720 9379','Activo',1,17,NULL,NULL),(18,'Jorge','Reyes','jorge.reyes18@gmail.com','$2y$10$70bbc913254232b5d3590d','323 360 1727','Activo',1,18,NULL,NULL),(19,'Juan','Peña','juan.pena19@gmail.com','$2y$10$86f94b1c15f14334709286','308 925 9821','Activo',1,19,NULL,NULL),(20,'Sebastián','Pardo','sebastian.pardo20@gmail.com','$2y$10$c130f381300964d81d4319','323 472 8066','Activo',1,20,NULL,NULL),(21,'Alejandra','Reyes','alejandra.reyes21@gmail.com','$2y$10$4430a3dd6abd69999299b6','325 738 6143','Activo',1,21,NULL,NULL),(22,'Valentina','Salazar','valentina.salazar22@gmail.com','$2y$10$1686722cc2e59a1679c5be','304 619 6067','Activo',1,22,NULL,NULL),(23,'Sandra','Martínez','sandra.martinez23@gmail.com','$2y$10$35792ca52fe58b7552cab6','316 813 5844','Activo',1,23,NULL,NULL),(24,'Diego','García','diego.garcia24@gmail.com','$2y$10$f95c35f91be92b376ff4f4','306 780 7211','Activo',1,24,NULL,NULL),(25,'Julián','Bermúdez','julian.bermudez25@gmail.com','$2y$10$4998dc43d0bda6c661a2bf','309 682 5930','Activo',1,25,NULL,NULL),(26,'Valentina','Ortiz','valentina.ortiz26@gmail.com','$2y$10$8a8bd940ed5e9cf0c0b925','304 393 4443','Activo',1,26,NULL,NULL),(27,'Laura','Gómez','laura.gomez27@gmail.com','$2y$10$cdb20b4863dd7d3160494f','329 770 6279','Activo',1,27,NULL,NULL),(28,'Tatiana','Rodríguez','tatiana.rodriguez28@gmail.com','$2y$10$a5436822f19d9d6a7a03d7','313 623 8752','Activo',1,28,NULL,NULL),(29,'Jorge','Mendoza','jorge.mendoza29@gmail.com','$2y$10$ec5654b3b77b5a9cbc4eb7','322 774 2389','Activo',1,29,NULL,NULL),(30,'Paula','Sánchez','paula.sanchez30@gmail.com','$2y$10$311601e07cbf518c5c5e6b','329 443 2530','Activo',1,30,NULL,NULL),(31,'Kevin','Rodríguez','kevin.rodriguez31@gmail.com','$2y$10$27278083e613a37cabede4','304 330 4262','Activo',1,31,NULL,NULL),(32,'Sebastián','Ramírez','sebastian.ramirez32@gmail.com','$2y$10$ecd360ba49037bf85af617','303 586 2193','Activo',1,32,NULL,NULL),(33,'Juliana','Ramírez','juliana.ramirez33@gmail.com','$2y$10$837c88a27bc1549f20c4af','329 299 7291','Activo',1,33,NULL,NULL),(34,'Yesenia','Rincón','yesenia.rincon34@gmail.com','$2y$10$dacaa820d48f28251c4599','302 771 1090','Activo',1,34,NULL,NULL),(35,'Sofía','Sánchez','sofia.sanchez35@gmail.com','$2y$10$426e6f35d6acb88a3642b9','306 324 3881','Activo',1,35,NULL,NULL),(36,'Fernando','Bermúdez','fernando.bermudez36@gmail.com','$2y$10$d36ed2b4942a4a6c103df1','328 575 1822','Activo',1,36,NULL,NULL),(37,'Diana','Mendoza','diana.mendoza37@gmail.com','$2y$10$48eb547553efe440d27288','307 236 8612','Activo',1,37,NULL,NULL),(38,'Patricia','Peña','patricia.pena38@gmail.com','$2y$10$2addbbf284acf249e22a47','329 424 8251','Activo',1,38,NULL,NULL),(39,'Mariana','Bermúdez','mariana.bermudez39@gmail.com','$2y$10$38e8cb280a0faff8d64f3f','328 536 9976','Activo',1,39,NULL,NULL),(40,'David','Martínez','david.martinez40@gmail.com','$2y$10$20e448942eb44a145354ef','307 560 5246','Activo',1,40,NULL,NULL),(41,'Patricia','Quintero','patricia.quintero41@gmail.com','$2y$10$267ac97d8637b278bf958c','324 884 9540','Activo',1,41,NULL,NULL),(42,'Gabriela','Vargas','gabriela.vargas42@gmail.com','$2y$10$0b9a588f108df52c331772','304 550 2269','Activo',1,42,NULL,NULL),(43,'Diego','Mendoza','diego.mendoza43@gmail.com','$2y$10$b24d954614b04947cfce94','304 443 6238','Activo',1,43,NULL,NULL),(44,'Juliana','Quintero','juliana.quintero44@gmail.com','$2y$10$2437f7ba1bf88c25539c8b','302 254 4788','Activo',1,44,NULL,NULL),(45,'Fernando','García','fernando.garcia45@gmail.com','$2y$10$cdc6c696e690d43a3b5c31','303 165 7797','Activo',1,45,NULL,NULL),(46,'Carolina','Vega','carolina.vega46@gmail.com','$2y$10$8edbf530a5451a4554eeb8','327 525 2020','Activo',1,46,NULL,NULL),(47,'Wilmer','López','wilmer.lopez47@gmail.com','$2y$10$225149e0507cd4913d09a4','316 888 1320','Activo',1,47,NULL,NULL),(48,'Diana','García','diana.garcia48@gmail.com','$2y$10$f1f9e81b006f8c1ec4cb09','326 588 1096','Activo',1,48,NULL,NULL),(49,'Fernando','Chaparro','fernando.chaparro49@gmail.com','$2y$10$cdaf3d6e9fc9c3bc129fa5','316 973 7865','Activo',1,49,NULL,NULL),(50,'Jorge','Rodríguez','jorge.rodriguez50@gmail.com','$2y$10$d2e32e31d50e9edbccf5c7','328 919 4613','Activo',1,50,NULL,NULL),(51,'Rodrigo','Beltrán','rodrigo.beltran51@gmail.com','$2y$10$ecbda970b28f33fd949818','316 597 1475','Activo',2,NULL,1,NULL),(52,'Yeison','Salazar','yeison.salazar52@gmail.com','$2y$10$8131d3f2e3bb31834379cf','326 841 3704','Activo',3,NULL,NULL,1),(53,'Brayan','Cárdenas','brayan.cardenas53@gmail.com','$2y$10$b1e4f2dbc84afb7591af06','309 646 1441','Activo',3,NULL,NULL,2);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-20 12:44:13
