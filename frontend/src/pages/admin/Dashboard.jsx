import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';

// Importación de estilos del admin
import '../../assets/css/base/usuarios.css';

const Dashboard = () => {
  const navigate = useNavigate();
  
  // Lista inicial de usuarios
  const [usuarios] = useState([
    { id: 101, nombre: 'Martin Diaz', correo: 'juan@gmail.com', rol: 'Cliente' },
    { id: 102, nombre: 'Brandon Devia', correo: 'maria.camila@gmail.com', rol: 'Administrador' },
    { id: 103, nombre: 'Jeison Guevara', correo: 'jeison.guevara@hotmail.com', rol: 'Cliente' },
    { id: 104, nombre: 'Sofia Diaz', correo: 'sofia.diaz@outlook.com', rol: 'Cliente' },
    { id: 105, nombre: 'Juan Vazques', correo: 'juan.vazques@gmail.com', rol: 'Cliente' },
    { id: 106, nombre: 'Maria Juana', correo: 'laura.juanita@gmail.com', rol: 'Cliente' },
    { id: 107, nombre: 'Santiago Ortiz', correo: 'santiago.ortiz@yahoo.com', rol: 'Cliente' },
    { id: 108, nombre: 'Pedro Lopez', correo: 'legend.pedro@gmail.com', rol: 'Administrador' },
    { id: 109, nombre: 'Mateo Chavez', correo: 'mateo.chavez@hotmail.com', rol: 'Cliente' },
    { id: 110, nombre: 'Paula Salas', correo: 'paula.salas@outlook.com', rol: 'Cliente' },
  ]);

  const [busqueda, setBusqueda] = useState('');

  // Filtrado reactivo de usuarios por nombre o correo
  const usuariosFiltrados = usuarios.filter((user) => 
    user.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
    user.correo.toLowerCase().includes(busqueda.toLowerCase())
  );

  const handleEditar = (nombre) => {
    Swal.fire('Editar Usuario', `Abriendo panel de edición para ${nombre}`, 'info');
  };

  const handleEliminar = (nombre) => {
    Swal.fire({
      title: '¿Estás seguro?',
      text: `Se eliminará al usuario ${nombre}`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire('Eliminado!', 'El usuario ha sido eliminado.', 'success');
      }
    });
  };

  const handleCerrarSesion = (e) => {
    e.preventDefault();
    localStorage.removeItem('usuario'); // Limpia la sesión
    navigate('/ingresar'); // Redirige al login
  };

  return (
    <div className="dashboard-layout">
      {/* SIDEBAR */}
      <aside className="sidebar" id="sidebar">
        <div className="sidebar-logo">
          <img src="../src/img/icono-panify.png" alt="Logo" onError={(e) => { e.target.style.display = 'none'; }} />
          <h2>
            <span className="marca">Pani<span className="marca marca-dos">fy</span></span>
          </h2>
          <p>Distribuciones Oro Pan</p>
        </div>
        <nav className="sidebar-menu">
          <Link to="/admin" className="active">
            <i className="fa-solid fa-users"></i>
            Usuarios
          </Link>

          <Link to="/admin/productos">
            <i className="fa-solid fa-box"></i>
            Productos
          </Link>

          <Link to="/admin/pedidos">
            <i className="fa-solid fa-cart-shopping"></i>
            Pedidos
          </Link>

          <Link to="/admin/recibos">
            <i className="fa-solid fa-receipt"></i>
            Recibos
          </Link>

          <a href="#salir" onClick={handleCerrarSesion}>
            <i className="fa-solid fa-right-from-bracket"></i>
            Salir
          </a>
        </nav>
      </aside>

      {/* CONTENIDO PRINCIPAL */}
      <main className="dashboard-main">
        <header className="topbar d-flex justify-content-between align-items-center mb-4">
          <div>
            <h1 className="m-0">Dashboard</h1>
            <p className="m-0 text-muted">Bienvenido al panel administrativo de Panify.</p>
          </div>

          <div className="admin-info d-flex align-items-center gap-2">
            <i className="fa-solid fa-circle-user fs-4"></i>
            <span>Administrador</span>
          </div>
        </header>

        {/* Tarjetas de Resumen */}
        <section className="row g-4 mb-4">
          <div className="col-lg-4 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-users"></i>
              <div>
                <h3>50</h3>
                <p>Usuarios registrados</p>
              </div>
            </div>
          </div>

          <div className="col-lg-4 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-box"></i>
              <div>
                <h3>15</h3>
                <p>Productos activos</p>
              </div>
            </div>
          </div>

          <div className="col-lg-4 col-md-12">
            <div className="card-resumen">
              <i className="fa-solid fa-cart-shopping"></i>
              <div>
                <h3>8</h3>
                <p>Ventas del día</p>
              </div>
            </div>
          </div>
        </section>

        {/* Tabla de Usuarios */}
        <section className="panel tabla p-4 bg-white rounded shadow-sm">
          <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div>
              <h2>Gestión de Usuarios</h2>
              <p className="text-muted m-0">Administra los usuarios registrados en la plataforma.</p>
            </div>
            {/* Barra de búsqueda integrada */}
            <div style={{ width: '250px' }}>
              <input
                type="text"
                className="form-control"
                placeholder="Buscar usuario..."
                value={busqueda}
                onChange={(e) => setBusqueda(e.target.value)}
              />
            </div>
          </div>

          <div className="table-responsive">
            <table className="table table-striped table-hover align-middle" style={{ width: '100%' }}>
              <thead className="table-light">
                <tr>
                  <th>ID</th>
                  <th>Nombre</th>
                  <th>Correo</th>
                  <th>Rol</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {usuariosFiltrados.map((user) => (
                  <tr key={user.id}>
                    <td>{user.id}</td>
                    <td>{user.nombre}</td>
                    <td>{user.correo}</td>
                    <td>
                      <span className={`badge ${user.rol === 'Administrador' ? 'bg-primary' : 'bg-secondary'}`}>
                        {user.rol}
                      </span>
                    </td>
                    <td>
                      <button
                        className="btn btn-sm btn-outline-primary me-2"
                        title="Editar usuario"
                        onClick={() => handleEditar(user.nombre)}
                      >
                        <i className="fa-solid fa-pen me-1"></i> Editar
                      </button>
                      <button
                        className="btn btn-sm btn-outline-danger"
                        title="Eliminar usuario"
                        onClick={() => handleEliminar(user.nombre)}
                      >
                        <i className="fa-solid fa-trash me-1"></i> Eliminar
                      </button>
                    </td>
                  </tr>
                ))}
                {usuariosFiltrados.length === 0 && (
                  <tr>
                    <td colSpan="5" className="text-center py-4 text-muted">
                      No se encontraron usuarios coincidentes.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>
  );
};

export default Dashboard;