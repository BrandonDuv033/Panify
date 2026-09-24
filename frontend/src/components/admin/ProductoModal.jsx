import { useEffect, useState } from "react";
import Modal from "./Modal.jsx";

const estadoInicial = (producto) => ({
  nombre: producto?.nombre ?? "",
  descripcion: producto?.descripcion ?? "",
  precio: producto?.precio ?? "",
  estado: producto?.estado ?? "Disponible",
});

export default function ProductoModal({
  abierto,
  producto,
  onCerrar,
  onGuardar,
}) {
  const [form, setForm] = useState(estadoInicial(producto));
  const [error, setError] = useState("");
  const [guardando, setGuardando] = useState(false);
  const editando = Boolean(producto);

  useEffect(() => {
    if (abierto) {
      setForm(estadoInicial(producto));
      setError("");
    }
  }, [abierto, producto]);

  const handleChange = (event) => {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    const nombre = form.nombre.trim();
    const descripcion = form.descripcion.trim();
    const precio = Number(form.precio);

    if (!nombre || !descripcion || !Number.isFinite(precio) || precio <= 0) {
      setError("Nombre, descripción y un precio mayor que cero son obligatorios.");
      return;
    }

    setGuardando(true);
    setError("");

    try {
      await onGuardar({
        nombre,
        descripcion,
        precio,
        estado: form.estado,
      });
    } catch (saveError) {
      console.error("Error al guardar producto:", saveError);
      setError(
        editando
          ? "No se pudo actualizar el producto."
          : "No se pudo agregar el producto.",
      );
    } finally {
      setGuardando(false);
    }
  };

  return (
    <Modal
      abierto={abierto}
      titulo={`${editando ? "Editar" : "Agregar"} producto${producto?.id ? ` #${producto.id}` : ""}`}
      onCerrar={onCerrar}
    >
      <form className="form-modal" onSubmit={handleSubmit} noValidate>
        <label>
          Nombre
          <input
            name="nombre"
            value={form.nombre}
            onChange={handleChange}
            autoFocus
          />
        </label>

        <label>
          Descripción
          <input
            name="descripcion"
            value={form.descripcion}
            onChange={handleChange}
          />
        </label>

        <label>
          Precio
          <input
            name="precio"
            type="number"
            min="1"
            step="1"
            value={form.precio}
            onChange={handleChange}
          />
        </label>

        <label>
          Estado
          <select name="estado" value={form.estado} onChange={handleChange}>
            <option value="Disponible">Disponible</option>
            <option value="Agotado">Agotado</option>
          </select>
        </label>

        {error && <p className="error">{error}</p>}

        <div className="form-modal-acciones">
          <button
            type="button"
            className="btn-modal btn-modal-cancelar"
            onClick={onCerrar}
            disabled={guardando}
          >
            Cancelar
          </button>
          <button
            type="submit"
            className="btn-modal btn-modal-guardar"
            disabled={guardando}
          >
            {guardando ? "Guardando..." : "Guardar cambios"}
          </button>
        </div>
      </form>
    </Modal>
  );
}
