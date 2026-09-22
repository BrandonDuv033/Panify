import API from "./api";

function getUsuarioAutenticado() {
  try {
    const usuario = JSON.parse(localStorage.getItem("usuario") || "null");
    return usuario;
  } catch {
    return null;
  }
}

function getClienteIdActual() {
  const usuario = getUsuarioAutenticado();
  if (!usuario) return null;

  const clienteId =
    usuario.cliente_idCliente ?? usuario.idCliente ?? usuario.clienteId ?? null;

  return clienteId === null || clienteId === undefined
    ? null
    : Number(clienteId);
}

export class PedidoAccesoError extends Error {
  constructor(message, status = 403) {
    super(message);
    this.name = "PedidoAccesoError";
    this.status = status;
  }
}

export async function obtenerPedidoDetalle(idPedido) {
  const usuario = getUsuarioAutenticado();
  const clienteId = getClienteIdActual();

  if (!usuario || !clienteId) {
    throw new PedidoAccesoError(
      "Debes iniciar sesión como cliente para ver este pedido.",
      401,
    );
  }

  try {
    const response = await API.get(`/pedidos/${idPedido}`);
    const pedido = response.data;

    if (!pedido) {
      throw new PedidoAccesoError("Pedido no encontrado.", 404);
    }

    if (Number(pedido.cliente_idCliente) !== Number(clienteId)) {
      throw new PedidoAccesoError(
        "No tienes permisos para ver este pedido.",
        403,
      );
    }

    return pedido;
  } catch (error) {
    if (error instanceof PedidoAccesoError) {
      throw error;
    }

    const status = error?.response?.status;
    if (status === 404) {
      throw new PedidoAccesoError("Pedido no encontrado.", 404);
    }

    if (status === 403) {
      throw new PedidoAccesoError(
        "No tienes permisos para ver este pedido.",
        403,
      );
    }

    throw new PedidoAccesoError(
      "No se pudo cargar el detalle del pedido.",
      500,
    );
  }
}

// Carga solo los pedidos del cliente autenticado
export async function obtenerPedidos() {
  const usuario = getUsuarioAutenticado();
  const clienteId = getClienteIdActual();

  if (!usuario || !clienteId) {
    throw new PedidoAccesoError(
      "Debes iniciar sesión como cliente para ver tus pedidos.",
      401,
    );
  }

  const [pedidos, usuarios, detallesPedidos, productos] = await Promise.all([
    API.get("/pedidos"),
    API.get("/users"),
    API.get("/detalle_pedidos"),
    API.get("/productos"),
  ]);

  return pedidos.data
    .filter((pedido) => Number(pedido.cliente_idCliente) === Number(clienteId))
    .map((pedido) => {
      const usuarioPedido = usuarios.data.find(
        (u) => Number(u.cliente_idCliente) === Number(pedido.cliente_idCliente),
      );

      const cliente = usuarioPedido
        ? `${usuarioPedido.nombre} ${usuarioPedido.apellido}`
        : "Cliente no encontrado";

      const detalles = detallesPedidos.data.filter(
        (dp) => Number(dp.pedido_idPedido) === Number(pedido.id),
      );

      const listaProductos = detalles.map((dp) => {
        const prod = productos.data.find(
          (p) => Number(p.id) === Number(dp.producto_idProducto),
        );
        const precioUnitario = dp.precioFijo || (prod ? prod.precio : 0);
        return {
          idProducto: dp.producto_idProducto,
          nombre: prod ? prod.nombre : "Producto no encontrado",
          cantidad: dp.cantidad,
          precioUnitario,
          subtotal: dp.cantidad * precioUnitario,
        };
      });

      const totalCalculado = listaProductos.reduce(
        (acc, item) => acc + item.subtotal,
        0,
      );

      return {
        ...pedido,
        cliente,
        telefono: usuarioPedido ? usuarioPedido.telefono : "N/A",
        productos: listaProductos,
        total: pedido.total || totalCalculado,
      };
    });
}

// Cancela el pedido solo si pertenece al cliente autenticado
export async function cancelarPedidoService(id) {
  const usuario = getUsuarioAutenticado();
  const clienteId = getClienteIdActual();

  if (!usuario || !clienteId) {
    throw new PedidoAccesoError(
      "Debes iniciar sesión para cancelar pedidos.",
      401,
    );
  }

  try {
    const pedido = await obtenerPedidoDetalle(id);

    if (Number(pedido.cliente_idCliente) !== Number(clienteId)) {
      throw new PedidoAccesoError(
        "No tienes permisos para cancelar este pedido.",
        403,
      );
    }

    const res = await API.patch(`/pedidos/${id}`, {
      estado: "Cancelado",
    });
    return res.data;
  } catch (error) {
    if (error instanceof PedidoAccesoError) {
      throw error;
    }

    const status = error?.response?.status;
    if (status === 404) {
      throw new PedidoAccesoError("Pedido no encontrado.", 404);
    }

    if (status === 403) {
      throw new PedidoAccesoError(
        "No tienes permisos para cancelar este pedido.",
        403,
      );
    }

    throw new PedidoAccesoError("No se pudo cancelar el pedido.", 500);
  }
}
