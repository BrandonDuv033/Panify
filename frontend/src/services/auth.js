import { obtenerUsuarios } from "./users.js";

const ROLES = {
  2: "domiciliario",
  3: "panadero",
};

export function obtenerUsuarioActual() {
  try {
    const usuario = JSON.parse(localStorage.getItem("usuario"));

    if (usuario?.token?.startsWith("fake-token")) {
      localStorage.removeItem("usuario");
      return null;
    }

    return usuario || null;
  } catch {
    return null;
  }
}

export function obtenerNombreUsuarioActual() {
  const usuario = obtenerUsuarioActual();

  if (!usuario) return "Administrador";

  const nombreCompleto = [usuario.nombre, usuario.apellido]
    .filter(Boolean)
    .join(" ")
    .trim();

  return nombreCompleto || usuario.correo || "Administrador";
}

export async function iniciarSesion(email, password) {
  const usuarios = await obtenerUsuarios();

  const usuario = usuarios.find(
    (u) => u.correo === email && u.contraseña === password,
  );

  if (!usuario) return null;

  // Si su Rol_idRol no está en ROLES, es cliente
  return { ...usuario, rol: ROLES[usuario.Rol_idRol] ?? "cliente" };
}
