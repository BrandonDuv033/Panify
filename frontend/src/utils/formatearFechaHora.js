export const formatearFechaHora = (fecha) => {
  if (!fecha) return "Sin fecha";

  const fechaHora = new Date(fecha);

  if (Number.isNaN(fechaHora.getTime())) {
    return fecha;
  }

  return fechaHora.toLocaleString("es-CO", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  });
};
