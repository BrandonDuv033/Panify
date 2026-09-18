# 1. Actualización Automática de stockActual en inventarios

DELIMITER //

CREATE TRIGGER trg_actualizar_stock_movimiento
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

# 2. Congelación Automática del Precio del Producto (precioFijo)

DELIMITER //

CREATE TRIGGER trg_congelar_precio_detalle
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

# 3. Recálculo Automático del Total en recibos

DELIMITER //

CREATE TRIGGER trg_actualizar_total_recibo
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

# 4. Validación de Exclusividad de Rol (Triángulo ISA en usuarios)

DELIMITER //

CREATE TRIGGER trg_validar_exclusividad_rol
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

# 5. Cambio Automático del Estado del Producto a 'Agotado'

DELIMITER //

CREATE TRIGGER trg_actualizar_estado_producto
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
