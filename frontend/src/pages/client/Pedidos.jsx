import { useEffect, useMemo, useState } from "react";
import { obtenerPedidos, cancelarPedidoService } from "../../services/pedidos";

export default function Pedidos() {
  const [pedidos, setPedidos] = useState([]);
  const [cargando, setCargando] = useState(true);
  const [error, setError] = useState(null);

  const [busqueda, setBusqueda] = useState("");
  const [filtroEstado, setFiltroEstado] = useState("Todos");

  // Estado para el modal de detalle de pedido
  const [pedidoSeleccionado, setPedidoSeleccionado] = useState(null);

  // --- READ: Cargar pedidos desde el servicio ---
  useEffect(() => {
    async function cargar() {
      try {
        setCargando(true);
        const data = await obtenerPedidos();
        setPedidos(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setCargando(false);
      }
    }
    cargar();
  }, []);

  // --- UPDATE: Cancelar un pedido ---
  async function handleCancelar(id) {
    const confirmar = window.confirm(
      "¿Seguro que quieres cancelar este pedido?"
    );
    if (!confirmar) return;

    try {
      const actualizado = await cancelarPedidoService(id);
      setPedidos((prev) =>
        prev.map((p) => (p.id === actualizado.id ? { ...p, estado: "Cancelado" } : p))
      );
      // Si el pedido cancelado estaba abierto en el modal, actualizamos su estado local
      if (pedidoSeleccionado && pedidoSeleccionado.id === id) {
        setPedidoSeleccionado((prev) => ({ ...prev, estado: "Cancelado" }));
      }
    } catch (err) {
      alert(err.message);
    }
  }

  // --- Filtrado por texto y estado ---
  const pedidosFiltrados = useMemo(() => {
    return pedidos.filter((p) => {
      const coincideTexto =
        busqueda.trim() === "" ||
        String(p.id).toLowerCase().includes(busqueda.toLowerCase()) ||
        (p.cliente || "").toLowerCase().includes(busqueda.toLowerCase());

      const coincideEstado =
        filtroEstado === "Todos" || p.estado === filtroEstado;

      return coincideTexto && coincideEstado;
    });
  }, [pedidos, busqueda, filtroEstado]);

  const activos = pedidosFiltrados.filter(
    (p) => p.estado !== "Entregado" && p.estado !== "Cancelado"
  );
  const historial = pedidosFiltrados.filter(
    (p) => p.estado === "Entregado" || p.estado === "Cancelado"
  );

  const contar = (estado) => pedidos.filter((p) => p.estado === estado).length;

  function badgeClase(estado) {
    switch (estado) {
      case "Pendiente":
        return "bg-danger";
      case "Preparación":
        return "bg-warning text-dark";
      case "En camino":
        return "bg-primary";
      case "Entregado":
        return "bg-success";
      case "Cancelado":
        return "bg-secondary";
      default:
        return "bg-light text-dark";
    }
  }

  function formatearProductos(productos) {
    if (!productos || productos.length === 0) return "—";
    return productos.map((p) => `${p.cantidad} ${p.nombre}`).join(", ");
  }

  function formatearTotal(total) {
    if (total == null) return "—";
    return `$${total.toLocaleString("es-CO")}`;
  }

  if (cargando) {
    return (
      <main className="container py-5 text-white text-center">
        <p>Cargando pedidos...</p>
      </main>
    );
  }

  if (error) {
    return (
      <main className="container py-5 text-white text-center">
        <p>Ocurrió un error: {error}</p>
      </main>
    );
  }

  return (
    <main className="container py-5 pedidos-cliente-main">
      {/* Encabezado */}
      <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap">
        <div>
          <h2 className="fw-bold text-white">
            <i className="fa-solid fa-box-open text-warning me-2"></i>
            Mis Pedidos
          </h2>
          <p className="text-light">
            Consulta el estado de tus pedidos y revisa tu historial de compras.
          </p>
        </div>
      </div>

      {/* Resumen */}
      <div className="row g-3 mb-5">
        <div className="col-md-3 col-6">
          <div className="card shadow-sm border-0 text-center p-3 pedidos-cliente-summary-card">
            <i className="fa-solid fa-clock text-danger fs-2 mb-2"></i>
            <h3>{contar("Pendiente")}</h3>
            <small className="text-muted">Pendientes</small>
          </div>
        </div>

        <div className="col-md-3 col-6">
          <div className="card shadow-sm border-0 text-center p-3 pedidos-cliente-summary-card">
            <i className="fa-solid fa-bread-slice text-warning fs-2 mb-2"></i>
            <h3>{contar("Preparación")}</h3>
            <small className="text-muted">Preparación</small>
          </div>
        </div>

        <div className="col-md-3 col-6">
          <div className="card shadow-sm border-0 text-center p-3 pedidos-cliente-summary-card">
            <i className="fa-solid fa-truck text-primary fs-2 mb-2"></i>
            <h3>{contar("En camino")}</h3>
            <small className="text-muted">En camino</small>
          </div>
        </div>

        <div className="col-md-3 col-6">
          <div className="card shadow-sm border-0 text-center p-3 pedidos-cliente-summary-card">
            <i className="fa-solid fa-circle-check text-success fs-2 mb-2"></i>
            <h3>{contar("Entregado")}</h3>
            <small className="text-muted">Entregados</small>
          </div>
        </div>
      </div>

      {/* Buscador */}
      <div className="card shadow-sm border-0 mb-5">
        <div className="card-body">
          <div className="row g-3">
            <div className="col-md-8">
              <input
                type="text"
                className="form-control pedidos-cliente-input"
                placeholder="Buscar pedido..."
                value={busqueda}
                onChange={(e) => setBusqueda(e.target.value)}
              />
            </div>

            <div className="col-md-4">
              <select
                className="form-select pedidos-cliente-select"
                value={filtroEstado}
                onChange={(e) => setFiltroEstado(e.target.value)}
              >
                <option>Todos</option>
                <option>Pendiente</option>
                <option>Preparación</option>
                <option>En camino</option>
                <option>Entregado</option>
                <option>Cancelado</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      {/* Pedidos Activos */}
      <h3 className="fw-bold mb-4 text-white">
        <i className="fa-solid fa-cart-shopping text-warning me-2"></i>
        Pedidos Activos
      </h3>

      {activos.length === 0 ? (
        <p className="text-light mb-5 pedidos-cliente-empty-text">
          No tienes pedidos activos por ahora.
        </p>
      ) : (
        <div className="card shadow-sm border-0 mb-5">
          <div className="table-responsive pedidos-cliente-table-wrapper">
            <table className="table table-hover align-middle mb-0 pedidos-cliente-table">
              <thead>
                <tr>
                  <th>Pedido</th>
                  <th>Cliente</th>
                  <th>Fecha</th>
                  <th>Productos</th>
                  <th>Total</th>
                  <th>Estado</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {activos.map((pedido) => (
                  <tr key={pedido.id}>
                    <td>
                      <strong>#{pedido.id}</strong>
                    </td>
                    <td>{pedido.cliente || "—"}</td>
                    <td>{pedido.fecha || "—"}</td>
                    <td>{formatearProductos(pedido.productos)}</td>
                    <td>{formatearTotal(pedido.total)}</td>
                    <td>
                      <span
                        className={`badge pedidos-cliente-badge ${badgeClase(pedido.estado)}`}
                      >
                        {pedido.estado}
                      </span>
                    </td>
                    <td>
                      <div className="d-flex gap-2 pedidos-cliente-actions">
                        <button
                          className="btn btn-sm btn-outline-dark pedidos-cliente-btn"
                          onClick={() => setPedidoSeleccionado(pedido)}
                        >
                          Ver detalles
                        </button>
                        <button
                          className="btn btn-sm btn-danger pedidos-cliente-btn"
                          onClick={() => handleCancelar(pedido.id)}
                        >
                          Cancelar
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Historial */}
      <h3 className="fw-bold mb-4 text-white">
        <i className="fa-solid fa-clock-rotate-left me-2 text-secondary"></i>
        Historial de Pedidos
      </h3>

      {historial.length === 0 ? (
        <p className="text-light pedidos-cliente-empty-text">
          Aún no tienes pedidos en tu historial.
        </p>
      ) : (
        <div className="card shadow-sm border-0">
          <div className="table-responsive pedidos-cliente-table-wrapper">
            <table className="table table-hover align-middle mb-0 pedidos-cliente-table">
              <thead>
                <tr>
                  <th>Pedido</th>
                  <th>Fecha</th>
                  <th>Productos</th>
                  <th>Total</th>
                  <th>Estado</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {historial.map((pedido) => (
                  <tr key={pedido.id}>
                    <td>
                      <strong>#{pedido.id}</strong>
                    </td>
                    <td>{pedido.fecha || "—"}</td>
                    <td>{formatearProductos(pedido.productos)}</td>
                    <td>{formatearTotal(pedido.total)}</td>
                    <td>
                      <span
                        className={`badge pedidos-cliente-badge ${badgeClase(pedido.estado)}`}
                      >
                        {pedido.estado}
                      </span>
                    </td>
                    <td>
                      <button
                        className="btn btn-sm btn-outline-secondary pedidos-cliente-btn"
                        onClick={() => setPedidoSeleccionado(pedido)}
                      >
                        Ver detalles
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* MODAL DETALLE DEL PEDIDO */}
      {pedidoSeleccionado && (
        <div
          className="modal fade show d-block"
          tabIndex="-1"
          style={{ backgroundColor: "rgba(0,0,0,0.6)" }}
        >
          <div className="modal-dialog modal-lg modal-dialog-centered">
            <div className="modal-content bg-dark text-white border-secondary">
              <div className="modal-header border-secondary">
                <h5 className="modal-title fw-bold">
                  <i className="fa-solid fa-receipt text-warning me-2"></i>
                  Detalle del Pedido #{pedidoSeleccionado.id}
                </h5>
                <button
                  type="button"
                  className="btn-close btn-close-white"
                  onClick={() => setPedidoSeleccionado(null)}
                ></button>
              </div>

              <div className="modal-body">
                <div className="row mb-3">
                  <div className="col-md-6">
                    <p className="mb-1">
                      <strong>Cliente:</strong> {pedidoSeleccionado.cliente}
                    </p>
                    <p className="mb-1">
                      <strong>Teléfono:</strong> {pedidoSeleccionado.telefono}
                    </p>
                  </div>
                  <div className="col-md-6 text-md-end">
                    <p className="mb-1">
                      <strong>Fecha:</strong> {pedidoSeleccionado.fecha || "—"}
                    </p>
                    <p className="mb-1">
                      <strong>Estado: </strong>
                      <span
                        className={`badge ${badgeClase(pedidoSeleccionado.estado)}`}
                      >
                        {pedidoSeleccionado.estado}
                      </span>
                    </p>
                  </div>
                </div>

                <h6 className="fw-bold mt-4 text-warning">Productos Solicitados</h6>
                <div className="table-responsive">
                  <table className="table table-dark table-striped align-middle mt-2 mb-0">
                    <thead>
                      <tr>
                        <th>Producto</th>
                        <th className="text-center">Cantidad</th>
                        <th className="text-end">Precio Unit.</th>
                        <th className="text-end">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody>
                      {pedidoSeleccionado.productos &&
                      pedidoSeleccionado.productos.length > 0 ? (
                        pedidoSeleccionado.productos.map((prod, index) => (
                          <tr key={index}>
                            <td>{prod.nombre}</td>
                            <td className="text-center">{prod.cantidad}</td>
                            <td className="text-end">
                              {formatearTotal(prod.precioUnitario)}
                            </td>
                            <td className="text-end fw-semibold">
                              {formatearTotal(prod.subtotal)}
                            </td>
                          </tr>
                        ))
                      ) : (
                        <tr>
                          <td colSpan="4" className="text-center text-muted">
                            No hay productos detallados.
                          </td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>

                <div className="text-end mt-3 fw-bold fs-5 text-warning">
                  Total Pedido: {formatearTotal(pedidoSeleccionado.total)}
                </div>
              </div>

              <div className="modal-footer border-secondary">
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => setPedidoSeleccionado(null)}
                >
                  Cerrar
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}