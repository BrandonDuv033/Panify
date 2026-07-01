const formulario = document.getElementById("formRecuperar");

formulario.addEventListener("submit", function (e) {
    e.preventDefault();

    let correo = document.getElementById("correo").value.trim();

    if (correo === "") {
        Swal.fire({
            icon: "error",
            title: "Campo vacío",
            text: "Ingrese su correo electrónico."
        });
        return;
    }

    Swal.fire({
        icon: "success",
        title: "Correo enviado",
        text: "Revisa tu correo para recuperar la contraseña."
    }).then(() => {
        window.location.href = "../index.html";
    });

});