const formulario = document.querySelector("form");

formulario.addEventListener("submit", function (e) {
    e.preventDefault();

    let nombre = document.getElementById("nombre").value;
    let direccion = document.getElementById("direccion").value;
    let correo = document.getElementById("email").value;
    let password = document.getElementById("password").value;

    if (nombre == "" || direccion == "" || correo == "" || password == "") {
        Swal.fire({
            icon: "warning",
            title: "Completa todos los campos"
        });
    } else {
        Swal.fire({
            icon: "success",
            title: "Registro exitoso"
        }).then(() => {
            window.location.href = "../index.html";
        });
    }
});