const formularioRecuperar = document.getElementById("formRecuperar");
const formularioRegistro = document.getElementById("formRegistro");

if (formularioRecuperar) {
  formularioRecuperar.addEventListener("submit", function (e) {
    e.preventDefault();

    let correo = document.getElementById("correo").value.trim();

    if (correo === "") {
      Swal.fire({
        icon: "error",
        title: "Campo vacío",
        text: "Ingrese su correo electrónico.",
      });
      return;
    }

    Swal.fire({
      icon: "success",
      title: "Correo enviado",
      text: "Revisa tu correo para recuperar la contraseña.",
    }).then(() => {
      window.location.href = "../index.html";
    });
  });
}

if (formularioRegistro) {
  formularioRegistro.addEventListener("submit", function (e) {
    e.preventDefault();

    let nombre = document.getElementById("nombre").value.trim();
    let direccion = document.getElementById("direccion").value.trim();
    let correo = document.getElementById("email").value.trim();
    let password = document.getElementById("password").value.trim();

    if (nombre === "" || direccion === "" || correo === "" || password === "") {
      Swal.fire({
        icon: "warning",
        title: "Completa todos los campos",
      });
    } else {
      Swal.fire({
        icon: "success",
        title: "Registro exitoso",
      }).then(() => {
        window.location.href = "../index.html";
      });
    }
  });
}
