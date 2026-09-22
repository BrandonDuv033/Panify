import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { obtenerUsuarioActual } from "../../services/auth.js";
import logoPanify from "../../assets/img/Logo Panify.png";

export default function Navbar() {
  const navigate = useNavigate();
  const location = useLocation();
  const [usuario, setUsuario] = useState(obtenerUsuarioActual);
  const [menuPerfilAbierto, setMenuPerfilAbierto] = useState(false);

  useEffect(() => {
    setUsuario(obtenerUsuarioActual());
    setMenuPerfilAbierto(false);
  }, [location]);

  useEffect(() => {
    const actualizarUsuario = () => setUsuario(obtenerUsuarioActual());

    window.addEventListener("storage", actualizarUsuario);
    window.addEventListener("usuarioActualizado", actualizarUsuario);

    return () => {
      window.removeEventListener("storage", actualizarUsuario);
      window.removeEventListener("usuarioActualizado", actualizarUsuario);
    };
  }, []);

  const esCliente = usuario?.rol === "cliente";
  const nombreUsuario = usuario?.nombre || "Cliente";
  const iniciales = nombreUsuario.charAt(0).toUpperCase();
  const fotoPerfil = usuario?.fotoPerfil || usuario?.foto || usuario?.avatar;

  const cerrarSesion = () => {
    localStorage.removeItem("usuario");
    setUsuario(null);
    setMenuPerfilAbierto(false);
    navigate("/");
  };

  return (
    <header>
      <nav className="navbar navbar-expand-lg navbar-panify">
        <div className="container">
          <Link
            to="/"
            className="navbar-brand d-flex align-items-center gap-3 ms-3"
          >
            <img src={logoPanify} alt="Logo Panify" className="logo" />
          </Link>
          <button
            className="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#menuPrincipal"
            aria-controls="menuPrincipal"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="collapse navbar-collapse" id="menuPrincipal">
            <ul className="navbar-nav ms-auto align-items-lg-center gap-5">
              <li className="nav-item">
                <Link className="nav-link opcion-menu" to="/">
                  Inicio
                </Link>
              </li>
              <li className="nav-item">
                {/* Coincide con path="/productos" de tu AppRouter */}
                <Link className="nav-link opcion-menu" to="/productos">
                  Productos
                </Link>
              </li>
              <li className="nav-item">
                <a className="nav-link opcion-menu" href="#contacto">
                  Contáctenos
                </a>
              </li>
              {esCliente ? (
                <>
                  <li className="nav-item">
                    <Link
                      to="/productos"
                      className="nav-cart-link"
                      aria-label="Abrir carrito"
                      title="Carrito"
                    >
                      <i className="fa-solid fa-cart-shopping"></i>
                    </Link>
                  </li>
                  <li className="nav-item profile-menu-wrapper">
                    <button
                      className="profile-trigger"
                      type="button"
                      aria-expanded={menuPerfilAbierto}
                      aria-label={`Abrir menú de ${nombreUsuario}`}
                      onClick={() => setMenuPerfilAbierto((abierto) => !abierto)}
                    >
                      <span className="profile-avatar">
                        {fotoPerfil ? (
                          <img src={fotoPerfil} alt="" />
                        ) : (
                          <span>{iniciales}</span>
                        )}
                      </span>
                      <span className="profile-name">{nombreUsuario}</span>
                      <i className="fa-solid fa-chevron-down profile-chevron"></i>
                    </button>

                    {menuPerfilAbierto && (
                      <div className="profile-menu">
                        <div className="profile-menu-heading">
                          <span className="profile-menu-label">Mi cuenta</span>
                          <strong>{nombreUsuario}</strong>
                        </div>
                        <Link to="/mis-pedidos" className="profile-menu-link">
                          <i className="fa-solid fa-box-open"></i>
                          Mis Pedidos
                        </Link>
                        <Link to="/perfil" className="profile-menu-link">
                          <i className="fa-solid fa-user-gear"></i>
                          Perfil
                        </Link>
                        <button className="profile-menu-link profile-logout" onClick={cerrarSesion}>
                          <i className="fa-solid fa-right-from-bracket"></i>
                          Cerrar sesión
                        </button>
                      </div>
                    )}
                  </li>
                </>
              ) : (
                <li className="nav-item">
                  <button
                    className="btn btn-login-nav"
                    onClick={() => navigate("/ingresar")}
                  >
                    <i className="fa-solid fa-right-to-bracket me-2"></i>
                    Ingresar
                  </button>
                </li>
              )}
            </ul>
          </div>
        </div>
      </nav>
    </header>
  );
}