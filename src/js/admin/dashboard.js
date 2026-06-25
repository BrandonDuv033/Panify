$(document).ready(function () {
  // Eventos para abrir/cerrar el menú responsivo lateral
  $("#menuToggle").on("click", function () {
    $("#sidebar").addClass("open");
    $("#sidebarOverlay").fadeIn();
  });

  $("#sidebarOverlay").on("click", function () {
    $("#sidebar").removeClass("open");
    $("#sidebarOverlay").fadeOut();
  });
});
