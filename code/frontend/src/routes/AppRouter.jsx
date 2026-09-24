import { BrowserRouter, Routes, Route } from "react-router-dom";

import PublicLayout from "../layouts/PublicLayout.jsx";
import AdminLayout from "../layouts/AdminLayout.jsx";
import ProtectedRoute from "../components/common/ProtectedRoute.jsx";

// Públicas
import Home from "../pages/public/Home.jsx";
import Catalogo from "../pages/public/Catalogo.jsx";
import Login from "../pages/public/Login.jsx";
import Registro from "../pages/public/Register.jsx";
import Recuperacion from "../pages/public/Recuperacion.jsx";

// Cliente
import MisPedidos from "../pages/client/Pedidos.jsx";
import PerfilCliente from "../pages/client/Profile.jsx";
import InicioCliente from "../pages/client/Inicio.jsx";
import Contacto  from "../pages/client/Contacto.jsx";



// Admin (Panadero + Domiciliario — Opción A)
import Users from "../pages/admin/Users.jsx";
import Recibos from "../pages/admin/Recibos.jsx";
import Inventario from "../pages/admin/Inventario.jsx";
import Pedidos from "../pages/admin/Pedidos.jsx";

export default function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<PublicLayout />}>
          <Route path="/" element={<Home />} />
          <Route path="/productos" element={<Catalogo />} />
          <Route path="/ingresar" element={<Login />} />
          <Route path="/registro" element={<Registro />} />
          <Route path="/recuperacion" element={<Recuperacion />} />

          <Route
            path="/mis-pedidos"
            element={
              <ProtectedRoute rolesPermitidos={["cliente"]}>
                <MisPedidos />
              </ProtectedRoute>
            }
          />
          <Route
            path="/perfil"
            element={
              <ProtectedRoute rolesPermitidos={["cliente"]}>
                <PerfilCliente />
              </ProtectedRoute>
            }
          />
          <Route
            path="/inicio"
            element={
              <ProtectedRoute rolesPermitidos={["cliente"]}>
                <InicioCliente />
              </ProtectedRoute>
            }
          />
           <Route
            path="/contacto"
            element={
              <ProtectedRoute rolesPermitidos={["cliente"]}>
                <Contacto />
              </ProtectedRoute>
            }
          />
           
       
        </Route>

        

        <Route
          element={
            <ProtectedRoute rolesPermitidos={["panadero", "domiciliario"]}>
              <AdminLayout />
            </ProtectedRoute>
          }
        >
          <Route path="/admin/usuarios" element={<Users />} />
          <Route path="/admin/recibos" element={<Recibos />} />
          <Route path="/admin/inventario" element={<Inventario />} />
          <Route path="/admin/pedidos" element={<Pedidos />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
