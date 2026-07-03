document.addEventListener("DOMContentLoaded", () => {

  // =========================
  // DATA SIMULADA
  // =========================
  let pedidos = [
    {
      id: "PAN-1045",
      cliente: "Brayan Muñoz",
      productos: "2 Pan Blandito, 1 Dona",
      total: 24800,
      estado: "En camino"
    },
    {
      id: "PAN-1046",
      cliente: "Laura Gómez",
      productos: "5 Pan Integral",
      total: 18000,
      estado: "Pendiente"
    },
    {
      id: "PAN-1047",
      cliente: "Carlos Pérez",
      productos: "3 Croissant",
      total: 22000,
      estado: "Preparación"
    },
    {
      id: "PAN-1048",
      cliente: "Ana Ruiz",
      productos: "10 Pan Blandito",
      total: 30000,
      estado: "Entregado"
    }
  ];

  // =========================
  // ELEMENTOS
  // =========================
  const tabla = document.getElementById("tabla-pedidos-admin");

  const numPendientes = document.getElementById("num-pendientes");
  const numPreparacion = document.getElementById("num-preparacion");
  const numCamino = document.getElementById("num-camino");
  const numEntregados = document.getElementById("num-entregados");

  // =========================
  // SEGURIDAD DOM
  // =========================
  if (!tabla) return;

  // =========================
  // RENDER TABLA
  // =========================
  function renderTabla() {

    tabla.innerHTML = "";

    pedidos.forEach((p, index) => {

      let color = "secondary";

      switch (p.estado) {
        case "Pendiente": color = "warning"; break;
        case "Preparación": color = "info"; break;
        case "En camino": color = "primary"; break;
        case "Entregado": color = "success"; break;
      }

      tabla.innerHTML += `
        <tr>
          <td class="ps-3">${p.id}</td>
          <td>${p.cliente}</td>
          <td>${p.productos}</td>
          <td>$${p.total.toLocaleString()}</td>
          <td>
            <span class="badge bg-${color}">
              ${p.estado}
            </span>
          </td>
          <td class="text-center pe-3">
            <button class="btn btn-sm btn-outline-primary"
              onclick="cambiarEstado(${index})">
              Avanzar
            </button>
          </td>
        </tr>
      `;
    });

    actualizarContadores();
  }

  // =========================
  // CAMBIAR ESTADO
  // =========================
  window.cambiarEstado = function (index) {

    const estados = ["Pendiente", "Preparación", "En camino", "Entregado"];

    const actual = estados.indexOf(pedidos[index].estado);

    if (actual !== -1 && actual < estados.length - 1) {
      pedidos[index].estado = estados[actual + 1];
    }

    renderTabla();
  };

  // =========================
  // CONTADORES
  // =========================
  function actualizarContadores() {

    let pendientes = 0;
    let preparacion = 0;
    let camino = 0;
    let entregados = 0;

    pedidos.forEach(p => {

      switch (p.estado) {
        case "Pendiente": pendientes++; break;
        case "Preparación": preparacion++; break;
        case "En camino": camino++; break;
        case "Entregado": entregados++; break;
      }
    });

    if (numPendientes) numPendientes.textContent = pendientes;
    if (numPreparacion) numPreparacion.textContent = preparacion;
    if (numCamino) numCamino.textContent = camino;
    if (numEntregados) numEntregados.textContent = entregados;
  }

  // =========================
  // INIT
  // =========================
  renderTabla();

});