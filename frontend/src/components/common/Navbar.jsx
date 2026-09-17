import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import logoPanify from "../../assets/img/Logo Panify.png";

export default function Navbar() {
  const navigate = useNavigate();

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
              <li className="nav-item">
                {/* Coincide con path="/ingresar" de tu AppRouter */}
                <button 
                  className="btn btn-login-nav" 
                  onClick={() => navigate('/ingresar')}
                >
                  <i className="fa-solid fa-right-from-bracket me-2"></i>
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