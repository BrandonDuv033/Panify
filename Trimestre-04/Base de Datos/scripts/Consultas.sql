-- 1. Top Productos y Ventas
SELECT 
    p.idProducto,
    p.nombre,
    SUM(dp.cantidad) AS total_unidades_vendidas,
    SUM(dp.cantidad * dp.precioFijo) AS total_recaudado,
    ROUND((SUM(dp.cantidad * dp.precioFijo) / (SELECT SUM(cantidad * precioFijo) FROM detalles_pedidos)) * 100, 2) AS porcentaje_ventas_global
FROM productos p
INNER JOIN detalles_pedidos dp ON p.idProducto = dp.producto_idProducto
GROUP BY p.idProducto, p.nombre
ORDER BY total_recaudado DESC
LIMIT 3;

-- 2. Clientes con Mayor Frecuencia de Compra
SELECT 
    c.idCliente,
    u.nombre,
    u.apellido,
    u.telefono,
    c.tipoCliente,
    COUNT(p.idPedido) AS total_pedidos_realizados
FROM clientes c
INNER JOIN usuarios u ON u.cliente_idCliente = c.idCliente
INNER JOIN pedidos p ON p.cliente_idCliente = c.idCliente
GROUP BY c.idCliente, u.nombre, u.apellido, u.telefono, c.tipoCliente
ORDER BY total_pedidos_realizados DESC;

-- 3. Rendimiento de Domiciliarios
SELECT 
    u.nombre AS nombre_domiciliario,
    u.telefono,
    COUNT(DISTINCT re.idRutasEntrega) AS total_rutas_asignadas,
    AVG(TIMESTAMPDIFF(MINUTE, p.fechaHoraCreacion, r.fechaEmision)) AS promedio_minutos_entrega
FROM domiciliarios d
INNER JOIN usuarios u ON u.domiciliario_idDomiciliario = d.idDomiciliario
INNER JOIN rutasEntrega re ON re.domiciliarios_idDomiciliario = d.idDomiciliario
INNER JOIN rutasParada rp ON rp.rutasEntrega_idRutasEntrega = re.idRutasEntrega
INNER JOIN pedidos p ON rp.pedidos_idPedido = p.idPedido
INNER JOIN recibos r ON r.pedido_idPedido = p.idPedido
WHERE rp.estadoParada = 'Entregado'
GROUP BY d.idDomiciliario, u.nombre, u.telefono;

-- 4. Alertas de Stock Bajo
SELECT 
    p.nombre AS producto,
    p.precio,
    i.stockActual,
    i.stockMinimo,
    (i.stockMinimo - i.stockActual) AS unidades_faltantes,
    CASE 
        WHEN i.stockActual = 0 THEN 'Agotado Crítico'
        WHEN i.stockActual <= i.stockMinimo THEN 'Reabastecer Pronto'
        ELSE 'OK'
    END AS estado_alerta
FROM inventarios i
INNER JOIN productos p ON i.producto_idProducto = p.idProducto
WHERE i.stockActual <= i.stockMinimo;

-- 5. Productos Inactivos en Menú
SELECT 
    p.idProducto,
    p.nombre,
    p.precio,
    p.estado,
    i.stockActual
FROM productos p
LEFT JOIN inventarios i ON p.idProducto = i.producto_idProducto
WHERE p.idProducto NOT IN (
    SELECT DISTINCT producto_idProducto 
    FROM movimientos 
    WHERE fechaHora >= DATE_SUB(NOW(), INTERVAL 30 DAY)
)
AND p.idProducto NOT IN (
    SELECT DISTINCT dp.producto_idProducto 
    FROM detalles_pedidos dp
    INNER JOIN pedidos ped ON dp.pedido_idPedido = ped.idPedido
    WHERE ped.fechaHoraCreacion >= DATE_SUB(NOW(), INTERVAL 30 DAY)
);

-- 6. Combos y Ventas Cruzadas
SELECT 
    p1.nombre AS producto_1,
    p2.nombre AS producto_2,
    COUNT(*) AS veces_comprados_juntos
FROM detalles_pedidos dp1
INNER JOIN detalles_pedidos dp2 
    ON dp1.pedido_idPedido = dp2.pedido_idPedido 
   AND dp1.producto_idProducto < dp2.producto_idProducto
INNER JOIN productos p1 ON dp1.producto_idProducto = p1.idProducto
INNER JOIN productos p2 ON dp2.producto_idProducto = p2.idProducto
GROUP BY dp1.producto_idProducto, dp2.producto_idProducto, p1.nombre, p2.nombre
ORDER BY veces_comprados_juntos DESC
LIMIT 5;

-- 7. Desglose de Consumo por Tipo de Cliente
SELECT 
    c.tipoCliente,
    COUNT(DISTINCT p.idPedido) AS total_pedidos,
    SUM(r.totalPagar) AS total_facturado,
    ROUND(AVG(r.totalPagar), 2) AS gasto_promedio_por_pedido
FROM clientes c
INNER JOIN pedidos p ON p.cliente_idCliente = c.idCliente
INNER JOIN recibos r ON r.pedido_idPedido = p.idPedido
GROUP BY c.tipoCliente
ORDER BY total_facturado DESC;

-- 8. Balance Diario de Caja
SELECT 
    DATE(r.fechaEmision) AS fecha,
    COUNT(r.idRecibo) AS total_pedidos_pagados,
    SUM(r.totalPagar) AS ingreso_total_dia,
    ROUND(AVG(r.totalPagar), 2) AS ticket_promedio
FROM recibos r
GROUP BY DATE(r.fechaEmision)
ORDER BY fecha DESC;

-- 9. Pedidos Retrasados
SELECT 
    p.idPedido,
    u.nombre AS cliente,
    u.telefono,
    p.fechaHoraCreacion,
    p.fechaHoraEntregaEstimada,
    p.estadoPedido
FROM pedidos p
INNER JOIN clientes c ON p.cliente_idCliente = c.idCliente
INNER JOIN usuarios u ON u.cliente_idCliente = c.idCliente
WHERE p.estadoPedido IN ('En camino', 'En preparación')
  AND NOW() > p.fechaHoraEntregaEstimada;

-- 10. Clientes Frecuentes sin Pedidos Activos
SELECT 
    c.idCliente,
    u.nombre,
    u.apellido,
    u.telefono,
    c.tipoCliente
FROM clientes c
INNER JOIN usuarios u ON u.cliente_idCliente = c.idCliente
WHERE c.tipoCliente = 'Frecuente'
  AND c.idCliente NOT IN (
      SELECT cliente_idCliente 
      FROM pedidos 
      WHERE estadoPedido IN ('En preparación', 'En camino')
  );