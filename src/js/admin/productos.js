const productos = [

    {
        nombre: "Pan Francés",
        categoria: "Pan",
        precio: 1500,
        stock: 45
    },

    {
        nombre: "Croissant",
        categoria: "Pastelería",
        precio: 3000,
        stock: 6
    },

    {
        nombre: "Dona Chocolate",
        categoria: "Dulces",
        precio: 2800,
        stock: 0
    }

];
// Guarda el índice del producto que se va a editar
let indiceEditar = -1;
// Guarda el índice del producto que se va a eliminar
let indiceEliminar = -1;

console.log(productos);
// Muestra todos los productos del inventario en la tabla

function mostrarProductos(filtro = ""){

    const tabla = document.getElementById("tablaProductos");

    tabla.innerHTML = "";

    productos.forEach(function(producto, index){
        if (!producto.nombre.toLowerCase().includes(filtro.toLowerCase())) {
    return;
}
        let estado = "";
        if (producto.stock == 0) {

    estado = `<span class="badge bg-danger">Agotado</span>`;

}
else if (producto.stock <= 10) {

    estado = `<span class="badge bg-warning text-dark">Poco Stock</span>`;

}
else {

    estado = `<span class="badge bg-success">Disponible</span>`;

}

    tabla.innerHTML += `
<tr class="${producto.stock == 0 ? 'table-danger' : ''}">

    <td>
        <i class="fa-solid fa-bread-slice fs-4 text-warning"></i>
    </td>

    <td>${producto.nombre}</td>

    <td>${producto.categoria}</td>

    <td>${formatearPrecio(producto.precio)}</td>

    <td>${producto.stock}</td>

    <td>
        ${estado}
    </td>

    <td>

        <button
    class="btn btn-sm btn-editar"
    onclick="editarProducto(${index})">

    <i class="fa-solid fa-pen"></i>

</button>

       <button
    class="btn btn-sm btn-eliminar"
    onclick="eliminarProducto(${index})">

    <i class="fa-solid fa-trash"></i>

</button>

    </td>

</tr>
`;
});
actualizarResumen();

}
// Actualiza las tarjetas de resumen del dashboard
function actualizarResumen() {

    let pocoStock = 0;
    let agotados = 0;

    productos.forEach(function(producto){

        if(producto.stock == 0){
            agotados++;
        }
        else if(producto.stock <= 10){
            pocoStock++;
        }

    });

    document.getElementById("totalProductos").textContent = productos.length;
    document.getElementById("stockBajo").textContent = pocoStock;
    document.getElementById("agotados").textContent = agotados;

}
// Muestra mensajes informativos al administrador
function mostrarMensaje(texto, tipo){

    const mensaje = document.getElementById("mensaje");

    mensaje.innerHTML = `
    
    <div class="alert alert-${tipo} alert-dismissible fade show">

        ${texto}

        <button
        class="btn-close"
        data-bs-dismiss="alert">
        </button>

    </div>

    `;

    setTimeout(function(){

        mensaje.innerHTML = "";

    },3000);

}
// Busca productos por nombre y categoría
function buscarProducto(){

    const texto = document.getElementById("buscarProducto").value.toLowerCase();

    const categoria = document.getElementById("filtroCategoria").value;

    const tabla = document.getElementById("tablaProductos");

    tabla.innerHTML = "";

    productos.forEach(function(producto,index){

        const coincideNombre = producto.nombre.toLowerCase().includes(texto);

        const coincideCategoria = categoria == "" || producto.categoria == categoria;

        if(!(coincideNombre && coincideCategoria)){
            return;
        }

        let estado = "";

        if(producto.stock == 0){

            estado = `<span class="badge bg-danger">Agotado</span>`;

        }

        else if(producto.stock <=10){

            estado = `<span class="badge bg-warning text-dark">Poco Stock</span>`;

        }

        else{

            estado = `<span class="badge bg-success">Disponible</span>`;

        }

        tabla.innerHTML += `
        <tr class="${producto.stock == 0 ? "table-danger" : ""}">

            <td><i class="fa-solid fa-bread-slice fs-4 text-warning"></i></td>

            <td>${producto.nombre}</td>

            <td>${producto.categoria}</td>

            <td>${formatearPrecio(producto.precio)}</td>

            <td>${producto.stock}</td>

            <td>${estado}</td>

            <td>

                <button
                    class="btn btn-sm btn-editar"
                    onclick="editarProducto(${index})">

                    <i class="fa-solid fa-pen"></i>

                </button>

                <button
                    class="btn btn-sm btn-eliminar"
                    onclick="eliminarProducto(${index})">

                    <i class="fa-solid fa-trash"></i>

                </button>

            </td>

        </tr>
        `;

    });

}
mostrarProductos();
actualizarFecha();

// Agrega un nuevo producto o actualiza uno existente
function agregarProducto() {

    // Obtiene los datos ingresados en el formulario
    const nombre = document.getElementById("nombre").value;
    const categoria = document.getElementById("categoria").value;
    const precio = Number(document.getElementById("precio").value);
    const stock = Number(document.getElementById("stock").value);

    // Valida que todos los campos estén completos
    if (
        nombre == "" ||
        categoria == "" ||
        precio <= 0 ||
        stock < 0
    ) {

        mostrarMensaje("Complete correctamente todos los campos.","danger");
        return;

    }

    // Verifica si se está agregando o editando un producto
    if (indiceEditar == -1) {

        // Agrega un nuevo producto al arreglo
        productos.push({
            nombre,
            categoria,
            precio,
            stock
        });

    } else {

        // Actualiza el producto seleccionado
        productos[indiceEditar] = {
            nombre,
            categoria,
            precio,
            stock
        };

        // Reinicia el índice de edición
        indiceEditar = -1;

        // Restaura el título y el botón del modal
        document.querySelector(".modal-title").textContent = "Agregar Producto";
        document.querySelector("#modalProducto .btn-maskot").textContent = "Guardar";
    }

    // Actualiza la tabla
    mostrarProductos();
mostrarMensaje("Producto agregado correctamente.","success");

    // Limpia el formulario
    document.getElementById("nombre").value = "";
    document.getElementById("categoria").value = "";
    document.getElementById("precio").value = "";
    document.getElementById("stock").value = "";

    // Cierra el modal
    const modal = bootstrap.Modal.getInstance(
        document.getElementById("modalProducto")
    );

    modal.hide();

}


    
// Abre el modal para confirmar la eliminación
function eliminarProducto(index){

    indiceEliminar = index;

    const modal = new bootstrap.Modal(
        document.getElementById("modalEliminar")
    );

    modal.show();

}
// Elimina el producto después de confirmar
function confirmarEliminar(){

    productos.splice(indiceEliminar, 1);

    mostrarProductos();

    mostrarMensaje(
        "Producto eliminado correctamente.",
        "success"
    );

    indiceEliminar = -1;

    const modal = bootstrap.Modal.getInstance(
        document.getElementById("modalEliminar")
    );

    modal.hide();

}
// Carga la información de un producto en el formulario para editarlo
function editarProducto(index){

    indiceEditar = index;

    document.getElementById("nombre").value = productos[index].nombre;

    document.getElementById("categoria").value = productos[index].categoria;

    document.getElementById("precio").value = productos[index].precio;

    document.getElementById("stock").value = productos[index].stock;

    document.querySelector(".modal-title").textContent = "Editar Producto";

    document.querySelector("#modalProducto .btn-maskot").textContent = "Actualizar";

    const modal = new bootstrap.Modal(document.getElementById("modalProducto"));

    modal.show();

}

// Formatea los precios en pesos colombianos
function formatearPrecio(precio){

    return "$ " + precio.toLocaleString("es-CO");

}
// Restablece el modal para agregar un nuevo producto
function reiniciarModal(){

    indiceEditar = -1;

    document.getElementById("nombre").value = "";
    document.getElementById("categoria").value = "";
    document.getElementById("precio").value = "";
    document.getElementById("stock").value = "";

    document.querySelector(".modal-title").textContent = "Agregar Producto";

    document.querySelector("#modalProducto .btn-maskot").textContent = "Guardar";

}
// Cuando el modal se cierre, vuelve a su estado inicial
document.getElementById("modalProducto").addEventListener("hidden.bs.modal", function(){

    reiniciarModal();

});
// Muestra la fecha y hora de la última actualización del inventario
function actualizarFecha(){

    const ahora = new Date();

    document.getElementById("ultimaActualizacion").textContent =
        "Última actualización: " + ahora.toLocaleString("es-CO");

}



    document.getElementById("totalProductos").textContent = productos.length;

    document.getElementById("stockBajo").textContent = pocoStock;

    document.getElementById("agotados").textContent = agotados;


