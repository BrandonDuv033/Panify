-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema panify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema panify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `panify` DEFAULT CHARACTER SET utf8mb4 ;
USE `panify` ;

-- -----------------------------------------------------
-- Table `panify`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`cliente` (
  `idCliente` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del cliente.',
  `tipoCliente` ENUM('Nuevo', 'Frecuente', 'Ocasional') NOT NULL COMMENT 'Clasificación del cliente (ej. Nuevo, Frecuente, Ocasional).',
  `dirección` VARCHAR(45) NOT NULL COMMENT 'Dirección de despacho o residencia del cliente.',
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`domiciliario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`domiciliario` (
  `idDomiciliario` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del repartidor o domiciliario.',
  `estadoDisponibilidad` ENUM('Libre', 'Ocupado', 'Inactivo') NOT NULL COMMENT 'Disponibilidad actual del domiciliario (ej. Libre, Ocupado, Inactivo)',
  PRIMARY KEY (`idDomiciliario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`orden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`orden` (
  `idOrden` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del comprobante o factura de pago.',
  `total_pagar` DOUBLE NOT NULL COMMENT 'Monto económico total consolidado de la transacción.',
  `fecha_emision` DATE NOT NULL COMMENT 'Fecha exacta en la que se generó y cobró el recibo.',
  PRIMARY KEY (`idOrden`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`pedido` (
  `idPedido` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único de la orden de compra.',
  `fechaHoraCreacion` DATE NOT NULL COMMENT 'Fecha y hora exacta en la que se registró el pedido.',
  `fechaHoraEntregaEstimada` DATE NOT NULL COMMENT 'Fecha y hora proyectada para la entrega del producto.',
  `estadoPedido` VARCHAR(45) NOT NULL COMMENT 'Etapa actual de la orden (ej. Pendiente, En preparación, Enviado, Entregado).',
  `cliente_idCliente` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula el pedido con el cliente que lo solicitó',
  `domiciliario_idDomiciliario` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Asigna el pedido al domiciliario encargado del reparto.',
  `orden_idOrden` INT(11) NOT NULL,
  PRIMARY KEY (`idPedido`),
  INDEX `fk_Pedido_Cliente1_idx` (`cliente_idCliente` ASC) ,
  INDEX `fk_Pedido_Domiciliario1_idx` (`domiciliario_idDomiciliario` ASC) ,
  INDEX `fk_pedido_orden1_idx` (`orden_idOrden` ASC) ,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `panify`.`cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Domiciliario1`
    FOREIGN KEY (`domiciliario_idDomiciliario`)
    REFERENCES `panify`.`domiciliario` (`idDomiciliario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_orden1`
    FOREIGN KEY (`orden_idOrden`)
    REFERENCES `panify`.`orden` (`idOrden`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`panadero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`panadero` (
  `idPanadero` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del operario de producción.',
  `estadoActivdad` ENUM('En turno', 'Descanso', 'Inactivo') NOT NULL COMMENT 'Estado operativo del panadero (ej. En turno, Descanso, Inactivo).',
  PRIMARY KEY (`idPanadero`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`movimientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`movimientos` (
  `idMovimientos` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del movimiento de inventario.',
  `tipoMovimiento` ENUM('Entrada', 'Salida') NOT NULL COMMENT 'Naturaleza de la transacción física de stock (\'Entrada\', \'Salida\').',
  `cantidad` INT(11) NOT NULL COMMENT 'Número de unidades físicas transadas del producto.',
  `fechaHora` DATE NOT NULL COMMENT 'Fecha y hora exacta en la que se ejecutó el movimiento.',
  `panadero_idPanadero` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Identifica al operario responsable de registrar la producción o merma.',
  PRIMARY KEY (`idMovimientos`),
  INDEX `fk_movimientos_panadero1_idx` (`panadero_idPanadero` ASC) ,
  CONSTRAINT `fk_movimientos_panadero1`
    FOREIGN KEY (`panadero_idPanadero`)
    REFERENCES `panify`.`panadero` (`idPanadero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`inventario` (
  `idInventario` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del artículo de panadería.',
  `nombre_producto` VARCHAR(45) NOT NULL COMMENT 'Nombre comercial del producto (ej. Pan Aliñado, Roscones).',
  `stock_minimo` INT(11) NOT NULL COMMENT 'Cantidad mínima permitida en almacén antes de disparar alertas de escasez.',
  `stock_actual` INT(11) NOT NULL COMMENT 'Cantidad real disponible del producto en el inventario.',
  `precio_unitario` DOUBLE NOT NULL COMMENT 'Valor comercial de venta por cada unidad del producto.',
  `movimientos_idMovimientos` INT(11) NOT NULL,
  PRIMARY KEY (`idInventario`),
  INDEX `fk_inventario_movimientos1_idx` (`movimientos_idMovimientos` ASC) ,
  CONSTRAINT `fk_inventario_movimientos1`
    FOREIGN KEY (`movimientos_idMovimientos`)
    REFERENCES `panify`.`movimientos` (`idMovimientos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`detalle_pedido` (
  `idDetalle_Pedido` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único de la línea de detalle.',
  `precioFijo` DOUBLE NOT NULL COMMENT 'Precio unitario del producto congelado al momento de la compra.',
  `cantidad` INT(11) NOT NULL COMMENT 'Número de unidades solicitadas de un mismo producto.',
  `pedido_idPedido` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Conecta este detalle con la cabecera del pedido global.',
  `producto_idProducto` INT(11) NOT NULL COMMENT 'Clave foránea (FK) o atributo que identifica el producto comprado.',
  PRIMARY KEY (`idDetalle_Pedido`),
  INDEX `fk_Detalle_Pedido_Pedido1_idx` (`pedido_idPedido` ASC) ,
  INDEX `fk_Detalle_Pedido_Producto1_idx` (`producto_idProducto` ASC) ,
  CONSTRAINT `fk_Detalle_Pedido_Pedido1`
    FOREIGN KEY (`pedido_idPedido`)
    REFERENCES `panify`.`pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalle_Pedido_Producto1`
    FOREIGN KEY (`producto_idProducto`)
    REFERENCES `panify`.`inventario` (`idInventario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`rol` (
  `idRol` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único del rol.',
  `nombre` VARCHAR(45) NOT NULL COMMENT 'Define permisos o características específicas para el rol de cliente.',
  PRIMARY KEY (`idRol`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`ruta_entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`ruta_entrega` (
  `idRuta_entrega` INT(11) NOT NULL COMMENT 'Clave primaria. Identificador único de la ruta de distribución.',
  `estadoRuta` ENUM('Pendiente', 'En Curso', 'Completada', 'Cancelada') NOT NULL COMMENT 'Estado logístico del despacho (\'Pendiente\', \'En Curso\', \'Completada\', \'Cancelada\').',
  `urlRutaGoogle` TINYTEXT NOT NULL COMMENT 'Enlace o dirección web de Google Maps con el recorrido optimizado.',
  `domiciliario_idDomiciliario` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Repartidor asignado al cumplimiento de la ruta.',
  PRIMARY KEY (`idRuta_entrega`),
  INDEX `fk_ruta_entrega_domiciliario1_idx` (`domiciliario_idDomiciliario` ASC) ,
  CONSTRAINT `fk_ruta_entrega_domiciliario1`
    FOREIGN KEY (`domiciliario_idDomiciliario`)
    REFERENCES `panify`.`domiciliario` (`idDomiciliario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `panify`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `panify`.`usuario` (
  `idUsuario` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Identificador único y autoincremental del usuario.',
  `nombre` VARCHAR(45) NOT NULL COMMENT 'Nombres completos del usuario.',
  `apellido` VARCHAR(45) NOT NULL COMMENT 'Apellidos completos del usuario.',
  `correoElectronico` VARCHAR(45) NOT NULL COMMENT 'Dirección de correo electrónico. Funciona como login único del sistema.',
  `contraseña` VARCHAR(45) NOT NULL COMMENT 'Contraseña encriptada de acceso a la plataforma',
  `telefono` VARCHAR(45) NOT NULL COMMENT 'Número telefónico o celular de contacto.',
  `estadoCuenta` ENUM('Activo', 'Inactivo') NOT NULL COMMENT 'Estado de la cuenta del usuario (ej. Activo/Inactivo).',
  `Rol_idRol` INT(11) NOT NULL COMMENT 'Clave foránea (FK). Vincula al usuario con su rol correspondiente en la tabla ROL.',
  `cliente_idCliente` INT(11) NOT NULL,
  `panadero_idPanadero` INT(11) NOT NULL,
  `domiciliario_idDomiciliario` INT(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `correoElectronico_UNIQUE` (`correoElectronico` ASC) ,
  INDEX `fk_Usuario_Rol1_idx` (`Rol_idRol` ASC) ,
  INDEX `fk_usuario_cliente1_idx` (`cliente_idCliente` ASC) ,
  INDEX `fk_usuario_panadero1_idx` (`panadero_idPanadero` ASC) ,
  INDEX `fk_usuario_domiciliario1_idx` (`domiciliario_idDomiciliario` ASC) ,
  CONSTRAINT `fk_Usuario_Rol1`
    FOREIGN KEY (`Rol_idRol`)
    REFERENCES `panify`.`rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_cliente1`
    FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `panify`.`cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_domiciliario1`
    FOREIGN KEY (`domiciliario_idDomiciliario`)
    REFERENCES `panify`.`domiciliario` (`idDomiciliario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_panadero1`
    FOREIGN KEY (`panadero_idPanadero`)
    REFERENCES `panify`.`panadero` (`idPanadero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
