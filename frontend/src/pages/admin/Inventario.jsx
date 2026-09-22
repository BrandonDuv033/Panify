import {
  obtenerProductos,
  eliminarProducto,
} from "../../services/inventario.js";
import { obtenerNombreUsuarioActual } from "../../services/auth.js";
import { useState, useEffect, useRef } from "react";
import { createPortal } from "react-dom";
import Swal from "sweetalert2";
import DataTable from "datatables.net-react";
import DT from "datatables.net-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";

export default function Inventario() {
  DataTable.use(DT);

  const [productos, setProductos] = useState([]);
  const [categoriaFiltro, setCategoriaFiltro] = useState("Todas");
  const [, setCargando] = useState(true);
  const tablaRef = useRef(null);
  const [contenedorFiltro, setContenedorFiltro] = useState(null);

  useEffect(() => {
    async function cargarProductos() {
      try {
        const productos = await obtenerProductos();
        setProductos(productos);
      } catch (error) {
        console.error("Error al cargar el inventario:", error);
      } finally {
        setCargando(false);
      }
    }

    cargarProductos();
  }, []);

  const handleCategoriaChange = (event) => {
    const categoria = event.target.value;
    setCategoriaFiltro(categoria);
    tablaRef.current
      ?.dt()
      .column(2)
      .search(categoria === "Todas" ? "" : categoria)
      .draw();
  };

  const handleAgregar = () => {
    Swal.fire({
      title: "Agregar Producto",
      text: "Función para registrar un nuevo producto en desarrollo.",
      icon: "info",
      confirmButtonColor: "#e5a93c",
    });
  };

  const handleEditar = (nombre) => {
    Swal.fire("Editar Producto", `Modificando el producto: ${nombre}`, "info");
  };

  const handleEliminar = async (producto) => {
    const result = await Swal.fire({
      title: "¿Estás seguro?",
      text: `Se eliminará el producto ${producto.nombre}`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    });

    if (!result.isConfirmed) return;

    try {
      await eliminarProducto(producto.id);
      Swal.fire("¡Eliminado!", "El producto ha sido eliminado.", "success");
      setProductos((prevProductos) =>
        prevProductos.filter((p) => p.id !== producto.id),
      );
    } catch (err) {
      console.error("Error al eliminar producto:", err);
      Swal.fire("Error", "No se pudo eliminar el producto", "error");
    }
  };

  const columnas = [
    {
      title: "ID",
      data: "id",
      orderable: true,
      render: (data) => `${data}`,
    },
    { title: "Producto", data: "nombre" },
    { title: "Descripción", data: "categoria" },
    {
      title: "Precio",
      data: "precio",
      render: (data) => `$ ${Number(data || 0).toLocaleString("es-CO")}`,
    },
    { title: "Stock", data: "stock" },
    {
      title: "Estado",
      data: "estado",
      render: (data) => {
        const clase =
          data === "Disponible"
            ? "bg-success"
            : data === "Poco Stock"
              ? "bg-warning text-dark"
              : "bg-danger";

        return `<span class="badge ${clase}">${data}</span>`;
      },
    },
    {
      title: "Acciones",
      data: null,
      orderable: false,
      searchable: false,
      render: () => `
        <button class="btn btn-sm btn-outline-primary me-2 btn-editar-producto" title="Editar">
          <i class="fa-solid fa-pen"></i>
        </button>
        <button class="btn btn-sm btn-outline-danger btn-eliminar-producto" title="Eliminar">
          <i class="fa-solid fa-trash"></i>
        </button>`,
    },
  ];

  return (
    <div className="dashboard-layout">
      <main className="dashboard-main">
        <header className="topbar d-flex justify-content-between align-items-center mb-4">
          <div>
            <h1 className="m-0">Inventario</h1>
            <p className="m-0 text-muted">
              Gestión de catálogo e inventario de panadería.
            </p>
          </div>
          <div className="admin-info d-flex align-items-center gap-2">
            <i className="fa-solid fa-circle-user fs-4"></i>
            <span>{obtenerNombreUsuarioActual()}</span>
          </div>
        </header>

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
                <h3>
                  {productos.filter((p) => p.stock > 0 && p.stock <= 10).length}
                </h3>
                <p>Poco Stock</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-circle-xmark"></i>
              <div>
                <h3>{productos.filter((p) => p.stock === 0).length}</h3>
                <p>Agotados</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-layer-group"></i>
              <div>
                <h3>{new Set(productos.map((p) => p.categoria)).size}</h3>
                <p>Categorías</p>
              </div>
            </div>
          </div>
        </section>

        <section className="panel tabla p-4 bg-white rounded shadow-sm">
          <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div>
              <h2>Inventario de Productos</h2>
              <p className="text-muted m-0">
                Administra los productos de la panadería.
              </p>
            </div>
            <button className="btn btn-primary" onClick={handleAgregar}>
              <i className="fa-solid fa-plus me-1"></i> Agregar Producto
            </button>
          </div>

          <div className="table-responsive">
            <DataTable
              ref={tablaRef}
              id="tablaInventario"
              data={productos}
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
                  info: "Mostrando _START_ a _END_ de _TOTAL_ productos",
                  infoEmpty: "No hay productos disponibles",
                  zeroRecords: "No se encontraron productos",
                  paginate: {
                    first: "Primero",
                    last: "Último",
                    next: "Siguiente",
                    previous: "Anterior",
                  },
                },
                initComplete() {
                  const contenedorBusqueda = this.api()
                    .table()
                    .container()
                    .querySelector(".dt-search");
                  setContenedorFiltro(contenedorBusqueda);
                },
                createdRow: (row, producto) => {
                  row
                    .querySelector(".btn-editar-producto")
                    ?.addEventListener("click", () =>
                      handleEditar(producto.nombre),
                    );
                  row
                    .querySelector(".btn-eliminar-producto")
                    ?.addEventListener("click", () =>
                      handleEliminar(producto),
                    );
                },
              }}
            />
          </div>
          {contenedorFiltro &&
            createPortal(
              <select
                className="form-select filtro-categoria-datatable"
                value={categoriaFiltro}
                onChange={handleCategoriaChange}
                aria-label="Filtrar por categoría"
              >
                <option value="Todas">Todas las categorías</option>
                <option value="artesanal">Artesanal</option>
                <option value="queso">Queso</option>
              </select>,
              contenedorFiltro,
            )}
        </section>
      </main>
    </div>
  );
}
