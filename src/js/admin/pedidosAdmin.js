document.querySelectorAll(".btn-Guardar").forEach(function (boton) {
  boton.addEventListener("click", function () {
    Swal.fire({
      title: "Cambios Guardados",
      icon: "success",
      draggable: true,
    }).then(() =>{
        window.location.href="pedidos.html";
    });
  });
});

$(document).ready(function(){
    $("#tablaPedidos").DataTable({
        language:{
            search: "Buscar",
            lengthMenu: "Mostrar _MENU_ Registros",
            info: "Mostrar _START_ a _END_ de _TOTAL_ registros",
            infoEmpty: "Mostrando 0 a 0 de 0 registros",
            zeroRecords: "No se encontraron resultados",
            emptyTable: "No hay datos disponibles en la tabla",
            paginate:{
                first: "Primero",
                last: "Ultimo",
                next: "Siguiente",
                previous: "Anterior"
            }
        }
    });
});
