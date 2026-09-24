import API from "./api.js";

export async function obtenerPedidosCliente(idCliente) {
  const { data } = await API.get("/pedidos", {
    params: { cliente_idCliente: idCliente },
  });
  return data;
}

export async function obtenerDetallesPedido(idPedido) {
  const { data } = await API.get("/detalles_pedidos", {
    params: { pedido_id: idPedido },
  });
  return data;
}

export async function obtenerProducto(idProducto) {
  const { data } = await API.get("/productos", {
    params: { idProducto },
  });
  return data[0];
}

export async function obtenerReciboPedido(idPedido) {
  const { data } = await API.get("/recibos", {
    params: { pedido_id: idPedido },
  });
  return data[0];
}