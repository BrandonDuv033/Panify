
##1 asignar al panadero un domicilio 

DELIMITER //

CREATE PROCEDURE `Asignadomiciliario`(   IN p_idPedido INT,
    IN p_idDomiciliario INT
)
BEGIN
    UPDATE pedido
    SET domiciliario_idDomiciliario = p_idDomiciliario
    WHERE idPedido = p_idPedido;

    UPDATE domiciliario
    SET estadoDisponibilidad = 'Disponible'
    WHERE idDomiciliario = p_idDomiciliario;
END //

DELIMITER ;

##2 Crear una ruta de entrega e insertar primera parada

DELIMITER //
CREATE PROCEDURE `RutaDeEntrega`(IN p_idDomiciliario INT,
    IN p_urlRutaGoogle VARCHAR(500),
    IN p_idPedido INT
)
BEGIN

    INSERT INTO ruta_entrega(
        estadoRuta,
        urlRutaGoogle,
        domiciliario_idDomiciliario
    )
    VALUES(
        'Pendiente',
        p_urlRutaGoogle,
        p_idDomiciliario
    );

    UPDATE pedido
    SET domiciliario_idDomiciliario = p_idDomiciliario
    WHERE idPedido = p_idPedido;

END//

##3. Actualizar estado operativo de un pedido
DELIMITER //
CREATE  PROCEDURE `ActualizarPedido`(  IN pedidoID INT,
    IN nuevoEstado VARCHAR(45)
)
BEGIN

    UPDATE pedido
    SET estadoPedido = CASE nuevoEstado
          WHEN nuevoEstado = 1 THEN 'pendiente'
        WHEN nuevoEstado = 2 THEN 'En Curso'
        WHEN nuevoEstado = 3 THEN 'Completado'
        WHEN nuevoEstado = 4 THEN 'Cancelado'
        ELSE estadoPedido
        
    END
    WHERE pedido.idPedido = pedidoID;

END//

##4. Consultar historial de pedidos de un cliente

DELIMITER // 
CREATE  PROCEDURE `Historial`( IN clienteID INT
)
BEGIN
    SELECT 
        usuario.nombre,
        usuario.apellido,
        pedido.idPedido,
        pedido.fechaHoraCreacion,
        pedido.estadoPedido,
        IFNULL(orden.total_pagar, 0) AS totalFacturado,
        orden.fecha_emision
    FROM cliente
    INNER JOIN usuario
        ON usuario.cliente_idCliente = cliente.idCliente
    INNER JOIN pedido
        ON pedido.cliente_idCliente = cliente.idCliente
    LEFT JOIN orden
        ON orden.idOrden = pedido.orden_idOrden
    WHERE cliente.idCliente = clienteID;
END//

##5. Crear pedido validando el Control Horario
Delimiter // 
CREATE  PROCEDURE `BloqueoHorario`(  IN clienteID INT,
    IN domiciliarioID INT,
    IN ordenID INT,
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
        INSERT INTO pedido (
            fechaHoraCreacion,
            fechaHoraEntregaEstimada,
            estadoPedido,
            cliente_idCliente,
            domiciliario_idDomiciliario,
            orden_idOrden
        )
        VALUES (
            NOW(),
            fechaHoraEntregaEstimada,
            'Pendiente',
            clienteID,
            domiciliarioID,
            ordenID
        );
    END IF;
END//