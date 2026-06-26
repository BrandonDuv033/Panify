// Base de datos de los productos asignados
let inventario = [
  { id: 1, nombre: "Pan Francés", categoria: "Pan", precio: 1500, stock: 15, icono: "fa-bread-slice" },
  { id: 2, nombre: "Croissant", categoria: "Pastelería", precio: 3000, stock: 10, icono: "fa-cookie-bite" },
  { id: 3, nombre: "Dona", categoria: "Pastelería", precio: 3000, stock: 8, icono: "fa-cookie-bite" }
];

let pedido = [];
let pedidoConfirmado = false;

// Al cargar el documento de manera asíncrona
document.addEventListener("DOMContentLoaded", () => {
  mostrarProductos();
  calcularSubtotalesYTotal();
});

// Renderizar el catálogo con íconos centrados arriba
function mostrarProductos() {
  const contenedor = document.getElementById("contenedor-productos");
  if (!contenedor) return;
  
  let rowHTML = '<div class="row g-3">';
  inventario.forEach(prod => {
    const estaAgotado = prod.stock === 0;
    rowHTML += `
      <div class="col-12 col-sm-6 mb-2">
        <div class="card h-100 card-producto-base">
          <div class="card-body d-flex flex-column text-start p-2">
            
            <div class="text-center mb-3 icono-pan-top">
              <i class="fa-solid ${prod.icono}"></i>
            </div>

            <h5 class="fw-bold mb-1 text-dark" style="font-size: 1.1rem;">${prod.nombre}</h5>
            <span class="text-muted small d-block mb-3">${prod.categoria}</span>
            <h4 class="fw-bold text-dark mb-4">$ ${prod.precio.toLocaleString('es-CO')}</h4>
            
            <div class="mt-auto text-center">
              ${estaAgotado 
                ? `<div class="alert alert-danger py-1 text-center small fw-bold mb-0">Agotado</div>`
                : `<button class="btn btn-sm bg-transparent border-0 text-dark fw-medium w-100 py-2" ${pedidoConfirmado ? 'disabled' : ''} onclick="agregarAlPedido(${prod.id})">
                    <i class="fa-solid fa-cart-shopping me-2"></i>Agregar al carrito
                   </button>`
              }
            </div>

          </div>
        </div>
      </div>
    `;
  });
  rowHTML += '</div>';
  contenedor.innerHTML = rowHTML;
}

function agregarAlPedido(id) {
  if (pedidoConfirmado) return;
  const item = pedido.find(i => i.id === id);
  const prod = inventario.find(p => p.id === id);

  if (prod && prod.stock >= (item ? item.cantidad + 1 : 1)) {
    if (item) {
      item.cantidad++;
    } else {
      pedido.push({ id: prod.id, nombre: prod.nombre, precio: prod.precio, cantidad: 1 });
    }
    calcularSubtotalesYTotal();
  } else {
    alert("Inventario insuficiente.");
  }
}

function aumentarCantidad(id) {
  agregarAlPedido(id);
}

function disminuirCantidad(id) {
  if (pedidoConfirmado) return;
  const item = pedido.find(i => i.id === id);
  if (item) {
    item.cantidad--;
    if (item.cantidad <= 0) {
      pedido = pedido.filter(i => i.id !== id);
    }
    calcularSubtotalesYTotal();
  }
}

function eliminarProducto(id) {
  if (pedidoConfirmado) return;
  pedido = pedido.filter(i => i.id !== id);
  calcularSubtotalesYTotal();
}

function vaciarCarrito() {
  if (pedidoConfirmado) return;
  pedido = [];
  calcularSubtotalesYTotal();
}

function calcularSubtotalesYTotal() {
  const contenedorCarrito = document.getElementById("contenedor-carrito");
  if (!contenedorCarrito) return;

  if (pedido.length === 0) {
    contenedorCarrito.innerHTML = `
      <div class="p-3 bg-white rounded shadow-sm text-start border">
        <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-cart-shopping me-2"></i>Carrito</h5>
        <div class="text-center py-4 text-muted small">No has añadido productos a tu pedido aún.</div>
      </div>`;
    return;
  }

  let total = 0;
  let filasHTML = "";

  pedido.forEach(item => {
    const subtotal = item.precio * item.cantidad;
    total += subtotal;
    filasHTML += `
      <div class="d-flex align-items-center justify-content-between border-bottom py-2 small">
        <div class="text-dark fw-semibold" style="min-width: 95px;">${item.nombre}</div>
        <div class="d-flex align-items-center border rounded px-1 bg-white">
          <button class="btn p-0 px-1 border-0 bg-transparent text-dark fw-bold" onclick="disminuirCantidad(${item.id})">-</button>
          <span class="px-2 fw-bold text-secondary">${item.cantidad}</span>
          <button class="btn p-0 px-1 border-0 bg-transparent text-dark fw-bold" onclick="aumentarCantidad(${item.id})">+</button>
        </div>
        <div class="text-muted px-2">$ ${subtotal}</div>
        <button class="btn btn-sm p-0 text-secondary border-0 bg-transparent" onclick="eliminarProducto(${item.id})">
          <i class="fa-regular fa-trash-can"></i>
        </button>
      </div>`;
  });

  contenedorCarrito.innerHTML = `
    <div class="p-3 bg-white rounded shadow-sm text-start border">
      <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-cart-shopping me-2"></i>Carrito</h5>
      <div class="mb-3">${filasHTML}</div>
      <button class="btn w-100 btn-vaciar text-white mb-2 py-2 small fw-semibold" onclick="vaciarCarrito()" ${pedidoConfirmado ? 'disabled' : ''}>Vaciar carrito</button>
      <div class="fw-bold text-dark small my-3">Total: $ ${total}</div>
      <button class="btn w-100 btn-finalizar text-white mb-2 py-2 small fw-semibold" onclick="confirmarPedido()" ${pedidoConfirmado ? 'disabled' : ''}>Finalizar compra</button>
      <button class="btn w-100 btn-recibo text-white py-2 small fw-semibold" onclick="generarRecibo()" ${!pedidoConfirmado ? 'disabled' : ''}>Generar recibo</button>
    </div>`;
}

function confirmarPedido() {
  if (pedido.length === 0 || pedidoConfirmado) return;
  pedidoConfirmado = true;
  
  pedido.forEach(item => {
    const prod = inventario.find(p => p.id === item.id);
    if (prod) prod.stock -= item.cantidad;
  });

  mostrarProductos();
  calcularSubtotalesYTotal();
  actualizarEstadoPedido("pendiente");
  
  setTimeout(() => actualizarEstadoPedido("preparacion"), 3000);
  setTimeout(() => actualizarEstadoPedido("camino"), 6000);
  setTimeout(() => actualizarEstadoPedido("entregado"), 9000);
}

function generarRecibo() {
  alert("Recibo generado con éxito.");
}

function actualizarEstadoPedido(estado) {
  const seccion = document.getElementById("seccion-seguimiento");
  if (!seccion) return;

  let msg = ""; let clase = ""; let paso = 1;
  if (estado === "pendiente") { msg = "Tu pedido está pendiente de confirmación."; clase = "alert-warning"; paso = 1; }
  else if (estado === "preparacion") { msg = "Tu pedido está en preparación."; clase = "alert-info"; paso = 2; }
  else if (estado === "camino") { msg = "Tu pedido está en camino."; clase = "alert-primary"; paso = 3; }
  else if (estado === "entregado") { msg = "Tu pedido fue entregado correctamente."; clase = "alert-success"; paso = 4; }

  seccion.innerHTML = `
    <div class="card shadow-sm border-0 mb-4 text-start">
      <div class="card-header bg-dark text-white py-3"><h5 class="mb-0 fw-bold"><i class="fa-solid fa-truck-fast me-2"></i>Seguimiento</h5></div>
      <div class="card-body text-center p-4">
        <div class="alert ${clase} fw-bold mb-4">${msg}</div>
        <div class="row g-2 justify-content-center text-muted small">
          <div class="col-3 ${paso >= 1 ? 'progreso-activo' : ''}"><i class="fa-solid fa-clock d-block mb-1"></i>Pendiente</div>
          <div class="col-3 ${paso >= 2 ? 'progreso-activo' : ''}"><i class="fa-solid fa-kitchen-set d-block mb-1"></i>Preparación</div>
          <div class="col-3 ${paso >= 3 ? 'progreso-activo' : ''}"><i class="fa-solid fa-truck d-block mb-1"></i>En camino</div>
          <div class="col-3 ${paso >= 4 ? 'text-success fw-bold' : ''}"><i class="fa-solid fa-circle-check d-block mb-1"></i>Entregado</div>
        </div>
      </div>
    </div>`;
}