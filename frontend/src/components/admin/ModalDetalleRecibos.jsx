import { formatearMoneda } from "../../utils/formatearMoneda.js";
import "../../assets/css/components/modaDetalleRecibos.css";

export default function ModalDetalleRecibo({ detalle, onClose }) {
  if (!detalle.idPedido) return null;

  const total = (detalle.productos ?? []).reduce(
    (suma, p) => suma + Number(p.subtotal || 0),
    0,
  );

  return (
    <div
      className="modal fade show d-block detalle-pedido-modal"
      tabIndex="-1"
      role="dialog"
      aria-modal="true"
      onClick={onClose}
    >
      <div
        className="modal-dialog modal-lg modal-dialog-centered"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">
              Detalle del pedido #{detalle.idPedido}
            </h5>
            <button
              type="button"
              className="btn-close"
              aria-label="Cerrar"
              onClick={onClose}
            ></button>
          </div>

          <div className="modal-body">
            {detalle.cargando ? (
              <p className="detalle-cargando">Cargando detalle...</p>
            ) : (
              <>
                <div className="table-responsive">
                  <table className="table table-striped table-hover mb-0">
                    <thead>
                      <tr>
                        <th>Producto</th>
                        <th className="text-end">Cantidad</th>
                        <th className="text-end">Precio</th>
                        <th className="text-end">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody>
                      {detalle.productos.map((p) => (
                        <tr key={p.id}>
                          <td>{p.producto}</td>
                          <td className="text-end">{p.cantidad}</td>
                          <td className="text-end">
                            {formatearMoneda(p.precio)}
                          </td>
                          <td className="text-end">
                            {formatearMoneda(p.subtotal)}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>

                <div className="total-pedido">
                  <span>Total</span>
                  <strong>{formatearMoneda(total)}</strong>
                </div>
              </>
            )}
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
