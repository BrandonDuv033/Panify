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
