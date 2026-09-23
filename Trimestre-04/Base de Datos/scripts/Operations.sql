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

-- =================================================================
-- 						Asignar domiciliario
-- =================================================================

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

-- =================================================================
-- 							Ruta de entrega
-- =================================================================

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

-- =========================================================================================
-- 									Actualizar pedido
-- Estados: 1=Pendiente, 2=En preparación, 3=Listo, 4=En camino, 5=Entregado, 6=Cancelado
-- =========================================================================================

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

-- =================================================================
-- 						Historial del cliente
-- =================================================================

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

-- =================================================================
-- 						Bloqueo de horario
-- =================================================================

-- 1. Caso Exitoso: Pedido programado para el día de mañana
CALL BloqueoHorario(1, 1, DATE_ADD(NOW(), INTERVAL 1 DAY)); 

-- 2. Caso Exitoso: Pedido para hoy a las 2:00 PM (antes de la hora límite)
CALL BloqueoHorario(2, 2, CONCAT(CURDATE(), ' 14:00:00')); 

-- 3. Caso Excepción (Dispara SIGNAL 45000 por ser hoy a las 7:00 PM)
CALL BloqueoHorario(3, 1, CONCAT(CURDATE(), ' 19:00:00'));