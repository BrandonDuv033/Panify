import { Link, useNavigate } from "react-router-dom";

import { obtenerNombreUsuarioActual } from "../../services/auth.js";

import "../../assets/css/pages/inicio.css";

import imagenblandito from "../../assets/img/pan-blandito.jpg";
import imagencorisant from "../../assets/img/croissant.jfif";
import imagenFrances from "../../assets/img/frances.jfif";

import { useEffect, useState } from "react";

import {
  obtenerPedidosCliente
} from "../../services/clienteService.js";

function formatoPrecio(valor) {
  return valor.toLocaleString("es-CO", {
    style: "currency",
    currency: "COP",
    minimumFractionDigits: 0
  });
}

function obtenerImagenProducto(id) {
  if (id === 1) {
    return imagenblandito;
  }

  if (id === 2) {
    return imagencorisant;
  }

  if (id === 3) {
    return imagenFrances;
  }

  return null;
}

export default function InicioCliente() {
  const navigate = useNavigate();

  const nombreUsuario = obtenerNombreUsuarioActual();

  const [carrito, setcarrito] = useState([]);
  const [pedido, setpedido] = useState([]);

  useEffect(() => {
    const cargarDatos = async () => {
      try {
        const usuario = JSON.parse(
          localStorage.getItem("usuario")
        );

        const clienteId = usuario.cliente_idCliente;

        const pedidosCliente =
          await obtenerPedidosCliente(clienteId);

        setpedido(pedidosCliente);

        const carritoGuardado =
          JSON.parse(
            localStorage.getItem("carrito")
          ) || [];

        setcarrito(carritoGuardado);
      } catch (error) {
        console.error(
          "Error al cargar los Datos:",
          error
        );
      }
    };

    cargarDatos();
  }, []);

  useEffect(() => {
    const actualizarCarrito = () => {
      const carritoGuardado =
        JSON.parse(
          localStorage.getItem("carrito")
        ) || [];

      setcarrito(carritoGuardado);
    };

    window.addEventListener(
      "storage",
      actualizarCarrito
    );

    return () => {
      window.removeEventListener(
        "storage",
        actualizarCarrito
      );
    };
  }, []);

  const totalProductos = carrito.reduce(
    (total, item) =>
      total + item.cantidad,
    0
  );

  const subtotal = carrito.reduce(
    (total, item) =>
      total +
      item.precio * item.cantidad,
    0
  );

  return (
    <>
      <main className="container py-5 inicio-cliente">
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
                <h5 className="fw-bold m-0 carrito-inicio">
                  <i className="fa-solid fa-basket-shopping me-2 letra-Listo"></i>

                  Tu Carrito
                </h5>

                <span className="badge border rounded-pill px-3 py-2 fw-semibold text-white producto-cliente">
                  {totalProductos} Productos
                </span>
              </div>

              <div className="mb-4">
                {carrito.length === 0 ? (
                  <p className="text-white text-center">
                    Tu carrito está vacío.
                  </p>
                ) : (
                  carrito.map((item) => (
                    <div
                      key={item.id}
                      className="d-flex align-items-center justify-content-between item-carrito"
                    >
                      {obtenerImagenProducto(
                        item.id
                      ) && (
                        <img
                          src={obtenerImagenProducto(
                            item.id
                          )}
                          alt={item.nombre}
                          className="imagen-producto"
                        />
                      )}

                      <div>
                        <h6 className="m-0 fw-semibold letra-cantidad">
                          {item.nombre}
                        </h6>

                        <small>
                          Cantidad: {item.cantidad}
                        </small>
                      </div>

                      <span className="fw-bold">
                        {formatoPrecio(
                          item.precio *
                            item.cantidad
                        )}
                      </span>
                    </div>
                  ))
                )}
              </div>

              <div className="precio-container p-3 rounded-3 mb-4">
                <div className="d-flex align-items-center justify-content-between mb-2">
                  <span className="text-light small">
                    Subtotal
                  </span>

                  <span className="fw-semibold text-white">
                    {formatoPrecio(subtotal)}
                  </span>
                </div>

                <div className="d-flex align-items-center justify-content-between border-top text-white pt-2">
                  <span className="fw-bold">
                    Total Estimado
                  </span>

                  <span className="fw-bold fs-5">
                    {formatoPrecio(subtotal)}
                  </span>
                </div>
              </div>

              <button
                className="btn btn-finalizar w-100 d-flex align-items-center justify-content-center gap-2 pagar-inicio"
                disabled={carrito.length === 0}
              >
                <span>
                  Proceder a pagar
                </span>

                <i className="fa-solid fa-arrow-right fs-6"></i>
              </button>
            </div>
          </div>

          <div className="col-lg-7">
            <div className="custom-card p-4 h-100">
              <div className="d-flex align-items-center justify-content-between mb-4">
                <h5 className="fw-bold m-0 estado-inicio">
                  <i className="fa-regular fa-bell me-2"></i>

                  Estado de Pedidos Recientes
                </h5>

                <Link
                  to="/mis-pedidos"
                  className="btn btn-link btn-historial text-decoration-none p-0"
                >
                  Ver todo el historial
                </Link>
              </div>

              <div className="d-flex flex-column gap-3">
                {pedido.map((pedido) => (
                  <div
                    key={pedido.id}
                    className="p-3 border rounded-3 pedido-row d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3"
                  >
                    <div className="d-flex align-items-center gap-3">
                      <div
                        className={`bg-status p-2 rounded-3 text-center d-none d-sm-block ${
                          pedido.estadoPedido ===
                          "Entregado"
                            ? "bg-success bg-opacity-10 text-success"
                            : "bg-warning bg-opacity-10 text-warning"
                        }`}
                      >
                        <i
                          className={`fs-5 mt-1 ${
                            pedido.estadoPedido ===
                            "Entregado"
                              ? "fa-solid fa-truck-ramp-box text-white"
                              : "fa-solid fa-fire-burner"
                          }`}
                        ></i>
                      </div>

                      <div>
                        <div className="d-flex align-items-center gap-2 numero-pedido">
                          <h6 className="m-0 fw-bold">
                            Pedido #
                            {pedido.idPedido}
                          </h6>
                        </div>

                        <span className="text-white small">
                          Pedido •{" "}
                          {
                            pedido.fechaHoraCreacion
                          }
                        </span>
                      </div>
                    </div>

                    <div>
                      {pedido.estadoPedido ===
                      "Entregado" ? (
                        <span className="estado-badge estado-entregado d-inline-block">
                          <i className="fa-solid fa-circle-check me-2"></i>

                          Entregado
                        </span>
                      ) : (
                        <span className="estado-badge estado-preparacion d-inline-block">
                          <i className="fa-solid fa-spinner fa-spin me-2"></i>

                          {pedido.estadoPedido}
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