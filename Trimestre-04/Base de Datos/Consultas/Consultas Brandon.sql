# 1. GENERAR RECIBO
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
    
    
# 2. VISUALIZAR PEDIDOS PENDIENTES
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

# SUBCONSULTAS

# 1. Total comprado por cada cliente
# Consultar los clientes registrados y calcular el valor total de todos sus pedidos, tomando la cantidad y el precio fijo de cada producto. También mostrar el usuario asociado y su rol.
SELECT
    u.idusuario,
    u.nombre,
    u.apellido,
    r.nombre AS rol,
    c.idCliente,
    COALESCE(t.totalComprado, 0) AS totalComprado
FROM usuario u

LEFT JOIN rol r
    ON u.Rol_idRol = r.idRol

LEFT JOIN cliente c
    ON u.cliente_idCliente = c.idCliente

LEFT JOIN (
    SELECT
        pe.cliente_idCliente,
        SUM(dp.cantidad * dp.precioFijo) AS totalComprado
    FROM pedido pe

    INNER JOIN detalle_pedido dp
        ON pe.idPedido = dp.pedido_idPedido

    INNER JOIN producto p
        ON dp.producto_idProducto = p.idProducto

    GROUP BY pe.cliente_idCliente
) t
    ON c.idCliente = t.cliente_idCliente;

# 2. Productos más solicitados y valor generado
# Consultar los productos registrados mostrando el stock actual, la cantidad total solicitada en pedidos y el valor económico generado por dichas solicitudes.
SELECT
    p.idProducto,
    p.nombre,
    i.stockActual,
    COALESCE(t.cantidadSolicitada, 0) AS cantidadSolicitada,
    COALESCE(t.valorGenerado, 0) AS valorGenerado
FROM producto p

LEFT JOIN inventario i
    ON p.idProducto = i.producto_idProducto

LEFT JOIN (
    SELECT
        dp.producto_idProducto,
        SUM(dp.cantidad) AS cantidadSolicitada,
        SUM(dp.cantidad * dp.precioFijo) AS valorGenerado
    FROM detalle_pedido dp

    INNER JOIN pedido pe
        ON dp.pedido_idPedido = pe.idPedido

    INNER JOIN cliente c
        ON pe.cliente_idCliente = c.idCliente

    GROUP BY dp.producto_idProducto
) t
    ON p.idProducto = t.producto_idProducto;