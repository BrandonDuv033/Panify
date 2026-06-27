// Arreglo con los productos disponibles
const productos = [

    {
        nombre: "Pan Francés",
        categoria: "Pan",
        precio: 1500,
       
    },

    {
        nombre: "Croissant",
        categoria: "Pastelería",
        precio: 3000,
       
    },
    {
        nombre: "Roscon",
        categoria: "Pan",
        precio: 1500,
       
    },
     {
        nombre: "Dona",
        categoria: "Pastelería",
        precio: 3000,
       
    },

    



];

// Almacena los productos que el cliente agrega al carrito
let carrito = [];

// Formatea el precio
function formatearPrecio(precio){

    return "$ " + precio.toLocaleString("es-CO");

}

// Muestra los productos en tarjetas
function mostrarProductos(){

    const contenedor = document.getElementById("listaProductos");

    contenedor.innerHTML = "";

   productos.forEach(function(producto, index){

        contenedor.innerHTML += `

        <div class="col-md-6 col-xl-4 mb-4">

            <div class="card h-100 shadow-sm">

               <div class="text-center pt-4">

    <i
        class="fa-solid ${obtenerIcono(producto.categoria)}"
        style="
            font-size:70px;
            color:#8b5a2b;
        ">
    </i>

</div>

                <div class="card-body">

                    <h5>${producto.nombre}</h5>

                    <p class="text-muted">

                        ${producto.categoria}

                    </p>

                    <h4 class="mb-3">

                        ${formatearPrecio(producto.precio)}

                    </h4>

                    <button
    class="btn btn-panify w-100"
    onclick="agregarCarrito(${index})">

    <i class="fa-solid fa-cart-plus"></i>

    Agregar al carrito

</button>

                </div>

            </div>

        </div>

        `;

    });

}
// Agrega un producto al carrito
function agregarCarrito(index){

    const producto = productos[index];

    const existe = carrito.find(function(item){

        return item.nombre == producto.nombre;

    });

    if(existe){

        existe.cantidad++;

    }else{

        carrito.push({

            nombre: producto.nombre,

            precio: producto.precio,

            cantidad: 1

        });

    }

    mostrarCarrito();

}
// Muestra todos los productos del carrito en pantalla y calcula el total
function mostrarCarrito() {

    const contenedor = document.getElementById("carrito"); 
    const total = document.getElementById("total"); 

    contenedor.innerHTML = ""; 

    let suma = 0; 

    carrito.forEach((producto, index) => {

        let subtotal = producto.precio * producto.cantidad; 
        suma += subtotal; 

        contenedor.innerHTML += `
        
        <div class="d-flex justify-content-between align-items-center mb-2">

            <div>
                <strong>${producto.nombre}</strong>

                <!-- botones para cambiar cantidad -->
                <button onclick="disminuirCantidad(${index})">➖</button>
                ${producto.cantidad}
                <button onclick="aumentarCantidad(${index})">➕</button>
            </div>

            <div>
                ${subtotal}
            </div>

            <!-- eliminar producto -->
            <button onclick="eliminarProductoCarrito(${index})">
                🗑
            </button>

        </div>
        `;
    });

    
    if (carrito.length === 0) {
        contenedor.innerHTML = "<p>El carrito está vacío</p>";
    }

   
    total.textContent = "$ " + suma;
}
mostrarProductos();
// Devuelve un ícono según la categoría del producto
function obtenerIcono(categoria){

    switch(categoria){

        case "Pan":
            return "fa-bread-slice";

        case "Pastelería":
            return "fa-cookie-bite";


        default:
            return "fa-box";

    }

}
function aumentarCantidad(index) {
    carrito[index].cantidad++;
    mostrarCarrito();
}
function disminuirCantidad(index) {
    carrito[index].cantidad--;

    if (carrito[index].cantidad <= 0) {
        carrito.splice(index, 1);
    }

    mostrarCarrito();
}
// ELIMINA UN PRODUCTO COMPLETO DEL CARRITO
function eliminarProductoCarrito(index) {

    // splice elimina el producto en la posición indicada
    carrito.splice(index, 1);

    
    mostrarCarrito();
}
// FINALIZA LA COMPRA DEL CARRITO
function finalizarCompra() {

    
    if (carrito.length === 0) {
        alert("El carrito está vacío");
        return;
    }

    
    carrito = [];

   
    mostrarCarrito();

   
    

    
    alert("Compra realizada con éxito");
}
// VACÍA COMPLETAMENTE EL CARRITO
function vaciarCarrito() {

    carrito = [];
    mostrarCarrito();
    alert("Carrito vaciado");
}


// GENERA RECIBO VISUAL EN PANTALLA
function generarRecibo() {

    if (carrito.length === 0) {
        alert("No hay productos en el carrito");
        return;
    }

    const recibo = document.getElementById("recibo");
    const detalle = document.getElementById("reciboDetalle");
    const totalFinal = document.getElementById("reciboTotal");

    detalle.innerHTML = "";

    let total = 0;

    carrito.forEach(producto => {

        let subtotal = producto.precio * producto.cantidad;
        total += subtotal;

        detalle.innerHTML += `
        <p>
            <strong>${producto.nombre}</strong><br>
            Cantidad: ${producto.cantidad} <br>
            Subtotal: $${subtotal}
        </p>
        <hr>
        `;
    });

    totalFinal.textContent = "TOTAL: $ " + total;

    // mostramos el recibo
    recibo.classList.remove("d-none");
}