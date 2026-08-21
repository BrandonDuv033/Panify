# Consultar los pedidos realizados por cada cliente
# Consultar los pedidos realizados por los clientes, mostrando la información 
# básica del usuario, el cliente, el pedido, los productos solicitados y la 
# cantidad de cada producto. 
# RF1 - RF10 - RF11 - RF8

SELECT 
    u.idusuario,
    u.nombre,
    u.apellido,
    c.idCliente,
    pe.idPedido,
    pe.estadoPedido,
    p.nombre AS producto,
    dp.cantidad,
    dp.precioFijo
FROM usuario u
LEFT JOIN cliente c
    ON u.cliente_idCliente = c.idCliente
LEFT JOIN pedido pe
    ON c.idCliente = pe.cliente_idCliente
LEFT JOIN detalle_pedido dp
    ON pe.idPedido = dp.pedido_idPedido
LEFT JOIN producto p
    ON dp.producto_idProducto = p.idProducto;

# Consultar productos solicitados y su disponibilidad
# Consultar los productos incluidos en los pedidos, mostrando el cliente que realizó 
# el pedido, el estado del pedido, la cantidad solicitada y el stock actual disponible.

SELECT 
    c.idCliente,
    pe.idPedido,
    pe.estadoPedido,
    p.idProducto,
    p.nombre AS producto,
    dp.cantidad,
    i.stockActual,
    i.stockMinimo
FROM cliente c
LEFT JOIN pedido pe
    ON c.idCliente = pe.cliente_idCliente
LEFT JOIN detalle_pedido dp
    ON pe.idPedido = dp.pedido_idPedido
LEFT JOIN producto p
    ON dp.producto_idProducto = p.idProducto
LEFT JOIN inventario i
    ON p.idProducto = i.producto_idProducto;
