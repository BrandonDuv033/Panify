import { Outlet } from "react-router-dom";
import Sidebar from "../components/admin/Sidebar.jsx";

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
