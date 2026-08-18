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

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del cliente.',
  `tipoCliente` enum('Nuevo','Frecuente','Ocasional') NOT NULL COMMENT 'Clasificación del cliente (ej. Nuevo, Frecuente, Ocasional).',
  `dirección` varchar(45) NOT NULL COMMENT 'Dirección de despacho o residencia del cliente.',
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Frecuente','Calle 145 # 92-15, Suba'),(2,'Nuevo','Carrera 80 # 38-45, Kennedy'),(3,'Frecuente','Calle 127 # 15-30, Usaquén'),(4,'Ocasional','Calle 65 Sur # 78-10, Bosa'),(5,'Frecuente','Carrera 78 # 40-22, Engativá'),(6,'Nuevo','Calle 26 # 96-32, Fontibón'),(7,'Frecuente','Carrera 13 # 63-25, Chapinero'),(8,'Ocasional','Calle 45 # 28-16, Teusaquillo'),(9,'Frecuente','Carrera 60 # 74-18, Barrios Unidos'),(10,'Nuevo','Calle 32 Sur # 12-45, Rafael Uribe'),(11,'Frecuente','Carrera 99 # 18-30, Fontibón'),(12,'Ocasional','Calle 68 Sur # 17-22, Ciudad Bolívar'),(13,'Frecuente','Carrera 15 # 118-40, Usaquén'),(14,'Nuevo','Calle 150 # 104-25, Suba'),(15,'Nuevo','Carrera 73 # 40-18, Kennedy'),(16,'Frecuente','Calle 64 # 78-35, Engativá'),(17,'Ocasional','Carrera 85 # 52-16, Bosa'),(18,'Frecuente','Calle 10 # 45-28, Puente Aranda'),(19,'Nuevo','Carrera 30 # 45-20, Teusaquillo'),(20,'Frecuente','Calle 57 # 9-32, Chapinero'),(21,'Ocasional','Carrera 100 # 17-45, Fontibón'),(22,'Ocasional','Calle 140 # 110-18, Suba'),(23,'Nuevo','Carrera 78 # 42-25, Kennedy'),(24,'Nuevo','Calle 70 # 85-20, Engativá'),(25,'Frecuente','Carrera 7 # 120-35, Usaquén'),(26,'Nuevo','Calle 60 Sur # 65-18, Bosa'),(27,'Frecuente','Carrera 17 # 52-30, Teusaquillo');
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
  `precioFijo` double NOT NULL COMMENT 'Precio unitario del producto congelado al momento de la compra.',
  `cantidad` int(11) NOT NULL COMMENT 'Número de unidades solicitadas de un mismo producto.',
  `pedido_idPedido` int(11) NOT NULL COMMENT 'Clave foránea (FK). Conecta este detalle con la cabecera del pedido global.',
  `inventario_idinventario` int(11) NOT NULL COMMENT 'Clave foránea (FK) o atributo que identifica el producto comprado.',
  PRIMARY KEY (`idDetalle_Pedido`),
  KEY `fk_Detalle_Pedido_Pedido1_idx` (`pedido_idPedido`),
  KEY `fk_Detalle_Pedido_Producto1_idx` (`inventario_idinventario`),
  CONSTRAINT `fk_Detalle_Pedido_Pedido1` FOREIGN KEY (`pedido_idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalle_Pedido_Producto1` FOREIGN KEY (`inventario_idinventario`) REFERENCES `inventario` (`idInventario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
INSERT INTO `detalle_pedido` VALUES (1,5000,9,1,1),(2,6000,13,2,2),(3,5000,25,3,1),(4,4000,14,4,5),(5,4000,23,5,5),(6,6000,6,6,2),(7,5000,21,7,1),(8,5000,13,8,1),(9,5000,29,9,1),(10,4000,20,10,5),(11,4000,13,11,5),(12,5000,23,12,1),(13,5000,14,13,1),(14,7000,14,14,2),(15,6000,10,15,2),(16,6000,22,16,2),(17,7000,7,17,2),(18,4000,22,18,5),(19,6000,26,19,2),(20,5000,14,20,1),(21,5000,20,21,1),(22,4000,14,22,5),(23,5000,25,23,1),(24,5000,13,24,1),(25,5000,18,25,1),(26,4000,29,26,5),(27,5000,10,27,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domiciliario`
--

LOCK TABLES `domiciliario` WRITE;
/*!40000 ALTER TABLE `domiciliario` DISABLE KEYS */;
INSERT INTO `domiciliario` VALUES (1,'Libre'),(2,'Inactivo'),(3,'Ocupado');
/*!40000 ALTER TABLE `domiciliario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `idInventario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del artículo de panadería.',
  `nombre_producto` varchar(45) NOT NULL COMMENT 'Nombre comercial del producto (ej. Pan Aliñado, Roscones).',
  `stock_minimo` int(11) NOT NULL COMMENT 'Cantidad mínima permitida en almacén antes de disparar alertas de escasez.',
  `stock_actual` int(11) NOT NULL COMMENT 'Cantidad real disponible del producto en el inventario.',
  `precio_unitario` double NOT NULL COMMENT 'Valor comercial de venta por cada unidad del producto.',
  `movimientos_idMovimientos` int(11) NOT NULL,
  PRIMARY KEY (`idInventario`),
  KEY `fk_inventario_movimientos1_idx` (`movimientos_idMovimientos`),
  CONSTRAINT `fk_inventario_movimientos1` FOREIGN KEY (`movimientos_idMovimientos`) REFERENCES `movimientos` (`idMovimientos`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,'Pan Integral',10,8,5000,1),(2,'Croissant',8,32,6000,2),(3,'Pan de Queso',12,50,4500,3),(4,'Mogolla',10,38,3500,4),(5,'Galleta de Avena',15,10,4000,5);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos`
--

DROP TABLE IF EXISTS `movimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos` (
  `idMovimientos` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del movimiento de inventario.',
  `tipoMovimiento` enum('Entrada','Salida') NOT NULL COMMENT 'Naturaleza de la transacción física de stock (''Entrada'', ''Salida'').',
  `cantidad` int(11) NOT NULL COMMENT 'Número de unidades físicas transadas del producto.',
  `fechaHora` date NOT NULL COMMENT 'Fecha y hora exacta en la que se ejecutó el movimiento.',
  `panadero_idPanadero` int(11) NOT NULL COMMENT 'Clave foránea (FK). Identifica al operario responsable de registrar la producción o merma.',
  PRIMARY KEY (`idMovimientos`),
  KEY `fk_movimientos_panadero1_idx` (`panadero_idPanadero`),
  CONSTRAINT `fk_movimientos_panadero1` FOREIGN KEY (`panadero_idPanadero`) REFERENCES `panadero` (`idPanadero`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos`
--

LOCK TABLES `movimientos` WRITE;
/*!40000 ALTER TABLE `movimientos` DISABLE KEYS */;
INSERT INTO `movimientos` VALUES (1,'Entrada',10,'2026-08-01',1),(2,'Salida',5,'2026-08-01',1),(3,'Entrada',15,'2026-08-01',1),(4,'Salida',3,'2026-08-01',1),(5,'Entrada',20,'2026-08-02',1),(6,'Salida',8,'2026-08-02',1),(7,'Entrada',12,'2026-08-02',1),(8,'Salida',6,'2026-08-02',1),(9,'Entrada',18,'2026-08-03',1),(10,'Salida',7,'2026-08-03',1),(11,'Entrada',25,'2026-08-03',1),(12,'Salida',9,'2026-08-03',1),(13,'Entrada',14,'2026-08-04',1),(14,'Salida',4,'2026-08-04',1),(15,'Entrada',16,'2026-08-04',1),(16,'Salida',11,'2026-08-04',1),(17,'Entrada',22,'2026-08-05',1),(18,'Salida',5,'2026-08-05',1),(19,'Entrada',13,'2026-08-05',1),(20,'Salida',8,'2026-08-05',1),(21,'Entrada',19,'2026-08-06',1),(22,'Salida',6,'2026-08-06',1),(23,'Entrada',17,'2026-08-06',1),(24,'Salida',10,'2026-08-06',1),(25,'Entrada',21,'2026-08-07',1),(26,'Salida',7,'2026-08-07',1),(27,'Entrada',15,'2026-08-07',1),(28,'Salida',9,'2026-08-07',1),(29,'Entrada',23,'2026-08-08',1),(30,'Salida',12,'2026-08-08',1);
/*!40000 ALTER TABLE `movimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orden`
--

DROP TABLE IF EXISTS `orden`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orden` (
  `idOrden` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del comprobante o factura de pago.',
  `total_pagar` double NOT NULL COMMENT 'Monto económico total consolidado de la transacción.',
  `fecha_emision` date NOT NULL COMMENT 'Fecha exacta en la que se generó y cobró el recibo.',
  PRIMARY KEY (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orden`
--

LOCK TABLES `orden` WRITE;
/*!40000 ALTER TABLE `orden` DISABLE KEYS */;
INSERT INTO `orden` VALUES (1,45000,'2026-08-01'),(2,78000,'2026-08-02'),(3,125000,'2026-08-03'),(4,56000,'2026-08-04'),(5,92000,'2026-08-05'),(6,38000,'2026-08-06'),(7,105000,'2026-08-07'),(8,67000,'2026-08-08'),(9,145000,'2026-08-09'),(10,83000,'2026-08-10'),(11,52000,'2026-08-11'),(12,115000,'2026-08-12'),(13,74000,'2026-08-13'),(14,98000,'2026-08-14'),(15,62000,'2026-08-15'),(16,132000,'2026-08-16'),(17,49000,'2026-08-17'),(18,88000,'2026-08-18'),(19,156000,'2026-08-19'),(20,71000,'2026-08-20'),(21,103000,'2026-08-21'),(22,58000,'2026-08-22'),(23,127000,'2026-08-23'),(24,69000,'2026-08-24'),(25,94000,'2026-08-25'),(26,118000,'2026-08-26'),(27,53000,'2026-08-27'),(28,86000,'2026-08-28'),(29,149000,'2026-08-29'),(30,76000,'2026-08-30');
/*!40000 ALTER TABLE `orden` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panadero`
--

LOCK TABLES `panadero` WRITE;
/*!40000 ALTER TABLE `panadero` DISABLE KEYS */;
INSERT INTO `panadero` VALUES (1,'En turno'),(2,'Descanso'),(3,'Inactivo'),(4,'Descanso'),(5,'En turno');
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
  `fechaHoraCreacion` date NOT NULL COMMENT 'Fecha y hora exacta en la que se registró el pedido.',
  `fechaHoraEntregaEstimada` date NOT NULL COMMENT 'Fecha y hora proyectada para la entrega del producto.',
  `estadoPedido` varchar(45) NOT NULL COMMENT 'Etapa actual de la orden (ej. Pendiente, En preparación, Enviado, Entregado).',
  `cliente_idCliente` int(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula el pedido con el cliente que lo solicitó',
  `domiciliario_idDomiciliario` int(11) NOT NULL COMMENT 'Clave foránea (FK). Asigna el pedido al domiciliario encargado del reparto.',
  `orden_idOrden` int(11) NOT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `fk_Pedido_Cliente1_idx` (`cliente_idCliente`),
  KEY `fk_Pedido_Domiciliario1_idx` (`domiciliario_idDomiciliario`),
  KEY `fk_pedido_orden1_idx` (`orden_idOrden`),
  CONSTRAINT `fk_Pedido_Cliente1` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Domiciliario1` FOREIGN KEY (`domiciliario_idDomiciliario`) REFERENCES `domiciliario` (`idDomiciliario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_orden1` FOREIGN KEY (`orden_idOrden`) REFERENCES `orden` (`idOrden`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,'2026-08-17','2026-08-17','Completado',1,1,1),(2,'2026-08-17','2026-08-17','Completado',2,2,2),(3,'2026-08-17','2026-08-17','En Curso',3,1,3),(4,'2026-08-17','2026-08-17','Pendiente',4,2,4),(5,'2026-08-17','2026-08-17','Completado',5,1,5),(6,'2026-08-17','2026-08-17','En Curso',6,2,6),(7,'2026-08-17','2026-08-17','Pendiente',7,1,7),(8,'2026-08-17','2026-08-17','Completado',8,2,8),(9,'2026-08-17','2026-08-17','En Curso',9,1,9),(10,'2026-08-17','2026-08-17','Pendiente',10,2,10),(11,'2026-08-17','2026-08-17','Completado',11,1,11),(12,'2026-08-17','2026-08-17','En Curso',12,2,12),(13,'2026-08-17','2026-08-17','Pendiente',13,1,13),(14,'2026-08-17','2026-08-17','Completado',14,2,14),(15,'2026-08-17','2026-08-17','En Curso',15,1,15),(16,'2026-08-17','2026-08-17','Pendiente',16,2,16),(17,'2026-08-17','2026-08-17','Completado',17,1,17),(18,'2026-08-17','2026-08-17','En Curso',18,2,18),(19,'2026-08-17','2026-08-17','Pendiente',19,1,19),(20,'2026-08-17','2026-08-17','Completado',20,2,20),(21,'2026-08-17','2026-08-17','En Curso',21,1,21),(22,'2026-08-17','2026-08-17','Pendiente',22,2,22),(23,'2026-08-17','2026-08-17','Completado',23,1,23),(24,'2026-08-17','2026-08-17','En Curso',24,2,24),(25,'2026-08-17','2026-08-17','Pendiente',25,1,25),(26,'2026-08-17','2026-08-17','Completado',26,2,26),(27,'2026-08-17','2026-08-17','En Curso',27,1,27);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
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
  PRIMARY KEY (`idRol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Cliente'),(2,'Panadero'),(3,'Domiciliario');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta_entrega`
--

DROP TABLE IF EXISTS `ruta_entrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruta_entrega` (
  `idRuta_entrega` int(11) NOT NULL COMMENT 'Clave primaria. Identificador único de la ruta de distribución.',
  `estadoRuta` enum('Pendiente','En Curso','Completada','Cancelada') NOT NULL COMMENT 'Estado logístico del despacho (''Pendiente'', ''En Curso'', ''Completada'', ''Cancelada'').',
  `urlRutaGoogle` tinytext NOT NULL COMMENT 'Enlace o dirección web de Google Maps con el recorrido optimizado.',
  `domiciliario_idDomiciliario` int(11) NOT NULL COMMENT 'Clave foránea (FK). Repartidor asignado al cumplimiento de la ruta.',
  PRIMARY KEY (`idRuta_entrega`),
  KEY `fk_ruta_entrega_domiciliario1_idx` (`domiciliario_idDomiciliario`),
  CONSTRAINT `fk_ruta_entrega_domiciliario1` FOREIGN KEY (`domiciliario_idDomiciliario`) REFERENCES `domiciliario` (`idDomiciliario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta_entrega`
--

LOCK TABLES `ruta_entrega` WRITE;
/*!40000 ALTER TABLE `ruta_entrega` DISABLE KEYS */;
INSERT INTO `ruta_entrega` VALUES (1,'Completada','https://maps.google.com/?q=Suba,Bogota',1),(2,'Pendiente','https://maps.google.com/?q=Kennedy,Bogota',2),(3,'Pendiente','https://maps.google.com/?q=Engativa,Bogota',1),(4,'En Curso','https://maps.google.com/?q=Bosa,Bogota',2),(5,'Pendiente','https://maps.google.com/?q=Usaquen,Bogota',1),(6,'Completada','https://maps.google.com/?q=Chapinero,Bogota',2),(7,'En Curso','https://maps.google.com/?q=Fontibon,Bogota',1),(8,'Pendiente','https://maps.google.com/?q=Teusaquillo,Bogota',2),(9,'Completada','https://maps.google.com/?q=BarriosUnidos,Bogota',1),(10,'Completada','https://maps.google.com/?q=PuenteAranda,Bogota',2),(11,'Pendiente','https://maps.google.com/?q=RafaelUribe,Bogota',1),(12,'En Curso','https://maps.google.com/?q=Tunjuelito,Bogota',2),(13,'Pendiente','https://maps.google.com/?q=CiudadBolivar,Bogota',1),(14,'Pendiente','https://maps.google.com/?q=SanCristobal,Bogota',2),(15,'Completada','https://maps.google.com/?q=Usme,Bogota',1),(16,'Completada','https://maps.google.com/?q=LaCandelaria,Bogota',2),(17,'Pendiente','https://maps.google.com/?q=LosMartires,Bogota',1),(18,'En Curso','https://maps.google.com/?q=AntonioNarino,Bogota',2),(19,'Pendiente','https://maps.google.com/?q=Suba,Bogota',1),(20,'Pendiente','https://maps.google.com/?q=Kennedy,Bogota',2),(21,'En Curso','https://maps.google.com/?q=Engativa,Bogota',1),(22,'Completada','https://maps.google.com/?q=Bosa,Bogota',2),(23,'Pendiente','https://maps.google.com/?q=Usaquen,Bogota',1),(24,'En Curso','https://maps.google.com/?q=Chapinero,Bogota',2),(25,'Pendiente','https://maps.google.com/?q=Fontibon,Bogota',1),(26,'Pendiente','https://maps.google.com/?q=Teusaquillo,Bogota',2),(27,'En Curso','https://maps.google.com/?q=BarriosUnidos,Bogota',1),(28,'Completada','https://maps.google.com/?q=PuenteAranda,Bogota',2),(29,'Pendiente','https://maps.google.com/?q=RafaelUribe,Bogota',1),(30,'Completada','https://maps.google.com/?q=Tunjuelito,Bogota',2);
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
  `correoElectronico` varchar(45) NOT NULL COMMENT 'Dirección de correo electrónico. Funciona como login único del sistema.',
  `contraseña` varchar(45) NOT NULL COMMENT 'Contraseña encriptada de acceso a la plataforma',
  `telefono` varchar(45) NOT NULL COMMENT 'Número telefónico o celular de contacto.',
  `estadoCuenta` enum('Activo','Inactivo') NOT NULL COMMENT 'Estado de la cuenta del usuario (ej. Activo/Inactivo).',
  `Rol_idRol` int(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula al usuario con su rol correspondiente en la tabla ROL.',
  `cliente_idCliente` int(11) DEFAULT NULL,
  `panadero_idPanadero` int(11) DEFAULT NULL,
  `domiciliario_idDomiciliario` int(11) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correoElectronico_UNIQUE` (`correoElectronico`),
  KEY `fk_Usuario_Rol1_idx` (`Rol_idRol`),
  KEY `fk_usuario_cliente1_idx` (`cliente_idCliente`),
  KEY `fk_usuario_panadero1_idx` (`panadero_idPanadero`),
  KEY `fk_usuario_domiciliario1_idx` (`domiciliario_idDomiciliario`),
  CONSTRAINT `fk_Usuario_Rol1` FOREIGN KEY (`Rol_idRol`) REFERENCES `rol` (`idRol`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_cliente1` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_domiciliario1` FOREIGN KEY (`domiciliario_idDomiciliario`) REFERENCES `domiciliario` (`idDomiciliario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_panadero1` FOREIGN KEY (`panadero_idPanadero`) REFERENCES `panadero` (`idPanadero`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Juan','Perez','juan.perez@gmail.com','123','3001234567','Activo',3,NULL,NULL,1),(2,'Ana','Gomez','ana.gomez@gmail.com','124','3012345678','Activo',1,1,NULL,NULL),(3,'Luis','Rodriguez','luis.rodriguez@gmail.com','125','3023456789','Activo',2,NULL,1,NULL),(4,'Maria','Lopez','M.Lopez@gmail.com','126','3034567890','Activo',1,2,NULL,NULL),(5,'Carlos','Díaz','carlos.diaz@gmail.com','127','3045678901','Activo',1,3,NULL,NULL),(6,'Andrés','Martínez','andres.martinez@gmail.com','128','3056789012','Activo',3,NULL,NULL,NULL),(7,'Laura','Torres','laura.torres@gmail.com','129','3067890123','Activo',1,4,NULL,NULL),(8,'Daniel','Vargas','daniel.vargas@gmail.com','130','3078901234','Activo',1,5,NULL,NULL),(9,'Sofía','Castro','sofia.castro@gmail.com','131','3089012345','Activo',1,6,NULL,NULL),(10,'Mateo','Ramírez','mateo.ramirez@gmail.com','132','3090123456','Activo',1,7,NULL,NULL),(11,'Valentina','Moreno','valentina.moreno@gmail.com','133','3101234567','Activo',1,8,NULL,NULL),(12,'Sebastián','Rojas','sebastian.rojas@gmail.com','134','3112345678','Activo',1,9,NULL,NULL),(13,'Camila','Herrera','camila.herrera@gmail.com','135','3123456789','Activo',1,10,NULL,NULL),(14,'Nicolás','Jiménez','nicolas.jimenez@gmail.com','136','3134567890','Activo',1,11,NULL,NULL),(15,'Daniela','Ortiz','daniela.ortiz@gmail.com','137','3145678901','Activo',1,12,NULL,NULL),(16,'Santiago','Molina','santiago.molina@gmail.com','138','3156789012','Activo',1,13,NULL,NULL),(17,'Mariana','Suárez','mariana.suarez@gmail.com','139','3167890123','Activo',1,14,NULL,NULL),(18,'Alejandro','Navarro','alejandro.navarro@gmail.com','140','3178901234','Activo',1,15,NULL,NULL),(19,'Gabriela','Guerrero','gabriela.guerrero@gmail.com','141','3189012345','Activo',1,16,NULL,NULL),(20,'Felipe','Mendoza','felipe.mendoza@gmail.com','142','3190123456','Activo',1,17,NULL,NULL),(21,'Isabella','Cárdenas','isabella.cardenas@gmail.com','143','3201234567','Activo',1,18,NULL,NULL),(22,'David','Peña','david.pena@gmail.com','144','3212345678','Activo',1,19,NULL,NULL),(23,'Natalia','Silva','natalia.silva@gmail.com','145','3223456789','Activo',1,20,NULL,NULL),(24,'Tomás','Pardo','tomas.pardo@gmail.com','146','3234567890','Activo',1,21,NULL,NULL),(25,'Juliana','Restrepo','juliana.restrepo@gmail.com','147','3245678901','Activo',1,22,NULL,NULL),(26,'Miguel','Arias','miguel.arias@gmail.com','148','3256789012','Activo',1,23,NULL,NULL),(27,'Sara','León','sara.leon@gmail.com','149','3267890123','Activo',1,24,NULL,NULL),(28,'Esteban','Salazar','esteban.salazar@gmail.com','150','3278901234','Activo',1,25,NULL,NULL),(29,'Paula','Méndez','paula.mendez@gmail.com','151','3289012345','Activo',1,26,NULL,NULL),(30,'Jorge','Beltrán','jorge.beltran@gmail.com','152','3290123456','Activo',3,NULL,NULL,2);
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

-- Dump completed on 2026-08-17 20:12:55
