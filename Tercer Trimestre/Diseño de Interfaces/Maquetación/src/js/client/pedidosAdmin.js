// Base de datos quemada por si el localStorage está vacío al inicio
let pedidosPorDefecto = [
  { id: "PAN-101", cliente: "Diego Alejandro", detalle: "3x Pan Francés, 1x Croissant", total: 7500, estado: "pendiente" },
  { id: "PAN-102", cliente: "Valentina Restrepo", detalle: "2x Dona de Chocolate", total: 6000, estado: "preparacion" }
];

// Variable global que manejará los pedidos reales
let colaPedidos = [];

document.addEventListener("DOMContentLoaded", () => {
  cargarPedidosDesdeStorage();
});

// Cargar datos reales creados por el cliente
function cargarPedidosDesdeStorage() {
  const guardados = localStorage.getItem("pedidosPanify");
  
  if (guardados) {
    // Si el cliente ya hizo pedidos, los traemos
    colaPedidos = JSON.parse(guardados);
  } else {
    // Si no hay nada en memoria, metemos los pedidos por defecto para que no se vea vacío
    colaPedidos = pedidosPorDefecto;
    localStorage.setItem("pedidosPanify", JSON.stringify(colaPedidos));
  }
  
  listarPedidosAdmin();
}

// Función para rellenar la tabla de administración
function listarPedidosAdmin() {
  const tabla = document.getElementById("tabla-pedidos-admin");
  if (!tabla) return;

  let lineasHTML = "";

  if (colaPedidos.length === 0) {
    tabla.innerHTML = `<tr><td colspan="6" class="text-center py-4 text-muted">No existen pedidos pendientes en cola.</td></tr>`;
    calcularEstadisticas();
    return;
  }

  colaPedidos.forEach(pedido => {
    let claseBadge = "";
    if (pedido.estado === "pendiente") claseBadge = "badge-pendiente";
    else if (pedido.estado === "preparacion") claseBadge = "badge-preparacion";
    else if (pedido.estado === "camino") claseBadge = "badge-camino";
    else if (pedido.estado === "entregado") claseBadge = "badge-entregado";

    lineasHTML += `
      <tr>
        <td class="ps-3 fw-bold text-secondary">${pedido.id}</td>
        <td class="fw-semibold">${pedido.cliente}</td>
        <td class="text-muted small">${pedido.detalle}</td>
        <td class="fw-bold">$ ${pedido.total.toLocaleString('es-CO')}</td>
        <td><span class="${claseBadge} text-uppercase small">${pedido.estado}</span></td>
        <td class="text-center pe-3">
          <div class="btn-group btn-group-sm">
            <button class="btn btn-sm btn-light border text-warning" title="Recibido" onclick="cambiarEstadoFlujo('${pedido.id}', 'pendiente')"><i class="fa-solid fa-clock"></i></button>
            <button class="btn btn-sm btn-light border text-info" title="Cocinar" onclick="cambiarEstadoFlujo('${pedido.id}', 'preparacion')"><i class="fa-solid fa-fire-burner"></i></button>
            <button class="btn btn-sm btn-light border text-primary" title="Enviar" onclick="cambiarEstadoFlujo('${pedido.id}', 'camino')"><i class="fa-solid fa-motorcycle"></i></button>
            <button class="btn btn-sm btn-light border text-success" title="Entregado" onclick="cambiarEstadoFlujo('${pedido.id}', 'entregado')"><i class="fa-solid fa-circle-check"></i></button>
          </div>
        </td>
      </tr>
    `;
  });

  tabla.innerHTML = lineasHTML;
  calcularEstadisticas();
}

// Cambiar estado, actualizar el localStorage y refrescar la tabla
function cambiarEstadoFlujo(id, nuevoEstado) {
  const item = colaPedidos.find(p => p.id === id);
  if (item) {
    item.estado = nuevoEstado;
    // Guardamos el cambio de estado para que persista
    localStorage.setItem("pedidosPanify", JSON.stringify(colaPedidos));
    listarPedidosAdmin();
  }
}

// Actualizar los contadores superiores
function calcularEstadisticas() {
  const pen = colaPedidos.filter(p => p.estado === "pendiente").length;
  const prep = colaPedidos.filter(p => p.estado === "preparacion").length;
  const cam = colaPedidos.filter(p => p.estado === "camino").length;
  const ent = colaPedidos.filter(p => p.estado === "entregado").length;

  if (document.getElementById("num-pendientes")) document.getElementById("num-pendientes").innerText = pen;
  if (document.getElementById("num-preparacion")) document.getElementById("num-preparacion").innerText = prep;
  if (document.getElementById("num-camino")) document.getElementById("num-camino").innerText = cam;
  if (document.getElementById("num-entregados")) document.getElementById("num-entregados").innerText = ent;
}