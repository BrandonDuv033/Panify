document.addEventListener("DOMContentLoaded", () => {

  // =========================
  // ELEMENTOS DEL HTML
  // =========================
  const buscarInput = document.getElementById("buscarPedido");
  const filtroEstado = document.getElementById("filtroEstado");

  const numPendientes = document.getElementById("numPendientes");
  const numPreparacion = document.getElementById("numPreparacion");
  const numCamino = document.getElementById("numCamino");
  const numEntregados = document.getElementById("numEntregados");

  // Todas las cards de pedidos (activos + historial)
  const pedidos = document.querySelectorAll(".card");

  // =========================
  // FUNCION: FILTRAR PEDIDOS
  // =========================
  function filtrarPedidos() {
    const texto = buscarInput.value.toLowerCase();
    const estado = filtroEstado.value.toLowerCase();

    pedidos.forEach((card) => {

      const contenido = card.innerText.toLowerCase();

      const coincideTexto = contenido.includes(texto);

      const coincideEstado =
        estado === "todos" || contenido.includes(estado);

      // Evita ocultar cards que no son pedidos reales
      const esPedido =
        card.querySelector(".card-header") !== null;

      if (esPedido && coincideTexto && coincideEstado) {
        card.style.display = "block";
      } else if (esPedido) {
        card.style.display = "none";
      }
    });
  }

  // =========================
  // FUNCION: ACTUALIZAR RESUMEN
  // =========================
  function actualizarResumen() {

    let pendientes = 0;
    let preparacion = 0;
    let camino = 0;
    let entregados = 0;

    pedidos.forEach((card) => {
      const esPedido = card.querySelector(".card-header");
      if (!esPedido) return;

      const texto = card.innerText.toLowerCase();

      if (texto.includes("pendiente")) pendientes++;
      if (texto.includes("preparación")) preparacion++;
      if (texto.includes("preparacion")) preparacion++;
      if (texto.includes("en camino")) camino++;
      if (texto.includes("entregado")) entregados++;
    });

    numPendientes.textContent = pendientes;
    numPreparacion.textContent = preparacion;
    numCamino.textContent = camino;
    numEntregados.textContent = entregados;
  }

  // =========================
  // EVENTOS
  // =========================
  buscarInput.addEventListener("input", filtrarPedidos);
  filtroEstado.addEventListener("change", filtrarPedidos);

  // Inicializar
  actualizarResumen();

});