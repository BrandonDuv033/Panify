import {
  obtenerUsuarios,
  actualizarUsuario,
  eliminarUsuario,
} from "../../services/users";
import { useState, useEffect } from "react";
import Swal from "sweetalert2";
import { obtenerNombreUsuarioActual } from "../../services/auth.js";
import DataTable from "datatables.net-react";
import DT from "datatables.net-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";

export default function Users() {
  DataTable.use(DT);

  const columnas = [
    { title: "ID", data: "id" },
    {
      title: "Nombre",
      data: null,
      render: (_, __, usuario) =>
        `${usuario.nombre ?? ""} ${usuario.apellido ?? ""}`.trim(),
    },
    { title: "Correo", data: "correo" },
    {
      title: "Rol",
      data: "Rol_idRol",
      render: (data) =>
        `<span class="badge ${data === 2 ? "bg-primary" : data === 3 ? "bg-danger" : "bg-secondary"}">${nombreRol(data)}</span>`,
    },
    {
      title: "Acciones",
      data: null,
      orderable: false,
      searchable: false,
      render: () => `
        <button class="btn btn-sm btn-outline-primary me-2 btn-editar-usuario" title="Editar usuario">
          <i class="fa-solid fa-pen me-1"></i> Editar
        </button>
        <button class="btn btn-sm btn-outline-danger btn-eliminar-usuario" title="Eliminar usuario">
          <i class="fa-solid fa-trash me-1"></i> Eliminar
        </button>`,
    },
  ];

  const [usuarios, setUsuarios] = useState([]);
  const [cargando, setCargando] = useState(true);

  function nombreRol(id) {
    const roles = {
      1: "Cliente",
      2: "Domiciliario",
      3: "Panadero",
    };

    return roles[id] || "Desconocido";
  }

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

  const handleEditar = async (usuario) => {
    const { value: datosActualizados } = await Swal.fire({
      title: `Editar usuario #${usuario.id}`,
      html: `
        <input id="editar-nombre" class="swal2-input" placeholder="Nombre" value="${usuario.nombre ?? ""}">
        <input id="editar-apellido" class="swal2-input" placeholder="Apellido" value="${usuario.apellido ?? ""}">
        <input id="editar-correo" type="email" class="swal2-input" placeholder="Correo" value="${usuario.correo ?? usuario.email ?? ""}">
        <input id="editar-telefono" class="swal2-input" placeholder="Teléfono" value="${usuario.telefono ?? ""}">
        <select id="editar-rol" class="swal2-select">
          <option value="1" ${Number(usuario.Rol_idRol) === 1 ? "selected" : ""}>Cliente</option>
          <option value="2" ${Number(usuario.Rol_idRol) === 2 ? "selected" : ""}>Domiciliario</option>
          <option value="3" ${Number(usuario.Rol_idRol) === 3 ? "selected" : ""}>Panadero</option>
        </select>
        <select id="editar-estado" class="swal2-select">
          <option value="Activo" ${usuario.estado === "Activo" ? "selected" : ""}>Activo</option>
          <option value="Inactivo" ${usuario.estado === "Inactivo" ? "selected" : ""}>Inactivo</option>
        </select>
      `,
      showCancelButton: true,
      confirmButtonText: "Guardar cambios",
      cancelButtonText: "Cancelar",
      focusConfirm: false,
      preConfirm: () => {
        const nombre = document.getElementById("editar-nombre").value.trim();
        const apellido = document
          .getElementById("editar-apellido")
          .value.trim();
        const correo = document.getElementById("editar-correo").value.trim();
        const telefono = document
          .getElementById("editar-telefono")
          .value.trim();

        if (!nombre || !apellido || !correo) {
          Swal.showValidationMessage(
            "Nombre, apellido y correo son obligatorios.",
          );
          return null;
        }

        return {
          nombre,
          apellido,
          correo,
          email: correo,
          telefono,
          Rol_idRol: Number(document.getElementById("editar-rol").value),
          estado: document.getElementById("editar-estado").value,
        };
      },
    });

    if (!datosActualizados) return;

    try {
      const usuarioGuardado = await actualizarUsuario(
        usuario.id,
        datosActualizados,
      );

      setUsuarios((usuariosActuales) =>
        usuariosActuales.map((usuarioActual) =>
          usuarioActual.id === usuario.id
            ? { ...usuarioActual, ...usuarioGuardado }
            : usuarioActual,
        ),
      );

      await Swal.fire(
        "Usuario actualizado",
        "Los cambios se guardaron correctamente.",
        "success",
      );
    } catch (error) {
      console.error("Error al actualizar usuario:", error);
      Swal.fire("Error", "No se pudo actualizar el usuario.", "error");
    }
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
            <span>{obtenerNombreUsuarioActual()}</span>
          </div>
        </header>

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

        <section className="panel tabla p-4 bg-white rounded shadow-sm">
          <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div>
              <h2>Gestión de Usuarios</h2>
              <p className="text-muted m-0">
                Administra los usuarios registrados en la plataforma.
              </p>
            </div>
          </div>

          <div className="table-responsive">
            <DataTable
              id="tablaUsuarios"
              data={usuarios}
              columns={columnas}
              className="table table-striped table-hover align-middle"
              options={{
                responsive: true,
                paging: true,
                searching: true,
                ordering: true,
                pageLength: 10,
                language: {
                  search: "Buscar:",
                  lengthMenu: "Mostrar _MENU_ registros",
                  info: "Mostrando _START_ a _END_ de _TOTAL_ usuarios",
                  infoEmpty: "No hay usuarios disponibles",
                  zeroRecords: "No se encontraron usuarios",
                  paginate: {
                    first: "Primero",
                    last: "Último",
                    next: "Siguiente",
                    previous: "Anterior",
                  },
                },
                createdRow: (row, usuario) => {
                  row
                    .querySelector(".btn-editar-usuario")
                    ?.addEventListener("click", () => handleEditar(usuario));
                  row
                    .querySelector(".btn-eliminar-usuario")
                    ?.addEventListener("click", () => handleEliminar(usuario));
                },
              }}
            />
          </div>
        </section>
      </main>
    </div>
  );
}
