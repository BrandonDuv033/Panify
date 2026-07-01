document.addEventListener("DOMContentLoaded", function () {
  console.log("¡El archivo JS cargó correctamente!");

  // Lógica del Login
  const btnIngresar = document.querySelector(".btn-login-ingresar");
  if (btnIngresar) {
    btnIngresar.addEventListener("click", function (event) {
      event.preventDefault();
      const email = document.getElementById("email").value.trim();
      const password = document.getElementById("password").value.trim();

      if (email === "" || password === "") {
        Swal.fire({
          icon: "warning",
          title: "Campos Vacíos",
          text: "Por favor complete los campos",
          confirmButtonColor: "#e5a93c",
        });
        return;
      }

      if (email === "admin@panify.com" && password === "12345") {
        Swal.fire({
          icon: "success",
          title: "¡Bienvenido!",
          text: "Redireccionando...",
        }).then(() => {
          window.location.href = "admin/dashboard.html";
        });
      } else if (email === "user@panify.com" && password === "12345") {
        Swal.fire({
          icon: "success",
          title: "¡Bienvenido!",
          text: "Redireccionando...",
        }).then(() => {
          window.location.href = "client/inicio.html";
        });
      } else {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "Credenciales incorrectas",
        });
      }
    });
  }
});
