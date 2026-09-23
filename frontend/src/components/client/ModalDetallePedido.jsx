
function badgeClase(estado) {
  switch (estado) {
    case "Pendiente":
      return "badge-pendiente";
    case "Preparación":
      return "badge-preparacion";
    case "En camino":
      return "badge-camino";
    case "Entregado":
      return "badge-entregado";
    case "Cancelado":
      return "badge-cancelado";
    default:
      return "bg-light text-dark";
  }
}

function formatearTotal(total) {
  if (total == null) return "—";
  return `$${Number(total).toLocaleString("es-CO")}`;
}

export default function DetallePedidoModal({ pedido, onClose }) {
  if (!pedido) return null;

  return (
    <div
      className="detalle-pedido-modal modal fade show d-block"
      tabIndex="-1"
    >
      <div className="modal-dialog modal-lg modal-dialog-centered">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title fw-bold">
              <i className="fa-solid fa-receipt text-warning me-2"></i>
              Detalle del Pedido #{pedido.id}
            </h5>
            <button
              type="button"
              className="btn-close btn-close-white"
              onClick={onClose}
            ></button>
          </div>

          <div className="modal-body">
            <div className="row mb-3">
              <div className="col-md-6">
                <p className="mb-1">
                  <strong>Cliente:</strong> {pedido.cliente}
                </p>
                <p className="mb-1">
                  <strong>Teléfono:</strong> {pedido.telefono}
                </p>
              </div>
              <div className="col-md-6 text-md-end">
                <p className="mb-1">
                  <strong>Fecha:</strong> {pedido.fecha || "—"}
                </p>
                <p className="mb-1">
                  <strong>Estado: </strong>
                  <span className={`badge ${badgeClase(pedido.estado)}`}>
                    {pedido.estado}
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
                  {pedido.productos && pedido.productos.length > 0 ? (
                    pedido.productos.map((prod, index) => (
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

            <div className="total-pedido text-end mt-3 fw-bold fs-5">
              Total Pedido: {formatearTotal(pedido.total)}
            </div>
          </div>

          <div className="modal-footer">
            <button type="button" className="btn btn-cerrar" onClick={onClose}>
              Cerrar
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}