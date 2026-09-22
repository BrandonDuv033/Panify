import API from "./api.js";

const ROLES = {
  2: "domiciliario",
  3: "panadero",
};

export function obtenerUsuarioActual() {
  try {
    const usuario = JSON.parse(localStorage.getItem("usuario"));

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
  let respuesta;

  try {
    respuesta = await API.post("/login", { email, password });
  } catch (error) {
    if (error.response?.status === 400) return null;
    throw error;
  }

  const usuario = respuesta.data.user;

  // Si su Rol_idRol no está en ROLES, es cliente
  return {
    ...usuario,
    correo: usuario.correo || usuario.email,
    rol: ROLES[usuario.Rol_idRol] ?? "cliente",
    token: respuesta.data.accessToken,
  };
}

export async function recuperarPassword(correo) {
  
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({ mensaje: "Enlace de recuperación enviado (simulado)." });
    }, 800); 
  });
}