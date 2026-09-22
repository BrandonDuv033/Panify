import API from "./api";

export async function obtenerUsuarios() {
  const res = await API.get("/users");
  return res.data;
}

export async function eliminarUsuario(id) {
  await API.delete(`/users/${id}`);
}
