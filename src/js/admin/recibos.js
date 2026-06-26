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
      Swal.fire({
        icon: "warning",
        title: "Campo requerido",
        text: "Por favor, seleccione una fecha para continuar.",
        confirmButtonColor: "#e67e22",
      });
      return;
    }

    Swal.fire({
      icon: "success",
      title: "¡Todo listo!",
      text: `Generando reporte ${tipo} para la fecha: ${fecha}`,
      confirmButtonColor: "#e67e22",
      showConfirmButton: true,
      timer: 3000,
    });
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
