import Sidebar from "../components/admin/Sidebar.jsx";
import { Outlet } from "react-router-dom";
import "../assets/css/base/usuarios.css";

export default function AdminLayout() {
  return (
    <div className="dashboard-layout">
      <Sidebar />
      <main className="dashboard-main">
        <Outlet />
      </main>
    </div>
  );
}
