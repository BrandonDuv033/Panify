# GENERAR RECIBO
# Muestra el id, datos del cliente, estado del pedido, nombre domiciliario, detalle venta.

SELECT 
    r.idRecibo,
    r.fechaEmision,
    CONCAT(ud.nombre, ' ', ud.apellido) AS domiciliario,
    CONCAT(uc.nombre, ' ', uc.apellido) AS cliente,
    r.totalPagar
FROM recibo r
INNER JOIN pedido p 
    ON r.pedido_idPedido = p.idPedido
INNER JOIN cliente c 
    ON p.cliente_idCliente = c.idCliente
INNER JOIN usuario uc 
    ON c.idCliente = uc.cliente_idCliente
INNER JOIN domiciliario d 
    ON p.domiciliario_idDomiciliario = d.idDomiciliario
INNER JOIN usuario ud 
    ON d.idDomiciliario = ud.domiciliario_idDomiciliario;
    
    
# VISUALIZAR PEDIDOS PENDIENTES
# Mostrar los pedidos registrados junto con el cliente que los realizó, 
# el domiciliario encargado, la ruta de entrega y los productos incluidos en el pedido.

SELECT 
    pe.idPedido,
    c.idCliente, u.nombre as Cliente,
    d.idDomiciliario,
    re.idRuta_entrega,
    re.urlRutaGoogle,
    pe.estadoPedido,
    p.nombre AS producto,
    dp.cantidad,
    ROUND(dp.cantidad * dp.precioFijo, 2) AS subtotal
FROM usuario u
INNER JOIN cliente c
on  u.cliente_idCliente = c.idCliente 
INNER JOIN pedido pe
    ON pe.cliente_idCliente = c.idCliente
INNER JOIN domiciliario d
    ON pe.domiciliario_idDomiciliario = d.idDomiciliario
INNER JOIN ruta_entrega re
    ON pe.ruta_entrega_idRuta_entrega = re.idRuta_entrega
INNER JOIN detalle_pedido dp
    ON pe.idPedido = dp.pedido_idPedido
INNER JOIN producto p
    ON dp.producto_idProducto = p.idProducto
ORDER BY pe.idPedido;