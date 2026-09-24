const API_URL = "http://localhost:1511";

export async function obtenerPedidosCliente(idCliente) {
  const respuesta = await fetch(
    `${API_URL}/pedidos?cliente_idCliente=${idCliente}`
  );

  if (!respuesta.ok) {
    throw new Error("No se pudieron obtener los pedidos");
  }

  return respuesta.json();
}

export async function obtenerDetallesPedido(idPedido) {
  const respuesta = await fetch(
    `${API_URL}/detalles_pedidos?pedido_id=${idPedido}`
  );

  if (!respuesta.ok) {
    throw new Error("No se pudieron obtener los detalles del pedido");
  }

  return respuesta.json();
}

export async function obtenerProducto(idProducto) {
  const respuesta = await fetch(
    `${API_URL}/productos?idProducto=${idProducto}`
  );

  if (!respuesta.ok) {
    throw new Error("No se pudo obtener el producto");
  }

  const productos = await respuesta.json();

  return productos[0];
}

export async function obtenerReciboPedido(idPedido) {
  const respuesta = await fetch(
    `${API_URL}/recibos?pedido_id=${idPedido}`
  );

  if (!respuesta.ok) {
    throw new Error("No se pudo obtener el recibo");
  }

  const recibos = await respuesta.json();

  return recibos[0];
}