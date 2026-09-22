import { Link, useNavigate } from "react-router-dom";
import { obtenerNombreUsuarioActual } from "../../services/auth.js";
import "../../assets/css/pages/inicio.css"
import "../../assets/img/rollo.jpg"
import imagenblandito from "../../assets/img/pan-blandito.jpg"
import imagenRollo from "../../assets/img/rollo.jpg"

const carritoEjemplo = [
  { id: 1, nombre: "Pan Blandito (Paquete x10)", cantidad: 2, precio: 6000 ,
    imagen:imagenblandito
  },
  { id: 2, nombre: "Pan Rollo (Paquete x5)", cantidad: 1, precio: 4000 , imagen:imagenRollo},
];

const pedidosEjemplo = [
  {
    id: "002",
    origen: "Fábrica de Pan",
    fecha: "Hoy, 11:15 AM",
    estado: "preparacion",
  },
  {
    id: "001",
    origen: "Entregado por domiciliario",
    fecha: "Ayer",
    estado: "entregado",
  },
];

function formatoPrecio(valor) {
  return valor.toLocaleString("es-CO", {
    style: "currency",
    currency: "COP",
    minimumFractionDigits: 0,
  });
}

export default function InicioCliente() {
  const navigate = useNavigate();
  const nombreUsuario = obtenerNombreUsuarioActual();

  const subtotal = carritoEjemplo.reduce(
    (total, item) => total + item.precio,
    0
  );
  const totalProductos = carritoEjemplo.reduce(
    (total, item) => total + item.cantidad,
    0
  );

  const handleLogout = () => {
    localStorage.removeItem("usuario");
    navigate("/");
  };

  return (
    <>
      

      <main className="container py-5">
        <div className="row mb-4">
          <div className="col-12">
            <h1 className="fw-bold text-white m-0">
              ¡Bienvenido de nuevo, {nombreUsuario}!
            </h1>
          </div>
        </div>

        <div className="row g-4">
          <div className="col-lg-5">
            <div className="custom-card p-4">
              <div className="d-flex align-items-center justify-content-between mb-4">
                <h5 className="fw-bold m-0">
                  <i className="fa-solid fa-basket-shopping me-2"></i>Tu
                  Carrito
                </h5>
                <span className="badge border rounded-pill px-3 py-2 fw-semibold text-white">
                  {totalProductos} Productos
                </span>
              </div>

              <div className="mb-4">
                {carritoEjemplo.map((item) => (
                  <div
                    key={item.id}
                    className="d-flex align-items-center justify-content-between item-carrito"
                  >
                    {item.imagen && (

                      <img

                        src={item.imagen}

                        alt={item.nombre}

                        className="imagen-producto"

                      />)}

                    
                    
                    <div>
                      <h6 className="m-0 fw-semibold">{item.nombre}</h6>
                      <small>Cantidad: {item.cantidad}</small>
                    </div>
                    <span className="fw-bold">
                      {formatoPrecio(item.precio)}
                    </span>
                  </div>
                ))}
              </div>

              <div className="precio-container p-3 rounded-3 mb-4">
                <div className="d-flex align-items-center justify-content-between mb-2">
                  <span className="text-light small">Subtotal</span>
                  <span className="fw-semibold text-white">
                    {formatoPrecio(subtotal)}
                  </span>
                </div>
                <div className="d-flex align-items-center justify-content-between border-top text-white pt-2">
                  <span className="fw-bold">Total Estimado</span>
                  <span className="fw-bold fs-5">
                    {formatoPrecio(subtotal)}
                  </span>
                </div>
              </div>

              <button className="btn btn-finalizar w-100 d-flex align-items-center justify-content-center gap-2" >
                <span>Proceder a pagar</span>
                <i className="fa-solid fa-arrow-right fs-6"></i>
              </button>
            </div>
          </div>

          <div className="col-lg-7">
            <div className="custom-card p-4 h-100">
              <div className="d-flex align-items-center justify-content-between mb-4">
                <h5 className="fw-bold m-0">
                  <i className="fa-regular fa-bell me-2"></i>Estado de
                  Pedidos Recientes
                </h5>
                <Link
                  to="/pedidos"
                  className="btn btn-link btn-historial text-decoration-none p-0"
                >
                  Ver todo el historial
                </Link>
              </div>

              <div className="d-flex flex-column gap-3">
                {pedidosEjemplo.map((pedido) => (
                  <div
                    key={pedido.id}
                    className="p-3 border rounded-3 pedido-row d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3"
                  >
                    <div className="d-flex align-items-center gap-3">
                      <div
                        className={`bg-status p-2 rounded-3 text-center d-none d-sm-block ${
                          pedido.estado === "entregado"
                            ? "bg-success bg-opacity-10 text-success"
                            : "bg-warning bg-opacity-10 text-warning"
                        }`}
                      >
                        <i
                          className={`fs-5 mt-1 ${
                            pedido.estado === "entregado"
                              ? "fa-solid fa-truck-ramp-box text-white"
                              : "fa-solid fa-fire-burner"
                          }`}
                        ></i>
                      </div>
                      <div>
                        <div className="d-flex align-items-center gap-2">
                          <h6 className="m-0 fw-bold">
                            Pedido #{pedido.id}
                          </h6>
                        </div>
                        <span className="text-white small">
                          {pedido.origen} • {pedido.fecha}
                        </span>
                      </div>
                    </div>
                    <div>
                      {pedido.estado === "entregado" ? (
                        <span className="estado-badge estado-entregado d-inline-block">
                          <i className="fa-solid fa-circle-check me-2"></i>
                          Entregado
                        </span>
                      ) : (
                        <span className="estado-badge estado-preparacion d-inline-block">
                          <i className="fa-solid fa-spinner fa-spin me-2"></i>
                          Preparando
                        </span>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </main>

     
    </>
  );
}
