## 1. Pedidos cuyo número de productos es superior al promedio

SELECT pedido_idPedido, SUM(cantidad) AS cantidad_productos
FROM detalle_pedidos
GROUP BY pedido_idPedido
having SUM(cantidad) > (
SELECT AVG(total_productos)
FROM (
SELECT SUM(cantidad) AS total_productos
FROM detalle_pedidos
GROUP BY pedido_idPedido
) AS promedio
) ORDER BY SUM(cantidad) desc;

## 2. Clientes que tienen más pedidos que el promedio

SELECT cliente_idCliente, COUNT(idPedido) AS cantidad_pedidos
FROM pedidos
GROUP BY cliente_idCliente
having COUNT(idPedido) > (
SELECT AVG(cantidad_pedidos)
FROM (
SELECT COUNT(idPedido) AS cantidad_pedidos
FROM pedidos
GROUP BY cliente_idCliente
) AS promedio
);

## 3. Productos cuyo stock actual está por debajo del promedio

SELECT p.nombre, i.stockActual
FROM productos p
JOIN inventarios i
ON p.idProducto = i.producto_idProducto
WHERE i.stockActual < (
SELECT AVG(stockActual)
FROM inventarios
);

## 4. Productos que se han vendido más veces que el promedio

SELECT producto_idProducto, SUM(cantidad) AS unidadesVendidas
FROM detalle_pedidos
GROUP BY producto_idProducto
having SUM(cantidad) > (
SELECT AVG(unidadesVendidas)
FROM (
SELECT SUM(cantidad) AS unidadesVendidas
FROM detalle_pedidos
GROUP BY producto_idProducto
) AS promedio
);

## 5. Clientes que han gastado más dinero que el promedio

SELECT p.cliente_idCliente, SUM(d.cantidad * d.precioFijo) AS gastoTotal
FROM pedidos p
JOIN detalle_pedidos d
ON p.idPedido = d.pedido_idPedido
GROUP BY p.cliente_idCliente
having SUM(d.cantidad * d.precioFijo) > (
SELECT AVG(gastoTotal)
FROM (
SELECT p2.cliente_idCliente, SUM(d2.cantidad * d2.precioFijo) AS gastoTotal
FROM pedidos p2
JOIN detalle_pedidos d2
ON p2.idPedido = d2.pedido_idPedido
GROUP BY p2.cliente_idCliente
) AS gastos
);

## 6. Día(s) de la semana cON mayor volumen de pedidos

SELECT dayname(fechaHoraCreaciON) AS diasemana, COUNT(idPedido) AS totalPedidos
FROM pedidos
GROUP BY dayname(fechaHoraCreaciON)
having COUNT(idPedido) = (
SELECT max(pedidos_por_dia)
FROM (
SELECT COUNT(idPedido) AS pedidos_por_dia
FROM pedidos
GROUP BY dayname(fechaHoraCreaciON)
) AS subcONsulta_maximo
);

## 7. Pedidos cuyo tiempo de entrega estimado supera el promedio general

SELECT idPedido, cliente_idCliente, fechaHoraCreaciON, fechaHoraEntregaEstimada, timestampdiff(minute, fechaHoraCreaciON, fechaHoraEntregaEstimada) AS tiempoEstimadoMinutos
FROM pedidos
WHERE timestampdiff(minute, fechaHoraCreaciON, fechaHoraEntregaEstimada) > (
SELECT AVG(timestampdiff(minute, fechaHoraCreaciON, fechaHoraEntregaEstimada))
FROM pedidos
);

## 8. SubcONsulta: Pedidos prioritarios en estado 'Pendiente' o 'En preparación'

SELECT p.idPedido, p.fechaHoraCreaciON, p.estadoPedido, p.cliente_idCliente
FROM pedidos p
WHERE (
SELECT p_sub.estadoPedido
FROM pedidos p_sub
WHERE p_sub.idPedido = p.idPedido
) = 'Pendiente'
or (
SELECT p_sub.estadoPedido
FROM pedidos p_sub
WHERE p_sub.idPedido = p.idPedido
) = 'En preparación'
order by p.fechaHoraCreaciON ASC;

## 9. Domiciliarios cON una cantidad de pedidos superior al promedio

SELECT domiciliario_idDomiciliario, COUNT(idPedido) AS cantidadPedidos
FROM pedidos
GROUP BY domiciliario_idDomiciliario
having COUNT(idPedido) > (
SELECT AVG(cantidadPedidos)
FROM (
SELECT COUNT(idPedido) AS cantidadPedidos
FROM pedidos
GROUP BY domiciliario_idDomiciliario
) AS promedio
);

## 10. Productos de mayor valor comercial

SELECT idProducto, nombre, precio
FROM productos
WHERE precio = (
SELECT max(precio)
FROM productos
);