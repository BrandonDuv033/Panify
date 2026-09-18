import React, { useState } from 'react';

import { Link, useNavigate } from 'react-router-dom';

import Swal from 'sweetalert2';

// Importa tus componentes comunes ya creados

import Navbar from '../../components/common/Navbar';

import Footer from '../../components/common/Footer';

// Importaciones de CSS y assets

import '../../assets/css/base/register.css'

import logoPanify from '../../assets/img/Logo Panify.png'; 

const Register = () => {

  const navigate = useNavigate();

  const [formData, setFormData] = useState({

    nombre: '',

    direccion: '',

    email: '',

    password: '',

  });

  const handleChange = (e) => {

    const { id, value } = e.target;

    setFormData({

      ...formData,

      [id]: value,

    });

  };

  const handleRegistroSubmit = (e) => {

    e.preventDefault();

    const { nombre, direccion, email, password } = formData;

    if (

      nombre.trim() === '' ||

      direccion.trim() === '' ||

      email.trim() === '' ||

      password.trim() === ''

    ) {

      Swal.fire({

        icon: 'warning',

        title: 'Completa todos los campos',

      });

    } else {

      Swal.fire({

        icon: 'success',

        title: 'Registro exitoso',

      }).then(() => {

        navigate('/'); 

      });

    }

  };

  return (

    <>

      <Navbar />

      <div className="contenedor">

        <section className="banner"></section>

        <div className="formulario">

          <div className="modal-content modal-registro">

            <div className="modal-header border-0">

              <h2 className="modal-title w-100 text-center text-white">Registro</h2>

            </div>

            <div className="modal-body">

              <form id="formRegistro" onSubmit={handleRegistroSubmit}>

                <div className="mb-3">

                  <label htmlFor="nombre" className="form-label">Nombre</label>

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

                  <label htmlFor="direccion" className="form-label">Dirección</label>

                  <input

                    type="text"

                    className="form-control"

                    id="direccion"

                    minLength="10"

                    maxLength="60"

                    placeholder="Ingresa tu dirección"

                    value={formData.direccion}

                    onChange={handleChange}

                    required

                  />

                </div>

                <div className="mb-3">

                  <label htmlFor="email" className="form-label">Correo</label>

                  <input

                    type="email"

                    className="form-control"

                    id="email"

                    placeholder="Dirección de correo"

                    minLength="20"

                    maxLength="80"

                    value={formData.email}

                    onChange={handleChange}

                    required

                  />

                </div>

                <div className="mb-4">

                  <label htmlFor="password" className="form-label">Crea una contraseña</label>

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

                <button type="submit" className="btn btn-login-ingresar w-100 mb-3">

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

        </div>

      </div>

      <Footer />

    </>

  );

};

export default Register;