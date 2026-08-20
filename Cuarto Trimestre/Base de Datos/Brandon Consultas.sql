##Mostrar el estado de cada ruta con el nombre y el apellido del domiciliario 
select distinct s.domiciliario_idDomiciliario as ID, s.nombre as nombre ,s.apellido as apellido,
r.estadoRuta 
from usuario s inner join domiciliario d 
on s.domiciliario_idDomiciliario = d.idDomiciliario 
inner join ruta_entrega r
on d.idDomiciliario = r.domiciliario_idDomiciliario;

##Muestra los clientes que hayan realizado pedidos, indicando el nombre del cliente, el número del pedido, el producto comprado, la cantidad solicitada 
select s.cliente_idCliente, s.nombre as nombre , s.apellido as apellido , idPedido as numero_PEDIDO, i.nombre_producto , d.cantidad
from usuario s inner join cliente c 
on s.cliente_idCliente = c.idCliente
inner join pedido p
on c.idCliente = p.cliente_idCliente
inner join detalle_pedido d
on p.idPedido = d.pedido_idPedido
inner join inventario i
on d.inventario_idinventario = i.idInventario;


##SUB-CONSULTAS
##dentificar cuáles pedidos tienen un valor superior al promedio de todas las órdenes, para detectar las compras de mayor valor.
select o.idOrden, o.total_pagar, o.fecha_emision
from orden o
where o.total_pagar > (select avg(total_pagar)
from orden)
order by o.total_pagar desc;

#identificar cuáles productos tienen una demanda superior al promedio para saber cuáles debería priorizar en la producción
select i.nombre_producto, sum(d.cantidad) as cantidad_vendida
from inventario i
inner join detalle_pedido d
on i.idInventario = d.inventario_idinventario
group by i.idInventario, i.nombre_producto
having sum(d.cantidad) > (select avg(total_producto)
from (select sum(cantidad) as total_producto
from detalle_pedido
group by inventario_idinventario) as promedio_productos);
