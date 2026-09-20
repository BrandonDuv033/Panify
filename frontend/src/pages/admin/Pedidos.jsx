  import { useState, useEffect } from "react";
  import { useNavigate } from "react-router-dom";
  import Swal from "sweetalert2";
  import API from "../../services/api";

  const Pedidos = () => {
    const navigate = useNavigate();

    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [pedidos, setPedidos] = useState([]);
    const [loading, setLoading] = useState(true);
    const [pedidoSeleccionado, setPedidoSeleccionado] = useState(null);
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
            API.get("/usuarios"),
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
              ? resUsuarios.data.find( (u) =>
               String(u.domiciliario_idDomiciliario) ===
               String(pedido.domiciliario_idDomiciliario),
              ) || {}
              : {};

            const usuario =
              resUsuarios.data.find(
                (u) => String(u.cliente_idCliente) === String(cliente.idCliente),
              ) || {};

            const detallesDelPedido = resDetalles.data.filter(
              (d) => String(d.pedido_idPedido) === String(pedido.id),
            );

            const nombresProductos = detallesDelPedido
              .map((det) => {
                const prod = resProductos.data.find(
                  (p) => String(p.id) === String(det.producto_id),
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

    const handleCerrarSesion = (e) => {
      e.preventDefault();
      localStorage.removeItem("usuario");
      navigate("/ingresar");
    };


    const abrirDetalle = (pedido) => {
      setPedidoSeleccionado(pedido);
      setNuevoEstado(pedido.estado);
    };

    const cerrarDetalle = () => {
      setPedidoSeleccionado(null);
      setNuevoEstado("");
    };

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

        {sidebarOpen && (
          <div
            id="sidebarOverlay"
            onClick={toggleSidebar}
          ></div>
        )}

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
                Bienvenido al panel administrativo de Panify.
              </p>
            </div>

            <div className="admin-info">
              <i className="fa-solid fa-circle-user"></i>

              <span>Administrador</span>
            </div>
          </header>
          <br />

          <section className="panel tabla">
            <div className="cabecera-tabla">
              <div>
                <h1>Lista de Pedidos</h1>
              </div>
            </div>

            <div className="table-responsive">
              <table id="tablaPedidos" className="table align-middle text-center">
                <thead>
                  <tr>
                    <th>ID Pedido</th>

                    <th>Nombre del Cliente</th>

                    <th>Dirección</th>

                    <th>Pedido Realizado</th>

                    <th>Domiciliario</th>

                    <th>Estado del pedido</th>

                    <th>Acciones</th>
                  </tr>
                </thead>

                <tbody>
                  {loading ? (
                    <tr>
                      <td colSpan="6" className="py-4 text-muted">
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

                        <td>
                          <button
                            type="button"
                            className="btn btn-sm btn-detalle"
                            onClick={() => abrirDetalle(ped)}
                          >
                            <i className="fa-solid fa-circle-info"></i>
                            Ver <br />
                            Detalles
                          </button>
                        </td>
                      </tr>
                    ))
                  )}

                  {!loading && pedidos.length === 0 && (
                    <tr>
                      <td colSpan="6" className="py-4 text-muted">
                        No se encontraron pedidos registrados.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </section>
          {pedidoSeleccionado && (

    <div
      className="modal-detalle-overlay"
      onClick={cerrarDetalle}>



      <div
        className="modal-actualizar"
        onClick={(e) => e.stopPropagation()} >


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

                <strong>
                  ID del pedido:
                </strong>{" "}

                {pedidoSeleccionado.id}

                <br />

                <strong>
                  Nombre del Cliente:
                </strong>{" "}

                {pedidoSeleccionado.nombreCliente}

                <br />

                <strong>
                  Dirección:
                </strong>{" "}

                {pedidoSeleccionado.direccion}

                <br />

                <strong>
                  Pedido:
                </strong>{" "}

                {pedidoSeleccionado.pedidoRealizado}

                <br />

                <strong>
                  Estado Actual:
                </strong>{" "}

                {pedidoSeleccionado.estado}

              </p>

            </div>


            <select
              className="form-select mb-4"
              value={nuevoEstado}
              onChange={(e) =>
                setNuevoEstado(e.target.value)
              }
              required
            >

              <option value="">
                --Seleccione un Estado--
              </option>

              <option value="Pendiente">
                Pendiente
              </option>

              <option value="Entregado">
                Entregado
              </option>

              <option value="En Camino">
                En Camino
              </option>

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
          <br />

          <section className="row g-4 mb-4">
            <div>
              <h1 className="resumenDia text-center">
                Resumen de Entregas del dia
              </h1>
            </div>

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
          <br />

          <section className="mapa d-flex justify-content-center">
            <div className="col-md-10">
              <h2 className="titulo-mapa text-center">Ruta de Entrega</h2>

              <br />

              <div className="mapa-contenedor">
                <iframe
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3976.7989169180273!2d-74.09387552418671!3d4.629933792265237!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f9bd9b9e73d65%3A0x3f449bb47da9bef3!2sCorferias!5e0!3m2!1ses-419!2sco!4v1782428730657!5m2!1ses-419!2sco"
                  width="100%"
                  height="400"
                ></iframe>
              </div>
            </div>
          </section>
        </main>
      </div>
    );
  };

  export default Pedidos;
