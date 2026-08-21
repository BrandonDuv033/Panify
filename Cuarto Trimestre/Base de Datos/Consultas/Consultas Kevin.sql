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


##5. Cantidad de pedidos y valor total por cliente
##Consultar cada cliente mostrando la cantidad de pedidos realizados y el valor total de los productos incluidos en dichos pedidos.
SELECT
    c.idCliente,
    u.nombre,
    u.apellido,
    COALESCE(t.totalPedidos, 0) AS totalPedidos,
    COALESCE(t.valorTotal, 0) AS valorTotal
FROM cliente c

INNER JOIN usuario u
    ON u.cliente_idCliente = c.idCliente

LEFT JOIN (
    SELECT
        pe.cliente_idCliente,
        COUNT(DISTINCT pe.idPedido) AS totalPedidos,
        SUM(dp.cantidad * dp.precioFijo) AS valorTotal
    FROM pedido pe

    INNER JOIN detalle_pedido dp
        ON pe.idPedido = dp.pedido_idPedido

    INNER JOIN producto p
        ON dp.producto_idProducto = p.idProducto

    GROUP BY pe.cliente_idCliente
) t
    ON c.idCliente = t.cliente_idCliente;

##6. Productos con movimientos y valor solicitado
##Consultar los productos mostrando el stock actual, la cantidad de movimientos de inventario y el valor total de los productos solicitados en pedidos.
SELECT
    p.idProducto,
    p.nombre,
    i.stockActual,
    COALESCE(m.totalMovimientos, 0) AS totalMovimientos,
    COALESCE(v.valorSolicitado, 0) AS valorSolicitado
FROM producto p

LEFT JOIN inventario i
    ON p.idProducto = i.producto_idProducto

LEFT JOIN (
    SELECT
        producto_idProducto,
        SUM(cantidad) AS totalMovimientos
    FROM movimiento
    GROUP BY producto_idProducto
) m
    ON p.idProducto = m.producto_idProducto

LEFT JOIN (
    SELECT
        dp.producto_idProducto,
        SUM(dp.cantidad * dp.precioFijo) AS valorSolicitado
    FROM detalle_pedido dp

    INNER JOIN pedido pe
        ON dp.pedido_idPedido = pe.idPedido

    INNER JOIN cliente c
        ON pe.cliente_idCliente = c.idCliente

    GROUP BY dp.producto_idProducto
) v
    ON p.idProducto = v.producto_idProducto;
