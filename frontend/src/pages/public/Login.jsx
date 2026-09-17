import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';

// Importaciones de estilos
import '../../assets/css/base/index.css';
import '../../assets/css/base/login.css';

const Login = () => {
  const navigate = useNavigate();
  const [credentials, setCredentials] = useState({
    email: '',
    password: '',
  });

  const handleChange = (e) => {
    const { id, value } = e.target;
    setCredentials({
      ...credentials,
      [id]: value,
    });
  };

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    const { email, password } = credentials;

    if (email.trim() === '' || password.trim() === '') {
      Swal.fire({
        icon: 'warning',
        title: 'Campos Vacíos',
        text: 'Por favor complete los campos',
        confirmButtonColor: '#e5a93c',
      });
      return;
    }

    if (email === 'admin@panify.com' && password === '12345') {
      Swal.fire({
        icon: 'success',
        title: '¡Bienvenido!',
        text: 'Redireccionando...',
        timer: 1500,
        showConfirmButton: false,
      }).then(() => {
        navigate('/admin'); 
      });
    } else if (email === 'user@panify.com' && password === '12345') {
      Swal.fire({
        icon: 'success',
        title: '¡Bienvenido!',
        text: 'Redireccionando...',
        timer: 1500,
        showConfirmButton: false,
      }).then(() => {
        navigate('/'); 
      });
    } else {
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Credenciales incorrectas',
      });
    }
  };

  return (
    <div className="contenedor">
      <section className="banner"></section>
      
      <div className="formulario pb-5">
        <div className="modal-content modal-login p-4">
          <div className="modal-header border-0 pb-0">
            <h2 className="modal-title w-100 text-center">Iniciar Sesión</h2>
          </div>
          
          <div className="modal-body">
            <form onSubmit={handleLoginSubmit}>
              
              <div className="mb-3 text-white">
                <label htmlFor="email" className="form-label">Correo Electrónico</label>
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
                <label htmlFor="password" className="form-label">Contraseña</label>
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
                    required
                  />
                </div>
              </div>

              <button type="submit" className="btn btn-login-ingresar w-100 py-2 mt-2">
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
      </div>
    </div>
  );
};

export default Login;