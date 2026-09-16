import { Navigate, Outlet } from "react-router-dom";

export default function ProtectedRoute({ rolesPermitidos, children }) {
  // 1. Obtener la información del usuario autenticado (desde tu Contexto, Redux o localStorage)
  // Ejemplo ficticio:
  const usuario = JSON.parse(localStorage.getItem("usuario")); // { rol: "cliente", token: "..." }

  // 2. Si el usuario no ha iniciado sesión, redirigir al login
  if (!usuario) {
    return <Navigate to="/ingresar" replace />;
  }

  // 3. Si se especificaron roles y el rol del usuario no está permitido, redirigir al inicio o página no autorizada
  if (rolesPermitidos && !rolesPermitidos.includes(usuario.rol)) {
    return <Navigate to="/" replace />;
  }

  // 4. Si pasa todas las validaciones, renderizar el contenido protegido
  // Si envuelve rutas hijas en el AppRouter usa <Outlet />, si envuelve un componente directamente usa children.
  return children ? children : <Outlet />;
}
