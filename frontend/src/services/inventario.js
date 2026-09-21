import API from "./api";

function calcularEstado(stock, stockMinimo) {
  if (stock === 0) return "Agotado";
  if (stock <= stockMinimo) return "Poco Stock";
  return "Disponible";
}

export async function obtenerProductos() {
  const [productos, inventarios] = await Promise.all([
    API.get("/productos"),
    API.get("/inventarios"),
  ]);

  return productos.data.map((producto) => {
    const inventario = inventarios.data.find(
      (i) => i.producto_idProducto === producto.id,
    );
    const stock = inventario?.stockActual ?? 0;
    const stockMinimo = inventario?.stockMinimo ?? 0;

    return {
      id: producto.id,
      nombre: producto.nombre,
      categoria: producto.descripcion || "General",
      precio: producto.precio,
      stock,
      stockMinimo,
      stock: stock,
      estado: calcularEstado(stock, stockMinimo),
      imagen: "🍞",
    };
  });
}

export async function eliminarProducto(id) {
  await API.delete(`/productos/${id}`);
}
