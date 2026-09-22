import API from "./api";

export async function obtenerRecibos() {
  const [recibos, pedidos, usuarios] = await Promise.all([
    API.get("/recibos"),
    API.get("/pedidos"),
    API.get("/users"),
  ]);

  return recibos.data.map((recibo) => {
    const pedido = pedidos.data.find((p) => p.id == recibo.pedido_id);

    const usuario = usuarios.data.find(
      (u) => u.cliente_idCliente == pedido?.cliente_idCliente,
    );
    
    const nombreCliente = usuario
      ? `${usuario.nombre} ${usuario.apellido}`
      : "Cliente no encontrado";

    return { ...recibo, nombreCliente };
  });
}
