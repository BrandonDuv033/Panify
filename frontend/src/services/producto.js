const API_URL = "http://localhost:1511";

export async function obtenerProductos() {
  const respuesta = await fetch(`${API_URL}/productos`);

  if (!respuesta.ok) {
    throw new Error("No se pudieron obtener los productos");
  }

  return respuesta.json();
}

export async function obtenerProducto(idProducto) {
  const respuesta = await fetch(
    `${API_URL}/productos?idProducto=${idProducto}`
  );

  if (!respuesta.ok) {
    throw new Error("No se pudo obtener el producto");
  }

  const productos = await respuesta.json();

  return productos[0];
}

export async function crearProducto(producto) {
  const respuesta = await fetch(`${API_URL}/productos`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(producto)
  });

  if (!respuesta.ok) {
    throw new Error("No se pudo agregar el producto");
  }

  return respuesta.json();
}

export async function actualizarProducto(idProducto, datos) {
  const respuesta = await fetch(
    `${API_URL}/productos/${idProducto}`,
    {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(datos)
    }
  );

  if (!respuesta.ok) {
    throw new Error("No se pudo actualizar el producto");
  }

  return respuesta.json();
}

export async function eliminarProducto(idProducto) {
  const respuesta = await fetch(
    `${API_URL}/productos/${idProducto}`,
    {
      method: "DELETE"
    }
  );

  if (!respuesta.ok) {
    throw new Error("No se pudo eliminar el producto");
  }

  return true;
}