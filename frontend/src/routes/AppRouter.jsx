import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";

// Subimos un nivel (../) porque AppRouter está dentro de la carpeta 'routes'
import Login from "../pages/public/Login";
import Dashboard from "../pages/admin/Dashboard";
import Inventario from "../pages/admin/Inventario";
import ProtectedRoute from "../components/common/ProtectedRoute"; // O la ruta correcta donde tengas tu ProtectedRoute

const AppRouter = () => {
  return (
    <BrowserRouter>
      <Routes>
        {/* Rutas Públicas */}
        <Route path="/ingresar" element={<Login />} />
        
        {/* Rutas Protegidas de Administrador */}
        <Route
          element={
            <ProtectedRoute rolesPermitidos={["panadero"]}>
              {/* Aquí puedes envolverlo con tu AdminLayout si lo usas */}
            </ProtectedRoute>
          }
        >
          <Route path="/admin" element={<Dashboard />} />
          <Route path="/admin/productos" element={<Inventario />} />
        </Route>

        {/* Ruta por defecto */}
        <Route path="*" element={<Login />} />
      </Routes>
    </BrowserRouter>
  );
};

export default AppRouter;