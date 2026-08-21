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
    