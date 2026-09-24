import API from "./api";

export async function obtenerRecibos() {
  const [recibos, pedidos, usuarios] = await Promise.all([
    API.get("/recibos"),
    API.get("/pedidos"),
    API.get("/users"),
  ]);

  return recibos.data.map((recibo) => {
    const pedido = pedidos.data.find((p) => p.id == recibo.idPedido);

    const usuario = usuarios.data.find(
      (u) => u.cliente_idCliente == pedido?.cliente_idCliente,
    );

    const nombreCliente = usuario
      ? `${usuario.nombre} ${usuario.apellido}`
      : "Cliente no encontrado";

    return { ...recibo, nombreCliente };
  });
}

// services/recibosService.js
export async function obtenerDetallePedido(idPedido) {
  try {
    const [detallesRespuesta, productosRespuesta] = await Promise.all([
      API.get("/detalle_pedidos", { params: { idPedido } }),
      API.get("/productos"),
    ]);

    const productos = productosRespuesta.data;

    return detallesRespuesta.data.map((detalle) => {
      const producto = productos.find(
        (p) => p.idProducto === detalle.producto_idProducto,
      );

      return {
        id: detalle.id,
        producto: producto?.nombre ?? "Producto no encontrado",
        cantidad: detalle.cantidad,
        precio: detalle.precioFijo,
        subtotal: detalle.cantidad * detalle.precioFijo,
      };
    });
  } catch (error) {
    throw new Error("No se pudo obtener el detalle del recibo");
  }
}
