$(document).ready(function () {
  // Toggle sidebar en móvil
  $("#menuToggle").on("click", function () {
    $("#sidebar").addClass("open");
    $("#sidebarOverlay").fadeIn();
  });

  $("#sidebarOverlay").on("click", function () {
    $("#sidebar").removeClass("open");
    $("#sidebarOverlay").fadeOut();
  });

  // Inicializar DataTable
  if (!$.fn.DataTable.isDataTable("#tablaUsuarios")) {
    $("#tablaUsuarios").DataTable({
      pageLength: 10,
      ordering: true,
      searching: true,
    });
  }

  // Evento para eliminar usuario
  $(document).on("click", ".btn-outline-danger", function () {
    const row = $(this).closest("tr");
    const userName = row.find("td").eq(1).text(); // Obtener el nombre del usuario

    Swal.fire({
      title: "¿Estás seguro?",
      text: `¿Deseas eliminar a ${userName}?`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#dc3545",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    }).then((result) => {
      if (result.isConfirmed) {
        row.fadeOut(300, function () {
          $(this).remove();
          $("#tablaUsuarios").DataTable().row.remove().draw();
        });

        Swal.fire({
          title: "Eliminado",
          text: `${userName} ha sido eliminado correctamente.`,
          icon: "success",
          timer: 2000,
        });
      }
    });
  });
});
