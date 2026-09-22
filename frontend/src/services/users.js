import API from "./api";

function obtenerUsuarioActual() {
  try {
    const usuario = JSON.parse(localStorage.getItem("usuario") || "null");
    return usuario;
  } catch {
    return null;
  }
}

export async function obtenerUsuarios() {
  const res = await API.get("/users");
  return res.data;
}

export async function eliminarUsuario(id) {
  await API.delete(`/users/${id}`);
}

// Obtener la información del perfil privado del usuario logueado
export async function obtenerPerfilUsuario(userId = null) {
  const usuarioLogueado = obtenerUsuarioActual();
  const clienteIdActual = Number(
    userId ?? usuarioLogueado?.cliente_idCliente ?? usuarioLogueado?.idCliente ?? usuarioLogueado?.id ?? 1
  );

  const [usuarios, clientes, pedidos] = await Promise.all([
    API.get(`/usuarios?cliente_idCliente=${clienteIdActual}`),
    API.get("/clientes"),
    API.get(`/pedidos?cliente_idCliente=${clienteIdActual}`),
  ]);

  const usuario = usuarios.data[0] || null;

  if (!usuario) {
    throw new Error("Usuario no encontrado");
  }

  const cliente = clientes.data.find(
    (item) => Number(item.idCliente ?? item.id) === Number(clienteIdActual)
  ) || null;

  const email = usuario.correo || cliente?.email || usuario.email || "";
  const direccion = cliente?.direccion || usuario.direccion || "No registrada";
  const ciudad = cliente?.ciudad || usuario.ciudad || "Soacha";

  const iniciales = `${(usuario.nombre || "U")[0]}${(usuario.apellido || "")[0] || ""}`.toUpperCase();

  return {
    id: clienteIdActual,
    clienteId: clienteIdActual,
    usuarioId: usuario.idUsuario ?? usuario.id,
    nombre: usuario.nombre || "",
    apellido: usuario.apellido || "",
    email,
    telefono: usuario.telefono || cliente?.telefono || "",
    direccion,
    ciudad,
    avatarUrl: usuario.avatarUrl || cliente?.avatarUrl || null,
    iniciales,
    totalPedidosRealizados: pedidos.data ? pedidos.data.length : 0,
  };
}

// Actualizar datos personales del cliente y sincronizarlos con la tabla clientes
export async function actualizarPerfilUsuario(userId, datosActualizados) {
  const [usuarios, clientes] = await Promise.all([
    API.get("/usuarios"),
    API.get("/clientes"),
  ]);

  const usuario = usuarios.data.find(
    (item) =>
      Number(item.cliente_idCliente ?? item.idUsuario ?? item.id) === Number(userId) ||
      Number(item.id) === Number(userId)
  );

  const cliente = clientes.data.find(
    (item) =>
      Number(item.idCliente ?? item.id) === Number(userId) ||
      Number(item.usuario_idUsuario ?? item.idUsuario) === Number(usuario?.idUsuario ?? userId)
  );

  const payloadUsuario = {
    nombre: datosActualizados.nombre,
    apellido: datosActualizados.apellido,
    telefono: datosActualizados.telefono,
    correo: datosActualizados.email,
    email: datosActualizados.email,
  };

  const payloadCliente = {
    email: datosActualizados.email,
    direccion: datosActualizados.direccion,
    ciudad: datosActualizados.ciudad,
    telefono: datosActualizados.telefono,
  };

  const peticiones = [];

  if (usuario) {
    peticiones.push(API.patch(`/usuarios/${usuario.id}`, payloadUsuario));
  }

  if (cliente) {
    peticiones.push(API.patch(`/clientes/${cliente.id}`, payloadCliente));
  }

  if (!usuario && !cliente) {
    throw new Error("No se encontró el usuario o cliente para actualizar");
  }

  const resultados = await Promise.all(peticiones);
  return resultados.at(-1)?.data || null;
}