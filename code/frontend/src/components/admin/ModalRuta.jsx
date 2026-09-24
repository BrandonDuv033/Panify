export default function ModalRuta({
  pedidoRuta,
  cerrarRuta,
  direccionMapa,
}) {
  if (!pedidoRuta) return null;

  return (
    <div
      className="modal-ruta-overlay"
      onClick={cerrarRuta}
    >
      <div
        className="modal-ruta"
        onClick={(e) => e.stopPropagation()}
      >
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
              <strong>Cliente:</strong>{" "}
              {pedidoRuta.nombreCliente}
            </p>

            <p>
              <strong>Dirección:</strong>{" "}
              {pedidoRuta.direccion}
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
  );
}