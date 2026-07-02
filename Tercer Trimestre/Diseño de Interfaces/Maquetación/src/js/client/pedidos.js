// Inventario inicial del catálogo de Panify
let productosPanaderia = [
  {
    id: "P-01",
    nombre: "Pan Blandito x10",
    precio: 5000,
    stock: 20,
    img: "https://placehold.co/150?text=Pan+Blandito",
  },
  {
    id: "P-02",
    nombre: "Pan Rollito de Queso",
    precio: 2500,
    stock: 15,
    img: "https://placehold.co/150?text=Pan+Queso",
  },
  {
    id: "P-03",
    nombre: "Croissant de Chocolate",
    precio: 3800,
    stock: 12,
    img: "https://placehold.co/150?text=Croissant",
  },
  {
    id: "P-04",
    nombre: "Dona con Chispas",
    precio: 3000,
    stock: 18,
    img: "https://placehold.co/150?text=Dona",
  },
];

// Carrito de compras del usuario actual
let miCarrito = [];

document.addEventListener("DOMContentLoaded", () => {
  dibujarCatalogo();
  dibujarResumenCarrito();
});

// Generar las tarjetas en la pantalla
function dibujarCatalogo() {
  const cajaProductos = document.getElementById("contenedor-productos");
  if (!cajaProductos) return;

  let cuerpoHTML = `<h3 class="mb-4 fw-bold text-start text-dark">Productos Disponibles</h3><div class="row g-3">`;

  productosPanaderia.forEach((item) => {
    cuerpoHTML += `
      <div class="col-12 col-sm-6">
        <div class="card h-100 shadow-sm border bg-white p-2">
          <div class="row g-0 align-items-center">
            <div class="col-4">
              <img src="${item.img}" class="img-fluid rounded" alt="${item.nombre}">
            </div>
            <div class="col-8">
              <div class="card-body py-1 text-start">
                <h6 class="card-title fw-bold mb-1">${item.nombre}</h6>
                <p class="card-text text-success fw-bold mb-1">$${item.precio.toLocaleString("es-CO")}</p>
                <p class="card-text text-muted small mb-2">Disponibles: ${item.stock}</p>
                <button class="btn btn-sm btn-warning fw-bold px-3" ${item.stock === 0 ? "disabled" : ""} onclick="meterAlCarrito('${item.id}')">
                  ${item.stock === 0 ? "Agotado" : "Agregar"}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  });

  cuerpoHTML += `</div>`;
  cajaProductos.innerHTML = cuerpoHTML;
}

// Agregar o sumar cantidad
function meterAlCarrito(id) {
  const prod = productosPanaderia.find((p) => p.id === id);
  if (!prod || prod.stock <= 0) return;

  const existente = miCarrito.find((c) => c.id === id);

  if (existente) {
    if (existente.cantidad < prod.stock) {
      existente.cantidad++;
    } else {
      alert("Lo sentimos, no hay más existencias de este producto.");
      return;
    }
  } else {
    miCarrito.push({
      id: prod.id,
      nombre: prod.nombre,
      precio: prod.precio,
      cantidad: 1,
    });
  }

  dibujarResumenCarrito();
}

// Modificar cantidades (+ / -)
function alterarCantidad(id, valor) {
  const item = miCarrito.find((c) => c.id === id);
  const prod = productosPanaderia.find((p) => p.id === id);
  if (!item || !prod) return;

  item.cantidad += valor;

  if (item.cantidad <= 0) {
    miCarrito = miCarrito.filter((c) => c.id !== id);
  } else if (item.cantidad > prod.stock) {
    alert("Llegaste al límite del inventario.");
    item.cantidad = prod.stock;
  }

  dibujarResumenCarrito();
}

// Pintar el cuadro de pago en <div id="contenedor-carrito">
function dibujarResumenCarrito() {
  const cajaCarrito = document.getElementById("contenedor-carrito");
  if (!cajaCarrito) return;

  if (miCarrito.length === 0) {
    cajaCarrito.innerHTML = `
      <div class="card p-4 border text-center bg-white shadow-sm">
        <i class="fa-solid fa-basket-shopping text-muted display-5 mb-3"></i>
        <h5 class="fw-bold">Tu carrito está vacío</h5>
        <p class="text-muted small mb-0">Selecciona panes para armar tu pedido.</p>
      </div>
    `;
    return;
  }

  let neto = miCarrito.reduce((acc, el) => acc + el.precio * el.cantidad, 0);
  let tablaHTML = `
    <div class="card p-3 border bg-white shadow-sm text-start">
      <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-cart-flatbed-suitcases me-2 text-warning"></i>Tu Pedido</h5>
      <ul class="list-group list-group-flush mb-3">
  `;

  miCarrito.forEach((item) => {
    tablaHTML += `
      <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-2 bg-transparent">
        <div>
          <h6 class="my-0 fw-bold text-dark">${item.nombre}</h6>
          <small class="text-muted">$${item.precio.toLocaleString("es-CO")} x ${item.cantidad}</small>
        </div>
        <div class="d-flex align-items-center gap-2">
          <button class="btn btn-xs btn-light border py-0 px-2" onclick="alterarCantidad('${item.id}', -1)">-</button>
          <span class="fw-bold text-dark">${item.cantidad}</span>
          <button class="btn btn-xs btn-light border py-0 px-2" onclick="alterarCantidad('${item.id}', 1)">+</button>
        </div>
      </li>
    `;
  });

  tablaHTML += `
      </ul>
      <div class="d-flex justify-content-between align-items-center fw-bold border-top pt-2 mb-3 fs-5">
        <span>Total:</span>
        <span class="text-success">$${neto.toLocaleString("es-CO")}</span>
      </div>
      <button class="btn btn-dark w-100 fw-bold py-2" onclick="despacharAlLocalStorage()">
        <i class="fa-solid fa-share-from-square me-2"></i>Confirmar y Enviar Orden
      </button>
    </div>
  `;

  cajaCarrito.innerHTML = tablaHTML;
}

// Enviar datos al administrador mediante localStorage
function despacharAlLocalStorage() {
  if (miCarrito.length === 0) return;

  const stringProductos = miCarrito
    .map((c) => `${c.cantidad}x ${c.nombre}`)
    .join(", ");
  const granTotal = miCarrito.reduce(
    (acc, el) => acc + el.precio * el.cantidad,
    0,
  );

  const nuevaOrdenAdmin = {
    id: `PAN-${Math.floor(100 + Math.random() * 900)}`,
    cliente: "Cliente Tienda Virtual",
    detalle: stringProductos,
    total: granTotal,
    estado: "pendiente",
  };

  // Guardar en el bus de datos compartido
  let listaActual = JSON.parse(localStorage.getItem("pedidosPanify")) || [];
  listaActual.push(nuevaOrdenAdmin);
  localStorage.setItem("pedidosPanify", JSON.stringify(listaActual));

  // Restar stock
  miCarrito.forEach((item) => {
    const p = productosPanaderia.find((el) => el.id === item.id);
    if (p) p.stock -= item.cantidad;
  });

  miCarrito = [];
  dibujarResumenCarrito();
  dibujarCatalogo();

  alert(
    "¡Orden enviada con éxito! Ya la puedes revisar en tu panel de administración.",
  );
}
