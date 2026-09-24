import { useEffect, useState } from "react";
import { obtenerPerfilUsuario, actualizarPerfilUsuario } from "../../services/users";

export default function Profile() {
  const [perfil, setPerfil] = useState(null);
  const [formData, setFormData] = useState({
    nombre: "",
    apellido: "",
    email: "",
    telefono: "",
    direccion: "",
    ciudad: "",
  });

  const [cargando, setCargando] = useState(true);
  const [guardando, setGuardando] = useState(false);
  const [error, setError] = useState(null);
  const [mensajeExito, setMensajeExito] = useState(null);

  useEffect(() => {
    async function cargar() {
      try {
        setCargando(true);
        const usuarioGuardado = JSON.parse(localStorage.getItem("usuario") || "null");
        const userId = usuarioGuardado?.cliente_idCliente ?? usuarioGuardado?.idCliente ?? usuarioGuardado?.id ?? 1;

        const data = await obtenerPerfilUsuario(userId);
        setPerfil(data);
        setFormData({
          nombre: data.nombre,
          apellido: data.apellido,
          email: data.email,
          telefono: data.telefono,
          direccion: data.direccion,
          ciudad: data.ciudad,
        });
      } catch (err) {
        setError(err.message);
      } finally {
        setCargando(false);
      }
    }
    cargar();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setGuardando(true);
    setMensajeExito(null);

    try {
      const usuarioGuardado = JSON.parse(localStorage.getItem("usuario") || "null");
      const usuarioId = perfil?.usuarioId ?? usuarioGuardado?.idUsuario ?? usuarioGuardado?.id;
      const clienteId = perfil?.clienteId ?? usuarioGuardado?.cliente_idCliente;

      await actualizarPerfilUsuario(usuarioId, clienteId, formData);

      const perfilActualizado = {
        ...perfil,
        ...formData,
        email: formData.email,
        telefono: formData.telefono,
        direccion: formData.direccion,
        ciudad: formData.ciudad,
      };

      setPerfil(perfilActualizado);

      if (usuarioGuardado) {
        localStorage.setItem(
          "usuario",
          JSON.stringify({
            ...usuarioGuardado,
            nombre: formData.nombre,
            apellido: formData.apellido,
            correo: formData.email,
            email: formData.email,
            telefono: formData.telefono,
            direccion: formData.direccion,
            ciudad: formData.ciudad,
          })
        );
      }

      setMensajeExito("¡Tus datos personales se han actualizado correctamente!");
    } catch (err) {
      alert("Error al actualizar la información: " + err.message);
    } finally {
      setGuardando(false);
    }
  };

  if (cargando) {
    return (
      <main className="container py-5 text-white text-center">
        <p>Cargando información personal...</p>
      </main>
    );
  }

  if (error || !perfil) {
    return (
      <main className="container py-5 text-white text-center">
        <p>Error al cargar la información: {error}</p>
      </main>
    );
  }

  return (
    <main className="container py-5 panify-profile-container text-white">
      {/* Encabezado del Perfil */}
      <div className="card panify-profile-card p-4 mb-4">
        <div className="d-flex align-items-center gap-4 flex-wrap">
          <div className="panify-profile-avatar-wrapper">
            {perfil.avatarUrl ? (
              <img
                src={perfil.avatarUrl}
                alt={perfil.nombre}
                className="panify-profile-avatar-img"
              />
            ) : (
              <span>{perfil.iniciales}</span>
            )}
          </div>

          <div>
            <h2 className="fw-bold mb-1">
              {perfil.nombre} {perfil.apellido}
            </h2>
            <p className="text-light mb-1">
              <i className="fa-solid fa-envelope me-2 text-warning"></i>
              {perfil.email}
            </p>
            <small className="text-muted">
              <i className="fa-solid fa-bag-shopping me-1"></i>
              Total pedidos en la plataforma: {perfil.totalPedidosRealizados}
            </small>
          </div>
        </div>
      </div>

      {/* Formulario de Datos Personales */}
      <div className="card panify-profile-card p-4">
        <h4 className="panify-profile-title mb-3">
          <i className="fa-solid fa-user-gear me-2"></i>Mis Datos Personales
        </h4>
        <p className="text-light small mb-4">
          Actualiza tu información de contacto y dirección para la entrega de tus pedidos.
        </p>

        {mensajeExito && (
          <div className="alert alert-success d-flex align-items-center" role="alert">
            <i className="fa-solid fa-circle-check me-2"></i>
            <div>{mensajeExito}</div>
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="row g-3 mb-3">
            <div className="col-md-6">
              <label className="form-label text-light">Nombre</label>
              <input
                type="text"
                className="form-control panify-profile-input"
                name="nombre"
                value={formData.nombre}
                onChange={handleChange}
                required
              />
            </div>

            <div className="col-md-6">
              <label className="form-label text-light">Apellido</label>
              <input
                type="text"
                className="form-control panify-profile-input"
                name="apellido"
                value={formData.apellido}
                onChange={handleChange}
                required
              />
            </div>
          </div>

          <div className="row g-3 mb-3">
            <div className="col-md-6">
              <label className="form-label text-light">Correo Electrónico</label>
              <input
                type="email"
                className="form-control panify-profile-input"
                name="email"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="col-md-6">
              <label className="form-label text-light">Teléfono / WhatsApp</label>
              <input
                type="tel"
                className="form-control panify-profile-input"
                name="telefono"
                value={formData.telefono}
                onChange={handleChange}
                required
              />
            </div>
          </div>

          <div className="row g-3 mb-4">
            <div className="col-md-8">
              <label className="form-label text-light">Dirección de Entrega</label>
              <input
                type="text"
                className="form-control panify-profile-input"
                name="direccion"
                value={formData.direccion}
                onChange={handleChange}
                placeholder="Ej. Calle 15 # 8-24"
              />
            </div>

            <div className="col-md-4">
              <label className="form-label text-light">Ciudad</label>
              <input
                type="text"
                className="form-control panify-profile-input"
                name="ciudad"
                value={formData.ciudad}
                onChange={handleChange}
              />
            </div>
          </div>

          <div className="text-end">
            <button
              type="submit"
              className="btn btn-warning fw-bold px-4"
              disabled={guardando}
            >
              {guardando ? (
                <>
                  <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                  Guardando...
                </>
              ) : (
                <>
                  <i className="fa-solid fa-floppy-disk me-2"></i>
                  Guardar Cambios
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </main>
  );
}