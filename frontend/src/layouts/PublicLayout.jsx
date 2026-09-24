import { Outlet } from "react-router-dom";
import Navbar from "../components/common/Navbar.jsx";
import Footer from "../components/common/Footer.jsx";

export default function PublicLayout() {
  return (
    <div>
      <Navbar />

      <main className="contenido-principal">
        <Outlet />
      </main>

      <Footer />
    </div>
  );
}
