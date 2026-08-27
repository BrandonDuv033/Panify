# Consultar pedidos con información del recibo
# Consultar los pedidos realizados por los clientes, mostrando el usuario que realizó el 
# pedido, los productos solicitados y la información del recibo generado.
# RF10 - RF11 - RF12 - RF15

SELECT 
    u.nombre,
    u.apellido,
    c.idCliente,
    pe.idPedido,
    pe.estadoPedido,
    dp.producto_idProducto,
    dp.cantidad,
    r.idRecibo,
    r.fechaEmision,
    r.totalPagar
FROM usuario u
LEFT JOIN cliente c
    ON u.cliente_idCliente = c.idCliente
LEFT JOIN pedido pe
    ON c.idCliente = pe.cliente_idCliente
LEFT JOIN detalle_pedido dp
    ON pe.idPedido = dp.pedido_idPedido
LEFT JOIN recibo r
    ON pe.idPedido = r.pedido_idPedido;


# Productos vendidos y stock disponible
# Mostrar los productos que han sido vendidos, indicando cuántas unidades se han
# solicitado, el valor total generado y el stock disponible actualmente.
# RF5 - RF8 - RF9 - RF10 - RF11

SELECT 
    p.idProducto,
    UPPER(p.nombre) AS nombreProducto,
    i.stockActual,
    i.stockMinimo,
    SUM(dp.cantidad) AS unidadesSolicitadas,
    ROUND(SUM(dp.cantidad * dp.precioFijo), 2) AS valorGenerado,
    ROUND(i.stockActual - SUM(dp.cantidad), 2) AS diferenciaStock
FROM producto p
INNER JOIN inventario i
    ON p.idProducto = i.producto_idProducto
INNER JOIN detalle_pedido dp
    ON p.idProducto = dp.producto_idProducto
INNER JOIN pedido pe
    ON dp.pedido_idPedido = pe.idPedido
INNER JOIN cliente c
    ON pe.cliente_idCliente = c.idCliente
GROUP BY 
    p.idProducto,
    p.nombre,
    i.stockActual,
    i.stockMinimo
ORDER BY unidadesSolicitadas DESC;


##7. Promedio de unidades por pedido de cada producto
##Consultar cada producto mostrando su inventario y el promedio de unidades solicitadas por pedido.
SELECT
    p.idProducto,
    p.nombre,
    i.stockActual,
    COALESCE(t.promedioUnidades, 0) AS promedioUnidades,
    COALESCE(t.totalUnidades, 0) AS totalUnidades
FROM producto p

LEFT JOIN inventario i
    ON p.idProducto = i.producto_idProducto

LEFT JOIN (
    SELECT
        dp.producto_idProducto,
        AVG(dp.cantidad) AS promedioUnidades,
        SUM(dp.cantidad) AS totalUnidades
    FROM detalle_pedido dp

    INNER JOIN pedido pe
        ON dp.pedido_idPedido = pe.idPedido

    INNER JOIN cliente c
        ON pe.cliente_idCliente = c.idCliente

    GROUP BY dp.producto_idProducto
) t
    ON p.idProducto = t.producto_idProducto;

##8. Valor promedio de los pedidos de cada cliente
##Consultar los clientes y calcular el valor promedio de sus pedidos, relacionando los pedidos con sus detalles, productos y recibos.
SELECT
    c.idCliente,
    u.nombre,
    u.apellido,
    COALESCE(t.promedioPedido, 0) AS promedioPedido,
    COALESCE(t.totalPedidos, 0) AS totalPedidos
FROM cliente c

INNER JOIN usuario u
    ON u.cliente_idCliente = c.idCliente

LEFT JOIN (
    SELECT
        pe.cliente_idCliente,
        AVG(dp.cantidad * dp.precioFijo) AS promedioPedido,
        COUNT(DISTINCT pe.idPedido) AS totalPedidos
    FROM pedido pe

    INNER JOIN detalle_pedido dp
        ON pe.idPedido = dp.pedido_idPedido

    INNER JOIN producto p
        ON dp.producto_idProducto = p.idProducto

    INNER JOIN recibo r
        ON pe.idPedido = r.pedido_idPedido

    GROUP BY pe.cliente_idCliente
) t
    ON c.idCliente = t.cliente_idCliente;
