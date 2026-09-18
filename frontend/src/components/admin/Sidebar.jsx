import logoPanify from "../../../public/img/icono-panify.png";
import { NavLink } from "react-router-dom";
import "../../assets/css/layout/sidebar.css";

export default function Sidebar() {
  return (
    <aside className="sidebar" id="sidebar">
      <div className="sidebar-logo">
        <img src={logoPanify} alt="Logo" />
        <h2>
          <span className="marca">
            Pani<span className="marca marca-dos">fy</span>
          </span>
        </h2>
        <p>Distribuciones Oro Pan</p>
      </div>

      <nav className="sidebar-menu">
        <NavLink to="/admin/usuarios">
          <i className="fa-solid fa-users"></i>
          Usuarios
        </NavLink>

        <NavLink to="/admin/inventario">
          <i className="fa-solid fa-box"></i>
          Inventario
        </NavLink>

        <NavLink to="/admin/pedidos">
          <i className="fa-solid fa-cart-shopping"></i>
          Pedidos
        </NavLink>

        <NavLink to="/admin/recibos">
          <i className="fa-solid fa-receipt"></i>
          Recibos
        </NavLink>

        <NavLink to="/">
          <i className="fa-solid fa-right-from-bracket"></i>
          Salir
        </NavLink>
      </nav>
    </aside>
  );
}
