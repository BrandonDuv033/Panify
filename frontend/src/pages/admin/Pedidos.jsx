import { useState, useEffect, useRef } from "react";
import { obtenerNombreUsuarioActual } from "../../services/auth";
import {obtenerPedidosAdmin, actualizarEstadoPedido} from "../../services/pedidos.js";
import Swal from "sweetalert2";
import DataTable from "datatables.net-react";
import DT from "datatables.net-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";
import ModalDetallePedido from "../../components/admin/ModalDetallePedido.jsx";
import ModalRuta from "../../components/admin/ModalRuta.jsx";



export default function Pedidos() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [pedidos, setPedidos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pedidoSeleccionado, setPedidoSeleccionado] = useState(null);
  const [pedidoRuta, setPedidoRuta] = useState(null);
  const [nuevoEstado, setNuevoEstado] = useState("");
  const tablaRef = useRef(null);

  useEffect(() => {
    const fetchPedidosData = async () => {
      try {
        const pedidosCompletos = await obtenerPedidosAdmin();

        setPedidos(pedidosCompletos);
        setLoading(false);
      } catch (error) {
        console.error("Error al cargar los pedidos:", error);
        setLoading(false);

        Swal.fire({
          icon: "error",
          title: "Error",
          text: "No se pudieron cargar los pedidos.",
          confirmButtonColor: "#e5a93c",
        });
      }
    };

    fetchPedidosData();
  }, []);

  useEffect(() => {
    DataTable.use(DT);

    const contenedor = tablaRef.current;

    if (!contenedor) return;

    const manejarClick = (e) => {
      const boton = e.target.closest("button[data-accion]");

      if (!boton) return;

      const id = boton.dataset.id;

      const pedido = pedidos.find(
        (p) => String(p.id) === String(id)
      );

      if (!pedido) return;

      if (boton.dataset.accion === "detalle") {
        abrirDetalle(pedido);
      }

      if (boton.dataset.accion === "ruta") {
        seleccionarRuta(pedido);
      }
    };

    contenedor.addEventListener("click", manejarClick);

    return () => {
      contenedor.removeEventListener("click", manejarClick);
    };
  }, [pedidos]);

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
      await actualizarEstadoPedido(
        pedidoSeleccionado.id,
        nuevoEstado
      );

      setPedidos(
        pedidos.map((p) =>
          p.id === pedidoSeleccionado.id
            ? {
                ...p,
                estado: nuevoEstado,
              }
            : p
        )
      );

      Swal.fire({
        icon: "success",
        title: "¡Actualizado!",
        text: "El estado del pedido ha sido modificado correctamente.",
        confirmButtonColor: "#e5a93c",
      });

      cerrarDetalle();
    } catch (error) {
      console.error(
        "Error al actualizar el estado del pedido:",
        error
      );

      Swal.fire({
        icon: "error",
        title: "Error",
        text: "No se pudo actualizar el estado del pedido.",
        confirmButtonColor: "#e5a93c",
      });
    }
  };

  const columnas = [
    {
      title: "ID",
      data: "id",
    },
    {
      title: "Cliente",
      data: "nombreCliente",
    },
    {
      title: "Dirección",
      data: "direccion",
    },
    {
      title: "Productos",
      data: "pedidoRealizado",
    },
    {
      title: "Domiciliario",
      data: "domiciliario",
    },
    {
      title: "Estado",
      data: "estado",
    },
    {
      title: "Acciones",
      data: null,
      orderable: false,
      searchable: false,

      render: function (row) {
        return `
          <div class="Botones">

            <button
              type="button"
              class="btn btn-sm btn-detalle"
              data-id="${row.id}"
              data-accion="detalle"
            >
              <i class="fa-solid fa-circle-info"></i>
              Ver <br />
              Detalles
            </button>

            <button
              type="button"
              class="btn btn-sm btn-ruta"
              data-id="${row.id}"
              data-accion="ruta"
            >
              <i class="fa-solid fa-route"></i>
              Ver <br />
              Ruta
            </button>

          </div>
        `;
      },
    },
  ];

  const opcionesDataTable = {
    language: {
      search: "Buscar:",
      lengthMenu: "Mostrar _MENU_ pedidos",
      info: "Mostrando _START_ a _END_ de _TOTAL_ pedidos",
      infoEmpty: "Mostrando 0 a 0 de 0 pedidos",
      zeroRecords: "No se encontraron pedidos",
      emptyTable: "No hay pedidos registrados",

      paginate: {
        first: "Primero",
        previous: "Anterior",
        next: "Siguiente",
        last: "Último",
      },
    },

    pageLength: 5,
    lengthMenu: [5, 10, 25, 50],
    responsive: true,
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
              Consulta y gestiona pedidos, revisa sus detalles y
              estados, y visualiza las rutas de entrega.
            </p>
          </div>

          <div className="admin-info">
            <i className="fa-solid fa-circle-user"></i>

            <span>
              {obtenerNombreUsuarioActual()}
            </span>
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
                  {
                    pedidos.filter(
                      (p) => p.estado === "Entregado"
                    ).length
                  }
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
                  {
                    pedidos.filter(
                      (p) => p.estado === "En Camino"
                    ).length
                  }
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
                  {
                    pedidos.filter(
                      (p) => p.estado === "Pendiente"
                    ).length
                  }
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

          <div
            className="table-responsive"
            ref={tablaRef}
          >

            {loading ? (
              <div className="py-4 text-muted text-center">
                Cargando pedidos desde el servidor...
              </div>
            ) : (
              <DataTable
                id="tablapedidosAdmin"
                className="table align-middle text-center"
                data={pedidos}
                columns={columnas}
                options={opcionesDataTable}
              />
            )}

          </div>

        </section>

        <ModalDetallePedido
          pedidoSeleccionado={pedidoSeleccionado}
          cerrarDetalle={cerrarDetalle}
          guardarCambiosEstado={guardarCambiosEstado}
          nuevoEstado={nuevoEstado}
          setNuevoEstado={setNuevoEstado}
        />

        <ModalRuta
          pedidoRuta={pedidoRuta}
          cerrarRuta={cerrarRuta}
          direccionMapa={direccionMapa}
        />

      </main>

    </div>
  );
}