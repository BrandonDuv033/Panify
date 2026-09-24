import { useEffect, useMemo, useState } from "react";
import { obtenerPedidos, cancelarPedidoService } from "../../services/pedidos";
import DetallePedidoModal from "../../components/client/ModalDetallePedido";
import DataTable from "datatables.net-react";
import DT from "datatables.net-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";

export default function Pedidos() {
  DataTable.use(DT);

  const [pedidos, setPedidos] = useState([]);
  const [cargando, setCargando] = useState(true);
  const [error, setError] = useState(null);

  const [filtroEstadoActivos, setFiltroEstadoActivos] = useState("Todos");
  const [filtroEstadoHistorial, setFiltroEstadoHistorial] = useState("Todos");

  // Estado para el modal de detalle de pedido
  const [pedidoSeleccionado, setPedidoSeleccionado] = useState(null);

  // --- READ: Cargar pedidos desde el servicio ---
  useEffect(() => {
    async function cargar() {
      try {
        setCargando(true);
        setError(null);

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

  const activos = useMemo(
    () =>
      pedidos.filter(
        (p) =>
          (p.estado !== "Entregado" && p.estado !== "Cancelado") &&
          (filtroEstadoActivos === "Todos" || p.estado === filtroEstadoActivos)
      ),
    [pedidos, filtroEstadoActivos]
  );

  const historial = useMemo(
    () =>
      pedidos.filter(
        (p) =>
          (p.estado === "Entregado" || p.estado === "Cancelado") &&
          (filtroEstadoHistorial === "Todos" || p.estado === filtroEstadoHistorial)
      ),
    [pedidos, filtroEstadoHistorial]
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

  const columnasActivas = [
    {
      title: "Pedido",
      data: null,
      render: (_, __, pedido) => `<strong>#${pedido.id}</strong>`,
    },
    {
      title: "Cliente",
      data: null,
      render: (_, __, pedido) => pedido.cliente || "—",
    },
    {
      title: "Fecha",
      data: null,
      render: (_, __, pedido) => pedido.fecha || "—",
    },
    {
      title: "Productos",
      data: null,
      render: (_, __, pedido) => formatearProductos(pedido.productos),
    },
    {
      title: "Total",
      data: null,
      render: (_, __, pedido) => formatearTotal(pedido.total),
    },
    {
      title: "Estado",
      data: null,
      render: (_, __, pedido) =>
        `<span class="badge pedidos-cliente-badge ${badgeClase(pedido.estado)}">${pedido.estado}</span>`,
    },
    {
      title: "",
      data: null,
      orderable: false,
      searchable: false,
      render: (_, __, pedido) => `
        <div class="d-flex gap-2 pedidos-cliente-actions">
          <button class="btn btn-sm btn-outline-dark pedidos-cliente-btn btn-detalle-pedido" data-id="${pedido.id}">Ver detalles</button>
          <button class="btn btn-sm btn-danger pedidos-cliente-btn btn-cancelar-pedido" data-id="${pedido.id}">Cancelar</button>
        </div>
      `,
    },
  ];

  const columnasHistorial = [
    {
      title: "Pedido",
      data: null,
      render: (_, __, pedido) => `<strong>#${pedido.id}</strong>`,
    },
    {
      title: "Fecha",
      data: null,
      render: (_, __, pedido) => pedido.fecha || "—",
    },
    {
      title: "Productos",
      data: null,
      render: (_, __, pedido) => formatearProductos(pedido.productos),
    },
    {
      title: "Total",
      data: null,
      render: (_, __, pedido) => formatearTotal(pedido.total),
    },
    {
      title: "Estado",
      data: null,
      render: (_, __, pedido) =>
        `<span class="badge pedidos-cliente-badge ${badgeClase(pedido.estado)}">${pedido.estado}</span>`,
    },
    {
      title: "",
      data: null,
      orderable: false,
      searchable: false,
      render: (_, __, pedido) => `
        <button class="btn btn-sm btn-outline-secondary pedidos-cliente-btn btn-detalle-pedido" data-id="${pedido.id}">Ver detalles</button>
      `,
    },
  ];

  const crearOpcionesTabla = (estadoActual, setEstadoActual) => ({
    responsive: true,
    paging: true,
    searching: true,
    ordering: true,
    pageLength: 5,
    lengthChange: false,
    info: true,
    destroy: true,
    initComplete: function () {
      const api = this.api();
      const container = api.table().container();
      const existing = container.querySelector(".dt-custom-status-filter");

      if (existing) return;

      const wrapper = document.createElement("div");
      wrapper.className = "dt-custom-status-filter mb-3 d-flex justify-content-end";

      const label = document.createElement("label");
      label.className = "d-flex align-items-center gap-2 mb-0 text-white";
      label.innerHTML = "<span>Estado</span>";

      const select = document.createElement("select");
      select.className = "form-select pedidos-cliente-select";
      select.innerHTML = `
        <option value="Todos">Todos</option>
        <option value="Pendiente">Pendiente</option>
        <option value="Preparación">Preparación</option>
        <option value="En camino">En camino</option>
        <option value="Entregado">Entregado</option>
        <option value="Cancelado">Cancelado</option>
      `;
      select.value = estadoActual;
      select.onchange = (event) => setEstadoActual(event.target.value);

      label.appendChild(select);
      wrapper.appendChild(label);

      const target =
        container.querySelector(".dt-search") ||
        container.querySelector(".dataTables_filter");

      if (target) {
        target.insertAdjacentElement("afterend", wrapper);
      } else {
        container.prepend(wrapper);
      }
    },
    language: {
      search: "Buscar:",
      lengthMenu: "Mostrar _MENU_ registros",
      info: "Mostrando _START_ a _END_ de _TOTAL_ pedidos",
      infoEmpty: "No hay pedidos disponibles",
      zeroRecords: "No hay pedidos disponibles",
      paginate: {
        first: "Primero",
        last: "Último",
        next: "Siguiente",
        previous: "Anterior",
      },
    },
  });

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

      {/* Pedidos Activos */}
      <h3 className="fw-bold mb-4 text-white">
        <i className="fa-solid fa-cart-shopping text-warning me-2"></i>
        Pedidos Activos
      </h3>

      <div className="card shadow-sm border-0 mb-5">
        <div className="table-responsive pedidos-cliente-table-wrapper">
          <DataTable
            key={`activos-${filtroEstadoActivos}-${activos.length}`}
            id="tablaPedidosActivosCliente"
            data={activos}
            columns={columnasActivas}
            className="table table-hover align-middle mb-0 pedidos-cliente-table"
            options={{
              ...crearOpcionesTabla(filtroEstadoActivos, setFiltroEstadoActivos),
              createdRow: (row, pedido) => {
                row
                  .querySelector(".btn-detalle-pedido")
                  ?.addEventListener("click", () => setPedidoSeleccionado(pedido));
                row
                  .querySelector(".btn-cancelar-pedido")
                  ?.addEventListener("click", () => handleCancelar(pedido.id));
              },
            }}
          />
        </div>
      </div>

      {/* Historial */}
      <h3 className="fw-bold mb-4 text-white">
        <i className="fa-solid fa-clock-rotate-left me-2 text-secondary"></i>
        Historial de Pedidos
      </h3>

      <div className="card shadow-sm border-0">
        <div className="table-responsive pedidos-cliente-table-wrapper">
          <DataTable
            key={`historial-${filtroEstadoHistorial}-${historial.length}`}
            id="tablaPedidosHistorialCliente"
            data={historial}
            columns={columnasHistorial}
            className="table table-hover align-middle mb-0 pedidos-cliente-table"
            options={{
              ...crearOpcionesTabla(filtroEstadoHistorial, setFiltroEstadoHistorial),
              createdRow: (row, pedido) => {
                row
                  .querySelector(".btn-detalle-pedido")
                  ?.addEventListener("click", () => setPedidoSeleccionado(pedido));
              },
            }}
          />
        </div>
      </div>

      {/* MODAL DETALLE DEL PEDIDO */}
      <DetallePedidoModal
        pedido={pedidoSeleccionado}
        onClose={() => setPedidoSeleccionado(null)}
      />
    </main>
  );
}