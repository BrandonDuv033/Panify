import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";
import { recuperarPassword } from "../../services/auth.js";

export default function Recuperacion() {
  const navigate = useNavigate();
  const [correo, setCorreo] = useState("");

  const handleChange = (e) => {
    setCorreo(e.target.value);
  };

  const handleRecuperarSubmit = async (e) => {
    e.preventDefault();

    if (correo.trim() === "") {
      Swal.fire({
        icon: "error",
        title: "Campo vacío",
        text: "Ingrese su correo electrónico.",
        confirmButtonColor: "#e5a93c",
      });
      return;
    }

    try {
      // Ajusta esta llamada según cómo esté implementado tu servicio de auth
      await recuperarPassword(correo);

      await Swal.fire({
        icon: "success",
        title: "Correo enviado",
        text: "Revisa tu correo para recuperar la contraseña.",
      });

      navigate("/");
    } catch (error) {
      console.error("Error al recuperar contraseña:", error);
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
        <div className="modal-content modal-registro p-4">
          <div className="text-center mb-4">
            <h2 className="text-white">
              <i className="bi bi-shield-lock-fill me-2"></i>Recuperar Contraseña
            </h2>
            <p className="texto-recuperar">
              No te preocupes, todos olvidamos cosas.
              <br />
              Ingresa tu correo electrónico y te enviaremos
              <br />
              un enlace para restablecer tu contraseña.
            </p>
          </div>

          <form onSubmit={handleRecuperarSubmit}>
            <div className="mb-3">
              <label htmlFor="correo" className="form-label">
                Correo Electrónico
              </label>
              <div className="input-group">
                <span className="input-group-text">
                  <i className="bi bi-envelope-fill"></i>
                </span>
                <input
                  type="email"
                  className="form-control"
                  id="correo"
                  placeholder="Correo usuario"
                  value={correo}
                  onChange={handleChange}
                  required
                />
              </div>
            </div>

            <button
              type="submit"
              className="btn btn-login-ingresar w-100 mb-3"
              id="recuperar"
            >
              Enviar enlace de recuperación
            </button>

            <div className="d-flex justify-content-between mt-3">
              <Link to="/" className="link-login">
                <i className="fa-solid fa-house me-2"></i>Volver al inicio
              </Link>
            </div>
          </form>
        </div>
      </section>
    </div>
  );
}