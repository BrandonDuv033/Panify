import React, { useState, useEffect } from 'react';

const injectDependencies = () => {
  if (!document.getElementById('bootstrap-css')) {
    const bootstrapLink = document.createElement('link');
    bootstrapLink.id = 'bootstrap-css';
    bootstrapLink.rel = 'stylesheet';
    bootstrapLink.href = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css';
    document.head.appendChild(bootstrapLink);
  }
  if (!document.getElementById('fontawesome-js')) {
    const faScript = document.createElement('script');
    faScript.id = 'fontawesome-js';
    faScript.src = 'https://kit.fontawesome.com/a0994db117.js';
    faScript.crossOrigin = 'anonymous';
    document.head.appendChild(faScript);
  }
};

const customStyles = `
  :root {
    --color-principal: #8b5a2b;
    --color-secundario: #d4af37;
    --color-dorado: #e5a93c;
    --color-oscuro: #2b1e13;
    --color-claro: #3d2b1f;
    --color-blanco: #ffffff;
    --color-crema: #f5ebe0;
    --fuente-principal: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
  }
  
  body {
    background-color: var(--color-crema);
    margin: 0;
    font-family: var(--fuente-principal);
    color: var(--color-oscuro);
  }
  
  .dashboard-layout {
    display: flex;
    min-height: 100vh;
    overflow-x: hidden;
  }
  
  /* Estilos del Menú Lateral */
  .sidebar {
    width: 260px;
    background-color: var(--color-claro);
    color: var(--color-blanco);
    flex-shrink: 0;
    transition: transform 0.3s ease;
    z-index: 1040;
    display: flex;
    flex-direction: column;
  }
  
  .sidebar-logo {
    padding: 20px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.05);
  }
  
  .sidebar-logo h2 {
    margin: 10px 0 0;
    font-size: 1.5rem;
    font-weight: bold;
  }
  
  .marca { color: var(--color-blanco); }
  .marca-dos { color: var(--color-dorado); }
  
  .sidebar-logo p {
    margin: 0;
    font-size: 0.85rem;
    color: #a39171;
  }
  
  .sidebar-menu {
    display: flex;
    flex-direction: column;
    padding: 15px 0;
  }
  
  .sidebar-menu a {
    color: var(--color-blanco);
    text-decoration: none;
    padding: 12px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    transition: all 0.2s;
  }
  
  .sidebar-menu a:hover {
    background-color: rgba(255, 255, 255, 0.05);
    color: var(--color-secundario);
  }
  
  .sidebar-menu a.active {
    background-color: var(--color-principal);
    color: var(--color-dorado);
    border-left: 4px solid var(--color-dorado);
  }
  
  /* Área Principal */
  .dashboard-main {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    width: 100%;
  }
  
  .topbar {
    background-color: var(--color-oscuro);
    color: var(--color-blanco);
    padding: 15px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .topbar h1 { margin: 0; font-size: 1.25rem; font-weight: bold; }
  .topbar p { margin: 0; color: #a39171; font-size: 0.9rem; }
  
  .mobile-toggle-btn {
    display: none;
    background: none;
    border: none;
    font-size: 1.5rem;
    color: var(--color-blanco);
    cursor: pointer;
  }
  
  .admin-info {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 500;
  }
  
  .admin-info i { font-size: 1.5rem; color: var(--color-dorado); }
  
  /* Tarjetas de Resumen */
  .card-resumen {
    background: var(--color-blanco);
    border-radius: 8px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 20px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    border: 1px solid rgba(139, 90, 43, 0.1);
  }
  
  .card-resumen i {
    font-size: 2.5rem;
    color: var(--color-principal);
  }
  
  .card-resumen h3 { margin: 0; font-size: 1.8rem; font-weight: bold; color: var(--color-principal); }
  .card-resumen p { margin: 0; color: var(--color-oscuro); opacity: 0.8; }
  
  /* Paneles y Tablas */
  .panel { 
    background-color: var(--color-blanco); 
    border-radius: 8px; 
    box-shadow: 0 4px 6px rgba(0,0,0,0.05); 
    border: 1px solid rgba(139, 90, 43, 0.1);
  }
  
  .table-custom-header {
    --bs-table-bg: var(--color-principal);
    --bs-table-color: var(--color-blanco);
  }
  
  /* Botones Personalizados */
  .btn-custom-edit {
    background-color: var(--color-secundario);
    color: var(--color-oscuro);
    border: none;
    font-weight: 500;
  }
  .btn-custom-edit:hover {
    background-color: var(--color-dorado);
    color: var(--color-oscuro);
  }
  
  .btn-custom-delete {
    background-color: #8b3a3a; /* Un rojo oscuro que pega con la paleta */
    color: var(--color-blanco);
    border: none;
    font-weight: 500;
  }
  .btn-custom-delete:hover {
    background-color: #6b2a2a;
    color: var(--color-blanco);
  }
  
  /* Sistema Toast Custom */
  .custom-toast-container {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 1060;
  }
  
  .custom-toast {
    background-color: var(--color-oscuro);
    color: var(--color-secundario);
    border-left: 4px solid var(--color-dorado);
  }

  @media (max-width: 768px) {
    .sidebar {
      position: fixed;
      height: 100vh;
      transform: translateX(-100%);
    }
    .sidebar.open { transform: translateX(0); }
    .mobile-toggle-btn { display: block; }
    .topbar { padding: 15px; }
  }
`;

const initialUsers = [
  { id: 101, name: 'Martin Diaz', email: 'juan@gmail.com', role: 'Cliente' },
  { id: 102, name: 'Brandon Devia', email: 'maria.camila@gmail.com', role: 'Administrador' },
  { id: 103, name: 'Jeison Guevara', email: 'jeison.guevara@hotmail.com', role: 'Cliente' },
  { id: 104, name: 'Sofia Diaz', email: 'sofia.diaz@outlook.com', role: 'Cliente' },
  { id: 105, name: 'Juan Vazques', email: 'juan.vazques@gmail.com', role: 'Cliente' },
  { id: 106, name: 'Maria Juana', email: 'laura.juanita@gmail.com', role: 'Cliente' },
  { id: 107, name: 'Santiago Ortiz', email: 'santiago.ortiz@yahoo.com', role: 'Cliente' },
  { id: 108, name: 'Pedro Lopez', email: 'legend.pedro@gmail.com', role: 'Administrador' },
  { id: 109, name: 'Mateo Chavez', email: 'mateo.chavez@hotmail.com', role: 'Cliente' },
  { id: 110, name: 'Paula Salas', email: 'paula.salas@outlook.com', role: 'Cliente' },
];

export default function App() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [users, setUsers] = useState(initialUsers);
  const [toastMsg, setToastMsg] = useState(null);

  useEffect(() => {
    injectDependencies();
  }, []);

  const toggleSidebar = () => setIsSidebarOpen(!isSidebarOpen);

  const showNotification = (msg) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 3000);
  };

  const handleEdit = (user) => {
    showNotification(`Editando al usuario: ${user.name}`);
  };

  const handleDelete = (id, name) => {
    setUsers(users.filter(u => u.id !== id));
    showNotification(`Usuario ${name} eliminado correctamente.`);
  };

  return (
    <>
      <style>{customStyles}</style>

      {}
      {isSidebarOpen && (
        <div
          onClick={toggleSidebar}
          style={{
            position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
            background: 'rgba(43, 30, 19, 0.7)', zIndex: 1030
          }}
        ></div>
      )}

      <div className="dashboard-layout">
        <aside className={`sidebar ${isSidebarOpen ? 'open' : ''}`}>
          <div className="sidebar-logo">
            <h2><span className="marca">Pani<span className="marca-dos">fy</span></span></h2>
            <p>Distribuciones Oro Pan</p>
          </div>
          <nav className="sidebar-menu">
            <a href="#" className="active"><i className="fa-solid fa-users"></i> Usuarios</a>
            <a href="#"><i className="fa-solid fa-box"></i> Productos</a>
            <a href="#"><i className="fa-solid fa-cart-shopping"></i> Pedidos</a>
            <a href="#"><i className="fa-solid fa-receipt"></i> Recibos</a>
            <a href="#"><i className="fa-solid fa-right-from-bracket"></i> Salir</a>
          </nav>
        </aside>

        {}
        <main className="dashboard-main">
          <header className="topbar">
            <div className="d-flex align-items-center gap-3">
              <button className="mobile-toggle-btn" onClick={toggleSidebar}>
                <i className="fa-solid fa-bars"></i>
              </button>
              <div>
                <h1>Dashboard</h1>
                <p className="d-none d-sm-block">Bienvenido al panel administrativo de Panify.</p>
              </div>
            </div>
            <div className="admin-info">
              <span className="d-none d-sm-inline">Administrador</span>
              <i className="fa-solid fa-circle-user"></i>
            </div>
          </header>

          <div className="p-4">
            <section className="row g-4 mb-4">
              <div className="col-lg-4 col-md-6">
                <div className="card-resumen">
                  <i className="fa-solid fa-users"></i>
                  <div>
                    <h3>{users.length}</h3>
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

            {}
            <section className="panel p-4">
              <div className="mb-4">
                <h2 style={{color: 'var(--color-principal)'}}>Gestión de Usuarios</h2>
                <p style={{color: 'var(--color-oscuro)', opacity: 0.8}}>Administra los usuarios registrados en la plataforma.</p>
              </div>

              <div className="table-responsive">
                <table className="table table-hover align-middle">
                  <thead className="table-custom-header">
                    <tr>
                      <th>ID</th>
                      <th>Nombre</th>
                      <th>Correo</th>
                      <th>Rol</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    {users.map((user) => (
                      <tr key={user.id}>
                        <td style={{fontWeight: '500'}}>{user.id}</td>
                        <td>{user.name}</td>
                        <td>{user.email}</td>
                        <td>
                          <span className={`badge ${user.role === 'Administrador' ? 'bg-secondary' : 'bg-success'}`} 
                                style={{backgroundColor: user.role === 'Administrador' ? 'var(--color-oscuro)' : 'var(--color-principal)'}}>
                            {user.role}
                          </span>
                        </td>
                        <td>
                          <button 
                            className="btn btn-sm btn-custom-edit me-2" 
                            title="Editar usuario"
                            onClick={() => handleEdit(user)}
                          >
                            <i className="fa-solid fa-pen me-1"></i> Editar
                          </button>
                          <button 
                            className="btn btn-sm btn-custom-delete" 
                            title="Eliminar usuario"
                            onClick={() => handleDelete(user.id, user.name)}
                          >
                            <i className="fa-solid fa-trash me-1"></i> Eliminar
                          </button>
                        </td>
                      </tr>
                    ))}
                    {users.length === 0 && (
                      <tr>
                        <td colSpan="5" className="text-center py-4">No hay usuarios registrados.</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </section>
          </div>
        </main>
      </div>

      {}
      {toastMsg && (
        <div className="custom-toast-container">
          <div className="alert custom-toast shadow d-flex align-items-center gap-2 mb-0" role="alert">
            <i className="fa-solid fa-bell"></i>
            <div>{toastMsg}</div>
          </div>
        </div>
      )}
    </>
  );
}