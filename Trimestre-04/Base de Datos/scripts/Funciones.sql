
#1 Calcular Total a Pagar de un Pedido
DELIMITER //
CREATE FUNCTION fn_calcularSubtotalLinea(
    p_cantidad INT,
    p_precioFijo DECIMAL(10,2)
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (p_cantidad * p_precioFijo);
END //
DELIMITER ;


##2  Obtener Total de Unidades por Pedido
DELIMITER //
CREATE FUNCTION fn_calcularTotalPedido(
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

##3. Título: Contar Pedidos Activos de un Cliente
DELIMITER //
CREATE FUNCTION fn_contarPedidosActivosCliente(
    p_idCliente INT
) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_conteo INT;
    
    SELECT COUNT(*) INTO v_conteo
    FROM pedidos
    WHERE cliente_idCliente = p_idCliente
      AND estadoPedido IN ('Pendiente', 'En preparación', 'Listo', 'En camino');
      
    RETURN v_conteo;
END //
DELIMITER ;

##4. Título: Obtener Total de Unidades por Pedido
DELIMITER //
CREATE FUNCTION fn_obtenerTotalUnidadesPedido(
    p_idPedido INT
) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_totalUnidades INT;
    
    SELECT IFNULL(SUM(cantidad), 0) INTO v_totalUnidades
    FROM detalle_pedidos
    WHERE pedido_idPedido = p_idPedido;
    
    RETURN v_totalUnidades;
END //
DELIMITER ;

##5. Título: Obtener Descuento según Categoría de Cliente 
DELIMITER //
CREATE FUNCTION fn_obtenerDescuentoCliente(
    p_idCliente INT
) 
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_tipoCliente VARCHAR(20);
    DECLARE v_descuento DECIMAL(5,2);
    
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

