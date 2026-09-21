import { iniciarSesion } from "../../services/auth.js";
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";

export default function Login() {
  const navigate = useNavigate();
  const [credentials, setCredentials] = useState({
    email: "",
    password: "",
  });

  const handleChange = (e) => {
    const { id, value } = e.target;
    setCredentials({
      ...credentials,
      [id]: value,
    });
  };

  const handleLoginSubmit = async (e) => {
    e.preventDefault();
    const { email, password } = credentials;

    if (email.trim() === "" || password.trim() === "") {
      Swal.fire({
        icon: "warning",
        title: "Campos Vacíos",
        text: "Por favor complete los campos",
        confirmButtonColor: "#e5a93c",
      });
      return;
    }

    try {
      const usuario = await iniciarSesion(email, password);

      if (!usuario) {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "Correo o contraseña incorrectos",
          confirmButtonColor: "#e5a93c",
        });
        return;
      }

      localStorage.setItem("usuario", JSON.stringify(usuario));

      await Swal.fire({
        icon: "success",
        title: `¡Bienvenido ${usuario.nombre}!`,
        text: "Has iniciado sesión correctamente.",
        timer: 1500,
        showConfirmButton: false,
      });

      navigate(usuario.rol === "cliente" ? "/productos" : "/admin/usuarios");
    } catch (error) {
      console.error("Error al iniciar sesión:", error);
      Swal.fire({
        icon: "error",
        title: "Error de conexión",
        text: "No se pudo conectar con el servidor (puerto 1511).",
        confirmButtonColor: "#e5a93c",
      });
    }
  };

  return (
    <div className="contenedor">
      <section className="banner">
        <div className="modal-content modal-login p-4">
          <div className="modal-header border-0 pb-0">
            <h2 className="modal-title w-100 text-center">Iniciar Sesión</h2>
          </div>

          <div className="modal-body">
            <form onSubmit={handleLoginSubmit}>
              <div className="mb-3 text-white">
                <label htmlFor="email" className="form-label">
                  Correo Electrónico
                </label>
                <div className="input-group">
                  <span className="input-group-text">
                    <i className="fa-regular fa-envelope"></i>
                  </span>
                  <input
                    type="email"
                    className="form-control"
                    id="email"
                    placeholder="Ingresa tu correo"
                    value={credentials.email}
                    onChange={handleChange}
                    required
                  />
                </div>
              </div>

              <div className="mb-4 text-white">
                <label htmlFor="password" className="form-label">
                  Contraseña
                </label>
                <div className="input-group">
                  <span className="input-group-text">
                    <i className="fa-solid fa-key"></i>
                  </span>
                  <input
                    type="password"
                    className="form-control"
                    id="password"
                    placeholder="Ingresa tu Contraseña"
                    value={credentials.password}
                    onChange={handleChange}
                    autoComplete="actual-password"
                    required
                  />
                </div>
              </div>

              <button
                type="submit"
                className="btn btn-login-ingresar w-100 py-2 mt-2"
              >
                Ingresar
              </button>

              <div className="d-flex justify-content-between mt-4 mb-3">
                <Link to="/recuperacion" className="link-login">
                  ¿Olvidaste tu contraseña?
                </Link>
                <Link to="/registro" className="link-login">
                  Regístrate
                </Link>
              </div>
            </form>
          </div>
        </div>
      </section>
    </div>
  );
}
