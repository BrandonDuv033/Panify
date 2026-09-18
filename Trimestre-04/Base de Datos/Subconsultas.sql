## 1. Pedidos cuyo número de productos es superior al promedio

select pedido_idPedido, sum(cantidad) as cantidad_productos
from detalles_pedidos
group by pedido_idPedido
having sum(cantidad) > (
select avg(total_productos)
from (
select sum(cantidad) as total_productos
from detalles_pedidos
group by pedido_idPedido
) as promedio
);

## 2. Clientes que tienen más pedidos que el promedio

select cliente_idCliente, count(idPedido) as cantidad_pedidos
from pedidos
group by cliente_idCliente
having count(idPedido) > (
select avg(cantidad_pedidos)
from (
select count(idPedido) as cantidad_pedidos
from pedidos
group by cliente_idCliente
) as promedio
);

## 3. Productos cuyo stock actual está por debajo del promedio

select p.nombre, i.stockActual
from productos p
join inventarios i
on p.idProducto = i.producto_idProducto
where i.stockActual < (
select avg(stockActual)
from inventarios
);

## 4. Productos que se han vendido más veces que el promedio

select producto_idProducto, sum(cantidad) as unidadesVendidas
from detalles_pedidos
group by producto_idProducto
having sum(cantidad) > (
select avg(unidadesVendidas)
from (
select sum(cantidad) as unidadesVendidas
from detalles_pedidos
group by producto_idProducto
) as promedio
);

## 5. Clientes que han gastado más dinero que el promedio

select p.cliente_idCliente, sum(d.cantidad * d.precioFijo) as gastoTotal
from pedidos p
join detalles_pedidos d
on p.idPedido = d.pedido_idPedido
group by p.cliente_idCliente
having sum(d.cantidad * d.precioFijo) > (
select avg(gastoTotal)
from (
select p2.cliente_idCliente, sum(d2.cantidad * d2.precioFijo) as gastoTotal
from pedidos p2
join detalles_pedidos d2
on p2.idPedido = d2.pedido_idPedido
group by p2.cliente_idCliente
) as gastos
);

## 6. Día(s) de la semana con mayor volumen de pedidos

select dayname(fechaHoraCreacion) as diaSemana, count(idPedido) as totalPedidos
from pedidos
group by dayname(fechaHoraCreacion)
having count(idPedido) = (
select max(pedidos_por_dia)
from (
select count(idPedido) as pedidos_por_dia
from pedidos
group by dayname(fechaHoraCreacion)
) as subconsulta_maximo
);

## 7. Pedidos cuyo tiempo de entrega estimado supera el promedio general

select idPedido, cliente_idCliente, fechaHoraCreacion, fechaHoraEntregaEstimada, timestampdiff(minute, fechaHoraCreacion, fechaHoraEntregaEstimada) as tiempoEstimadoMinutos
from pedidos
where timestampdiff(minute, fechaHoraCreacion, fechaHoraEntregaEstimada) > (
select avg(timestampdiff(minute, fechaHoraCreacion, fechaHoraEntregaEstimada))
from pedidos
);

## 8. Subconsulta: Pedidos prioritarios en estado 'Pendiente' o 'En preparación'

select p.idPedido, p.fechaHoraCreacion, p.estadoPedido, p.cliente_idCliente
from pedidos p
where (
select p_sub.estadoPedido
from pedidos p_sub
where p_sub.idPedido = p.idPedido
) = 'Pendiente'
or (
select p_sub.estadoPedido
from pedidos p_sub
where p_sub.idPedido = p.idPedido
) = 'En preparación'
order by p.fechaHoraCreacion asc;

## 9. Domiciliarios con una cantidad de pedidos superior al promedio

select domiciliario_idDomiciliario, count(idPedido) as cantidadPedidos
from pedidos
group by domiciliario_idDomiciliario
having count(idPedido) > (
select avg(cantidadPedidos)
from (
select count(idPedido) as cantidadPedidos
from pedidos
group by domiciliario_idDomiciliario
) as promedio
);

## 10. Productos de mayor valor comercial

select idProducto, nombre, precio
from productos
where precio = (
select max(precio)
from productos
);