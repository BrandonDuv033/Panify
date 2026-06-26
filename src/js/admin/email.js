$(document).ready(function () {
  $("#tablaUsuarios").DataTable({
    language: {
      search: "Buscar",
      lengthMenu: "Mostrar _MENU_    Registro",
      info: "Mostrar _START_ a _END_ de _TOTAL_ registros",
      infoEmpty: "Mostrando 0 a 0 de 0 registros",
      zeroRecords: "No se encontraron resultados",
      emptyTable: "No hay datos disponibles en la tabla",
      paginate: {
        first: "Primero",
        last: "Último",
        next: "Siguiente",
        previous: "Anterior",
      },
    },
  });
});

document.querySelectorAll(".btnEliminar").forEach(function (boton) {
  boton.addEventListener("click", function () {
    Swal.fire({
      title: "¿Estás seguro?",
      text: "Usuario eliminado",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD403A",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire({
          icon: "success",
          title: "Eliminado",
          text: "El usuario fue eliminado correctamente",
          confirmButtonColor: "#37ac1d",
        });
      }
    });
  });
});

$("#tablaUsuarios").on("click", ".btnEditar", function () {

    let fila = $(this).closest("tr");

    let identificacion = fila.find("td:eq(0)").text();
    let nombre = fila.find("td:eq(1)").text();
    let correo = fila.find("td:eq(2)").text();
    let rol = fila.find("td:eq(3)").text();

    $("#identificacion").val(identificacion);
    $("#nombre").val(nombre);
    $("#correo").val(correo);
    $("#rol").val(rol);

    $("#modalUsuario").modal("show");

});