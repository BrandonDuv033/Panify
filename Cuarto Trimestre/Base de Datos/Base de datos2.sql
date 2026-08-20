CREATE DATABASE  IF NOT EXISTS `panify` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `panify`;
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
  `dirección` varchar(150) NOT NULL COMMENT 'Dirección de despacho o residencia del cliente.',
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domiciliario`
--

LOCK TABLES `domiciliario` WRITE;
/*!40000 ALTER TABLE `domiciliario` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimiento`
--

LOCK TABLES `movimiento` WRITE;
/*!40000 ALTER TABLE `movimiento` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panadero`
--

LOCK TABLES `panadero` WRITE;
/*!40000 ALTER TABLE `panadero` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta_entrega`
--

LOCK TABLES `ruta_entrega` WRITE;
/*!40000 ALTER TABLE `ruta_entrega` DISABLE KEYS */;
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
  `contraseña` varchar(255) NOT NULL COMMENT 'Contraseña encriptada de acceso a la plataforma',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
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

-- Dump completed on 2026-08-19 20:09:13
