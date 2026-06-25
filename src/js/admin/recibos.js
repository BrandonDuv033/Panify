$(document).ready(function () {
  // Inicializar DataTable en español
  $("#tablaRecibos").DataTable({
    language: {
      url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json",
    },
    responsive: true,
    pageLength: 5,
    lengthMenu: [5, 10, 15, 20],
  });

  flatpickr("#fecha-reporte", {
    locale: "es",
    dateFormat: "d/m/Y",
    allowInput: true,
    disableMobile: "true",
  });

  $("#formReporte").on("submit", function (e) {
    e.preventDefault();
    const tipo = $("#tipo-reporte").val();
    const fecha = $("#fecha-reporte").val();

    if (!fecha) {
      alert("Por favor seleccione una fecha.");
      return;
    }
    alert(`Generando reporte ${tipo} para la fecha: ${fecha}`);
  });

  $("#menuToggle").on("click", function () {
    $("#sidebar").addClass("open");
    $("#sidebarOverlay").fadeIn();
  });

  $("#sidebarOverlay").on("click", function () {
    $("#sidebar").removeClass("open");
    $("#sidebarOverlay").fadeOut();
  });
});
