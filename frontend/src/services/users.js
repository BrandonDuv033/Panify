import API from "./api";

export async function obtenerUsuarios() {
  const res = await API.get("/usuarios");
  return res.data;
}

export async function eliminarUsuario(id) {
  await API.delete(`/usuarios/${id}`);
}
