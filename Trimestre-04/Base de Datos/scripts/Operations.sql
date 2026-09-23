-- ==========================================
-- 				PROCEDIMIENTOS
-- ==========================================


-- ==========================================
-- 1. Asignar domiciliario
-- ==========================================
DELIMITER //

CREATE PROCEDURE `Asignadomiciliario`(
    IN p_idPedido INT, 
    IN p_idDomiciliario INT
) 
BEGIN 
    UPDATE pedidos 
    SET domiciliario_idDomiciliario = p_idDomiciliario 
    WHERE idPedido = p_idPedido; 
    
    UPDATE domiciliarios 
    SET estadoDisponibilidad = 'Ocupado' 
    WHERE idDomiciliario = p_idDomiciliario; 
END //

DELIMITER ;

-- Asigna el pedido 7 al domiciliario 1 (Pedro Diaz)
CALL Asignadomiciliario(7, 1); 

-- Asigna el pedido 8 al domiciliario 2 (Jorge Vega)
CALL Asignadomiciliario(8, 2); 

-- Asigna el pedido 6 al domiciliario 3 (Mateo Gil)
CALL Asignadomiciliario(6, 3);

-- ==========================================
-- 2. Ruta de entrega
-- ==========================================
DELIMITER //

CREATE PROCEDURE `RutaDeEntrega`(
    IN p_idDomiciliario INT, 
    IN p_urlRutaGoogle VARCHAR(500), 
    IN p_idPedido INT
) 
BEGIN 
    INSERT INTO rutasEntrega(
        estadoRuta, 
        urlRutaGoogle, 
        domiciliarios_idDomiciliario
    ) 
    VALUES(
        'Pendiente', 
        p_urlRutaGoogle, 
        p_idDomiciliario
    ); 
    
    UPDATE pedidos 
    SET domiciliario_idDomiciliario = p_idDomiciliario 
    WHERE idPedido = p_idPedido; 
END //

DELIMITER ;

-- Registra ruta para el pedido 7
CALL RutaDeEntrega(1, 'https://maps.google.com/?q=Cra+7+%23+12-34+Soacha', 7); 

-- Registra ruta para el pedido 8
CALL RutaDeEntrega(2, 'https://maps.google.com/?q=Cra+8+%23+11-11+Soacha', 8); 

-- Registra ruta para el pedido 4
CALL RutaDeEntrega(1, 'https://maps.google.com/?q=Cra+4+%23+15-20+Soacha', 4);


-- ==========================================
-- 3. Actualizar estado del pedido
-- ==========================================
DELIMITER //

CREATE PROCEDURE `ActualizarPedido`(
    IN pedidoID INT, 
    IN nuevoEstado INT
) 
BEGIN 
    UPDATE pedidos 
    SET estadoPedido = CASE nuevoEstado 
        WHEN 1 THEN 'Pendiente' 
        WHEN 2 THEN 'En preparación' 
        WHEN 3 THEN 'Listo' 
        WHEN 4 THEN 'En camino' 
        WHEN 5 THEN 'Entregado' 
        WHEN 6 THEN 'Cancelado' 
        ELSE estadoPedido 
    END 
    WHERE idPedido = pedidoID; 
END //

DELIMITER ;

-- Transición del pedido 7 de 'Pendiente' a 'En preparación'
CALL ActualizarPedido(7, 2); 

-- Transición del pedido 6 de 'En preparación' a 'Listo'
CALL ActualizarPedido(6, 3); 

-- Cancelar el pedido 8
CALL ActualizarPedido(8, 6);

-- ==========================================
-- 4. Historial del cliente
-- ==========================================
DELIMITER //

CREATE PROCEDURE `Historial`(
    IN clienteID INT
) 
BEGIN 
    SELECT 
        u.nombre, 
        u.apellido, 
        p.idPedido, 
        p.fechaHoraCreacion, 
        p.estadoPedido, 
        IFNULL(r.totalPagar, 0) AS totalFacturado, 
        r.fechaEmision 
    FROM clientes c 
    INNER JOIN usuarios u ON u.cliente_idCliente = c.idCliente 
    INNER JOIN pedidos p ON p.cliente_idCliente = c.idCliente 
    LEFT JOIN recibos r ON r.pedido_idPedido = p.idPedido 
    WHERE c.idCliente = clienteID; 
END //

DELIMITER ;

-- Historial de compras del Cliente 1 (Ana Gomez)
CALL Historial(1); 

-- Historial de compras del Cliente 2 (Luis Perez)
CALL Historial(2); 

-- Historial de compras del Cliente 5 (Juan Cruz)
CALL Historial(5);


-- ==========================================
-- 5. Bloqueo de horario
-- ==========================================
DELIMITER //

CREATE PROCEDURE `BloqueoHorario`(
    IN clienteID INT, 
    IN domiciliarioID INT, 
    IN fechaHoraEntregaEstimada DATETIME
) 
BEGIN 
    DECLARE horaActual TIME; 
    DECLARE fechaEntrega DATE; 
    DECLARE fechaHoy DATE; 
    
    SET horaActual = CURTIME(); 
    SET fechaEntrega = DATE(fechaHoraEntregaEstimada); 
    SET fechaHoy = CURDATE(); 
    
    IF fechaEntrega = fechaHoy AND horaActual > '18:00:00' THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Después de las 6:00 PM no se permiten pedidos para el mismo día.'; 
    ELSE 
        INSERT INTO pedidos ( 
            fechaHoraCreacion, 
            fechaHoraEntregaEstimada, 
            estadoPedido, 
            cliente_idCliente, 
            domiciliario_idDomiciliario 
        ) 
        VALUES ( 
            NOW(), 
            fechaHoraEntregaEstimada, 
            'Pendiente', 
            clienteID, 
            domiciliarioID 
        ); 
    END IF; 
END //

DELIMITER ;

-- 1. Caso Exitoso: Pedido programado para el día de mañana
CALL BloqueoHorario(1, 1, DATE_ADD(NOW(), INTERVAL 1 DAY)); 

-- 2. Caso Exitoso: Pedido para hoy a las 2:00 PM (antes de la hora límite)
CALL BloqueoHorario(2, 2, CONCAT(CURDATE(), ' 14:00:00')); 

-- 3. Caso Excepción (Dispara SIGNAL 45000 por ser hoy a las 7:00 PM)
CALL BloqueoHorario(3, 1, CONCAT(CURDATE(), ' 19:00:00'));


-- ==========================================
-- 					TRIGGERS
-- ==========================================


-- =================================================================
-- 1. Actualización Automática de stockActual en inventarios
-- =================================================================
DELIMITER //

CREATE TRIGGER actualizarStockMovimiento
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
    IF NEW.tipoMovimiento = 'Entrada' THEN
        UPDATE inventarios 
        SET stockActual = stockActual + NEW.cantidad
        WHERE producto_idProducto = NEW.producto_idProducto;
    ELSEIF NEW.tipoMovimiento = 'Salida' THEN
        UPDATE inventarios 
        SET stockActual = stockActual - NEW.cantidad
        WHERE producto_idProducto = NEW.producto_idProducto;
    ELSEIF NEW.tipoMovimiento = 'Ajuste' THEN
        UPDATE inventarios 
        SET stockActual = NEW.cantidad
        WHERE producto_idProducto = NEW.producto_idProducto;
    END IF;
END //

DELIMITER ;

-- Verificar stock actual del producto 1 (Pan Aliñado, stockActual = 40)
SELECT producto_idProducto, stockActual 
FROM inventarios 
WHERE producto_idProducto = 1;

-- 1.1. Registrar una Entrada de 20 unidades (El stock pasará a 60)
INSERT INTO movimientos (tipoMovimiento, cantidad, fechaHora, panadero_idPanadero, producto_idProducto) 
VALUES ('Entrada', 20, NOW(), 1, 1);

-- 1.2. Registrar una Salida de 15 unidades (El stock pasará a 45)
INSERT INTO movimientos (tipoMovimiento, cantidad, fechaHora, panadero_idPanadero, producto_idProducto) 
VALUES ('Salida', 15, NOW(), 1, 1);

-- 1.3. Registrar un Ajuste directo a 50 unidades
INSERT INTO movimientos (tipoMovimiento, cantidad, fechaHora, panadero_idPanadero, producto_idProducto) 
VALUES ('Ajuste', 50, NOW(), 1, 1);

-- Comprobar el resultado final del stock
SELECT producto_idProducto, stockActual 
FROM inventarios 
WHERE producto_idProducto = 1;


-- =================================================================
-- 2. Congelación Automática del Precio del Producto (precioFijo)
-- =================================================================
DELIMITER //

CREATE TRIGGER congelarPrecioDetalle
BEFORE INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_precio DECIMAL(10, 2);
    
    SELECT precio INTO v_precio
    FROM productos
    WHERE idProducto = NEW.producto_idProducto;
    
    SET NEW.precioFijo = v_precio;
END //

DELIMITER ;

-- Consultar precio del producto 2 (Pan Rollo, precio = 1500.00)
SELECT idProducto, nombre, precio 
FROM productos 
WHERE idProducto = 2;

-- Insertar un detalle enviando precioFijo en 0 (el trigger asignará automáticamente 1500.00)
INSERT INTO detalle_pedidos (precioFijo, cantidad, pedido_idPedido, producto_idProducto) 
VALUES (0, 4, 7, 2);

-- Verificar que precioFijo tomó el valor 1500.00 automáticamente
SELECT * 
FROM detalle_pedidos 
WHERE pedido_idPedido = 7 AND producto_idProducto = 2;

-- =================================================================
-- 3. Recálculo Automático del Total en recibos
-- =================================================================
DELIMITER //

CREATE TRIGGER actualizarTotalRecibo
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(10, 2);
    
    SELECT SUM(precioFijo * cantidad) INTO v_total
    FROM detalle_pedidos
    WHERE pedido_idPedido = NEW.pedido_idPedido;
    
    UPDATE recibos
    SET totalPagar = v_total
    WHERE pedido_idPedido = NEW.pedido_idPedido;
END //

DELIMITER ;

-- Verificar total actual del recibo para el pedido 8
SELECT * 
FROM recibos 
WHERE pedido_idPedido = 8;

-- Agregar un nuevo producto al pedido 8 (2 unidades de Pan Aliñado a 2500.00 = +5000.00)
INSERT INTO detalle_pedidos (precioFijo, cantidad, pedido_idPedido, producto_idProducto) 
VALUES (2500.00, 2, 8, 1);

-- Comprobar que el total del recibo se actualizó automáticamente sumando el nuevo ítem
SELECT * 
FROM recibos 
WHERE pedido_idPedido = 8;

-- =================================================================
-- 4. Validación de Exclusividad de Rol (Triángulo ISA en usuarios)
-- =================================================================
DELIMITER //

CREATE TRIGGER validarExclusividadRol
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    DECLARE v_roles_contados INT DEFAULT 0;
    
    IF NEW.cliente_idCliente IS NOT NULL THEN
        SET v_roles_contados = v_roles_contados + 1;
    END IF;
    
    IF NEW.panadero_idPanadero IS NOT NULL THEN
        SET v_roles_contados = v_roles_contados + 1;
    END IF;

    IF NEW.domiciliario_idDomiciliario IS NOT NULL THEN
        SET v_roles_contados = v_roles_contados + 1;
    END IF;
    
    IF v_roles_contados > 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Un usuario no puede tener mas de un subtipo de rol asignado.';
    END IF;
END //

DELIMITER ;

-- 4.1. Inserción Válida: Usuario asignado únicamente a Cliente (idCliente = 10)
INSERT INTO usuarios (nombre, apellido, correo, contrasena, telefono, estado, Rol_idRol, cliente_idCliente, panadero_idPanadero, domiciliario_idDomiciliario) 
VALUES ('Usuario', 'Prueba1', 'prueba1@mail.com', 'hash123', '3000000001', 'Activo', 1, 10, NULL, NULL);

-- 4.2. Inserción Inválida (Lanzará error por asignar Cliente y Domiciliario)
INSERT INTO usuarios (nombre, apellido, correo, contrasena, telefono, estado, Rol_idRol, cliente_idCliente, panadero_idPanadero, domiciliario_idDomiciliario) 
VALUES ('Usuario', 'Error', 'error@mail.com', 'hash123', '3000000002', 'Activo', 1, 1, NULL, 1);

-- =================================================================
-- 5. Cambio Automático del Estado del Producto a 'Agotado'
-- =================================================================
DELIMITER //

CREATE TRIGGER actualizarEstadoProducto
AFTER UPDATE ON inventarios
FOR EACH ROW
BEGIN
    IF NEW.stockActual <= 0 THEN
        UPDATE productos
        SET estado = 'Agotado'
        WHERE idProducto = NEW.producto_idProducto;
    ELSE
        UPDATE productos
        SET estado = 'Disponbile'
        WHERE idProducto = NEW.producto_idProducto;
    END IF;
END //

DELIMITER ;

-- Verificar estado inicial del producto 1 (Pan Aliñado)
SELECT idProducto, nombre, estado 
FROM productos 
WHERE idProducto = 1;

-- 5.1. Agotar el inventario del producto 1
UPDATE inventarios 
SET stockActual = 0 
WHERE producto_idProducto = 1;

-- Comprobar que el producto cambió automáticamente a 'Agotado'
SELECT idProducto, nombre, estado 
FROM productos 
WHERE idProducto = 1;

-- 5.2. Restablecer el inventario del producto 1 a 40 unidades
UPDATE inventarios 
SET stockActual = 40 
WHERE producto_idProducto = 1;

-- Comprobar que el producto volvió automáticamente a 'Disponible'
SELECT idProducto, nombre, estado 
FROM productos 
WHERE idProducto = 1;


-- ==========================================
-- 				FUNCIONES
-- ==========================================


-- =================================================================
-- 1. Calcular Subtotal de Línea (Cantidad x Precio)
-- =================================================================
DELIMITER //

CREATE FUNCTION calcularSubtotalLinea(
    p_cantidad INT,
    p_precioFijo DECIMAL(10,2)
) 
RETURNS DECIMAL(10,2) 
DETERMINISTIC
BEGIN
    RETURN (p_cantidad * p_precioFijo);
END //

DELIMITER ;

-- Ejemplo 1: 4 unidades a $2.500 COP
SELECT calcularSubtotalLinea(4, 2500.00) AS Subtotal_Calculado;

-- Ejemplo 2: 10 unidades a $1.800 COP
SELECT calcularSubtotalLinea(10, 1800.00) AS Subtotal_Calculado;

-- Ejemplo 3: Cálculo directo sobre los datos de la tabla de productos
SELECT 
    nombre, 
    precio, 
    calcularSubtotalLinea(6, precio) AS Subtotal_6_Unidades
FROM productos
WHERE idProducto = 1;

-- =================================================================
-- 2. Calcular Total a Pagar de un Pedido
-- =================================================================
DELIMITER //

CREATE FUNCTION calcularTotalPedido(
    p_idPedido INT
) 
RETURNS DECIMAL(10,2) 
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(cantidad * precioFijo), 0.00) INTO v_total
    FROM detalle_pedidos
    WHERE pedido_idPedido = p_idPedido;
    
    RETURN v_total;
END //

DELIMITER ;

-- Ejemplo 1: Total del Pedido 1 (4 Pan Aliñado = $10.000.00)
SELECT calcularTotalPedido(1) AS Total_Pedido_1;

-- Ejemplo 2: Total del Pedido 6 (10 Buñuelos = $18.000.00)
SELECT calcularTotalPedido(6) AS Total_Pedido_6;

-- Ejemplo 3: Total del Pedido 7 (1 Torta de Vainilla = $25.000.00)
SELECT calcularTotalPedido(7) AS Total_Pedido_7;

-- =================================================================
-- 3. Contar Pedidos Activos (en curso) de un Cliente
-- =================================================================
DELIMITER //

CREATE FUNCTION contarPedidosActivosCliente(
    p_idCliente INT
) 
RETURNS INT 
READS SQL DATA
BEGIN
    DECLARE v_conteo INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_conteo
    FROM pedidos
    WHERE cliente_idCliente = p_idCliente 
      AND estadoPedido IN ('Pendiente', 'En preparación', 'Listo', 'En camino');
      
    RETURN v_conteo;
END //

DELIMITER ;

-- Ejemplo 1: Pedidos activos de Ana Gómez (Cliente 1: tiene el pedido 6 en preparación)
SELECT contarPedidosActivosCliente(1) AS Pedidos_Activos_Cliente_1;

-- Ejemplo 2: Pedidos activos de Luis Pérez (Cliente 2: tiene el pedido 7 pendiente)
SELECT contarPedidosActivosCliente(2) AS Pedidos_Activos_Cliente_2;

-- Ejemplo 3: Pedidos activos de Carlos Ruíz (Cliente 3: solo tiene el pedido 3 cancelado)
SELECT contarPedidosActivosCliente(3) AS Pedidos_Activos_Cliente_3;

-- =================================================================
-- 4. Obtener Total de Unidades Físicas por Pedido
-- =================================================================
DELIMITER //

CREATE FUNCTION obtenerTotalUnidadesPedido(
    p_idPedido INT
) 
RETURNS INT 
READS SQL DATA
BEGIN
    DECLARE v_totalUnidades INT DEFAULT 0;
    
    SELECT IFNULL(SUM(cantidad), 0) INTO v_totalUnidades
    FROM detalle_pedidos
    WHERE pedido_idPedido = p_idPedido;
    
    RETURN v_totalUnidades;
END //

DELIMITER ;

-- Ejemplo 1: Unidades totales del Pedido 1 (4 unidades)
SELECT obtenerTotalUnidadesPedido(1) AS Unidades_Pedido_1;

-- Ejemplo 2: Unidades totales del Pedido 6 (10 unidades)
SELECT obtenerTotalUnidadesPedido(6) AS Unidades_Pedido_6;

-- Ejemplo 3: Unidades totales del Pedido 9 (5 unidades)
SELECT obtenerTotalUnidadesPedido(9) AS Unidades_Pedido_9;

-- =================================================================
-- 5. Obtener Descuento Según Categoría de Cliente (Fidelización)
-- =================================================================
DELIMITER //

CREATE FUNCTION obtenerDescuentoCliente(
    p_idCliente INT
) 
RETURNS DECIMAL(5,2) 
READS SQL DATA
BEGIN
    DECLARE v_tipoCliente VARCHAR(20);
    DECLARE v_descuento DECIMAL(5,2) DEFAULT 0.00;
    
    SELECT tipoCliente INTO v_tipoCliente
    FROM clientes
    WHERE idCliente = p_idCliente;
    
    IF v_tipoCliente = 'Frecuente' THEN
        SET v_descuento = 10.00;
    ELSEIF v_tipoCliente = 'Nuevo' THEN
        SET v_descuento = 5.00;
    ELSE
        SET v_descuento = 0.00;
    END IF;
    
    RETURN v_descuento;
END //

DELIMITER ;

-- Ejemplo 1: Descuento para el Cliente 1 ('Nuevo' -> 5%)
SELECT obtenerDescuentoCliente(1) AS Porcentaje_Descuento;

-- Ejemplo 2: Descuento para el Cliente 2 ('Frecuente' -> 10%)
SELECT obtenerDescuentoCliente(2) AS Porcentaje_Descuento;

-- Ejemplo 3: Descuento para el Cliente 3 ('Ocasional' -> 0%)
SELECT obtenerDescuentoCliente(3) AS Porcentaje_Descuento;