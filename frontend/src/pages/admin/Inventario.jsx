import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Swal from "sweetalert2";
import API from "../../services/api";

export default function Inventario() {
  const navigate = useNavigate();
  const [productos, setProductos] = useState([]);
  const [busqueda, setBusqueda] = useState("");
  const [categoriaFiltro, setCategoriaFiltro] = useState("");
  const [cargando, setCargando] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [resProductos, resInventarios] = await Promise.all([
          API.get("/productos"),
          API.get("/inventarios"),
        ]);

        const dataProductos = resProductos.data;
        const dataInventarios = resInventarios.data;

        // Unimos los datos de productos con su respectivo stock e inventario
        const productosCompletos = dataProductos.map((prod) => {
          // Buscamos el inventario correspondiente usando id
          const inv = dataInventarios.find(
            (i) => i.producto_id === prod.id,
          ) || { stockActual: 0 };

          // Determinamos el estado basado en el stock actual
          let estado = "Disponible";
          if (inv.stockActual === 0) {
            estado = "Agotado";
          } else if (inv.stockActual <= 10) {
            estado = "Poco Stock";
          }

          return {
            id: prod.id,
            nombre: prod.nombre,
            categoria: prod.descripcion || "General",
            precio: prod.precio,
            stock: inv.stockActual,
            estado: estado,
            imagen: "🍞",
          };
        });

        setProductos(productosCompletos);
        setCargando(false);
      } catch (error) {
        console.error("Error al cargar el inventario:", error);
        setCargando(false);
      }
    };

    fetchData();
  }, []);

  // Filtrado reactivo de productos
  const productosFiltrados = productos.filter((prod) => {
    const coincideBusqueda = prod.nombre
      .toLowerCase()
      .includes(busqueda.toLowerCase());

    const coincideCategoria =
      categoriaFiltro === "Todas" ||
      prod.categoria.toLowerCase().includes(categoriaFiltro.toLowerCase());

    return coincideBusqueda && coincideCategoria;
  });

  const handleCerrarSesion = (e) => {
    e.preventDefault();
    localStorage.removeItem("usuario");
    navigate("/ingresar");
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

  const handleEliminar = (producto) => {
    Swal.fire({
      title: "¿Estás seguro?",
      text: `Se eliminará el producto ${producto.nombre}`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    }).then((result) => {
      if (result.isConfirmed) {
        API.delete(`/productos/${producto.id}`)
          .then(() => {
            Swal.fire(
              "¡Eliminado!",
              "El producto ha sido eliminado.",
              "success",
            );
            setProductos((prevProductos) =>
              prevProductos.filter((p) => p.id !== producto.id),
            );
          })
          .catch((err) => {
            console.error("Error al eliminar producto:", err);
            Swal.fire("Error", "No se pudo eliminar el producto", "error");
          });
      }
    });
  };

  return (
    <div className="dashboard-layout">
      {/* CONTENIDO PRINCIPAL */}
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

        {/* Sección Inventario */}
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
                <option value="artesanal">Artesanal</option>
                <option value="queso">Queso</option>
              </select>
            </div>
          </div>

          <div className="table-responsive">
            <table
              className="table table-striped table-hover align-middle"
              style={{ width: "100%" }}
            >
              <thead className="table-light">
                <tr>
                  <th>Imagen</th>
                  <th>Producto</th>
                  <th>Descripción</th>
                  <th>Precio</th>
                  <th>Stock</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {cargando ? (
                  <tr>
                    <td colSpan="7" className="text-center py-4 text-muted">
                      Cargando inventario desde el servidor...
                    </td>
                  </tr>
                ) : (
                  productosFiltrados.map((prod) => (
                    <tr key={prod.id}>
                      <td className="fs-4">{prod.imagen}</td>
                      <td>{prod.nombre}</td>
                      <td>{prod.categoria}</td>
                      <td>$ {prod.precio.toLocaleString()}</td>
                      <td>{prod.stock}</td>
                      <td>
                        <span
                          className={`badge ${
                            prod.estado === "Disponible"
                              ? "bg-success"
                              : prod.estado === "Poco Stock"
                                ? "bg-warning text-dark"
                                : "bg-danger"
                          }`}
                        >
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
                          onClick={() => handleEliminar(prod)}
                        >
                          <i className="fa-solid fa-trash"></i>
                        </button>
                      </td>
                    </tr>
                  ))
                )}
                {!cargando && productosFiltrados.length === 0 && (
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
}
