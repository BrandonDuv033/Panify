$(document).ready(function () {

  // Inicializar DataTable
$("#tablaUsuarios").DataTable({
    responsive: true,
    pageLength: 5,
    lengthMenu: [5, 10, 15, 20],
    language: {
        url: "https://cdn.datatables.net/plug-ins/2.3.2/i18n/es-ES.json"
    }
});

  // Formulario de nuevo pedido
  $("#formUsuario").on("submit", function (e) {
    e.preventDefault();

    Swal.fire({
      icon: "success",
      title: "¡Pedido registrado!",
      text: "Ahora puedes seleccionar los productos.",
      confirmButtonColor: "#e67e22",
    });
  });

  // Abrir menú lateral (si existe el botón)
  $("#menuToggle").on("click", function () {
    $("#sidebar").addClass("open");
    $("#sidebarOverlay").fadeIn();
  });

  // Cerrar menú lateral
  $("#sidebarOverlay").on("click", function () {
    $("#sidebar").removeClass("open");
    $("#sidebarOverlay").fadeOut();
  });

});
let clientes = [];

$("#formUsuario").submit(function (e) {
    e.preventDefault();

    const cliente = {
        identificacion: $("#identificacion").val(),
        nombre: $("#nombre").val(),
        correo: $("#correo").val(),
        direccion: $("#direccion").val()
    };

    clientes.push(cliente);

    console.log(clientes);

    alert("Datos Guardados");
});

