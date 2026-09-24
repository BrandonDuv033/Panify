import Swal from "sweetalert2";
import { formatearMoneda } from "../../utils/formatearMoneda.js";

export default function ModalDetalleRecibo({ detalle, onClose }) {
  if (!detalle.idPedido) return null;

  return (
    <div
      className="modal fade show d-block"
      tabIndex="-1"
      role="dialog"
      style={{ backgroundColor: "rgba(0, 0, 0, 0.5)" }}
    >
      <div className="modal-dialog modal-lg modal-dialog-centered">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">
              Detalle del pedido #{detalle.idPedido}
            </h5>
            <button
              type="button"
              className="btn-close"
              onClick={onClose}
            ></button>
          </div>

          <div className="modal-body">
            {detalle.cargando ? (
              <p>Cargando detalle...</p>
            ) : (
              <div className="table-responsive">
                <table className="table table-bordered">
                  <thead>
                    <tr>
                      <th>Producto</th>
                      <th>Cantidad</th>
                      <th>Precio</th>
                      <th>Subtotal</th>
                    </tr>
                  </thead>
                  <tbody>
                    {detalle.productos.map((p) => (
                      <tr key={p.id}>
                        <td>{p.producto}</td>
                        <td>{p.cantidad}</td>
                        <td>{formatearMoneda(p.precio)}</td>
                        <td>{formatearMoneda(p.subtotal)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          <div className="modal-footer">
            <button className="btn btn-secondary" onClick={onClose}>
              Cerrar
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
