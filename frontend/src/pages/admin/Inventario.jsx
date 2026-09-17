import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';

// Importa el CSS correspondiente de administración
import '../../assets/css/base/usuarios.css';

const Inventario = () => {
  const navigate = useNavigate();

  // Estado inicial de productos
  const [productos, setProductos] = useState([
    { id: 1, nombre: 'Pan Francés', categoria: 'Pan', precio: 1500, stock: 45, estado: 'Disponible', imagen: '🍞' },
    { id: 2, nombre: 'Croissant', categoria: 'Pastelería', precio: 3000, stock: 6, estado: 'Poco Stock', imagen: '🥐' },
    { id: 3, nombre: 'Pan Integral', categoria: 'Pan', precio: 2500, stock: 0, estado: 'Agotado', imagen: '🍞' },
  ]);

  const [busqueda, setBusqueda] = useState('');
  const [categoriaFiltro, setCategoriaFiltro] = useState('Todas');

  // Filtrado reactivo de productos
  const productosFiltrados = productos.filter((prod) => {
    const coincideBusqueda = prod.nombre.toLowerCase().includes(busqueda.toLowerCase());
    const coincideCategoria = categoriaFiltro === 'Todas' || prod.categoria === categoriaFiltro;
    return coincideBusqueda && coincideCategoria;
  });

  const handleCerrarSesion = (e) => {
    e.preventDefault();
    localStorage.removeItem('usuario');
    navigate('/ingresar');
  };

  const handleAgregar = () => {
    Swal.fire({
      title: 'Agregar Producto',
      text: 'Función para registrar un nuevo producto en desarrollo.',
      icon: 'info',
      confirmButtonColor: '#e5a93c',
    });
  };

  const handleEditar = (nombre) => {
    Swal.fire('Editar Producto', `Modificando el producto: ${nombre}`, 'info');
  };

  const handleEliminar = (nombre) => {
    Swal.fire({
      title: '¿Estás seguro?',
      text: `Se eliminará el producto ${nombre}`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#6c757d',
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire('¡Eliminado!', 'El producto ha sido eliminado.', 'success');
      }
    });
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
          <Link to="/admin">
            <i className="fa-solid fa-users"></i>
            Usuarios
          </Link>

          <Link to="/admin/productos" className="active">
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
            <h1 className="m-0">Productos</h1>
            <p className="m-0 text-muted">Gestión de catálogo e inventario de panadería.</p>
          </div>
          <div className="admin-info d-flex align-items-center gap-2">
            <i className="fa-solid fa-circle-user fs-4"></i>
            <span>Administrador</span>
          </div>
        </header>

        {/* Tarjetas de Resumen */}
        <section className="row g-4 mb-4">
          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-boxes-stacked"></i>
              <div>
                <h3>{productos.length}</h3>
                <p>Productos</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-triangle-exclamation"></i>
              <div>
                <h3>{productos.filter(p => p.stock > 0 && p.stock <= 10).length}</h3>
                <p>Poco Stock</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-circle-xmark"></i>
              <div>
                <h3>{productos.filter(p => p.stock === 0).length}</h3>
                <p>Agotados</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-layer-group"></i>
              <div>
                <h3>3</h3>
                <p>Categorías</p>
              </div>
            </div>
          </div>
        </section>

        {/* Sección Inventario */}
        <section className="panel tabla p-4 bg-white rounded shadow-sm">
          <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div>
              <h2>Inventario de Productos</h2>
              <p className="text-muted m-0">Administra los productos de la panadería.</p>
            </div>
            <button className="btn btn-primary" onClick={handleAgregar}>
              <i className="fa-solid fa-plus me-1"></i> Agregar Producto
            </button>
          </div>

          {/* Filtros y Buscador */}
          <div className="row g-3 mb-4">
            <div className="col-md-6">
              <input
                type="text"
                className="form-control"
                placeholder="Buscar producto..."
                value={busqueda}
                onChange={(e) => setBusqueda(e.target.value)}
              />
            </div>
            <div className="col-md-6">
              <select
                className="form-select"
                value={categoriaFiltro}
                onChange={(e) => setCategoriaFiltro(e.target.value)}
              >
                <option value="Todas">Todas las categorías</option>
                <option value="Pan">Pan</option>
                <option value="Pastelería">Pastelería</option>
              </select>
            </div>
          </div>

          <div className="table-responsive">
            <table className="table table-striped table-hover align-middle" style={{ width: '100%' }}>
              <thead className="table-light">
                <tr>
                  <th>Imagen</th>
                  <th>Producto</th>
                  <th>Categoría</th>
                  <th>Precio</th>
                  <th>Stock</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {productosFiltrados.map((prod) => (
                  <tr key={prod.id}>
                    <td className="fs-4">{prod.imagen}</td>
                    <td>{prod.nombre}</td>
                    <td>{prod.categoria}</td>
                    <td>$ {prod.precio.toLocaleString()}</td>
                    <td>{prod.stock}</td>
                    <td>
                      <span className={`badge ${
                        prod.estado === 'Disponible' ? 'bg-success' : 
                        prod.estado === 'Poco Stock' ? 'bg-warning text-dark' : 'bg-danger'
                      }`}>
                        {prod.estado}
                      </span>
                    </td>
                    <td>
                      <button
                        className="btn btn-sm btn-outline-primary me-2"
                        title="Editar"
                        onClick={() => handleEditar(prod.nombre)}
                      >
                        <i className="fa-solid fa-pen"></i>
                      </button>
                      <button
                        className="btn btn-sm btn-outline-danger"
                        title="Eliminar"
                        onClick={() => handleEliminar(prod.nombre)}
                      >
                        <i className="fa-solid fa-trash"></i>
                      </button>
                    </td>
                  </tr>
                ))}
                {productosFiltrados.length === 0 && (
                  <tr>
                    <td colSpan="7" className="text-center py-4 text-muted">
                      No se encontraron productos registrados.
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

export default Inventario;