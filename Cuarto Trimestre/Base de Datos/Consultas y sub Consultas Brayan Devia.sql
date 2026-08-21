##Consulta 1 Obtener un reporte consolidado de los pedidos que incluya el nombre del cliente, el identificador de la orden,
## el monto facturado en el recibo y el enlace de la ruta de entrega asignada para el rastreo del paquete.
select (c.idCliente) as id_Cliente, CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    p.idPedido,
    r.totalPagar,
    re.urlRutaGoogle
    from cliente c inner join usuario u
    on c.idCliente = u.cliente_idCliente
    inner join pedido p 
    on c.idCliente = p.cliente_idCliente
    inner join recibo r 
    on p.idPedido = r.pedido_idPedido
    inner join ruta_entrega re 
    on re.idRuta_entrega = p.ruta_entrega_idRuta_entrega;
##Consultar el historial de movimientos de inventario mostrando el nombre del producto, la cantidad retirada,
## el stock disponible actualizado y el nombre completo del panadero responsable del registro.
SELECT 
    p.nombre AS producto,
    m.cantidad AS cantidad_retirada,
    i.stockActual,
    CONCAT(u.nombre, ' ', u.apellido) AS panadero
FROM producto p
INNER JOIN inventario i ON p.idProducto = i.producto_idProducto
INNER JOIN movimiento m ON p.idProducto = m.producto_idProducto
INNER JOIN usuario u ON m.panadero_idPanadero = u.panadero_idPanadero;

##Sub Consultas 
##Listar los productos vendidos junto con el cliente y el total facturado, filtrando únicamente aquellos ítems cuyo precio unitario registrado
## en el detalle del pedido sea mayor al promedio general de todos los recibos emitidos.
select (pro.nombre) as nombre_Producto, concat(u.nombre," ",u.apellido) as cliente,(r.totalPagar) as totalPagar, (dp.precioFijo) as precioFijo
from cliente c inner join usuario u
on c.idCliente = u.cliente_idCliente
  inner join pedido p 
    on c.idCliente = p.cliente_idCliente
    inner join recibo r 
    on p.idPedido = r.pedido_idPedido
    inner join detalle_pedido dp
    on p.idPedido = dp.pedido_idPedido
    inner join producto pro
    on pro.idProducto = dp.producto_idProducto
 where dp.precioFijo > (select avg(totalPagar)from recibo) ;
    ##Obtener la lista de productos asociados a pedidos con estado 'Entregado', detallando las unidades vendidas y el estado de la orden,
    ##únicamente para aquellos productos cuyo stock actual en inventario sea inferior al promedio de stock global.

  SELECT 
    p.nombre AS producto,
    i.stockActual,
    dp.cantidad AS cantidad_pedida,
    ped.estadoPedido
FROM producto p
INNER JOIN inventario i ON p.idProducto = i.producto_idProducto
INNER JOIN detalle_pedido dp ON p.idProducto = dp.producto_idProducto
INNER JOIN pedido ped ON dp.pedido_idPedido = ped.idPedido
WHERE ped.estadoPedido = 'Entregado'
  AND i.stockActual < (
      SELECT AVG(stockActual) 
      FROM inventario
  );















