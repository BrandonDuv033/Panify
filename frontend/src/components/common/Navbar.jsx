import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { obtenerUsuarioActual } from "../../services/auth.js";
import { formatearMoneda } from "../../utils/formatearMoneda.js";
import logoPanify from "../../assets/img/Logo Panify.png";

function obtenerCarritoGuardado() {
  try {
    const carrito = JSON.parse(localStorage.getItem("carrito"));
    return Array.isArray(carrito) ? carrito : [];
  } catch (error) {
    console.error("Error al cargar el carrito:", error);
    return [];
  }
}

export default function Navbar() {
  const navigate = useNavigate();
  const location = useLocation();
  const [usuario, setUsuario] = useState(obtenerUsuarioActual);
  const [menuPerfilAbierto, setMenuPerfilAbierto] = useState(false);
  const [menuMovilAbierto, setMenuMovilAbierto] = useState(false);
  const [carrito, setCarrito] = useState(obtenerCarritoGuardado);
  const [carritoAbierto, setCarritoAbierto] = useState(false);

  useEffect(() => {
    setUsuario(obtenerUsuarioActual());
    setMenuPerfilAbierto(false);
    setMenuMovilAbierto(false);
    setCarritoAbierto(false);
  }, [location]);

  useEffect(() => {
    const actualizarUsuario = () => setUsuario(obtenerUsuarioActual());
    const actualizarCarrito = () => setCarrito(obtenerCarritoGuardado());

    window.addEventListener("storage", actualizarUsuario);
    window.addEventListener("usuarioActualizado", actualizarUsuario);
    window.addEventListener("storage", actualizarCarrito);
    window.addEventListener("carritoActualizado", actualizarCarrito);

    return () => {
      window.removeEventListener("storage", actualizarUsuario);
      window.removeEventListener("usuarioActualizado", actualizarUsuario);
      window.removeEventListener("storage", actualizarCarrito);
      window.removeEventListener("carritoActualizado", actualizarCarrito);
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
    setMenuMovilAbierto(false);
    navigate("/");
  };

  const cerrarMenuMovil = () => setMenuMovilAbierto(false);
  const totalProductos = carrito.reduce(
    (total, item) => total + item.cantidad,
    0,
  );
  const subtotal = carrito.reduce(
    (total, item) => total + item.precio * item.cantidad,
    0,
  );

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
            aria-controls="menuPrincipal"
            aria-expanded={menuMovilAbierto}
            aria-label="Toggle navigation"
            onClick={() => setMenuMovilAbierto((abierto) => !abierto)}
          >
            <span className="navbar-toggler-icon"></span>
          </button>
          <div
            className={`collapse navbar-collapse ${
              menuMovilAbierto ? "show" : ""
            }`}
            id="menuPrincipal"
          >
            <ul className="navbar-nav ms-auto align-items-lg-center gap-5">
              <li className="nav-item">
                <Link
                  className="nav-link opcion-menu"
                  to={esCliente ? "/cliente/inicio" : "/"}
                  onClick={cerrarMenuMovil}
                >
                  Inicio
                </Link>
              </li>
              <li className="nav-item">
                {/* Coincide con path="/productos" de tu AppRouter */}
                <Link
                  className="nav-link opcion-menu"
                  to="/productos"
                  onClick={cerrarMenuMovil}
                >
                  Productos
                </Link>
              </li>
              <li className="nav-item">
                <a
                  className="nav-link opcion-menu"
                  href="/contacto"
                  onClick={cerrarMenuMovil}
                >
                  Contáctenos
                </a>
              </li>
              {esCliente ? (
                <>
                  <li className="nav-item">
                    <button
                      type="button"
                      className="nav-cart-link"
                      aria-label="Abrir carrito"
                      title="Carrito"
                      onClick={() => {
                        cerrarMenuMovil();
                        setCarritoAbierto(true);
                      }}
                    >
                      <i className="fa-solid fa-cart-shopping"></i>
                      {totalProductos > 0 && (
                        <span className="nav-cart-count">{totalProductos}</span>
                      )}
                    </button>
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
                        <Link
                          to="/cliente/pedidos"
                          className="profile-menu-link"
                          onClick={cerrarMenuMovil}
                        >
                          <i className="fa-solid fa-box-open"></i>
                          Mis Pedidos
                        </Link>
                        <Link
                          to="/cliente/perfil"
                          className="profile-menu-link"
                          onClick={cerrarMenuMovil}
                        >
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
                    onClick={() => {
                      cerrarMenuMovil();
                      navigate("/ingresar");
                    }}
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
      {esCliente && carritoAbierto && (
        <>
          <button
            type="button"
            className="cart-sidebar-backdrop"
            aria-label="Cerrar carrito"
            onClick={() => setCarritoAbierto(false)}
          />
          <aside className="cart-sidebar" aria-label="Carrito de compras">
            <div className="cart-sidebar-header">
              <div>
                <span className="cart-sidebar-eyebrow">Tu compra</span>
                <h2>Carrito</h2>
              </div>
              <button
                type="button"
                className="cart-sidebar-close"
                aria-label="Cerrar carrito"
                onClick={() => setCarritoAbierto(false)}
              >
                <i className="fa-solid fa-xmark"></i>
              </button>
            </div>

            <div className="cart-sidebar-body">
              {carrito.length === 0 ? (
                <p className="cart-sidebar-empty">Tu carrito está vacío.</p>
              ) : (
                carrito.map((item) => (
                  <div className="cart-sidebar-item" key={item.id}>
                    <div>
                      <h3>{item.nombre}</h3>
                      <span>
                        {item.cantidad} x {formatearMoneda(item.precio)}
                      </span>
                    </div>
                    <strong>
                      {formatearMoneda(item.precio * item.cantidad)}
                    </strong>
                  </div>
                ))
              )}
            </div>

            <div className="cart-sidebar-footer">
              <div className="cart-sidebar-total">
                <span>Total estimado</span>
                <strong>{formatearMoneda(subtotal)}</strong>
              </div>
              <Link
                to="/productos"
                className="btn btn-finalizar w-100"
                onClick={() => setCarritoAbierto(false)}
              >
                Ver productos
              </Link>
            </div>
          </aside>
        </>
      )}
    </header>
  );
}