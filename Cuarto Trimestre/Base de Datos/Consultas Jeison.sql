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