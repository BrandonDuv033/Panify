import "../../assets/css/layout/navbar.css";
import logoPanify from "../../assets/img/Logo Panify.png";

export default function Navbar() {
  return (
    <header>
      <nav className="navbar navbar-expand-lg navbar-panify">
        <div className="container">
          <a
            href=""
            className="navbar-brand d-flex align-items-center gap-3 ms-3"
          >
            <img src={logoPanify} alt="Logo Panify" className="logo" />
          </a>
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
                <a className="nav-link opcion-menu" href="#">
                  Inicio
                </a>
              </li>
              <li className="nav-item">
                <a className="nav-link opcion-menu" href="/productos">
                  Productos
                </a>
              </li>
              <li className="nav-item">
                <a className="nav-link opcion-menu" href="/contacto">
                  Contáctenos
                </a>
              </li>
              <li className="nav-item">
                <button
                  className="btn btn-login-nav"
                  data-bs-toggle="modal"
                  data-bs-target="#loginModal"
                >
                  <i className="fa-solid fa-right-from-bracket me-1"></i>
                  Ingresar
                </button>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>
  );
}
