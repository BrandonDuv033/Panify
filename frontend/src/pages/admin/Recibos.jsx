import DataTable from "datatables.net-react";
import DT from "datatables.net-bs5";
import "datatables.net-bs5/css/dataTables.bootstrap5.min.css";
import { obtenerRecibos } from "../../services/recibos.js";
import { useState, useEffect } from "react";
import Swal from "sweetalert2";

export default function recibos() {
  DataTable.use(DT);

  const columnas = [
    { title: "ID", data: "id" },
    { title: "Cliente", data: "nombreCliente" },
    {
      title: "Fecha emisión",
      data: "fechaEmision",
      render: (data) => formatearFechaHora(data),
    },
    {
      title: "Total",
      data: "totalPagar",
      render: (data) => formatearMoneda(data),
    },
    {
      title: "Estado",
      data: null,
      render: () => '<span class="badge bg-success">Pagado</span>',
    },
    {
      title: "Recibo",
      data: null,
      orderable: false,
      render: () =>
        `<button class="btn btn-sm btn-outline-primary btn-recibo">
          <i class="fa-solid fa-file-pdf me-1"></i> Ver recibo
        </button>`,
    },
  ];

  const [recibos, setRecibos] = useState([]);
  const [busqueda, setBusqueda] = useState("");
  const [cargando, setCargando] = useState(true);

  useEffect(() => {
    async function cargarRecibos() {
      try {
        const recibos = await obtenerRecibos();
        setRecibos(recibos);
      } catch (error) {
        console.error("Error al cargar recibos:", error);
        Swal.fire("Error", "No se pudieron cargar los recibos.", "error");
      } finally {
        setCargando(false);
      }
    }

    cargarRecibos();
  }, []);

  const formatearFechaHora = (fecha) => {
    if (!fecha) return "Sin fecha";

    const fechaHora = new Date(fecha);

    if (Number.isNaN(fechaHora.getTime())) {
      return fecha;
    }

    return fechaHora.toLocaleString("es-CO", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
    });
  };

  const formatearMoneda = (moneda) => {
    if (!moneda) return "$0";

    return new Intl.NumberFormat("es-CO", {
      style: "currency",
      currency: "COP",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(moneda);
  };

  return (
    <main className="dashboard-main">
      <header className="topbar">
        <button className="mobile-toggle-btn" id="menuToggle">
          <i className="fa-solid fa-bars"></i>
        </button>

        <div>
          <h1>Recibos</h1>
          <p className="d-none d-sm-block">
            Historial y consulta de comprobantes generados automáticamente.
          </p>
        </div>

        <div className="admin-info">
          <i className="fa-solid fa-circle-user"></i>
          <span>Administrador</span>
        </div>
      </header>

      <section className="panel tabla p-4 bg-white">
        <div className="cabecera-tabla mb-4">
          <div>
            <h2>Gestión de recibos</h2>
            <p>Visualiza, filtra y descarga las facturas de venta.</p>
          </div>
        </div>

        <div className="table-responsive">
          <DataTable
            id="tablaRecibos"
            data={recibos}
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
                info: "Mostrando _START_ a _END_ de _TOTAL_ recibos",
                infoEmpty: "No hay recibos disponibles",
                zeroRecords: "No se encontraron recibos",
                paginate: {
                  first: "Primero",
                  last: "Último",
                  next: "Siguiente",
                  previous: "Anterior",
                },
              },
            }}
          />
        </div>
      </section>

      <hr className="mx-3 my-4" />

      <section className="panel reporte my-4 mx-3 p-4 bg-white rounded shadow-sm">
        <div className="mb-3">
          <h2>
            <i className="fa-solid fa-chart-line me-1"></i>
            Reporte Ventas
          </h2>
          <p>
            Configura los parámetros para exportar las estadísticas de
            facturación.
          </p>
        </div>

        <form id="formReporte" className="row g-3 align-items-end reporte-form">
          <div className="col-12 col-md-4">
            <label
              htmlFor="tipo-reporte"
              className="form-label font-weight-bold reporte-label"
            >
              Tipo de Reporte
            </label>
            <div className="input-group">
              <span className="input-group-text reporte-icon-box">
                <span className="material-symbols-outlined fs-5 reporte-icon">
                  <i className="fa-solid fa-calendar-day"></i>{" "}
                </span>
              </span>
              <select id="tipo-reporte" className="form-select reporte-select">
                <option value="diario">Diario</option>
                <option value="semanal">Semanal</option>
                <option value="mensual">Mensual</option>
              </select>
            </div>
          </div>

          <div className="col-12 col-md-4">
            <label htmlFor="fecha-reporte" className="form-label reporte-label">
              Seleccionar Fecha
            </label>
            <div className="input-group">
              <span className="input-group-text reporte-icon-box">
                <span className="material-symbols-outlined fs-5 reporte-icon">
                  <i className="fa-regular fa-calendar-days"></i>
                </span>
              </span>
              <input
                type="text"
                id="fecha-reporte"
                className="form-control reporte-input"
                placeholder="Elija una fecha..."
              />
            </div>
          </div>

          <div className="col-12 col-md-4">
            <button
              type="submit"
              className="btn btn-primary w-100 py-2 reporte-btn"
            >
              <i className="fa-solid fa-file-invoice-dollar me-2"></i>Generar
              Reporte
            </button>
          </div>
        </form>
      </section>
    </main>
  );
}
