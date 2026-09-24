export default function ModalDetallePedido({
  pedidoSeleccionado,
  cerrarDetalle,
  guardarCambiosEstado,
  nuevoEstado,
  setNuevoEstado,
}) {
  if (!pedidoSeleccionado) return null;

  return (
    <div
      className="modal-detalle-overlay"
      onClick={cerrarDetalle}
    >
      <div
        className="modal-actualizar"
        onClick={(e) => e.stopPropagation()}
      >
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
                <strong>ID del pedido:</strong>{" "}
                {pedidoSeleccionado.id}

                <br />

                <strong>Nombre del Cliente:</strong>{" "}
                {pedidoSeleccionado.nombreCliente}

                <br />

                <strong>Dirección:</strong>{" "}
                {pedidoSeleccionado.direccion}

                <br />

                <strong>Pedido:</strong>{" "}
                {pedidoSeleccionado.pedidoRealizado}

                <br />

                <strong>Estado Actual:</strong>{" "}
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
  );
}