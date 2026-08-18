#Consulta cuyo stock actual sea menor al minimo
select i.nombre_producto,i.stock_actual as actual, i.stock_minimo as minimo
from inventario i 
where stock_actual <= i.stock_minimo
;
##Muestra los clientes que tengan al menos un pedido en estado En Curso
select distinct c.idCliente ,s.nombre as nombre , s.apellido as apellido , p.fechaHoraCreacion , p.estadoPedido
from usuario s inner join cliente c 
on s.cliente_idCliente = c.idCliente
inner  join pedido p
on c.idCliente = p.cliente_idCliente
where p.estadoPedido like "En Curso";

##identificar qué clientes han generado órdenes con un valor superior al promedio general.
select c.idCliente, s.nombre, s.apellido
from cliente c
inner join usuario s
on c.idCliente = s.cliente_idCliente
where c.idCliente in (select p.cliente_idCliente
from pedido p
inner join orden o
on p.orden_idOrden = o.idOrden
where o.total_pagar > (select avg(total_pagar)
from orden));

#identificar los productos cuya cantidad vendida está por encima del promedio de unidades vendidas por producto.
select i.nombre_producto, i.stock_actual
from inventario i
where i.idInventario in (select d.inventario_idinventario
from detalle_pedido d
group by d.inventario_idinventario
having sum(d.cantidad) > (select avg(total_vendido)
from (select sum(cantidad) as total_vendido
from detalle_pedido
group by inventario_idinventario) as promedio));










