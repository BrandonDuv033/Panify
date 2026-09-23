import { useState, useEffect } from "react";
import { obtenerNombreUsuarioActual } from "../../services/auth.js";
import Swal from "sweetalert2";
import API from "../../services/api";

export default function Pedidos() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [pedidos, setPedidos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pedidoSeleccionado, setPedidoSeleccionado] = useState(null);
  const [pedidoRuta, setPedidoRuta] = useState(null);
  const [nuevoEstado, setNuevoEstado] = useState("");

  useEffect(() => {
    const fetchPedidosData = async () => {
      try {
        const [
          resPedidos,
          resClientes,
          resUsuarios,
          resDetalles,
          resProductos,
        ] = await Promise.all([
          API.get("/pedidos"),
          API.get("/clientes"),
          API.get("/users"),
          API.get("/detalles_pedidos"),
          API.get("/productos"),
        ]);

        const pedidosCompletos = resPedidos.data.map((pedido) => {
          const cliente =
            resClientes.data.find(
              (c) => String(c.idCliente) === String(pedido.cliente_idCliente),
            ) || {};

          const domiciliario =
            pedido.domiciliario_idDomiciliario !== null
              ? resUsuarios.data.find(
                  (u) =>
                    String(u.domiciliario_idDomiciliario) ===
                    String(pedido.domiciliario_idDomiciliario),
                ) || {}
              : {};

          const usuario =
            resUsuarios.data.find(
              (u) => String(u.cliente_idCliente) === String(cliente.idCliente),
            ) || {};

          const detallesDelPedido = resDetalles.data.filter(
            (d) => String(d.pedido_id) === String(pedido.id),
          );

          const nombresProductos = detallesDelPedido
            .map((det) => {
              const prod = resProductos.data.find(
                (p) => String(p.id) === String(det.producto_idProducto),
              );

              return prod ? `${prod.nombre} (x${det.cantidad})` : "";
            })
            .filter(Boolean)
            .join(", ");

          return {
            id: pedido.id,

            nombreCliente: usuario.nombre
              ? `${usuario.nombre} ${usuario.apellido}`
              : "Cliente no registrado",

            direccion: cliente.direccion || "Dirección no registrada",

            pedidoRealizado: nombresProductos || "Productos variados",

            domiciliario: domiciliario.nombre
              ? `${domiciliario.nombre} ${domiciliario.apellido || ""}`.trim()
              : "Sin domiciliario",

            estado: pedido.estadoPedido || "Pendiente",
          };
        });

        setPedidos(pedidosCompletos);
        setLoading(false);
      } catch (error) {
        console.error("Error al cargar los pedidos:", error);
        setLoading(false);
      }
    };

    fetchPedidosData();
  }, []);

  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen);
  };

  const abrirDetalle = (pedido) => {
    setPedidoSeleccionado(pedido);
    setNuevoEstado(pedido.estado);
  };

  const cerrarDetalle = () => {
    setPedidoSeleccionado(null);
    setNuevoEstado("");
  };

  const seleccionarRuta = (pedido) => {
    setPedidoRuta(pedido);
  };

  const cerrarRuta = () => {
    setPedidoRuta(null);
  };

  const direccionMapa = pedidoRuta
    ? encodeURIComponent(pedidoRuta.direccion)
    : "";

  const guardarCambiosEstado = async (e) => {
    e.preventDefault();

    if (!pedidoSeleccionado) return;

    try {
      await API.patch(`/pedidos/${pedidoSeleccionado.id}`, {
        estadoPedido: nuevoEstado,
      });

      setPedidos(
        pedidos.map((p) =>
          p.id === pedidoSeleccionado.id
            ? {
                ...p,
                estado: nuevoEstado,
              }
            : p,
        ),
      );

      Swal.fire({
        icon: "success",
        title: "¡Actualizado!",
        text: "El estado del pedido ha sido modificado correctamente.",
        confirmButtonColor: "#e5a93c",
      });

      cerrarDetalle();
    } catch (error) {
      console.error("Error al actualizar el estado del pedido:", error);

      Swal.fire({
        icon: "error",
        title: "Error",
        text: "No se pudo actualizar el estado del pedido.",
        confirmButtonColor: "#e5a93c",
      });
    }
  };

  return (
    <div className="dashboard-layout">
      {sidebarOpen && <div id="sidebarOverlay" onClick={toggleSidebar}></div>}

      <main className="dashboard-main">
        <header className="topbar">
          <button
            className="mobile-toggle-btn"
            id="menuToggle"
            onClick={toggleSidebar}
          >
            <i className="fa-solid fa-bars"></i>
          </button>

          <div>
            <h1>Pedidos</h1>

            <p className="d-none d-sm-block">
              Consulta y gestiona pedidos, revisa sus detalles y estados, y
              visualiza las rutas de entrega.
            </p>
          </div>

          <div className="admin-info">
            <i className="fa-solid fa-circle-user"></i>

            <span>{obtenerNombreUsuarioActual()}</span>
          </div>
        </header>

        <section className="row g-4 mb-4">
          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-clipboard-list"></i>

              <div>
                <h3>{pedidos.length}</h3>

                <p>Total de Pedidos</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-circle-check"></i>

              <div>
                <h3>
                  {pedidos.filter((p) => p.estado === "Entregado").length}
                </h3>

                <p>Entregadas</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-truck-fast"></i>

              <div>
                <h3>
                  {pedidos.filter((p) => p.estado === "En Camino").length}
                </h3>

                <p>En camino</p>
              </div>
            </div>
          </div>

          <div className="col-lg-3 col-md-6">
            <div className="card-resumen">
              <i className="fa-solid fa-spinner"></i>

              <div>
                <h3>
                  {pedidos.filter((p) => p.estado === "Pendiente").length}
                </h3>

                <p>Pendientes</p>
              </div>
            </div>
          </div>
        </section>

        <section className="panel tabla">
          <div className="cabecera-tabla">
            <div>
              <h1>Lista de Pedidos</h1>
            </div>
          </div>

          <div className="table-responsive">
            <table
              id="tablapedidosAdmin"
              className="table align-middle text-center"
            >
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Cliente</th>
                  <th>Dirección</th>
                  <th>Productos</th>
                  <th>Domiciliario</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>

              <tbody>
                {loading ? (
                  <tr>
                    <td colSpan="7" className="py-4 text-muted">
                      Cargando pedidos desde el servidor...
                    </td>
                  </tr>
                ) : (
                  pedidos.map((ped) => (
                    <tr key={ped.id}>
                      <td>{ped.id}</td>

                      <td>{ped.nombreCliente}</td>

                      <td>{ped.direccion}</td>

                      <td>{ped.pedidoRealizado}</td>

                      <td>{ped.domiciliario}</td>

                      <td>{ped.estado}</td>

                      <td className="Botones">
                        <button
                          type="button"
                          className="btn btn-sm btn-detalle"
                          onClick={() => abrirDetalle(ped)}
                        >
                          <i className="fa-solid fa-circle-info"></i>
                          Ver <br />
                          Detalles
                        </button>

                        <button
                          type="button"
                          className="btn btn-sm btn-ruta"
                          onClick={() => seleccionarRuta(ped)}
                        >
                          <i className="fa-solid fa-route"></i>
                          Ver <br />
                          Ruta
                        </button>
                      </td>
                    </tr>
                  ))
                )}

                {!loading && pedidos.length === 0 && (
                  <tr>
                    <td colSpan="7" className="py-4 text-muted">
                      No se encontraron pedidos registrados.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {pedidoSeleccionado && (
          <div className="modal-detalle-overlay" onClick={cerrarDetalle}>
            <div
              className="modal-actualizar"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="modal-header border-0">
                <h2 className="modal-title w-100 text-center">
                  Detalle del Pedido
                </h2>

                <button
                  type="button"
                  className="btn-close"
                  onClick={cerrarDetalle}
                ></button>
              </div>

              <div className="modal-body">
                <form onSubmit={guardarCambiosEstado}>
                  <div className="detalles mb-3">
                    <p>
                      <strong>ID del pedido:</strong> {pedidoSeleccionado.id}
                      <br />
                      <strong>Nombre del Cliente:</strong>{" "}
                      {pedidoSeleccionado.nombreCliente}
                      <br />
                      <strong>Dirección:</strong> {pedidoSeleccionado.direccion}
                      <br />
                      <strong>Pedido:</strong>{" "}
                      {pedidoSeleccionado.pedidoRealizado}
                      <br />
                      <strong>Estado Actual:</strong>{" "}
                      {pedidoSeleccionado.estado}
                    </p>
                  </div>

                  <select
                    className="form-select mb-4"
                    value={nuevoEstado}
                    onChange={(e) => setNuevoEstado(e.target.value)}
                    required
                  >
                    <option value="">--Seleccione un Estado--</option>

                    <option value="Pendiente">Pendiente</option>

                    <option value="Entregado">Entregado</option>

                    <option value="En Camino">En Camino</option>
                  </select>

                  <button
                    type="submit"
                    className="btn btn-actualizar btn-Guardar w-100"
                  >
                    Guardar Cambios
                  </button>
                </form>
              </div>
            </div>
          </div>
        )}

        {pedidoRuta && (
          <div className="modal-ruta-overlay" onClick={cerrarRuta}>
            <div className="modal-ruta" onClick={(e) => e.stopPropagation()}>
              <div className="modal-header border-0">
                <h2 className="modal-title w-100 text-center rutaEntrega">
                  Ruta de Entrega
                </h2>

                <button
                  type="button"
                  className="btn-close"
                  onClick={cerrarRuta}
                ></button>
              </div>

              <div className="modal-body">
                <div className="ruta-info">
                  <p>
                    <strong>Cliente:</strong> {pedidoRuta.nombreCliente}
                  </p>

                  <p>
                    <strong>Dirección:</strong> {pedidoRuta.direccion}
                  </p>
                </div>

                <div className="mapa-modal">
                  <iframe
                    src={`https://www.google.com/maps?q=${direccionMapa}&output=embed`}
                    width="100%"
                    height="400"
                    style={{ border: 0 }}
                    allowFullScreen=""
                    loading="lazy"
                    title="Mapa de ruta de entrega"
                  ></iframe>
                </div>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
