# Consultar los productos más solicitados
# Mostrar los productos que han sido incluidos en los pedidos, indicando 
# la cantidad total solicitada y el valor total generado por cada producto.

SELECT 
    p.idProducto,
    p.nombre,
    COUNT(DISTINCT dp.pedido_idPedido) AS cantidadPedidos,
    SUM(dp.cantidad) AS unidadesVendidas,
    ROUND(SUM(dp.cantidad * dp.precioFijo), 2) AS valorTotal
FROM producto p
INNER JOIN detalle_pedido dp
    ON p.idProducto = dp.producto_idProducto
INNER JOIN pedido pe
    ON dp.pedido_idPedido = pe.idPedido
INNER JOIN cliente c
    ON pe.cliente_idCliente = c.idCliente
GROUP BY 
    p.idProducto,
    p.nombre
ORDER BY unidadesVendidas DESC;

# Consultar información completa de los usuarios
# Mostrar la información de los usuarios registrados en Panify, incluyendo su 
# nombre completo, correo electrónico, rol y, cuando corresponda, la información
# relacionada con el cliente, domiciliario o panadero.

SELECT 
    u.idUsuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombreCompleto,
    u.correoElectronico,
    r.nombre AS rol,
    c.idCliente,
    d.idDomiciliario,
    p.idPanadero
FROM usuario u
INNER JOIN rol r 
    ON u.Rol_idRol = r.idRol
LEFT JOIN cliente c 
    ON u.cliente_idCliente = c.idCliente
LEFT JOIN domiciliario d 
    ON u.domiciliario_idDomiciliario = d.idDomiciliario
LEFT JOIN panadero p 
    ON u.panadero_idPanadero = p.idPanadero;
    
##3. Comparar stock con unidades solicitadas
##Consultar los productos y determinar la diferencia entre el stock actual y la cantidad total de unidades solicitadas en los pedidos.

SELECT
    p.idProducto,
    p.nombre,
    i.stockActual,
    i.stockMinimo,
    COALESCE(t.totalSolicitado, 0) AS totalSolicitado,
    (
        i.stockActual - COALESCE(t.totalSolicitado, 0)
    ) AS diferenciaStock
FROM producto p

LEFT JOIN inventario i
    ON p.idProducto = i.producto_idProducto

LEFT JOIN (
    SELECT
        dp.producto_idProducto,
        SUM(dp.cantidad) AS totalSolicitado
    FROM detalle_pedido dp

    INNER JOIN pedido pe
        ON dp.pedido_idPedido = pe.idPedido

    INNER JOIN cliente c
        ON pe.cliente_idCliente = c.idCliente

    GROUP BY dp.producto_idProducto
) t
    ON p.idProducto = t.producto_idProducto;
    
##4. Promedio de compra de cada cliente
##Consultar los clientes y calcular el valor promedio de los productos que han comprado, teniendo en cuenta la cantidad y el precio fijo.

    SELECT
    c.idCliente,
    u.nombre,
    u.apellido,
    COALESCE(t.promedioCompra, 0) AS promedioCompra,
    COALESCE(t.totalUnidades, 0) AS totalUnidades
FROM cliente c

INNER JOIN usuario u
    ON u.cliente_idCliente = c.idCliente

LEFT JOIN (
    SELECT
        pe.cliente_idCliente,
        AVG(dp.cantidad * dp.precioFijo) AS promedioCompra,
        SUM(dp.cantidad) AS totalUnidades
    FROM pedido pe

    INNER JOIN detalle_pedido dp
        ON pe.idPedido = dp.pedido_idPedido

    INNER JOIN producto p
        ON dp.producto_idProducto = p.idProducto

    GROUP BY pe.cliente_idCliente
) t
    ON c.idCliente = t.cliente_idCliente;