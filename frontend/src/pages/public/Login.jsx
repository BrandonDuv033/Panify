import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";
import API from "../../services/api";

const Login = () => {
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

    // 1. Validar credenciales fijas del Administrador (Rol "panadero" según AppRouter)
    if (email === "admin@panify.com" && password === "12345") {
      const datosUsuario = {
        nombre: "Administrador",
        correo: "admin@panify.com",
        rol: "panadero", // Coincide con rolesPermitidos={["panadero", "domiciliario"]}
        Rol_idRol: 3,
        token: "fake-token-admin",
      };
      localStorage.setItem("usuario", JSON.stringify(datosUsuario));

      Swal.fire({
        icon: "success",
        title: "¡Bienvenido Administrador!",
        text: "Redireccionando al Dashboard...",
        timer: 1500,
        showConfirmButton: false,
      }).then(() => {
        navigate("/admin/usuarios"); // Redirige a la vista de usuarios en el dashboard
      });
      return;
    }

    try {
      // 2. Consulta de usuarios desde el json-server en el puerto 1511
      const response = await API.get("/usuarios");
      const usuarios = response.data;

      const usuarioEncontrado = usuarios.find(
        (u) => u.correo === email && u.contraseña === password,
      );

      if (usuarioEncontrado) {
        // Asignamos el texto del rol de acuerdo a su ID (1: cliente, 2: domiciliario, 3: panadero)
        let rolTexto = "cliente";
        if (usuarioEncontrado.Rol_idRol === 3) rolTexto = "panadero";
        if (usuarioEncontrado.Rol_idRol === 2) rolTexto = "domiciliario";

        const usuarioConRol = { ...usuarioEncontrado, rol: rolTexto };
        localStorage.setItem("usuario", JSON.stringify(usuarioConRol));

        Swal.fire({
          icon: "success",
          title: `¡Bienvenido ${usuarioEncontrado.nombre}!`,
          text: "Has iniciado sesión correctamente.",
          timer: 1500,
          showConfirmButton: false,
        }).then(() => {
          // Validar redirección según el rol
          if (
            usuarioEncontrado.Rol_idRol === 3 ||
            usuarioEncontrado.Rol_idRol === 2
          ) {
            navigate("/admin/usuarios"); // Dashboard de administrador
          } else {
            navigate("/productos"); // Vista de cliente (Catálogo)
          }
        });
      } else {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "Correo o contraseña incorrectos",
          confirmButtonColor: "#e5a93c",
        });
      }
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
};

export default Login;
