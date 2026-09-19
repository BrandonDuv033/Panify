import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";
import API from "../../services/api";

// Importaciones de CSS y assets
import "../../assets/css/pages/register.css";

const Register = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    nombre: "",
    direccion: "",
    email: "",
    password: "",
  });

  const handleChange = (e) => {
    const { id, value } = e.target;
    setFormData({
      ...formData,
      [id]: value,
    });
  };

  const handleRegistroSubmit = async (e) => {
    e.preventDefault();
    const { nombre, direccion, email, password } = formData;

    if (
      nombre.trim() === "" ||
      direccion.trim() === "" ||
      email.trim() === "" ||
      password.trim() === ""
    ) {
      Swal.fire({
        icon: "warning",
        title: "Completa todos los campos",
        confirmButtonColor: "#e5a93c",
      });
      return;
    }

    try {
      // 1. Opcional: Si quieres registrar la dirección en la tabla "clientes" primero o registrar el usuario directamente.
      // Basado en tu db.json, creamos la estructura del usuario vinculada al rol de Cliente (Rol_idRol: 1)
      const nuevoUsuario = {
        nombre: nombre,
        apellido: "", // Si no lo pides en el form, lo dejamos vacío o lo puedes separar
        correo: email,
        contraseña: password, // En producción se cifraría, aquí queda plano para que el login lo valide tal como lo tienes
        telefono: "3000000000", // Valor por defecto o puedes agregarlo al form si deseas
        estado: "Activo",
        Rol_idRol: 1, // 1: Cliente
        cliente_idCliente: 2, // ID simulado o el que corresponda
        panadero_idPanadero: null,
        domiciliario_idDomiciliario: null,
      };

      // Petición POST al backend (json-server en puerto 1511)
      await API.post("/usuarios", nuevoUsuario);

      Swal.fire({
        icon: "success",
        title: "¡Registro exitoso!",
        text: "Ya puedes iniciar sesión con tus credenciales.",
        confirmButtonColor: "#e5a93c",
      }).then(() => {
        navigate("/ingresar"); // Redirige al login para iniciar sesión con este usuario
      });
    } catch (error) {
      console.error("Error al registrar el usuario:", error);
      Swal.fire({
        icon: "error",
        title: "Error en el servidor",
        text: "No se pudo completar el registro. Inténtalo de nuevo.",
        confirmButtonColor: "#e5a93c",
      });
    }
  };

  return (
    <>
      <section className="banner-register">
            <div className="modal-content modal-registro">
              <div className="modal-header border-0">
                <h2 className="modal-title w-100 text-center text-white">
                  Registro
                </h2>
              </div>
              <div className="modal-body">
                <form id="formRegistro" onSubmit={handleRegistroSubmit}>
                  <div className="mb-3">
                    <label htmlFor="nombre" className="form-label">
                      Nombre
                    </label>
                    <input
                      type="text"
                      className="form-control"
                      id="nombre"
                      placeholder="Ingresa tu nombre"
                      value={formData.nombre}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <div className="mb-3">
                    <label htmlFor="direccion" className="form-label">
                      Dirección
                    </label>
                    <input
                      type="text"
                      className="form-control"
                      id="direccion"
                      placeholder="Ingresa tu dirección"
                      value={formData.direccion}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <div className="mb-3">
                    <label htmlFor="email" className="form-label">
                      Correo
                    </label>
                    <input
                      type="email"
                      className="form-control"
                      id="email"
                      placeholder="Dirección de correo"
                      value={formData.email}
                      onChange={handleChange}
                      autoComplete="email"
                      required
                    />
                  </div>
                  <div className="mb-4">
                    <label htmlFor="password" className="form-label">
                      Crea una contraseña
                    </label>
                    <input
                      type="password"
                      className="form-control"
                      id="password"
                      placeholder="Ingresa tu Contraseña"
                      value={formData.password}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <button
                    type="submit"
                    className="btn btn-login-ingresar w-100 mb-3"
                  >
                    Regístrate
                  </button>
                  <div className="d-flex justify-content-between mt-3">
                    <Link to="/" className="link-login">
                      <i className="fa-solid fa-house me-2"></i>Volver al inicio
                    </Link>
                  </div>
                </form>
              </div>
            </div>
      </section>
    </>
  );
};

export default Register;
