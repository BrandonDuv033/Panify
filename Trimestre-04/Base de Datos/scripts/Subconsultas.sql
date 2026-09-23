## 1. Pedidos cuyo número de productos es superior al promedio
SELECT pedido_idPedido, SUM(cantidad) AS cantidad_productos
FROM detalles_pedidos
GROUP BY pedido_idPedido
HAVING SUM(cantidad) > (
SELECT AVG(total_productos)
FROM (
SELECT SUM(cantidad) AS total_productos
FROM detalles_pedidos
GROUP BY pedido_idPedido) AS promedio)
ORDER BY SUM(cantidad) DESC;

## 2. Clientes que tienen más pedidos que el promedio
SELECT cliente_idCliente, COUNT(idPedido) AS cantidad_pedidos
FROM pedidos
GROUP BY cliente_idCliente
HAVING COUNT(idPedido) > (
SELECT AVG(cantidad_pedidos)
FROM (
SELECT COUNT(idPedido) AS cantidad_pedidos
FROM pedidos
GROUP BY cliente_idCliente) AS promedio);

## 3. Productos cuyo stock actual está por debajo del promedio
SELECT p.nombre, i.stockActual
FROM productos p
JOIN inventarios i ON p.idProducto = i.producto_idProducto
WHERE i.stockActual < (
SELECT AVG(stockActual)
FROM inventarios);

## 4. Productos que se han vendido más veces que el promedio
SELECT producto_idProducto, SUM(cantidad) AS unidadesVendidas
FROM detalles_pedidos
GROUP BY producto_idProducto
HAVING SUM(cantidad) > (
SELECT AVG(unidadesVendidas)
FROM (
SELECT SUM(cantidad) AS unidadesVendidas
FROM detalles_pedidos
GROUP BY producto_idProducto) AS promedio);

## 5. Clientes que han gastado más dinero que el promedio
SELECT p.cliente_idCliente, SUM(d.cantidad * d.precioFijo) AS gastoTotal
FROM pedidos p
JOIN detalles_pedidos d ON p.idPedido = d.pedido_idPedido
GROUP BY p.cliente_idCliente
HAVING SUM(d.cantidad * d.precioFijo) > (
SELECT AVG(gastoTotal)
FROM (
SELECT p2.cliente_idCliente, SUM(d2.cantidad * d2.precioFijo) AS gastoTotal
FROM pedidos p2
JOIN detalles_pedidos d2 ON p2.idPedido = d2.pedido_idPedido
GROUP BY p2.cliente_idCliente) AS gastos);

## 6. Día(s) de la semana con mayor volumen de pedidos
SELECT DAYNAME(fechaHoraCreacion) AS diasemana, COUNT(idPedido) AS totalPedidos
FROM pedidos
GROUP BY DAYNAME(fechaHoraCreacion)
HAVING COUNT(idPedido) = (
SELECT MAX(pedidos_por_dia)
FROM (
SELECT COUNT(idPedido) AS pedidos_por_dia
FROM pedidos
GROUP BY DAYNAME(fechaHoraCreacion)) AS subconsulta_maximo);

## 7. Pedidos cuyo tiempo de entrega estimado supera el promedio general
SELECT idPedido, cliente_idCliente, fechaHoraCreacion, fechaHoraEntregaEstimada, TIMESTAMPDIFF(MINUTE, fechaHoraCreacion, fechaHoraEntregaEstimada) AS tiempoEstimadoMinutos
FROM pedidos
WHERE TIMESTAMPDIFF(MINUTE, fechaHoraCreacion, fechaHoraEntregaEstimada) > (
SELECT AVG(TIMESTAMPDIFF(MINUTE, fechaHoraCreacion, fechaHoraEntregaEstimada))
FROM pedidos);

## 8. Pedidos prioritarios en estado 'Pendiente' o 'En preparación'
SELECT p.idPedido, p.fechaHoraCreacion, p.estadoPedido, p.cliente_idCliente
FROM pedidos p
WHERE (
SELECT p_sub.estadoPedido
FROM pedidos p_sub
WHERE p_sub.idPedido = p.idPedido
) = 'Pendiente'
OR (
SELECT p_sub.estadoPedido
FROM pedidos p_sub
WHERE p_sub.idPedido = p.idPedido) = 'En preparación'
ORDER BY p.fechaHoraCreacion ASC;

## 9. Domiciliarios con una cantidad de pedidos superior al promedio
SELECT domiciliario_idDomiciliario, COUNT(idPedido) AS cantidadPedidos
FROM pedidos
GROUP BY domiciliario_idDomiciliario
HAVING COUNT(idPedido) > (
SELECT AVG(cantidadPedidos)
FROM (
SELECT COUNT(idPedido) AS cantidadPedidos
FROM pedidos
GROUP BY domiciliario_idDomiciliario) AS promedio);

## 10. Productos de mayor valor comercial
SELECT idProducto, nombre, precio
FROM productos
WHERE precio = (
SELECT MAX(precio)
FROM productos);
