// components/usuarios/EditarUsuarioModal.jsx
import { useEffect, useState } from "react";
import Modal from "./Modal.jsx";

const ROLES = [
  { id: 1, nombre: "Cliente" },
  { id: 2, nombre: "Domiciliario" },
  { id: 3, nombre: "Panador" },
];

const estadoInicial = (usuario) => ({
  nombre: usuario?.nombre ?? "",
  apellido: usuario?.apellido ?? "",
  correo: usuario?.correo ?? usuario?.email ?? "",
  telefono: usuario?.telefono ?? "",
  Rol_idRol: Number(usuario?.Rol_idRol) || 1,
  estado: usuario?.estado ?? "Activo",
});

export default function EditarUsuarioModal({
  abierto,
  usuario,
  onCerrar,
  onGuardar,
}) {
  const [form, setForm] = useState(estadoInicial(usuario));
  const [error, setError] = useState("");
  const [guardando, setGuardando] = useState(false);

  // Cada vez que se abre con otro usuario, se reinicia el formulario
  useEffect(() => {
    if (abierto) {
      setForm(estadoInicial(usuario));
      setError("");
    }
  }, [abierto, usuario]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({
      ...prev,
      [name]: name === "Rol_idRol" ? Number(value) : value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const nombre = form.nombre.trim();
    const apellido = form.apellido.trim();
    const correo = form.correo.trim();

    if (!nombre || !apellido || !correo) {
      setError("Nombre, apellido y correo son obligatorios.");
      return;
    }

    setGuardando(true);
    setError("");
    try {
      await onGuardar({
        nombre,
        apellido,
        correo,
        email: correo,
        telefono: form.telefono.trim(),
        Rol_idRol: form.Rol_idRol,
        estado: form.estado,
      });
    } catch {
      setError("No se pudo actualizar el usuario.");
    } finally {
      setGuardando(false);
    }
  };

  return (
    <Modal
      abierto={abierto}
      titulo={`Editar usuario #${usuario?.id ?? ""}`}
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
          Apellido
          <input
            name="apellido"
            value={form.apellido}
            onChange={handleChange}
          />
        </label>

        <label>
          Correo
          <input
            name="correo"
            type="email"
            value={form.correo}
            onChange={handleChange}
          />
        </label>

        <label>
          Teléfono
          <input
            name="telefono"
            value={form.telefono}
            onChange={handleChange}
          />
        </label>

        <label>
          Rol
          <select
            name="Rol_idRol"
            value={form.Rol_idRol}
            onChange={handleChange}
          >
            {ROLES.map((rol) => (
              <option key={rol.id} value={rol.id}>
                {rol.nombre}
              </option>
            ))}
          </select>
        </label>

        <label>
          Estado
          <select name="estado" value={form.estado} onChange={handleChange}>
            <option value="Activo">Activo</option>
            <option value="Inactivo">Inactivo</option>
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
