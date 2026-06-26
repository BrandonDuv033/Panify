document
  .querySelector(".btn-login-ingresar")
  .addEventListener("click", function (event) {
    event.preventDefault();

    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();

    if (email === "" || password === "") {
      Swal.fire({
        icon: "warning",
        title: "Campos Vacios",
        text: "Por favor complete los campos",
        confirmButtonColor: "#37ac1d",
      });
      return;
    }

    if (email === "admin@panify.com" && password === "12345") {
      Swal.fire({
        icon: "success",
        title: "Inicio Exitoso",
        text: "Bienvenido Administrador",
        confirmButtonColor: "#37ac1d",
      }).then(() => {
        window.location.href = "admin/dashboard.html";
      });
    } else if (email === "cliente@panify.com" && password === "12345") {
      Swal.fire({
        icon: "success",
        title: "Inicio Exitoso",
        text: "Bienvenido Cliente",
        confirmButtonColor: "#37ac1d",
      }).then(() => {
        window.location.href = "client/client.html";
      });
    } else {
      Swal.fire({
        icon: "error",
        title: "Credenciales incorrectas",
        text: "Correo o contraseña invalidos",
        confirmButtonColor: "#00ffff",
      });
    }
  });
