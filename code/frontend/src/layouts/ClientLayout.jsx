import { Outlet } from "react-router-dom";
import Navbar from "../components/common/Navbar.jsx";
import Footer from "../components/common/Footer.jsx";

export default function ClientLayout() {
  return (
    <div className="dashboard-layout client-layout">
      <Navbar/>
      <main className="dashboard-main client">
        <Outlet />
      </main>
      <Footer/>
    </div>
  );
}
