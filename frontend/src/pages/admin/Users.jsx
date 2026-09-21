import { obtenerUsuarios, eliminarUsuario } from "../../services/users";
import { useState, useEffect } from "react";
import Swal from "sweetalert2";

export default function Users() {
  const [usuarios, setUsuarios] = useState([]);
  const [busqueda, setBusqueda] = useState("");
  const [cargando, setCargando] = useState(true);

  useEffect(() => {
    async function cargarUsuarios() {
      try {
        const usuarios = await obtenerUsuarios();
        setUsuarios(usuarios);
      } catch (err) {
        console.error("Error al cargar usuarios:", err);
        Swal.fire("Error", "No se pudieron cargar los usuarios", "error");
      } finally {
        setCargando(false);
      }
    }

    cargarUsuarios();
  }, []);

  const usuariosFiltrados = usuarios.filter(
    (user) =>
      user.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
      user.correo.toLowerCase().includes(busqueda.toLowerCase()),
  );

  const handleEditar = (nombre) => {
    Swal.fire(
      "Editar Usuario",
      `Abriendo panel de edición para ${nombre}`,
      "info",
    );
  };

  const handleEliminar = async (user) => {
    const result = await Swal.fire({
      title: "¿Estás seguro?",
      text: `Se eliminará al usuario ${user.nombre}`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    });

    if (!result.isConfirmed) return;

    try {
      await eliminarUsuario(user.id);
      Swal.fire("¡Eliminado!", "El usuario ha sido eliminado.", "success");
      setUsuarios((prevUsuarios) =>
        prevUsuarios.filter((u) => u.id !== user.id),
      );
    } catch (err) {
      console.error("Error al eliminar usuario:", err);
      Swal.fire("Error", "No se pudo eliminar el usuario", "error");
    }
  };

  return (
    <div className="dashboard-layout">
      {/* CONTENIDO PRINCIPAL */}
      <main className="dashboard-main">
        <header className="topbar d-flex justify-content-between align-items-center mb-4">
          <div>
            <h1 className="m-0">Dashboard</h1>
            <p className="m-0 text-muted">
              Bienvenido al panel administrativo de Panify.
            </p>
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
                <h3>{usuarios.length}</h3>
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
              <p className="text-muted m-0">
                Administra los usuarios registrados en la plataforma.
              </p>
            </div>
            {/* Barra de búsqueda integrada */}
            <div style={{ width: "250px" }}>
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
            <table
              className="table table-striped table-hover align-middle"
              style={{ width: "100%" }}
            >
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
                    <td>
                      {user.nombre} {user.apellido}
                    </td>
                    <td>{user.correo}</td>
                    <td>
                      <span
                        className={`badge ${user.Rol_idRol === 2 ? "bg-primary" : "bg-secondary"}`}
                      >
                        {user.Rol_idRol}
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
                        onClick={() => handleEliminar(user)}
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
}
